#!/usr/bin/env python3
#
# Checks every invoke-* in the decoded smali of the work dir for the register count its method signature needs
# (one per argument, two for J/D, one more for the receiver of a non-static call). apktool assembles a wrong count
# without complaint, but ART's verifier then rejects the whole class at its first use: in system_server that is a
# VerifyError on every boot (9.3.74: K4NandswapQuota.start passed {v1, v2, v3} for postDelayed(Runnable, long)).
#
# Usage: check_smali_invokes.py <dir>...  (exit 1 and one line per bad invoke if any is found)

import os
import re
import sys

INVOKE = re.compile(
    r"^\s*invoke-(virtual|super|direct|static|interface)(/range)?\s+\{([^}]*)\},\s*"
    r"(\[*L[^;]+;|\[+[ZBSCIJFD])->([^(\s]+)\(([^)]*)\)")
PARAM = re.compile(r"\[*(?:L[^;]+;|[ZBSCIJFD])")
REG = re.compile(r"^[vp](\d+)$")


def slots(params):
    n = 0
    for p in PARAM.findall(params):
        n += 2 if p in ("J", "D") else 1
    return n


def passed(regs, is_range):
    regs = regs.strip()
    if not regs:
        return 0
    if is_range:
        a, b = [r.strip() for r in regs.split("..")]
        ma, mb = REG.match(a), REG.match(b)
        if not ma or not mb or a[0] != b[0]:
            return None
        return int(mb.group(1)) - int(ma.group(1)) + 1
    return len([r for r in regs.split(",") if r.strip()])


def main(dirs):
    bad = checked = 0
    for top in dirs:
        for root, _, files in os.walk(top):
            for name in files:
                if not name.endswith(".smali"):
                    continue
                path = os.path.join(root, name)
                with open(path, encoding="utf-8", errors="replace") as f:
                    for no, line in enumerate(f, 1):
                        if "invoke-" not in line:
                            continue
                        m = INVOKE.match(line)
                        if not m:
                            continue
                        kind, rng, regs, _, meth, params = m.groups()
                        want = slots(params) + (0 if kind == "static" else 1)
                        got = passed(regs, rng is not None)
                        checked += 1
                        if got is not None and got != want:
                            bad += 1
                            print("%s:%d: %s passes %d register(s), %s needs %d"
                                  % (path, no, "invoke-" + kind + (rng or ""), got, meth + "(" + params + ")", want))
    print("checked %d invokes, %d with a wrong register count" % (checked, bad), file=sys.stderr)
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:] or ["."]))
