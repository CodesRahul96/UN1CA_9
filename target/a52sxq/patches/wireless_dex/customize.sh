# Samsung DeX on the A52s: wireless only (Smart View / Miracast to a TV or monitor). See module.prop.
#
# How One UI 9 starts DeX on a phone (S26U, same code on this port):
#   QS tile "DeX" (launcher com.honeyspace.dexservice.DesktopModeTile) or
#   Settings > Connected devices > Samsung DeX > "Connect wirelessly" (DexModeSettingsFragment)
#     -> launcher com.sec.android.desktopmode.activity.connectivity.ConnectivityActivity (Wi-Fi Display scan list)
#     -> DisplayManager.semConnectWifiDisplay(SemWifiDisplayConfig mode 2, "wfd_sec_mirroring_mode=dex")
#     -> WifiDisplayAdapter: mode 2 = "wifi:desktop:" device that may host tasks (not mirror-only)
#     -> LogicalDisplay: external desktop flag -> RootWindowContainer.startSystemDecorations()
#     -> DexController.setExternalDesktopDisplayId(), launcher SecondaryLauncher + taskbar on the TV,
#        WMShell DesktopStateImpl.isDesktopModeSupportedOnDisplay() = true for it (projected desktop mode).
# All of that only needs desktop windowing on (sff.sh) and the stock aconfig flags (enable_desktop_windowing_mode,
# enable_projected_display_desktop_mode, enable_display_content_mode_management: all ENABLED/RO in the S26U system).
#
# What is A52s-specific: both entry points look at /sys/class/dp_sec/dex (Samsung DisplayPort driver;
# CONFIG_SEC_DISPLAYPORT is not set in the a52sxq kernel, the phone has no DP alt mode). This patch owns all DeX entry
# points; a52s_hw_features leaves them alone.
#   - SecSettings DexModePreferenceController: isWirelessDexOnlyDevice() || dp_sec/dex exists, else UNSUPPORTED (hidden).
#     Stock ExternalDisplayUtils.isWirelessDexOnlyDevice() on a phone (not Utils.isTablet()) is
#     WIRELESS_DESKTOP_SUPPORTED_ONLY || !exists(/sys/class/dp_sec/dex), so it is already true on the A52s. It is pinned
#     to a constant true (this phone's situation, independent of the tablet/feature checks): it shows the entry, the
#     wireless-only help text/image and the top-level "Connected devices" summary. Its only other users hide
#     tablet/fold-only rows, which are hidden on a phone anyway.
#   - SystemUI TileFeatureChecker.isAvailableCustomTile() allows the launcher's DesktopModeTile unconditionally and the
#     stock default tile list (sec_quick_settings_tiles_default) contains DesktopMode. Nothing to change; asserted
#     below so no other patch hides the tile this patch makes useful (a52s_hw_features used to).
#   - Launcher k6/b.g() ("DeX available") = desktop windowing && (dp_sec/dex exists || tablet without stand-alone DeX).
#     When false, the DeX tile toggles stand-alone desktop windowing on the phone screen (tablet behaviour; the phone
#     display cannot host desktops, config_canInternalDisplayHostDesktops=false) instead of opening the wireless list.
#     Make the launcher's lazy "Supports dp" check true. Its other users are the DeX routine action and the tile state.

DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"
python3 - "$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk" << 'PYEOF' || ABORT "Failed to show the Samsung DeX settings entry"
import glob, re, sys
f = glob.glob(sys.argv[1] + "/smali*/com/samsung/android/settings/desktop/ExternalDisplayUtils.smali")
assert len(f) == 1, "ExternalDisplayUtils: %d" % len(f)
s = open(f[0]).read()
SIG = ".method public static isWirelessDexOnlyDevice(Landroid/content/Context;)Z\n"
assert s.count(SIG) == 1, "isWirelessDexOnlyDevice: %d" % s.count(SIG)
start = s.index(SIG)
end = s.index(".end method", start)
body = s[start:end]
TRUE = SIG + "    .locals 0\n\n    const/4 p0, 0x1\n\n    return p0\n"
if body == TRUE:
    print("  - isWirelessDexOnlyDevice() already true")
    sys.exit(0)
assert body != TRUE.replace("const/4 p0, 0x1", "const/4 p0, 0x0"), \
    "isWirelessDexOnlyDevice() was forced false by another patch (the DeX entry points are owned by wireless_dex)"
# Stock: tablet -> desktop-mode-on-display check; phone -> WIRELESS_DESKTOP_SUPPORTED_ONLY || !dp_sec/dex exists
for need in ("Lcom/android/settings/Utils;->isTablet()Z",
             "Lcom/samsung/android/settings/desktop/ExternalDisplayUtils;->WIRELESS_DESKTOP_SUPPORTED_ONLY:Z",
             'const-string v0, "/sys/class/dp_sec/dex"',
             "Ljava/io/File;->exists()Z"):
    assert body.count(need) == 1, "isWirelessDexOnlyDevice() source body changed (%s):\n%s" % (need, body)
