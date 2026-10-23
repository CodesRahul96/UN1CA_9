LOG_STEP_IN "- Disabling LE Audio / Auracast Bluetooth profiles (as stock A52s)"
for p in bap.broadcast.assist bap.broadcast.source bap.unicast.client bas.client csip.set_coordinator hap.client \
    mcp.server ccp.server vcp.controller; do
    SET_PROP "product" "bluetooth.profile.$p.enabled" "false"
done
SET_PROP "product" "persist.bluetooth.samsung.leaudio.livecast" "false"
LOG_STEP_OUT

# Gemini Nano / AICore: the source SoC hardware configs (Fold8: SM8850; S25: SM8750 + SM8850) make AICore pick
# flagship NPU models that can't run on SM7325
while IFS= read -r f; do
    DELETE_FROM_WORK_DIR "product" "etc/sysconfig/$(basename "$f")"
done < <(find "$WORK_DIR/product/etc/sysconfig" -maxdepth 1 -name "google_aicore_QC_*.xml" 2> /dev/null | LC_ALL=C sort)
unset f

# Adaptive color tone: backend app needs a colour-temperature (TYPE_LIGHT_CCT) light sensor
DELETE_FROM_WORK_DIR "system" "system/priv-app/EnvironmentAdaptiveDisplay"
DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"
DECODE_APK "system_ext" "priv-app/SystemUI/SystemUI.apk"
python3 - "$APKTOOL_DIR" << 'PYEOF' || ABORT "Failed to hide the source-only settings"
import glob, re, sys
A = sys.argv[1]
UNSUPPORTED = ".method public getAvailabilityStatus()I\n    .locals 1\n\n    const/4 p0, 0x3\n\n    return p0\n"

def method_span(s, sig):
    start = s.index(sig)
    return start, s.index(".end method", start)

# SecSettings > Display > Adaptive color tone -> UNSUPPORTED_ON_DEVICE (3)
f = glob.glob(A + "/**/SecSettings.apk/smali*/com/samsung/android/settings/display/controller/SecEADPreferenceController.smali", recursive=True)
assert len(f) == 1, "SecEADPreferenceController"; f = f[0]
s = open(f).read()
start, end = method_span(s, ".method public getAvailabilityStatus()I")
s = s[:start] + UNSUPPORTED + s[end:]
open(f, "w").write(s)

# SecSettings > Display > Privacy display: S26 Ultra sets config_pd_enable, which gates the page, its search entry, the
# Pd*SettingsActivity components and the Routines action (the panel feature itself is 0); the S25 ships it false
f = glob.glob(A + "/**/SecSettings.apk/res/values/bools.xml", recursive=True)
assert len(f) == 1, "SecSettings bools"; f = f[0]
s = open(f).read()
s = s.replace('<bool name="config_pd_enable">true</bool>', '<bool name="config_pd_enable">false</bool>')
open(f, "w").write(s)

# SecSettings > Display > Continue apps on cover screen: fold sources only hide it on multi-fold models; flat
# sources (S25) already compile it to a constant UNSUPPORTED_ON_DEVICE
f = glob.glob(A + "/**/SecSettings.apk/smali*/com/samsung/android/settings/display/controller/FrontScreenAppsPreferenceController.smali", recursive=True)
assert len(f) <= 1, "FrontScreenAppsPreferenceController"
if f:
    f = f[0]
    s = open(f).read()
    start, end = method_span(s, ".method public getAvailabilityStatus()I")
    body = s[start:end]
    insns = [l.strip() for l in body.split("\n")[1:] if l.strip() and not l.strip().startswith((".", "#"))]
    if re.fullmatch(r"(sget-object p0, \S+\n)?const/4 p0, 0x3\nreturn p0", "\n".join(insns)):
        print("FrontScreenApps: already UNSUPPORTED_ON_DEVICE")
    else:
        assert "isMultiFoldModel" in body, "unexpected FrontScreenApps availability"
        s = s[:start] + UNSUPPORTED + s[end:]
        open(f, "w").write(s)

# Samsung DeX (Settings > Connected devices > Samsung DeX, the launcher's QS tile, the default tile list) is owned by
# the wireless_dex patch: wireless DeX to a TV/monitor is supported, wired DeX is not (no DP alt mode). Do not touch
# ExternalDisplayUtils.isWirelessDexOnlyDevice(), TileFeatureChecker's DesktopModeTile branch or the DesktopMode
# default tile here; wireless_dex asserts their stock state.

# SecSettings > Wi-Fi > Labs (developer) > Wi-Fi 7 mode / MLO: SemWifiUtils.isSupportedWifi7() only checks the country
# code, not the chip; the A52s has no 802.11be (stock had no such option) -> UNSUPPORTED_ON_DEVICE (3)
f = glob.glob(A + "/**/SecSettings.apk/smali*/com/samsung/android/settings/wifi/develop/WifiLabs7ModeSettingsController.smali", recursive=True)
assert len(f) <= 1, "WifiLabs7ModeSettingsController"
if f:
    f = f[0]
    s = open(f).read()
    start, end = method_span(s, ".method public getAvailabilityStatus()I")
    s = s[:start] + UNSUPPORTED + s[end:]
    open(f, "w").write(s)

# Default tile list (new setups): drop Auracast (LE Audio broadcast is disabled above)
f = glob.glob(A + "/**/SystemUI.apk/res/values/strings.xml", recursive=True)
assert len(f) == 1, "SystemUI strings"; f = f[0]
s = open(f).read()
key = '<string name="sec_quick_settings_tiles_default">'
assert s.count(key) == 1, "sec_quick_settings_tiles_default: %d" % s.count(key)
i = s.index(key) + len(key); j = s.index("</string>", i)
tiles = [t for t in s[i:j].split(",") if t != "Auracast"]
s = s[:i] + ",".join(tiles) + s[j:]
open(f, "w").write(s)
PYEOF
LOG "- Hid Adaptive color tone, Continue apps on cover screen, Wi-Fi 7 labs, LE Audio/Auracast and the source AICore SoC configs"

# android.hardware.security.model.compatible ("supports the Android security model", CDD): the stock A52s declares it in
# /system/etc/permissions/handheld_core_hardware.xml, the S26 Ultra in its own vendor copy of that file. This port has
# the S26 system file and the A52s vendor file, so neither declared it (pm has-feature: false).
FEATURE_XML="$WORK_DIR/system/system/etc/permissions/android.hardware.security.model.compatible.xml"
if ! grep -q -r -F '"android.hardware.security.model.compatible"' "$WORK_DIR/system/system/etc/permissions" \
        "$WORK_DIR/vendor/etc/permissions" "$WORK_DIR/product/etc/permissions" 2> /dev/null; then
    LOG "- Declaring android.hardware.security.model.compatible"
    cat > "$FEATURE_XML" << 'XMLEOF'
<?xml version="1.0" encoding="utf-8"?>
<permissions>
    <feature name="android.hardware.security.model.compatible" />
</permissions>
XMLEOF
    SET_METADATA "system" "system/etc/permissions/android.hardware.security.model.compatible.xml" 0 0 644 "u:object_r:system_file:s0"
fi
unset FEATURE_XML
