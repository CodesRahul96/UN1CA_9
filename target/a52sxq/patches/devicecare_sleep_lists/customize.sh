# See module.prop. Device Care (com.samsung.android.lool) builds every sleeping-app Add list in jc/e.c(II) from the FAS
# cache that jc/e.e() loads from SemAppRestrictionManager.getAllList(); every add goes through ed/z.c(...).
# smali/com/k4/devicecare/*.smali is generated from src/com/k4/devicecare/K4RestrictList.java by src/build.sh
# (javac + d8 + baksmali; run it with SRC_DIR pointing at a tree that has out/tools/bin/apktool.jar).
# ed/z.c() runs on Device Care's UI thread for the Add/Done buttons and the app battery switch, so K4RestrictList.enter()
# moves the allowlist/MARs wait to a background thread there and re-enters c() on the UI thread with the prepared list
# (enter() returns null = the stock body returns at once). Off the UI thread (ExternalBatteryProvider) it prepares inline.
DEVICECARE="system/priv-app/SmartManager_v5/SmartManager_v5.apk"
DECODE_APK "system" "$DEVICECARE" || ABORT "Failed to decode $DEVICECARE"
LOG "- Listing every restrictable app in the sleeping-app Add lists"
DST="$APKTOOL_DIR/system/${DEVICECARE//system\//}/smali/com/k4/devicecare"
mkdir -p "$DST"
cp -f "$SRC_DIR/target/a52sxq/patches/devicecare_sleep_lists/smali/com/k4/devicecare/"*.smali "$DST/"
JC="$(find "$APKTOOL_DIR/system/${DEVICECARE//system\//}" -path "*/smali*/jc/e.smali" -type f)"
[ "$JC" ] && [ "$(wc -l <<< "$JC")" -eq 1 ] || ABORT "jc/e.smali not found"
# (already-patched checks keep the patch re-runnable on the same decode)
grep -q -F 'Lcom/k4/devicecare/K4RestrictList;->canList(' "$JC" || SMALI_PATCH "system" "$DEVICECARE" \
    "smali/jc/e.smali" "replace" \
    'c(II)Ljava/util/ArrayList;' \
    'invoke-virtual {v2, p1, v5, v7}, Lcom/samsung/android/sdhms/SemAppRestrictionManager;->canRestrict(ILjava/lang/String;I)Z' \
    'invoke-static {v2, p1, v5, v7}, Lcom/k4/devicecare/K4RestrictList;->canList(Lcom/samsung/android/sdhms/SemAppRestrictionManager;ILjava/lang/String;I)Z' \
    || ABORT "Failed to patch the Add list filter"
grep -q -F 'Lcom/k4/devicecare/K4RestrictList;->getAllList(' "$JC" || SMALI_PATCH "system" "$DEVICECARE" \
    "smali/jc/e.smali" "replace" \
    'e()V' \
    'invoke-virtual {v0}, Lcom/samsung/android/sdhms/SemAppRestrictionManager;->getAllList()Ljava/util/List;' \
    'invoke-static {v0}, Lcom/k4/devicecare/K4RestrictList;->getAllList(Lcom/samsung/android/sdhms/SemAppRestrictionManager;)Ljava/util/List;' \
    || ABORT "Failed to patch the FAS cache loader"
python3 - "$APKTOOL_DIR/system/${DEVICECARE//system\//}" << 'PYEOF' || ABORT "Failed to hook the sleeping-app add handler"
import glob, sys
root = sys.argv[1]
# The helper reads kc.d.a (package) and kc.d.c (uid) directly, like Device Care's own code does.
d = glob.glob(root + "/smali*/kc/d.smali")
assert len(d) == 1, "kc/d.smali: %d" % len(d)
ds = open(d[0]).read()
assert ".field public a:Ljava/lang/String;" in ds and ".field public c:I" in ds, "kc.d fields changed"
f = glob.glob(root + "/smali*/ed/z.smali")
assert len(f) == 1, "ed/z.smali: %d" % len(f)
s = open(f[0]).read()
SIG = ".method public final c(Landroid/content/Context;Ljava/util/List;IZLjava/lang/String;)V\n"
HOOK = ("    invoke-static/range {p0 .. p5}, Lcom/k4/devicecare/K4RestrictList;->enter("
        "Led/z;Landroid/content/Context;Ljava/util/List;IZLjava/lang/String;)Ljava/util/List;\n\n"
        "    move-result-object p2\n\n"
        "    if-nez p2, :k4_restrict\n\n"
        "    return-void\n\n"
        "    :k4_restrict\n")
assert s.count(SIG) == 1, "ed/z.c: %d" % s.count(SIG)
start = s.index(SIG)
end = s.index(".end method", start)
body = s[start:end]
if body.count(HOOK) == 1:
    print("ed/z.c: already hooked"); sys.exit(0)
assert "K4RestrictList;" not in body, "ed/z.c: hooked by another version of this patch"
lines = body.split("\n")
assert lines[1].strip().startswith(".locals"), "ed/z.c: no .locals line"
# the hook clobbers no local; the stock body starts by reading p3/p4/p5 and then p2.isEmpty()
assert lines[3] == "    move/from16 v0, p3", "ed/z.c: first instruction changed: %r" % lines[3]
# insert right after ".locals N" and its blank line, before the first instruction
body = "\n".join(lines[:2]) + "\n\n" + HOOK + "\n".join(lines[2:]).lstrip("\n")
s = s[:start] + body + s[end:]
open(f[0], "w").write(s)
PYEOF
unset DEVICECARE DST JC
