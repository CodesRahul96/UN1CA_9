#!/usr/bin/env python3
# Does our frozen BPF loader + frozen netd.o load what every Tethering version we know about needs?
#
#   check_netd.py <a52_netd.o> <known netd.o>...    exit 0: all covered; 1: something missing (printed)
#   check_netd.py --list <known netd.o>...          prints "<sha256> <label>" lines for /system/etc/bpf/a52_netd.known
#
# Our loader (netbpfload_a52*) only ever loads /system/etc/bpf/a52_netd.o, whatever Tethering APEX is active. The
# APEX's userspace (libservice-connectivity.so in system_server, libnetd_updatable.so in netd) opens the map and
# program pins its own netd.o defines and abort()s when one is missing -> crash loop -> apexd reverts the update (a
# staged boot) or, after a ROM flash under an already active train, a real boot loop. So a52_netd.o must define:
#   * every map of every known netd.o with an identical bpf_map_def (ringbuf maps: min_kver may be lowered to 5.4,
#     regen.py does that on purpose; maps both sides only create on >= 5.10, e.g. sk_storage, may differ), and
#   * every program pin a known netd.o would pin on this kernel at API 37.
# Known objects live in known/ as <versionCode>_<label>_netd.o (the factory one and each Play train's, pulled from
# /apex/com.android.tethering/etc/bpf/mainline/netd.o or /cache/k4_mainline/staged_tethering_netd.o).
#
# The other objects the frozen loader loads come from the ACTIVE APEX itself (loadAllObjects in netbpfload 371021120,
# same order: offload.o test.o clatd.o dscpPolicy.o netd.o; the @funcs.o variants only on >= 6.6.118 kernels). Each
# is critical: a map the kernel cannot create or a non-optional program the kernel rejects fails the whole load ->
# bpfloader reboot_on_failure -> reboot,bpfloader-failed loop. So every known entry also needs its
# <versionCode>_<label>_<obj>.o for each of those objects, and for each of them the loader's own rules are replayed
# for 5.4.302 at API 37 (kver/api windows of every map and program), plus what this kernel can execute:
#   * every map it would create has a map type this kernel has (5.4: 0-25, + RINGBUF 27 from k4 patch 0006),
#   * every program it would load has a 5.4 program type and only 5.4 instructions/helpers (no kfuncs, no cpu v4 /
#     5.12+ atomics; helpers: only the ids this kernel implements, i.e. has a `case BPF_FUNC_<x>:` for in net/ or
#     kernel/ of ~/git/kernel_a52sxq_bone - 1..110 and the backported 125 ktime_get_boot_ns; 111..124 are only named
#     in its uapi enum and the verifier rejects them),
#     else the load fails - except for an optional program in offload.o, the only object the frozen loader loads
#     without libbpf on 5.4 (loadObject(offload.o, libbpf = kernel >= 5.10)), which is skipped and stays unpinned,
#   * no in-window program of a libbpf-loaded object (test/clatd/dscpPolicy.o, a52_netd.o) is optional: the frozen
#     loader's libbpf path refuses those ("Optional program cannot be loaded by libbpf") and fails the object,
#   * every map/program pin it defines for API 37 (on any kernel) is created on 5.4.302 - unless the factory object
#     of the same name does not create it on 5.4.302 either (the factory userspace runs without it: e.g. dscpPolicy's
#     5.15+ program) or known/tolerated.txt lists it ("<obj> <pin>  # why", for a reviewed 5.10+-only addition).
#   * struct bpf_map_def/bpf_prog_def sizes are the ones the loader reads (192/180), a license section exists.
# The same instruction checks also run on the programs a52_netd.o itself loads.
import hashlib, os, re, struct, sys
sys.dont_write_bytecode = True
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "tethering"))
from bpf_union import Elf, Btf, map_defs

KV = lambda a, b, c: (a << 24) | (b << 16) | c
KERNEL = KV(5, 4, 302)          # bone-machine 5.4.302
API = 3700                      # Android 17 (sdk_full 37.0 -> netbpfload api 3700)
M_SZ, P_SZ = 192, 180           # struct bpf_map_def, struct bpf_prog_def
RINGBUF = 27
LOADER_OBJS = ("offload", "test", "clatd", "dscpPolicy")   # loaded from the active APEX's etc/bpf/mainline/
NON_LIBBPF = {"offload"}        # loadObject(offload.o, libbpf=false): BTF only sanitized by sanitizeBtf()
# what kernel 5.4.302 (bone-machine, k4 patches) has
MAP_TYPES = set(range(0, 26)) | {RINGBUF}   # STRUCT_OPS 26 is only an enum placeholder in the k4 backport
MAX_PROG_TYPE = 25              # BPF_PROG_TYPE_CGROUP_SOCKOPT
HELPERS = set(range(1, 111)) | {125}   # implemented helpers (see above); per-program-type availability is not modelled
MAX_BTF_KIND = 15               # DATASEC; FLOAT/DECL_TAG/TYPE_TAG/ENUM64 are 5.13+
HERE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "known")


