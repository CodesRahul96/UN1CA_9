# One UI 8.5+ SamsungGlobalActionsPresenter.onShowDialog() posts a lambda (lambda$onShowDialog$3 on the Fold8 and S25,
# 500 ms) which calls LockPatternUtilsWrapper.lockDownDelayed(0) -> requireStrongAuth(AFTER_USER_LOCKDOWN) + lockNow():
# the phone locks as soon as the power menu opens, so cancelling it lands on the bouncer and biometrics are refused
# until the PIN/pattern is entered (on secure devices; USB data also drops). The Settings switch "Secure lock with
# Power button" (Settings.Secure lockdown_option_enabled) is only consulted when the menu was opened from the quick
# panel (mSideKeyType == 2); from the side key / key combo the lockdown is unconditional. Drop the side-key-type check
# so the switch governs every entry point - turn it off and the power menu never locks the phone.
DECODE_APK "system" "system/framework/framework.jar"
python3 - "$APKTOOL_DIR/system/framework/framework.jar" << 'PYEOF' || ABORT "Failed to patch the power menu lockdown"
import glob, re, sys
f = glob.glob(sys.argv[1] + "/smali*/com/samsung/android/globalactions/presentation/SamsungGlobalActionsPresenter.smali")
assert len(f) == 1, "SamsungGlobalActionsPresenter.smali"
s = open(f[0]).read()
P = "Lcom/samsung/android/globalactions/presentation/SamsungGlobalActionsPresenter;"
# the (synthetic, index varies between builds) method that calls lockDownDelayed
methods = [m for m in re.finditer(r"\.method [^\n]*\n(?:.*\n)*?\.end method", s)
           if "Lcom/samsung/android/globalactions/util/LockPatternUtilsWrapper;->lockDownDelayed(I)V" in m.group(0)]
assert len(methods) == 1, "lockDownDelayed callers: %d" % len(methods)
m = methods[0]
body = m.group(0)
assert "IS_LOCKDOWN_OPTION_ENABLED" in body, "unexpected lockdown method body"
check = re.compile(r" +iget (\w+), p0, " + re.escape(P) + r"->mSideKeyType:I\n\n"
                   r" +const/4 (\w+), 0x2\n\n"
                   r" +if-ne \1, \2, :\w+\n\n")
MARK = "    # k4_un1ca power_menu_lockdown: mSideKeyType == 2 check removed\n\n"
hits = list(check.finditer(body))
if not hits and MARK in body:
    print("  - power menu lockdown already patched"); sys.exit(0)
assert MARK not in body, "power_menu_lockdown marker present but the side key check is back"
assert len(hits) == 1, "side key type check: %d" % len(hits)
# the check must sit right before the IS_LOCKDOWN_OPTION_ENABLED lookup it skips
assert "IS_LOCKDOWN_OPTION_ENABLED" in body[hits[0].end():hits[0].end() + 400], "side key check is not the option guard"
body = body[:hits[0].start()] + MARK + body[hits[0].end():]
s = s[:m.start()] + body + s[m.end():]
open(f[0], "w").write(s)
print("  - %s" % body.split("\n")[0])
PYEOF
LOG "- Power menu only locks the phone when \"Secure lock with Power button\" is on"

# Fresh installs: SettingsProvider's SecOneUIUpgradeController inserts lockdown_option_enabled=1 when the setting is
# null (and SecSettings' BOOT_COMPLETED receiver writes 1 only while it is still unset), so "Secure lock with Power
# button" starts on and the power menu locks the phone. Insert 0 instead. Existing values are never touched.
DECODE_APK "system" "system/priv-app/SettingsProvider/SettingsProvider.apk"
python3 - "$APKTOOL_DIR/system/priv-app/SettingsProvider/SettingsProvider.apk" << 'PYEOF' || ABORT "Failed to patch the lockdown_option_enabled default"
import glob, re, sys
files = [f for f in glob.glob(sys.argv[1] + "/smali*/**/*.smali", recursive=True)
         if '"lockdown_option_enabled"' in open(f).read()]
if not files:
    # legitimately not applicable: this SettingsProvider never writes a default for the key
    print("  - SettingsProvider does not default lockdown_option_enabled, nothing to do")
    sys.exit(0)
# const-string vA, "lockdown_option_enabled" / const-string vB, "1" / ... / insertSetting*Locked(name, value, ...)
def pat(v):
    return re.compile(r'( +const-string (\w+), "lockdown_option_enabled"\n\n +const-string (\w+), )"%s"(\n\n(?: +[^\n]+\n\n){0,3}'
                      r' +invoke-virtual(?:/range)? \{[^}]*\}, Lcom/android/providers/settings/SettingsState;->insertSetting\w*Locked\()' % v)
src = {f: open(f).read() for f in files}
on = sum(len(pat("1").findall(t)) for t in src.values())
off = sum(len(pat("0").findall(t)) for t in src.values())
if on == 0 and off == 1:
    print("  - lockdown_option_enabled default already 0"); sys.exit(0)
# anything but exactly one "1" insert (another class, another form, several inserts) is a source change to look at
assert on == 1 and off == 0, "lockdown_option_enabled default inserts in %s: \"1\" x%d, \"0\" x%d" % (
    ", ".join(f.split("/smali", 1)[1] for f in files), on, off)
for f, t in src.items():
    t, n = pat("1").subn(r'\1"0"\4', t)
    if n:
        assert f.endswith("/SecOneUIUpgradeController.smali"), "unexpected class with the default insert: " + f
        open(f, "w").write(t)
PYEOF
LOG "- \"Secure lock with Power button\" defaults to off on new setups"
