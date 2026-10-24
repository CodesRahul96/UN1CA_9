#!/usr/bin/env bash
# Builds meta-overlayfs-13101-1.3.1-k4.1.zip (the K4 build of meta-overlayfs, see K4_CHANGES.txt) from the
# official v1.3.1 release zip and the changed files in this directory. Reproducible: fixed order, times and modes,
# so the result always has the sha256 pinned in ../customize.sh and ../k4-ksu-metamodule.
# Usage: make_zip.sh <meta-overlayfs-13100-1.3.1.zip (official release asset)> <output zip>
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
UP="$1"
OUT="$2"
UP_SHA256=279d85a6a35724dfcf8aa1137a9630c7e989e154b94543517c539ee70f9b8811
[ "$(sha256sum "$UP" | cut -d ' ' -f 1)" = "$UP_SHA256" ] || { echo "make_zip: $UP is not the v1.3.1 release zip" >&2; exit 1; }
python3 -I - "$UP" "$OUT" "$HERE" << 'PY'
import sys, zipfile
up, out, here = sys.argv[1:4]
changed = ("metainstall.sh", "metamount.sh", "module.prop")
with zipfile.ZipFile(up) as zi, zipfile.ZipFile(out, "w") as zo:
    for info in zi.infolist():
        data = open(f"{here}/{info.filename}", "rb").read() if info.filename in changed else zi.read(info)
        n = zipfile.ZipInfo(info.filename, info.date_time if info.filename not in changed else (2026, 10, 24, 0, 0, 0))
        n.external_attr = info.external_attr
        n.create_system = 3
        n.compress_type = zipfile.ZIP_DEFLATED
        zo.writestr(n, data, compresslevel=9)
    n = zipfile.ZipInfo("K4_CHANGES.txt", (2026, 10, 24, 0, 0, 0))
    n.external_attr = 0o100644 << 16
    n.create_system = 3
    n.compress_type = zipfile.ZIP_DEFLATED
    zo.writestr(n, open(f"{here}/K4_CHANGES.txt", "rb").read(), compresslevel=9)
PY
sha256sum "$OUT"
