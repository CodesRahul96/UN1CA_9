# com.android.nfc (NfcNciApex, /apex/com.android.nfcservices) and com.samsung.android.nfc (SecNfc) are both persistent,
# share android.uid.nfc and run in ONE process named "com.android.nfc". Normally AMS starts that process for
# com.android.nfc: NfcApplication creates NfcService, which registers the "nfc" binder and then broadcasts
# android.nfc.action.OEM_EXTENSION_INIT to SecNfc's SecBootCompleteReceiver; delivering it creates SecNfcApplication in
# the same process, and its onCreate() builds SamsungExtension (NfcAdapter.getNfcAdapter() works, "nfc" exists).
#
# When the process is bound for com.samsung.android.nfc instead, SecNfcApplication.onCreate() runs before NfcService
# exists. AMS startPersistentApps() starts the persistent apps in PackageManager order (com.android.nfc hashes first),
# so this happens when com.android.nfc is missing from getPersistentApplications(): hidden or uninstalled for user 0
# (reproduced on the test phone with `pm hide com.android.nfc` + reboot: the exact tester crash loop), or its APEX did not
# activate. A merely disabled com.android.nfc (enabled=2) is still started first and works (tested). Then:
# NfcAdapter.getNfcAdapter() throws UnsupportedOperationException, AMS restarts the persistent process at once and the
# same thing happens again (tester 9.3.85: 277 crashes in 25 s every boot, "Can't find service: nfc", PackageWatchdog
# blames com.samsung.android.nfc and RescueParty escalates: warm reboot, then settings resets).
#
# Fix (smali, SecNfcApplication + SecBootCompleteReceiver):
# - onCreate(): if ServiceManager.checkService("nfc") is null, SamsungExtension is deferred (no crash) and an explicit
#   no-op broadcast to com.android.nfc/.NfcTagAllowNotificationReceiver (not exported, same uid, direct boot aware,
#   ignores other actions) makes AMS load com.android.nfc into this process: NfcApplication -> NfcService -> "nfc" ->
#   OEM_EXTENSION_INIT.
# - SecBootCompleteReceiver.onReceive() (OEM_EXTENSION_INIT) runs the deferred SamsungExtension init once "nfc" exists.
#   In the normal order onCreate() already did it and the receiver does nothing extra.
# - The SamsungExtension init itself catches UnsupportedOperationException (no NFC service/feature) and logs it instead
#   of killing the process, so SecNfc can never crash-loop the shared process again; NFC is then just unavailable.
DECODE_APK "system" "system/priv-app/SecNfc/SecNfc.apk"
python3 - "$APKTOOL_DIR/system/priv-app/SecNfc/SecNfc.apk" << 'PYEOF' || ABORT "Failed to patch SecNfc shared process start"
import glob, re, sys
A = sys.argv[1]
MARK = "# k4 nfc_shared_process"
APP = "Lcom/samsung/android/nfc/SecNfcApplication;"

def one(pattern):
    f = glob.glob(A + "/smali*/com/samsung/android/nfc/" + pattern)
    assert len(f) == 1, pattern
    return f[0]

def strip_lines(body):
    return re.sub(r"\n    \.line \d+\n", "\n", body)

# --- SecNfcApplication ---
f = one("SecNfcApplication.smali")
s = open(f).read()
if MARK in s:
    print("  - SecNfcApplication already patched")
