# One UI Home: setPorterDuffMode reflection only on BackgroundBlurDrawable (see module.prop).
#
# Each site is the stock block
#     sget-object vA, PorterDuff$Mode;->OVERLAY ; filled-new-array {vA} ; move-result-object vA
#     const-string vB, "setPorterDuffMode"
#     invoke-static {X, vB, vA}, ReflectionUtilsKt;->invokeReflection(Object;String;[Object;)Object
#     move-result-object Y ; check-cast Y, Lkotlin/Unit;
# vA is written by the sget right after, so it is free for the instance-of. The block is wrapped in
#     instance-of vA, X, BackgroundBlurDrawable ; if-eqz vA, :k4_pdm_skip ... :k4_pdm_skip
# Field stack (9.3.77, k4diag build): WorkspaceCellLayoutContainer.setBlurProgress -> f -> CellLayoutBlurUpdater.updateBlur
# -> new GradientDrawable -> setBackground override -> invokeReflection miss, 3 containers x every frame.
DECODE_APK "system" "system/priv-app/TouchWizHome_2017/TouchWizHome_2017.apk"
python3 - "$APKTOOL_DIR/system/priv-app/TouchWizHome_2017/TouchWizHome_2017.apk" << 'PYEOF' || ABORT "Failed to gate the launcher setPorterDuffMode reflection"
import glob, re, sys

A = sys.argv[1]
MARK = "# k4 launcher_porterduff_gate"
BBD = "Lcom/android/internal/graphics/drawable/BackgroundBlurDrawable;"
# stock sites, relative to the smali_classes* dir
SITES = ("com/honeyspace/ui/honeypots/workspace/presentation/WorkspaceCellLayoutContainer.smali",
         "com/honeyspace/ui/common/minusoneeditpage/MinusOneEditContent.smali",
         "com/honeyspace/ui/common/qsb/HomeSearchBar.smali",
         "ce/d.smali")
BLOCK = re.compile(
    r"(?P<ind>[ ]{4})sget-object (?P<a>[vp]\d+), Landroid/graphics/PorterDuff\$Mode;->OVERLAY:Landroid/graphics/PorterDuff\$Mode;\n\s*\n"
    r"[ ]{4}filled-new-array \{(?P=a)\}, \[Ljava/lang/Object;\n\s*\n"
    r"[ ]{4}move-result-object (?P=a)\n\s*\n"
    r"[ ]{4}const-string (?P<b>[vp]\d+), \"setPorterDuffMode\"\n\s*\n"
    r"[ ]{4}invoke-static \{(?P<x>[vp]\d+), (?P=b), (?P=a)\}, Lcom/honeyspace/common/reflection/ReflectionUtilsKt;->invokeReflection\(Ljava/lang/Object;Ljava/lang/String;\[Ljava/lang/Object;\)Ljava/lang/Object;\n\s*\n"
    r"[ ]{4}move-result-object (?P<y>[vp]\d+)\n\s*\n"
    r"[ ]{4}check-cast (?P=y), Lkotlin/Unit;\n")

# every setPorterDuffMode call in the APK must be one of the known sites
calls = [f for f in glob.glob(A + "/smali*/**/*.smali", recursive=True) if '"setPorterDuffMode"' in open(f).read()]
rel = sorted(re.sub(r"^.*/smali[^/]*/", "", f) for f in calls)
assert rel == sorted(SITES), "unexpected setPorterDuffMode call sites: %s" % rel

for f in calls:
    s = open(f).read()
    name = re.sub(r"^.*/smali[^/]*/", "", f)
    if MARK in s:
        assert s.count(MARK) == 1 and not BLOCK.search(s.split(MARK)[0]), name
        print("  - %s already gated" % name)
        continue
    m = list(BLOCK.finditer(s))
    assert len(m) == 1 and s.count('"setPorterDuffMode"') == 1, "%s: %d stock blocks" % (name, len(m))
    m = m[0]
    a, x = m.group("a"), m.group("x")
    assert a != x, name
    new = ("    %s: setPorterDuffMode only exists on BackgroundBlurDrawable\n"
           "    instance-of %s, %s, %s\n\n"
           "    if-eqz %s, :k4_pdm_skip\n\n"
           "%s\n"
           "    :k4_pdm_skip\n") % (MARK, a, x, BBD, a, m.group(0))
    s = s[:m.start()] + new + s[m.end():]
    assert s.count(MARK) == 1 and s.count(":k4_pdm_skip") == 2
    open(f, "w").write(s)
    print("  - %s: setPorterDuffMode gated on BackgroundBlurDrawable" % name)
PYEOF
