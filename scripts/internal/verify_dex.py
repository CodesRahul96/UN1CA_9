#!/usr/bin/env python3
#
# Runs ART's own class verifier (host dex2oat, --compiler-filter=verify) on every dex container the build rebuilt
# with apktool, against the ROM's own boot class path, and fails on hard verification failures - the kind that
# throw VerifyError at runtime and reject the whole class (9.3.74: K4NandswapQuota.start passed 3 registers to
# Handler.postDelayed(Runnable, long), system_server died on every boot).
#
# Only failures that are NEW count: each file is also verified as Samsung shipped it (same path in the source
# firmware, else in the target firmware) against the stock boot class path, and a method that already fails there
# is reported as pre-existing but never blocks the build. A rebuilt file that has no stock counterpart has no
# baseline, so every hard failure in it counts. Comparing against stock (rather than only looking at the classes a
# patch touched) also catches an untouched class that breaks because a patch changed something it depends on,
# e.g. the type of a framework field.
#
# Class loaders are modelled the way the device builds them:
#   - boot class path jars: verified against BOOTCLASSPATH minus the jar itself (a debug dex2oat aborts on the
#     first erroneous class of a boot image compile, so they are compiled as an app instead),
#   - SYSTEMSERVERCLASSPATH jars: PCL[every other system server jar] on top of BOOTCLASSPATH,
#   - standalone system server jars: PCL[] whose parent is PCL[SYSTEMSERVERCLASSPATH],
#   - APKs and everything else: PCL[] plus the <uses-library> jars declared in the decoded manifest.
# BOOTCLASSPATH and SYSTEMSERVERCLASSPATH are derived like derive_classpath does on device: the classpaths/*.pb
# fragments of the ART module, of /system and of every other APEX (sorted by name), APEX jars are extracted from
# the APEX payloads (erofs: extract.erofs, ext4: debugfs) into a cache keyed by the payload CRC.
#
# Results are cached by content (dex CRCs of the file, of every class path jar and of dex2oat itself), so the stock
# side is verified once per firmware and an unchanged rebuild costs nothing.
#
# Usage: verify_dex.py --dex2oat <dex2oat> --rom <work dir> [--stock <dir>]... [--apktool-dir <dir>]
#                      [--target <host file>=<device path>]... [--cache <dir>] [-j N]
# Exit status: 0 = no new hard failure (or the check could not run: a warning says why), 1 = new hard failures.

import argparse
import concurrent.futures
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import threading
import time
import zipfile

CACHE_VERSION = "1"
INDENT = " " * int(os.environ.get("INDENT_LEVEL", "0") or 0)
YELLOW, RED, RESET = "\033[0;33m", "\033[0;31m", "\033[0m"

BOOTCLASSPATH, SYSTEMSERVERCLASSPATH, DEX2OATBOOTCLASSPATH, STANDALONE_SYSTEMSERVER_JARS = 1, 2, 3, 4
DEX_ENTRY = re.compile(r"^classes\d*\.dex$")
LOG_LINE = re.compile(r"^\S+ \S+\s+\d+\s+(\d+) ([VDIWEF]) [^:]+: (\S+:\d+) ?(.*)$")
HARD_FAIL = "Verification error in "


class SkipCheck(Exception):
    pass


def log(msg):
    print(INDENT + msg, flush=True)


def warn(msg):
    print(YELLOW + INDENT + msg + RESET, file=sys.stderr, flush=True)


def err(msg):
    print(RED + INDENT + msg + RESET, file=sys.stderr, flush=True)


# --- protobuf (classpaths/*.pb, apex_manifest.pb): just enough of the wire format ---

def _varint(b, i):
    r = s = 0
    while True:
        c = b[i]
        i += 1
        r |= (c & 0x7F) << s
        s += 7
        if not c & 0x80:
            return r, i


