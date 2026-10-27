# Settings > Connections > NFC crashes whenever the "nfc" service is missing (NFC stack down, see nfc_shared_process):
# PaymentDropDownPreference's constructor passes NfcAdapter.getDefaultAdapter() straight to CardEmulation.getInstance(),
# which throws NullPointerException("NfcAdapter is null") while the NFC page inflates (tester 9.3.85). NfcSettings itself
# already handles a null adapter. Without an adapter the preference now keeps mCardEmulation null, and its two users
# (initSubscriptionDetails(), the SIM list click handler) return early instead of calling into it.
DECODE_APK "system" "system/priv-app/SecSettings/SecSettings.apk"
python3 - "$APKTOOL_DIR/system/priv-app/SecSettings/SecSettings.apk" << 'PYEOF' || ABORT "Failed to patch SecSettings PaymentDropDownPreference"
import glob, sys
A = sys.argv[1]
P = "Lcom/samsung/android/settings/nfc/PaymentDropDownPreference;"
CE = P + "->mCardEmulation:Landroid/nfc/cardemulation/CardEmulation;"

def one(name):
    f = glob.glob(A + "/smali*/com/samsung/android/settings/nfc/" + name)
    assert len(f) == 1, name
    return f[0]

def method(s, head):
    assert s.count(head) == 1, head.strip()
    i = s.index(head)
    return i, s.index(".end method\n", i)

f = one("PaymentDropDownPreference.smali")
s = open(f).read()
if "k4_no_adapter" in s:
    print("  - PaymentDropDownPreference already patched")
else:
    # constructor: skip CardEmulation.getInstance() without an adapter
    i, j = method(s, ".method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V\n")
    body = s[i:j]
    get = ("    invoke-static {p1}, Landroid/nfc/NfcAdapter;->getDefaultAdapter(Landroid/content/Context;)Landroid/nfc/NfcAdapter;\n\n"
           "    move-result-object v0\n\n")
    inst = ("    invoke-static {v0}, Landroid/nfc/cardemulation/CardEmulation;->getInstance(Landroid/nfc/NfcAdapter;)Landroid/nfc/cardemulation/CardEmulation;\n\n"
            "    move-result-object v0\n\n"
            "    iput-object v0, p0, " + CE + "\n")
    assert body.count(get + inst) == 1, "ctor getDefaultAdapter -> CardEmulation.getInstance -> mCardEmulation"
    body = body.replace(get + inst, get + "    if-eqz v0, :k4_no_adapter\n\n" + inst + "\n    :k4_no_adapter\n", 1)
    s = s[:i] + body + s[j:]
    # initSubscriptionDetails(): nothing to read without CardEmulation
    i, j = method(s, ".method public final initSubscriptionDetails()V\n")
    body = s[i:j]
    first = "    iget-object v0, p0, " + CE + "\n\n    invoke-virtual {v0}, Landroid/nfc/cardemulation/CardEmulation;->getDefaultNfcSubscriptionId()I\n"
    assert body.count(first) == 1, "initSubscriptionDetails first read"
    body = body.replace(first, "    iget-object v0, p0, " + CE + "\n\n    if-nez v0, :k4_ce_ok\n\n    return-void\n\n    :k4_ce_ok\n"
                        "    invoke-virtual {v0}, Landroid/nfc/cardemulation/CardEmulation;->getDefaultNfcSubscriptionId()I\n", 1)
    s = s[:i] + body + s[j:]
    open(f, "w").write(s)

# SIM list click handler: dismiss the popup and return without CardEmulation
for f in glob.glob(A + "/smali*/com/samsung/android/settings/nfc/PaymentDropDownPreference$$ExternalSyntheticLambda*.smali"):
    s = open(f).read()
    if CE not in s:
        continue
    if "k4_ce_ok" in s:
        print("  - %s already patched" % f.rsplit("/", 1)[1]); continue
    i, j = method(s, ".method public final onItemClick(Landroid/widget/AdapterView;Landroid/view/View;IJ)V\n")
    body = s[i:j]
    first = "    iget-object p0, p0, " + s[s.index(".class public final synthetic ") + len(".class public final synthetic "):].split("\n", 1)[0] + "->f$0:" + P + "\n"
    assert body.count(first) == 1, "onItemClick f$0 read"
    guard = (first + "\n    iget-object p1, p0, " + CE + "\n\n    if-nez p1, :k4_ce_ok\n\n"
             "    iget-object p0, p0, " + P + "->mListPopup:Landroidx/appcompat/widget/ListPopupWindow;\n\n"
             "    invoke-virtual {p0}, Landroidx/appcompat/widget/ListPopupWindow;->dismiss()V\n\n"
             "    return-void\n\n    :k4_ce_ok\n")
    body = body.replace(first, guard, 1)
    s = s[:i] + body + s[j:]
    open(f, "w").write(s)