def label(path):
    m = re.fullmatch(r"(\d+)_(.+)_netd\.o", os.path.basename(path))
    assert m, f"{path}: name it <versionCode>_<label>_netd.o"
    return m.group(1), m.group(2)


def prog_pins(e):
    """pin -> [(min_kver, max_kver, min_api, max_api)] from .android_progs"""
    d = e.sh[e.idx(".android_progs")]["data"]; assert len(d) % P_SZ == 0
    out = {}
    for o in range(0, len(d), P_SZ):
        r = bytes(d[o:o + P_SZ])
        mink, maxk = struct.unpack_from("<2I", r, 16); mina, maxa = struct.unpack_from("<2i", r, 28)
        out.setdefault(r[106:176].split(b"\0")[0].decode(), []).append((mink, maxk, mina, maxa))
    return out


def loaded(pins):
    return {p for p, v in pins.items() if any(mk <= KERNEL < xk and ma <= API < xa for mk, xk, ma, xa in v)}


def in_window(mk, xk, ma, xa): return mk <= KERNEL < xk and ma <= API < xa


def insn_problems(code):
    """features of a BPF program that kernel 5.4 does not have (empty list: fine)"""
    bad, i = set(), 0
    while i + 8 <= len(code):
        op, regs = code[i], code[i + 1]; off, imm = struct.unpack_from("<hi", code, i + 2)
        cls, src = op & 7, regs >> 4
        if op == 0x18:                                   # ld_imm64: 2 slots; 1 map fd / 2 map value are fine
            if src not in (0, 1, 2): bad.add(f"ld_imm64 pseudo {src}")
            i += 16; continue
        if op == 0x85:
            if src == 0 and imm not in HELPERS: bad.add(f"helper {imm}")
            elif src == 2: bad.add("kfunc call")
        elif cls == 1 and op & 0xE0 == 0x80: bad.add("sign-extending load (6.6)")
        elif cls == 3 and op & 0xE0 == 0xC0 and imm != 0: bad.add(f"atomic op {imm:#x} (5.12)")
        elif cls in (4, 7) and op & 0xF0 in (0x30, 0x90) and off: bad.add("signed div/mod (6.6)")
        elif cls in (4, 7) and op & 0xF0 == 0xB0 and off: bad.add("movsx (6.6)")
        elif op == 0xD7: bad.add("bswap (6.6)")
        elif cls == 6 and op & 0xF0 == 0: bad.add("gotol (6.6)")
        i += 8
    return sorted(bad)


def parse_obj(path):
    """what the frozen loader does with this object on KERNEL at API: (problems, required pins, created pins)"""
    e = Elf(open(path, "rb").read()); probs = []
    libbpf = os.path.basename(path).rsplit("_", 1)[-1][:-2] not in NON_LIBBPF
    if not e.has("license"): probs.append("no license section (loader aborts)")
    syms = list(e.syms())
    def def_sizes(sec):
        si = e.idx(sec)
        return {s[6] for s in syms if s[4] == si and s[1].endswith("_def")}
    req, made = set(), set()
    if e.has(".android_maps"):
        d = e.sh[e.idx(".android_maps")]["data"]
        if len(d) % M_SZ or def_sizes(".android_maps") - {M_SZ}:
            return [f"struct bpf_map_def is not {M_SZ} bytes (loader would misread every map)"], req, made
        for o in range(0, len(d), M_SZ):
            r = bytes(d[o:o + M_SZ]); typ, = struct.unpack_from("<I", r, 0)
            mina, maxa = struct.unpack_from("<2i", r, 32); mink, maxk = struct.unpack_from("<2I", r, 40)
            pin = r[118:188].split(b"\0")[0].decode()
            if mina <= API < maxa: req.add(pin)
            if not in_window(mink, maxk, mina, maxa): continue
            if typ not in MAP_TYPES: probs.append(f"map {pin}: type {typ} cannot be created on 5.4 (load fails)")
            else: made.add(pin)
    if e.has(".android_progs"):
        pi = e.idx(".android_progs"); d = e.sh[pi]["data"]
        if len(d) % P_SZ or def_sizes(".android_progs") - {P_SZ}:
            return probs + [f"struct bpf_prog_def is not {P_SZ} bytes (loader would misread every program)"], req, made
        defs = {s[1]: s[5] for s in syms if s[4] == pi}
        code = {}                                        # prog def offset -> code section (readCodeSections)
        for si, n in enumerate(e.names):
            if n.startswith(".") or "/" not in n or not e.sh[si]["size"]: continue
            f = [s[1] for s in syms if s[4] == si and s[2] & 0xF == 2]
            assert f and f[0] + "_def" in defs, (path, n, "no program definition")
            code[defs[f[0] + "_def"]] = (n, bytes(e.sh[si]["data"]))
        for o in range(0, len(d), P_SZ):
            r = bytes(d[o:o + P_SZ]); typ, = struct.unpack_from("<I", r, 0); opt = r[24]
            mink, maxk = struct.unpack_from("<2I", r, 16); mina, maxa = struct.unpack_from("<2i", r, 28)
            pin = r[106:176].split(b"\0")[0].decode()
            if mina <= API < maxa: req.add(pin)
            if not in_window(mink, maxk, mina, maxa) or o not in code: continue
            why = ([f"program type {typ}"] if typ > MAX_PROG_TYPE else []) + insn_problems(code[o][1])
            if libbpf and opt:
                probs.append(f"program {pin} ({code[o][0]}) is optional: the frozen loader's libbpf path refuses "
                             f"optional programs (load fails)")
            elif not why: made.add(pin)
            elif libbpf or not opt:
                probs.append(f"program {pin} ({code[o][0]}) would be rejected by 5.4: {', '.join(why)} (load fails)")
    btf = Btf(bytes(e.sh[e.idx(".BTF")]["data"])) if e.has(".BTF") else None
    kinds = sorted({t[0] for t in btf.types[1:] if t[0] > MAX_BTF_KIND}) if btf else []
    if kinds and not libbpf:
        probs.append(f"BTF kinds {kinds} unknown to 5.4 and not sanitized on this path (load fails)")
    elif kinds:
        print(f"note: {path}: BTF kinds {kinds} (libbpf sanitizes them on 5.4)")
    return probs, req, made