def pb_fields(b):
    i, out = 0, []
    while i < len(b):
        k, i = _varint(b, i)
        f, t = k >> 3, k & 7
        if t == 0:
            v, i = _varint(b, i)
        elif t == 2:
            n, i = _varint(b, i)
            v, i = b[i:i + n], i + n
        elif t == 5:
            v, i = b[i:i + 4], i + 4
        elif t == 1:
            v, i = b[i:i + 8], i + 8
        else:
            raise ValueError("unsupported wire type %d" % t)
        out.append((f, v))
    return out


def classpath_jars(pb_path, sdk):
    """[(device path, classpath kind)] of an ExportedClasspathsJars fragment, filtered by min/max SDK."""
    with open(pb_path, "rb") as f:
        data = f.read()
    jars = []
    for field, value in pb_fields(data):
        if field != 1:
            continue
        jar = {f: v for f, v in pb_fields(value)}
        path = jar.get(1, b"").decode()
        lo, hi = jar.get(3, b"").decode(), jar.get(4, b"").decode()
        if sdk and lo.isdigit() and int(lo) > sdk:
            continue
        if sdk and hi.isdigit() and int(hi) < sdk:
            continue
        jars.append((path, jar.get(2, 0)))
    return jars


# --- fingerprints ---

_fp_lock = threading.Lock()
_fp_cache = {}


def fingerprint(path):
    """Content fingerprint: the dex entry CRCs of a zip (free, from its central directory), else a file hash."""
    st = os.stat(path)
    key = (path, st.st_size, st.st_mtime_ns)
    with _fp_lock:
        if key in _fp_cache:
            return _fp_cache[key]
    h = hashlib.sha1()
    if zipfile.is_zipfile(path):
        with zipfile.ZipFile(path) as z:
            for i in sorted(z.infolist(), key=lambda i: i.filename):
                if DEX_ENTRY.match(i.filename):
                    h.update(("%s:%08x:%d;" % (i.filename, i.CRC, i.file_size)).encode())
    else:
        with open(path, "rb") as f:
            for chunk in iter(lambda: f.read(1 << 20), b""):
                h.update(chunk)
    fp = h.hexdigest()
    with _fp_lock:
        _fp_cache[key] = fp
    return fp


def has_dex(path):
    try:
        with zipfile.ZipFile(path) as z:
            return any(DEX_ENTRY.match(n) for n in z.namelist())
    except (zipfile.BadZipFile, OSError):
        return False


# --- APEX extraction ---

