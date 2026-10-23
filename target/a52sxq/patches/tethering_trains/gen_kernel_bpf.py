#!/usr/bin/env python3
# What the phone's kernel can actually run, for check_netd.py: map types and program types this build registers
# (include/linux/bpf_types.h under its .config) and, per program type, the helpers its verifier ops' get_func_proto
# chain returns (net/core/filter.c, kernel/bpf/*.c, kernel/trace/bpf_trace.c, with the #ifdefs of that .config).
# Not run by the build: rerun after a kernel change and paste the output over the generated block in check_netd.py.
#
#   gen_kernel_bpf.py <kernel tree> <.config, e.g. adb shell zcat /proc/config.gz>
#
# A case that returns a proto only for some attach types / conditions is counted as available (it is for the attach
# type the program was written for); `return NULL` cases and helpers no proto function lists are not.
import hashlib, os, re, sys

KDIR, CFG = sys.argv[1], sys.argv[2]
cfg = {}
for line in open(CFG):
    m = re.match(r"(CONFIG_\w+)=(.*)", line.strip())
    if m: cfg[m.group(1)] = m.group(2)
on = lambda c: cfg.get(c) in ("y", "m")
unknown = set()


def cond(expr):
    e = expr.split("/*")[0].strip()
    e = re.sub(r"IS_ENABLED\((CONFIG_\w+)\)|IS_BUILTIN\((CONFIG_\w+)\)|defined\s*\(?\s*(CONFIG_\w+)\s*\)?",
               lambda m: str(on(m.group(1) or m.group(2) or m.group(3))), e)
    e = re.sub(r"\b(CONFIG_\w+)\b", lambda m: str(on(m.group(1))), e)
    py = e.replace("&&", " and ").replace("||", " or ").replace("!", " not ")
    try:
        return bool(eval(py, {"__builtins__": {}}, {"True": True, "False": False}))
    except Exception:
        unknown.add(expr.strip()); return True


def preprocess(path):
    out, stack = [], []          # stack of [this branch active, any branch taken, parent active]
    for line in open(path, errors="replace"):
        s = line.strip()
        m = re.match(r"#\s*(ifdef|ifndef|if|elif|else|endif)\b(.*)", s)
        if not m:
            if all(a for a, _, _ in stack): out.append(line)
            continue
        d, rest = m.group(1), m.group(2)
        par = all(a for a, _, _ in stack)
        if d in ("ifdef", "ifndef"):
            v = on(rest.split()[0]) if rest.split()[0].startswith("CONFIG_") else (unknown.add(s) or True)
            v = v if d == "ifdef" else not v
            stack.append([v, v, par])
        elif d == "if":
            v = cond(rest); stack.append([v, v, par])
        elif d == "elif":
            top = stack[-1]; v = not top[1] and cond(rest); top[0] = v; top[1] = top[1] or v
        elif d == "else":
            top = stack[-1]; top[0] = not top[1]; top[1] = True
        else:
            stack.pop()
    return "".join(out)


src = {}
for sub in ("net/core", "kernel/bpf", "kernel/trace", "net/ipv4", "net/ipv6"):
    for f in sorted(os.listdir(os.path.join(KDIR, sub))):
        if f.endswith(".c"): src[os.path.join(sub, f)] = preprocess(os.path.join(KDIR, sub, f))
alltext = "\n".join(src.values())


def body(fn):
    m = re.search(r"\n" + fn + r"\(enum bpf_func_id func_id[^)]*\)\s*\{", alltext)
    assert m, fn
    i, depth = m.end(), 1
    while depth:
        c = alltext[i]; depth += (c == "{") - (c == "}"); i += 1
    return alltext[m.end():i - 1]


memo = {}


def helpers(fn):
    """helper name -> 'yes' | 'cond' | 'no' for one func_proto function (with its fallbacks)"""
    if fn in memo: return memo[fn]
    memo[fn] = {}
    b = body(fn); res = {}
    for fb in re.findall(r"(\w+_func_proto)\(\s*func_id", b):
        if fb != fn:
            for h, v in helpers(fb).items(): res.setdefault(h, v)
    own, labels, between = {}, [], ""
    for tok in re.finditer(r"case\s+BPF_FUNC_(\w+)\s*:|default\s*:|return\b[^;]*;|\b(if|switch)\b", b):
        t = tok.group(0)
        if t.startswith("case"):
            if not labels: between = ""
            labels.append(tok.group(1))
        elif t.startswith("default"):
            labels = []
        elif t in ("if", "switch"):
            between += t
        elif labels:
            v = "no" if re.fullmatch(r"return\s+NULL\s*;", t) else "cond" if (between or "NULL" in t or "?" in t) else "yes"
            for h in labels: own.setdefault(h, v)
            labels = []
    res.update(own)
    memo[fn] = res
    return res


bpf_h = open(os.path.join(KDIR, "include/uapi/linux/bpf.h")).read()
enum = lambda name: [x.strip().rstrip(",") for x in re.search(r"enum " + name + r" \{(.*?)\};", bpf_h, re.S).group(1)
                     .split("\n") if x.strip().startswith("BPF_")]
MAPT = {n: i for i, n in enumerate(enum("bpf_map_type"))}
PROGT = {n: i for i, n in enumerate(enum("bpf_prog_type"))}
fnames = re.findall(r"FN\((\w+)\)", re.search(r"#define __BPF_FUNC_MAPPER\(FN\)(.*?)\n\n", bpf_h, re.S).group(1))
FID = {n: i for i, n in enumerate(fnames)}

tmp = os.path.join(os.path.dirname(os.path.abspath(CFG)), ".bpf_types.h.pp")
open(tmp, "w").write(open(os.path.join(KDIR, "include/linux/bpf_types.h")).read())
types_h = preprocess(tmp); os.unlink(tmp)
progs = re.findall(r"BPF_PROG_TYPE\((BPF_PROG_TYPE_\w+),\s*(\w+)", types_h)
maps = sorted(MAPT[m] for m in re.findall(r"BPF_MAP_TYPE\((BPF_MAP_TYPE_\w+),", types_h))

out = {}
for pt, name in progs:
    m = re.search(r"const struct bpf_verifier_ops " + name + r"_verifier_ops = \{(.*?)\};", alltext, re.S)
    if not m: continue
    fn = re.search(r"\.get_func_proto\s*=\s*(\w+)", m.group(1)).group(1)
    h = helpers(fn)
    out[PROGT[pt]] = (pt, fn, sorted(FID[x] for x, v in h.items() if v != "no" and x in FID),
                      sorted(FID[x] for x, v in h.items() if v == "cond" and x in FID))

sig = hashlib.sha256(open(CFG, "rb").read()).hexdigest()[:16]
print(f"# --- generated by gen_kernel_bpf.py (kernel {open(os.path.join(KDIR, 'Makefile')).read().split('SUBLEVEL = ')[1].split()[0]},"
      f" .config sha256 {sig}...) ---")
print(f"MAP_TYPES = {set(maps)}")
print("PROG_HELPERS = {   # program type -> helper ids its get_func_proto chain returns")
for t in sorted(out):
    pt, fn, ids, cnd = out[t]
    print(f"    {t}: {set(ids)},   # {pt} ({fn}); attach-type/condition dependent: {cnd}")
print("}")
print("# --- end of generated block ---")
if unknown: print("# unevaluated preprocessor conditions (taken as true):", sorted(unknown)[:20], file=sys.stderr)