if sys.argv[1] == "--list":
    for k in sys.argv[2:]:
        ver, lab = label(k)
        print(hashlib.sha256(open(k, "rb").read()).hexdigest(), f"Tethering {ver} ({lab})")
    sys.exit(0)

ours = Elf(open(sys.argv[1], "rb").read())
om, op = map_defs(ours), loaded(prog_pins(ours))
bad = 0
for p in parse_obj(sys.argv[1])[0]:
    print(f"a52_netd.o: {p}"); bad += 1
for k in sys.argv[2:]:
    ver, lab = label(k)
    e = Elf(open(k, "rb").read())
    km, kp = map_defs(e), loaded(prog_pins(e))
    before = bad
    for name, (_, rec) in sorted(km.items()):
        if name not in om:
            print(f"Tethering {ver} ({lab}): map {name} missing from a52_netd.o"); bad += 1; continue
        a, b = bytearray(om[name][1]), bytearray(rec)
        kv_a, kv_b = struct.unpack_from("<I", a, 40)[0], struct.unpack_from("<I", b, 40)[0]
        if struct.unpack_from("<I", b, 0)[0] == RINGBUF and kv_a <= kv_b:
            a[40:44] = b[40:44]
        if a != b and not (kv_a > KERNEL and kv_b > KERNEL):
            diff = [i for i in range(len(a)) if a[i] != b[i]]
            print(f"Tethering {ver} ({lab}): map {name} defined differently (bytes {diff[:8]})"); bad += 1
    for pin in sorted(kp - op):
        print(f"Tethering {ver} ({lab}): program {pin} would not be pinned by a52_netd.o"); bad += 1
    if bad == before:
        print(f"Tethering {ver} ({lab}): {len(km)} maps, {len(kp)} programs covered")

# --- the objects the loader takes from the active APEX ----------------------------------------------------------
known = {label(k): os.path.dirname(os.path.abspath(k)) for k in sys.argv[2:]}
factory = [vl for vl in known if vl[1] == "factory"]
if len(factory) != 1:
    print(f"known/: exactly one *_factory_netd.o needed as the baseline, got {len(factory)}"); bad += 1
tolerated = set()
tol = os.path.join(os.path.dirname(os.path.abspath(sys.argv[2])) if sys.argv[2:] else HERE, "tolerated.txt")
if os.path.exists(tol):
    for line in open(tol):
        f = line.split("#", 1)[0].split()
        if f: assert len(f) == 2, (tol, line); tolerated.add(tuple(f))
base = {}
for ver, lab in factory + sorted(set(known) - set(factory)):
    before, n = bad, 0
    for obj in LOADER_OBJS:
        p = os.path.join(known[(ver, lab)], f"{ver}_{lab}_{obj}.o")
        if not os.path.exists(p):
            print(f"Tethering {ver} ({lab}): known/{os.path.basename(p)} missing - copy it from that APEX's "
                  f"etc/bpf/mainline/{obj}.o (or /cache/k4_mainline/staged_tethering_{obj}.o)"); bad += 1; continue
        probs, req, made = parse_obj(p)
        missing = req - made
        if lab == "factory": base[obj] = missing
        for q in probs:
            print(f"Tethering {ver} ({lab}) {obj}.o: {q}"); bad += 1
        for pin in sorted(missing - base.get(obj, set())):
            if (obj, pin) in tolerated: continue
            print(f"Tethering {ver} ({lab}) {obj}.o: {pin} defined for API {API} but not created on 5.4.302 "
                  f"(the factory one is) - its userspace may abort; review, then fix or add it to known/tolerated.txt"); bad += 1
        n += len(made)
    if bad == before:
        print(f"Tethering {ver} ({lab}): {', '.join(o + '.o' for o in LOADER_OBJS)} load on 5.4.302 at API {API} ({n} pins)")
sys.exit(1 if bad else 0)