class ApexCache:
    def __init__(self, cache_dir):
        self.dir = os.path.join(cache_dir, "apex")
        os.makedirs(self.dir, exist_ok=True)
        self.extract_erofs = shutil.which("extract.erofs")
        self.debugfs = shutil.which("debugfs")
        self.lock = threading.Lock()
        self.inflight = {}

    def get(self, apex_path):
        """Extracted dir (javalib/, etc/classpaths/, apex_manifest.pb) of an .apex/.capex, None if no payload."""
        try:
            z = zipfile.ZipFile(apex_path)
        except (zipfile.BadZipFile, OSError):
            return None
        with z:
            names = set(z.namelist())
            entry = "original_apex" if "original_apex" in names else "apex_payload.img"
            if entry not in names:
                return None
            info = z.getinfo(entry)
            key = "%s-%08x-%d" % (os.path.basename(apex_path), info.CRC, info.file_size)
            out = os.path.join(self.dir, key)
            if os.path.exists(os.path.join(out, ".done")):
                os.utime(os.path.join(out, ".done"))
                return out
            with self.lock:
                ev = self.inflight.get(key)
                owner = ev is None
                if owner:
                    ev = self.inflight[key] = threading.Event()
            if not owner:
                ev.wait()
                return out if os.path.exists(os.path.join(out, ".done")) else None
            try:
                return self._extract(z, entry, out)
            except SkipCheck:
                raise
            except Exception as e:  # a broken APEX must not take the whole check down
                warn("Cannot unpack %s: %s" % (os.path.basename(apex_path), e))
                return None
            finally:
                ev.set()

    def _extract(self, z, entry, out):
        tmp = "%s.tmp%d.%d" % (out, os.getpid(), threading.get_ident())
        shutil.rmtree(tmp, ignore_errors=True)
        os.makedirs(tmp)
        try:
            inner = z
            if entry == "original_apex":
                z.extract(entry, tmp)
                inner = zipfile.ZipFile(os.path.join(tmp, entry))
            with open(os.path.join(tmp, "apex_manifest.pb"), "wb") as f:
                f.write(inner.read("apex_manifest.pb"))
            inner.extract("apex_payload.img", tmp)
            if inner is not z:
                inner.close()
                os.remove(os.path.join(tmp, entry))
            payload = os.path.join(tmp, "apex_payload.img")
            with open(payload, "rb") as f:
                f.seek(1024)
                erofs = f.read(4) == b"\xe2\xe1\xf5\xe0"
            fs = os.path.join(tmp, "fs")
            os.makedirs(os.path.join(fs, "etc"))
            if erofs:
                if not self.extract_erofs:
                    raise SkipCheck("extract.erofs not found, cannot unpack " + os.path.basename(out))
                for p in ("/javalib", "/etc/classpaths"):
                    subprocess.run([self.extract_erofs, "-i", payload, "-X", p, "-o", fs, "-s"],
                                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            else:
                if not self.debugfs:
                    raise SkipCheck("debugfs not found, cannot unpack " + os.path.basename(out))
                # rdump warns that it cannot chown, the files are extracted anyway
                for p, d in (("/javalib", fs), ("/etc/classpaths", os.path.join(fs, "etc"))):
                    subprocess.run([self.debugfs, "-R", "rdump %s %s" % (p, d), payload],
                                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            os.remove(payload)
            for d in ("javalib", "etc"):
                if os.path.isdir(os.path.join(fs, d)):
                    os.rename(os.path.join(fs, d), os.path.join(tmp, d))
            shutil.rmtree(fs, ignore_errors=True)
            shutil.rmtree(out, ignore_errors=True)
            os.rename(tmp, out)
            open(os.path.join(out, ".done"), "w").close()
            return out
        finally:
            shutil.rmtree(tmp, ignore_errors=True)


# --- partition trees (work dir / extracted firmware) ---

class Tree:
    """A work dir or extracted firmware dir (<root>/system/system, <root>/product, ...)."""

    def __init__(self, root, label, apexes, overrides=None):
        self.root = root
        self.label = label
        self.overrides = overrides or {}
        self.sdk = self._sdk()
        self.apex = {}  # apex name -> extracted dir
        dirs = [self._join(p) for p in ("/system/apex", "/system_ext/apex", "/product/apex", "/vendor/apex")]
        files = []
        for d in dirs:
            for d2 in d:
                if os.path.isdir(d2):
                    files += sorted(os.path.join(d2, f) for f in os.listdir(d2)
                                    if f.endswith((".apex", ".capex")))
        with concurrent.futures.ThreadPoolExecutor(8) as ex:
            extracted = list(ex.map(apexes.get, files))
        for d in extracted:
            if not d:
                continue
            try:
                with open(os.path.join(d, "apex_manifest.pb"), "rb") as f:
                    name = next(v.decode() for k, v in pb_fields(f.read()) if k == 1)
            except (OSError, StopIteration, ValueError):
                continue
            self.apex.setdefault(name, d)
        self.bcp = self._classpath(BOOTCLASSPATH)
        self.sscp = self._classpath(SYSTEMSERVERCLASSPATH)
        self.standalone = self._classpath(STANDALONE_SYSTEMSERVER_JARS)
        self.libs = self._libraries()

    def _join(self, device):
        """Candidate host paths of a /partition/... device path."""
        part, _, rest = device.lstrip("/").partition("/")
        if part == "system":
            return [os.path.join(self.root, "system/system", rest)]
        return [os.path.join(self.root, part, rest), os.path.join(self.root, "system/system", part, rest)]

    def resolve(self, device):
        if device in self.overrides:
            return self.overrides[device]
        if device.startswith("/apex/"):
            name, _, rest = device[6:].partition("/")
            d = self.apex.get(name)
            p = os.path.join(d, rest) if d else None
            return p if p and os.path.isfile(p) else None
        for p in self._join(device):
            if os.path.isfile(p):
                return p
        return None

    def _sdk(self):
        for p in self._join("/system/build.prop"):
            try:
                with open(p, errors="replace") as f:
                    for line in f:
                        if line.startswith("ro.build.version.sdk="):
                            return int(line.split("=", 1)[1].strip())
            except (OSError, ValueError):
                pass
        return 0

    def _classpath(self, kind):
        """[(device path, host path)] in derive_classpath order: ART module, /system, other APEXes by name."""
        name = "systemserverclasspath.pb" if kind in (SYSTEMSERVERCLASSPATH, STANDALONE_SYSTEMSERVER_JARS) \
            else "bootclasspath.pb"
        fragments = []
        if "com.android.art" in self.apex:
            fragments.append(os.path.join(self.apex["com.android.art"], "etc/classpaths", name))
        fragments += self._join("/system/etc/classpaths/" + name)
        fragments += [os.path.join(self.apex[n], "etc/classpaths", name) for n in sorted(self.apex)
                      if n != "com.android.art"]
        out, seen = [], set()
        for frag in fragments:
            if not os.path.isfile(frag):
                continue
            for jar, k in classpath_jars(frag, self.sdk):
                if k != kind or jar in seen:
                    continue
                seen.add(jar)
                host = self.resolve(jar)
                if host and has_dex(host):
                    out.append((jar, host))
        return out

    def _libraries(self):
        """<library name> -> device path, from etc/permissions of every partition (plus the implicit ones)."""
        libs = {}
        for name in ("org.apache.http.legacy", "android.test.base", "android.test.mock", "android.test.runner"):
            libs[name] = "/system/framework/%s.jar" % name
        lib_re = re.compile(r"<(?:library|updatable-library|apex-library)\b([^>]*)>", re.S)
        attr_re = re.compile(r'(\w+)\s*=\s*"([^"]*)"')
        for part in ("/system", "/system_ext", "/product", "/vendor", "/odm"):
            for d in self._join(part + "/etc/permissions"):
                if not os.path.isdir(d):
                    continue
                for f in sorted(os.listdir(d)):
                    if not f.endswith(".xml"):
                        continue
                    try:
                        with open(os.path.join(d, f), errors="replace") as fh:
                            text = fh.read()
                    except OSError:
                        continue
                    for m in lib_re.finditer(text):
                        a = dict(attr_re.findall(m.group(1)))
                        if a.get("name") and a.get("file"):
                            libs[a["name"]] = a["file"]
        return libs

    def bcp_args(self, exclude=None):
        jars = [(d, h) for d, h in self.bcp if d != exclude]
        return ["--runtime-arg", "-Xbootclasspath:" + ":".join(h for _, h in jars),
                "--runtime-arg", "-Xbootclasspath-locations:" + ":".join(d for d, _ in jars)], [h for _, h in jars]

    def has_art(self):
        return any(d.startswith("/apex/com.android.art/") and d.endswith("/core-oj.jar") for d, _ in self.bcp)


def uses_libraries(manifest):
    if not manifest or not os.path.isfile(manifest):
        return []
    with open(manifest, errors="replace") as f:
        text = f.read()
    return re.findall(r'<uses-library[^>]*?android:name="([^"]+)"', text)


def make_job(tree, device, host, libs):
    """dex2oat arguments (minus the I/O ones) for verifying host as device in tree, and the files it reads."""
    sscp = [d for d, _ in tree.sscp]
    if any(d == device for d, _ in tree.bcp):
        mode = "bootclasspath"
        bcp, files = tree.bcp_args(exclude=device)
        clc = "PCL[]"
    else:
        bcp, files = tree.bcp_args()
        if device in sscp:
            mode = "systemserver"
            others = [h for d, h in tree.sscp if d != device]
            clc = "PCL[%s]" % ":".join(others)
            files += others
        elif any(d == device for d, _ in tree.standalone):
            mode = "standalone systemserver"
            clc = "PCL[];PCL[%s]" % ":".join(h for _, h in tree.sscp)
            files += [h for _, h in tree.sscp]
        else:
            mode = "app"
            shared = []
            for name in libs:
                p = tree.resolve(tree.libs[name]) if name in tree.libs else None
                if p and has_dex(p) and p not in shared:
                    shared.append(p)
            clc = "PCL[]" + ("{%s}" % "#".join("PCL[%s]" % p for p in shared) if shared else "")
            files += shared
    return {"mode": mode, "args": bcp + ["--class-loader-context=" + clc], "files": files,
            "host": host, "device": device, "tree": tree.label}


# --- running dex2oat ---

def parse_log(text):
    """[{method, message}] of every hard verification failure dex2oat logged."""
    open_recs, failures = {}, []
    for line in text.splitlines():
        m = LOG_LINE.match(line)
        if not m:
            continue
        tid, _, src, msg = m.groups()
        key = (tid, src)
        if msg.startswith(HARD_FAIL):
            rec = {"method": msg[len(HARD_FAIL):].strip(), "message": []}
            failures.append(rec)
            open_recs[key] = rec
        elif key in open_recs and msg.strip():
            text_ = msg.strip()
            meth = open_recs[key]["method"]
            for prefix in (meth + " failed to verify: " + meth + ": ", meth + ": "):
                if text_.startswith(prefix):
                    text_ = text_[len(prefix):]
                    break
            open_recs[key]["message"].append(text_)
        elif key in open_recs:
            del open_recs[key]
    return [{"method": f["method"], "message": " | ".join(f["message"])} for f in failures]


class Runner:
    def __init__(self, dex2oat, cache_dir, threads):
        self.dex2oat = dex2oat
        self.host_root = os.path.dirname(os.path.dirname(os.path.realpath(dex2oat)))
        self.cache_dir = os.path.join(cache_dir, "results")
        self.work = os.path.join(cache_dir, "run.%d" % os.getpid())
        self.threads = threads
        os.makedirs(self.cache_dir, exist_ok=True)
        os.makedirs(os.path.join(self.work, "data"), exist_ok=True)
        self.tool_fp = fingerprint(dex2oat)
        self.env = dict(os.environ, ANDROID_ROOT=self.host_root, ANDROID_ART_ROOT=self.host_root,
                        ANDROID_I18N_ROOT=os.path.join(self.host_root, "com.android.i18n"),
                        ANDROID_TZDATA_ROOT=os.path.join(self.host_root, "com.android.tzdata"),
                        ANDROID_DATA=os.path.join(self.work, "data"), ANDROID_LOG_TAGS="*:w")
        self.counter = 0
        self.lock = threading.Lock()

    def key(self, job):
        h = hashlib.sha1()
        h.update(json.dumps([CACHE_VERSION, self.tool_fp, job["device"], job["mode"], fingerprint(job["host"]),
                             [fingerprint(f) for f in job["files"]],
                             re.sub(r"(/[^:\[\]{}#;]+)", lambda m: os.path.basename(m.group(1)),
                                    " ".join(job["args"]))]).encode())
        return h.hexdigest()

    def run(self, job):
        key = self.key(job)
        cached = os.path.join(self.cache_dir, key + ".json")
        if os.path.isfile(cached):
            with open(cached) as f:
                res = json.load(f)
            os.utime(cached)
            res["cached"] = True
            return res
        with self.lock:
            self.counter += 1
            out = os.path.join(self.work, "%d.odex" % self.counter)
        cmd = [self.dex2oat] + job["args"] + [
            "--base=0x70000000",  # imageless mode wants it even when no image is written
            "--dex-file=" + job["host"], "--dex-location=" + job["device"], "--oat-file=" + out,
            "--compiler-filter=verify", "--instruction-set=arm64", "--avoid-storing-invocation",
            "-j%d" % self.threads]
        t = time.time()
        p = subprocess.run(cmd, env=self.env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                           errors="replace")
        for ext in (".odex", ".vdex", ".art"):
            try:
                os.remove(out[:-5] + ext)
            except OSError:
                pass
        res = {"failures": parse_log(p.stdout), "rc": p.returncode, "seconds": round(time.time() - t, 1)}
        if p.returncode != 0:
            tail = [m.group(4) for m in map(LOG_LINE.match, p.stdout.splitlines())
                    if m and m.group(2) in "EF" and m.group(4).strip()]
            last = p.stdout.strip().splitlines()[-1:]
            res["error"] = " | ".join(tail[:3]) or (last[0] if last else "exit status %d" % p.returncode)
        else:
            with open(cached + ".tmp", "w") as f:
                json.dump(res, f)
            os.replace(cached + ".tmp", cached)
        res["cached"] = False
        return res

    def cleanup(self):
        shutil.rmtree(self.work, ignore_errors=True)


# --- targets ---

def apktool_targets(apktool_dir):
    """[(device path, decoded dir)] of every APK/JAR apktool decoded (and so rebuilt)."""
    out = []
    for root, dirs, _ in os.walk(apktool_dir):
        for d in sorted(dirs):
            if d.endswith((".apk", ".jar")):
                rel = os.path.relpath(os.path.join(root, d), apktool_dir)
                out.append(("/" + rel, os.path.join(root, d)))
        dirs[:] = [d for d in dirs if not d.endswith((".apk", ".jar"))]
    return out


def prune(cache_dir, days=30):
    """Drops cached results and unpacked APEXes not used for a month (older firmwares, older ROM builds)."""
    limit = time.time() - days * 86400
    results = os.path.join(cache_dir, "results")
    for f in os.listdir(results) if os.path.isdir(results) else []:
        p = os.path.join(results, f)
        if os.path.getmtime(p) < limit:
            os.remove(p)
    apex = os.path.join(cache_dir, "apex")
    for d in os.listdir(apex) if os.path.isdir(apex) else []:
        done = os.path.join(apex, d, ".done")
        if not os.path.exists(done) or os.path.getmtime(done) < limit:
            if ".tmp" not in d or os.path.getmtime(os.path.join(apex, d)) < limit:
                shutil.rmtree(os.path.join(apex, d), ignore_errors=True)


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--dex2oat", required=True)
    ap.add_argument("--rom", required=True, help="work dir (or any dir laid out like it)")
    ap.add_argument("--stock", action="append", default=[],
                    help="stock firmware dir(s) for the baseline; the first one also gives the stock class path")
    ap.add_argument("--apktool-dir", help="verify every APK/JAR decoded here")
    ap.add_argument("--target", action="append", default=[], metavar="HOST=DEVICE",
                    help="verify HOST as DEVICE (it also replaces DEVICE in the ROM class paths)")
    ap.add_argument("--cache", required=True)
    ap.add_argument("-j", "--jobs", type=int, default=os.cpu_count() or 4)
    ap.add_argument("--report", help="write the full result as JSON here")
    a = ap.parse_args()

    start = time.time()
    overrides, manifests = {}, {}
    for t in a.target:
        host, _, device = t.partition("=")
        overrides[device] = os.path.abspath(host)
    if a.apktool_dir and not a.target:
        for device, decoded in apktool_targets(a.apktool_dir):
            overrides.setdefault(device, None)
            manifests[device] = os.path.join(decoded, "AndroidManifest.xml")
    if not overrides:
        log("Nothing to verify")
        return 0

    os.makedirs(a.cache, exist_ok=True)
    apexes = ApexCache(a.cache)
    try:
        rom = Tree(a.rom, "rom", apexes, {d: h for d, h in overrides.items() if h})
        stock = [Tree(s, "stock", apexes) for s in a.stock if os.path.isdir(s)]
    except SkipCheck as e:
        warn("%s, the dex files are not verified" % e)
        return 0
    if not rom.has_art():
        warn("No ART module boot jars found in the ROM, the dex files are not verified")
        return 0
    if stock and not stock[0].has_art():
        warn("No ART module boot jars found in the stock firmware, failures cannot be compared with stock")
        stock = []

    targets = []
    for device in sorted(overrides):
        host = rom.resolve(device)
        if not host or not has_dex(host):
            continue
        libs = uses_libraries(manifests.get(device))
        job = make_job(rom, device, host, libs)
        base = None
        for s in stock:
            h = s.resolve(device)
            if h and has_dex(h):
                base = make_job(stock[0], device, h, libs)
                base["origin"] = s.root
                break
        targets.append((job, base))
    if not targets:
        log("No rebuilt dex to verify")
        return 0

    jobs = [j for t in targets for j in t if j]
    jobs.sort(key=lambda j: -os.path.getsize(j["host"]))
    threads = 4
    runner = Runner(a.dex2oat, a.cache, threads)
    results = {}
    try:
        with concurrent.futures.ThreadPoolExecutor(max(1, a.jobs // threads)) as ex:
            futs = {ex.submit(runner.run, j): id(j) for j in jobs}
            for f in concurrent.futures.as_completed(futs):
                results[futs[f]] = f.result()
    finally:
        runner.cleanup()

    new_total = old_total = 0
    blocked = []
    report = []
    for job, base in targets:
        r = results[id(job)]
        b = results[id(base)] if base else None
        name = job["device"]
        entry = {"device": name, "mode": job["mode"], "rom": r, "stock": b,
                 "baseline": base["origin"] if base else None}
        report.append(entry)
        if r["rc"] != 0:
            if b is not None and b["rc"] != 0:
                warn("%s: dex2oat fails on it and on the stock file too (%s), not verified" % (name, r.get("error")))
            else:
                err("%s: dex2oat failed (%s)" % (name, r.get("error")))
                blocked.append(name)
            continue
        stock_methods = {f["method"] for f in b["failures"]} if b and b["rc"] == 0 else set()
        new = [f for f in r["failures"] if f["method"] not in stock_methods]
        old = [f for f in r["failures"] if f["method"] in stock_methods]
        entry["new"] = new
        new_total += len(new)
        old_total += len(old)
        how = "" if base else ", no stock counterpart"
        if b is not None and b["rc"] != 0:
            how = ", stock file not verifiable"
        if new:
            err("%s (%s%s): %d new hard verification failure(s)" % (name, job["mode"], how, len(new)))
            for f in new:
                err("    %s: %s" % (f["method"], f["message"]))
            blocked.append(name)
        elif old:
            log("- %s: %d hard failure(s), all already in stock" % (name, len(old)))

    elapsed = time.time() - start
    ran = sum(1 for r in results.values() if not r["cached"])
    log("- Verified %d file(s) (%d dex2oat run(s), %d cached) in %ds: %d new hard failure(s), %d pre-existing in stock"
        % (len(targets), ran, len(results) - ran, elapsed, new_total, old_total))
    if a.report:
        with open(a.report, "w") as f:
            json.dump(report, f, indent=1)
    prune(a.cache)
    if blocked:
        err("The ART verifier rejects classes in: %s" % ", ".join(blocked))
        err("Each one throws VerifyError when first used on device (system_server: bootloop)")
        return 1
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception:  # a bug here must not block a build: say so loudly and skip
        import traceback
        traceback.print_exc()
        warn("verify_dex.py crashed, the rebuilt dex files are not verified")
        sys.exit(0)