assert re.search(r"Ljava/io/File;->exists\(\)Z\n\n    move-result p0\n\n    if-nez p0, :cond_\w+\n", body), \
    "isWirelessDexOnlyDevice() dp_sec/dex branch changed:\n" + body
open(f[0], "w").write(s[:start] + TRUE + s[end:])
print("  - isWirelessDexOnlyDevice() -> true")
PYEOF
LOG "- Settings: Samsung DeX entry shown (wireless DeX only)"

DECODE_APK "system_ext" "priv-app/SystemUI/SystemUI.apk"
python3 - "$APKTOOL_DIR/system_ext/priv-app/SystemUI/SystemUI.apk" << 'PYEOF' || ABORT "The Samsung DeX QS tile is no longer offered"
import glob, re, sys
f = glob.glob(sys.argv[1] + "/smali*/com/android/systemui/qs/TileFeatureChecker.smali")
assert len(f) == 1, "TileFeatureChecker: %d" % len(f)
s = open(f[0]).read()
SIG = ".method public final isAvailableCustomTile(Lcom/android/systemui/qs/pipeline/shared/TileSpec;)Z\n"
assert s.count(SIG) == 1, "isAvailableCustomTile: %d" % s.count(SIG)
start = s.index(SIG)
body = s[start:s.index(".end method", start)]
m = re.search(r' +const-string (\w+), "com\.sec\.android\.app\.launcher/com\.honeyspace\.dexservice\.DesktopModeTile"\n\n'
              r' +invoke-virtual \{\1, \w+\}, Ljava/lang/Object;->equals\(Ljava/lang/Object;\)Z\n\n'
              r' +move-result (\w+)\n\n'
              r' +if-eqz \2, :\w+\n\n'
              r' +goto(?:/16|/32)? :(goto_\w+)\n', body)
assert m and body.count("dexservice.DesktopModeTile") == 1, "DesktopModeTile branch no longer jumps to the shared tail"
t = re.search(r"\n    :" + m.group(3) + r"\n    return (\w+)\n", body)
assert t and re.search(r"\n    const/4 " + t.group(1) + r", 0x1\n", body[:m.start()]), "DesktopModeTile tail is not 'return true'"
print("  - SystemUI offers the DeX tile")
f = glob.glob(sys.argv[1] + "/res/values/strings.xml")
assert len(f) == 1, "SystemUI strings"
s = open(f[0]).read()
m = re.search(r'<string name="sec_quick_settings_tiles_default">([^<]*)</string>', s)
assert m, "sec_quick_settings_tiles_default"
print("  - DeX in the default tile list" if "DesktopMode" in m.group(1).split(",") else
      "  - note: the source default tile list has no DesktopMode tile (it can still be added)")
PYEOF
LOG "- SystemUI: DeX quick settings tile offered"

DECODE_APK "system" "system/priv-app/TouchWizHome_2017/TouchWizHome_2017.apk"
python3 - "$APKTOOL_DIR/system/priv-app/TouchWizHome_2017/TouchWizHome_2017.apk" << 'PYEOF' || ABORT "Failed to point the launcher DeX tile at wireless DeX"
import glob, re, sys
pat = re.compile(r'(    const-string (v\d+), "/sys/class/dp_sec/dex"\n\n'
                 r'    invoke-direct \{(v\d+), \2\}, Ljava/io/File;-><init>\(Ljava/lang/String;\)V\n\n'
                 r'    invoke-virtual \{\3\}, Ljava/io/File;->exists\(\)Z\n\n'
                 r'    move-result (v\d+)\n)(\n    const/4 \4, 0x1\n)?'
                 r'(\n    if-nez \4, :cond_\w+\n\n    const-string v\d+, "Do not Supports dp"\n)')
hits = done = 0
for f in glob.glob(sys.argv[1] + "/smali*/**/*.smali", recursive=True):
    s = open(f).read()
    if '"/sys/class/dp_sec/dex"' not in s:
        continue
    found = pat.findall(s)
    assert len(found) <= 1, "%s: %d dp_sec checks" % (f, len(found))
    assert found, "%s: dp_sec/dex check no longer matches" % f
    hits += 1
    if found[0][4]:
        done += 1
        continue
    s = pat.sub(lambda m: m.group(1) + "\n    const/4 " + m.group(4) + ", 0x1\n" + m.group(6), s)
    open(f, "w").write(s)
assert hits == 1, "launcher dp_sec/dex checks: %d" % hits
print("  - launcher dp check already forced" if done else "  - launcher \"Supports dp\" -> true")
PYEOF
LOG "- Launcher: DeX tile opens the wireless DeX device list"
