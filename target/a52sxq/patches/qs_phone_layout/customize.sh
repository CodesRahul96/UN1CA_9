# One UI 9 SystemUI picks the quick-panel mode from SecQsUiDisplayModeInteractor.DeviceFormFactor:
# PHONE -> NORMAL (edge-to-edge, no pop-over), FOLD -> NARROW when folded / WIDE (pop-over card) when unfolded.
# The Fold8 build compiles getDeviceFormFactor() to the FOLD constant; this device reports a single DEFAULT
# device state that the interactor counts as "unfolded", so the quick panel came up as the foldable pop-over card.
# Fold sources only: flat sources (S25) already return PHONE from getDeviceFormFactor()
if [[ "$(GET_FLOATING_FEATURE_CONFIG "$FW_DIR/$SOURCE_FIRMWARE_PATH/system/system/etc/floating_feature.xml" \
        "SEC_FLOATING_FEATURE_FRAMEWORK_SUPPORT_FOLDABLE_TYPE_FOLD")" != "TRUE" ]]; then
    LOG "- Source is not a foldable, nothing to do"
    return 0
fi
DECODE_APK "system_ext" "priv-app/SystemUI/SystemUI.apk"
python3 - "$APKTOOL_DIR/system_ext/priv-app/SystemUI/SystemUI.apk" << 'PYEOF' || ABORT "Failed to apply the phone-style quick panel patch"
import glob, re, sys
f = glob.glob(sys.argv[1] + "/smali*/com/android/systemui/util/SecQsUiDisplayModeInteractor.smali")
assert len(f) == 1, "SecQsUiDisplayModeInteractor"
s = open(f[0]).read()
# work on the method body only, so a FOLD load in a later method can never satisfy the count
SIG = ".method private final getDeviceFormFactor()Lcom/android/systemui/util/SecQsUiDisplayModeInteractor$DeviceFormFactor;\n"
assert s.count(SIG) == 1, "getDeviceFormFactor() not found"
start = s.index(SIG)
end = s.index("\n.end method", start) + 1
body = s[start:end]
FF = "Lcom/android/systemui/util/SecQsUiDisplayModeInteractor$DeviceFormFactor;"
fold = re.compile(r"(\n +sget-object p0, " + re.escape(FF) + r"->)FOLD(:" + re.escape(FF) + r"\n\n +return-object p0\n)")
if not fold.search(body) and "->FOLD:" not in body and re.search(r"sget-object p0, " + re.escape(FF) + r"->PHONE:", body):
    print("  - getDeviceFormFactor() already returns PHONE"); sys.exit(0)
body, n = fold.subn(r"\1PHONE\2", body)
assert n == 1, "getDeviceFormFactor(): %d 'sget-object p0, ...->FOLD; return-object p0' sites" % n
s = s[:start] + body + s[end:]
open(f[0], "w").write(s)
PYEOF
LOG "- Quick panel form factor forced to PHONE"