else:
    head = ".method public onCreate()V\n"
    assert s.count(head) == 1, "SecNfcApplication.onCreate"
    i = s.index(head)
    j = s.index(".end method\n", i) + len(".end method\n")
    body = s[i:j]
    flat = strip_lines(body)
    super_call = "    invoke-super {p0}, Landroid/app/Application;->onCreate()V\n"
    for need in (super_call, '"SamsungExtensionMainHandler"',
                 "Lcom/samsung/android/nfc/SecNfcInjector;-><init>(Landroid/content/Context;Landroid/os/Looper;)V",
                 "Lcom/samsung/android/nfc/core/SamsungExtension;-><init>(Landroid/content/Context;Lcom/samsung/android/nfc/SecNfcInjector;)V"):
        assert flat.count(need) == 1, "onCreate: " + need.strip()
    assert flat.count("return-void") == 1 and flat.rstrip().endswith("return-void\n.end method"), "onCreate: one return at the end"
    m = re.match(r"\.method public onCreate\(\)V\n    \.locals (\d+)\n", flat)
    assert m and int(m.group(1)) >= 3, "onCreate .locals"
    # The original body becomes k4InitExtension() (without the super call), guarded against UnsupportedOperationException.
    init = flat.replace(".method public onCreate()V\n", ".method public k4InitExtension()V\n", 1)
    init = init.replace(super_call, "", 1)
    init = init.replace(m.group(0).replace("onCreate()V", "k4InitExtension()V"),
                        ".method public k4InitExtension()V\n    .locals %s\n\n    :k4_try_start\n" % m.group(1), 1)
    k = init.rindex("    return-void\n")
    init = (init[:k] + "    :k4_try_end\n    .catch Ljava/lang/UnsupportedOperationException; {:k4_try_start .. :k4_try_end} :k4_catch\n\n"
            "    return-void\n\n"
            "    :k4_catch\n"
            "    move-exception v0\n\n"
            "    const-string v1, \"SecNfcApplication\"\n\n"
            "    const-string v2, \"k4: SamsungExtension init failed, NFC unavailable (no crash loop)\"\n\n"
            "    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I\n\n"
            "    return-void\n"
            ".end method\n")
    new = """.method public onCreate()V
    .locals 3

    %(mark)s: never build SamsungExtension before NfcService registered "nfc"
    invoke-super {p0}, Landroid/app/Application;->onCreate()V

    const-string v0, "nfc"

    invoke-static {v0}, Landroid/os/ServiceManager;->checkService(Ljava/lang/String;)Landroid/os/IBinder;

    move-result-object v0

    if-nez v0, :k4_nfc_up

    sput-object p0, %(app)s->k4Deferred:%(app)s

    const-string v1, "SecNfcApplication"

    const-string v2, "k4: process started for com.samsung.android.nfc before NfcService (no \\"nfc\\" service); loading com.android.nfc, SamsungExtension waits for OEM_EXTENSION_INIT"

    invoke-static {v1, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    invoke-virtual {p0}, %(app)s->k4StartNfcApp()V

    return-void

    :k4_nfc_up
    invoke-virtual {p0}, %(app)s->k4InitExtension()V

    return-void
.end method

.method public k4StartNfcApp()V
    .locals 3

    :k4_kick_start
    new-instance v0, Landroid/content/Intent;

    const-string v1, "com.samsung.android.nfc.action.K4_START_NFC_SERVICE"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v1, "com.android.nfc"

    const-string v2, "com.android.nfc.NfcTagAllowNotificationReceiver"

    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const v1, 0x10000020

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    invoke-virtual {p0, v0}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V
    :k4_kick_end
    .catch Ljava/lang/Exception; {:k4_kick_start .. :k4_kick_end} :k4_kick_catch

    return-void

    :k4_kick_catch
    move-exception v0

    const-string v1, "SecNfcApplication"

    const-string v2, "k4: could not start com.android.nfc"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method public static k4OnOemExtensionInit()V
    .locals 3

    sget-object v0, %(app)s->k4Deferred:%(app)s

    if-eqz v0, :k4_nothing

    const-string v1, "nfc"

    invoke-static {v1}, Landroid/os/ServiceManager;->checkService(Ljava/lang/String;)Landroid/os/IBinder;

    move-result-object v1

    if-eqz v1, :k4_nothing

    const/4 v1, 0x0

    sput-object v1, %(app)s->k4Deferred:%(app)s

    const-string v1, "SecNfcApplication"

    const-string v2, "k4: OEM_EXTENSION_INIT received, starting the deferred SamsungExtension"

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    invoke-virtual {v0}, %(app)s->k4InitExtension()V

    :k4_nothing
    return-void
.end method
""" % {"mark": MARK, "app": APP}
    s = s[:i] + new + "\n" + init + s[j:]
    anchor = "# direct methods\n"
    assert s.count(anchor) == 1, "SecNfcApplication direct methods anchor"
    s = s.replace(anchor, "# static fields\n.field public static k4Deferred:%s\n\n\n%s" % (APP, anchor), 1)
    open(f, "w").write(s)

# --- SecBootCompleteReceiver: OEM_EXTENSION_INIT runs the deferred init ---
f = one("SecBootCompleteReceiver.smali")
s = open(f).read()
call = "    invoke-static {}, %s->k4OnOemExtensionInit()V\n\n" % APP
if call in s:
    print("  - SecBootCompleteReceiver already patched")
else:
    head = ".method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V\n"
    assert s.count(head) == 1, "SecBootCompleteReceiver.onReceive"
    i = s.index(head)
    j = s.index(".end method\n", i)
    body = s[i:j]
    assert body.count("return-void") == 1, "onReceive: one return"
    body = body.replace("    return-void\n", call + "    return-void\n", 1)
    s = s[:i] + body + s[j:]
    open(f, "w").write(s)
PYEOF
LOG "- SecNfc: no crash loop when the shared NFC process starts for com.samsung.android.nfc; com.android.nfc is loaded first"