# NFC preference controllers that keep NfcAdapter.getDefaultAdapter() in a field call it unguarded from
# getAvailabilityStatus() (NfcModeController.isReaderOptionSupported(), ...): report UNSUPPORTED_ON_DEVICE (3) without
# an adapter, so their preferences are hidden instead of crashing the NFC page.
import re
for f in sorted(glob.glob(A + "/smali*/com/samsung/android/settings/nfc/**/*.smali", recursive=True) +
                glob.glob(A + "/smali*/com/android/settings/nfc/**/*.smali", recursive=True)):
    s = open(f).read()
    m = re.search(r"^\.field (?:[a-z]+ )*(\w+):Landroid/nfc/NfcAdapter;$", s, re.M)
    head = ".method public getAvailabilityStatus()I\n"
    if not m or head not in s:
        continue
    cls = re.search(r"^\.class (?:[a-z]+ )*(L[^;]+;)$", s, re.M).group(1)
    i, j = method(s, head)
    body = s[i:j]
    if "k4_adapter_ok" in body:
        print("  - %s already guarded" % cls); continue
    loc = re.match(r"\.method public getAvailabilityStatus\(\)I\n    \.locals (\d+)\n", body)
    assert loc and int(loc.group(1)) >= 1, cls + " getAvailabilityStatus .locals"
    guard = (loc.group(0) + "\n    iget-object v0, p0, %s->%s:Landroid/nfc/NfcAdapter;\n\n    if-nez v0, :k4_adapter_ok\n\n"
             "    const/4 v0, 0x3\n\n    return v0\n\n    :k4_adapter_ok\n") % (cls, m.group(1))
    s = s[:i] + body.replace(loc.group(0), guard, 1) + s[j:]
    open(f, "w").write(s)
    print("  - guarded %s.getAvailabilityStatus" % cls)
# NfcSettings handles a null adapter in onCreate() and the options menu but not in onActivityCreated() (main switch:
# isEnabled()), onResume() (isReaderOptionSupported()) and updatePaymentSim() (getAdapterState()). Without an adapter
# the page now closes itself in onActivityCreated() (NFC cannot be used anyway; the Connections entry is hidden by the
# NfcPreferenceController guard above) and the other two return at once.
f = one("NfcSettings.smali")
s = open(f).read()
NS = "Lcom/samsung/android/settings/nfc/NfcSettings;"
AD = NS + "->mNfcAdapter:Landroid/nfc/NfcAdapter;"
if "k4_ns_adapter_ok" in s:
    print("  - NfcSettings already patched")
else:
    for head, after, reg in (
            (".method public final onActivityCreated(Landroid/os/Bundle;)V\n",
             "    invoke-super {p0, p1}, Lcom/android/settings/SettingsPreferenceFragment;->onActivityCreated(Landroid/os/Bundle;)V\n", "v0"),
            (".method public final onResume()V\n",
             "    invoke-super {p0}, Lcom/android/settings/dashboard/DashboardFragment;->onResume()V\n", "v0"),
            (".method public final updatePaymentSim()V\n", None, "v0")):
        i, j = method(s, head)
        body = s[i:j]
        loc = body.split("\n", 2)[1] + "\n"
        assert loc.startswith("    .locals ") and int(loc.split()[1]) >= 1, head
        anchor = after if after else loc
        assert body.count(anchor) == 1, "anchor in " + head.strip()
        finish = ""
        if "onActivityCreated" in head:
            finish = ("    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;\n\n"
                      "    move-result-object %s\n\n    if-eqz %s, :k4_ns_ret\n\n"
                      "    invoke-virtual {%s}, Landroid/app/Activity;->finish()V\n\n    :k4_ns_ret\n") % (reg, reg, reg)
        guard = (anchor + "\n    iget-object %s, p0, %s\n\n    if-nez %s, :k4_ns_adapter_ok\n\n%s    return-void\n\n    :k4_ns_adapter_ok\n"
                 % (reg, AD, reg, finish))
        s = s[:i] + body.replace(anchor, guard, 1) + s[j:]
    open(f, "w").write(s)
PYEOF
LOG "- SecSettings: NFC page no longer crashes when NFC is unavailable (PaymentDropDownPreference)"
