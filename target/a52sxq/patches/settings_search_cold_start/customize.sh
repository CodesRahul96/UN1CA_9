# See module.prop.
#
# Evidence (R5CTA0ESFTF, 9.3.72, 2026-10-23, /mnt/B1/OneUi9/scratch/agents/search/):
#   am force-stop com.android.settings; open Settings search ->
#     Settings pid starts "for content provider SettingsSearchIndexablesProvider", 120 ms later
#     E DatabaseUtils: java.lang.UnsupportedOperationException: Spa environment is not set
#       at SpaSearchRepository.getSearchIndexablePageList <- SearchFeatureProviderImpl lambda (lazy)
#       <- SettingsSearchIndexablesProvider.queryNonIndexableKeys / queryDynamicRawData
#     D SpaEnvironment: reset  (SettingsApplication$$ExternalSyntheticLambda1 case 1, ThreadUtils background) +20 ms
#     SettingsIntelligence: "Cannot add index data for Uri: content://com.android.settings/settings/non_indexables_key"
#     -> updateDataInDatabase "[D - E] com.android.settings_pd_extra_dim" and 703 more rows; prefs_index enabled
#        1846 -> 2550 of 2827; "Maximum privacy protection" (Privacy display, no such panel here) shows up in search.
# Verify after flashing (phone unlocked): am force-stop com.android.settings, open search, type "maximum privacy"
# -> no result; logcat -d | grep -E "Spa environment is not set|K4SpaEnvWait|D - E\] com.android.settings_pd"
# -> only "K4SpaEnvWait: search provider waited for the Spa environment", no D - E lines.
SECSETTINGS="system/priv-app/SecSettings/SecSettings.apk"
SSI="system/priv-app/SecSettingsIntelligence/SecSettingsIntelligence.apk"
DECODE_APK "system" "$SECSETTINGS" || ABORT "Failed to decode $SECSETTINGS"
DECODE_APK "system" "$SSI" || ABORT "Failed to decode $SSI"
LOG "- Settings search: keep unavailable settings hidden when Settings was not running"
python3 - "$APKTOOL_DIR/system/${SECSETTINGS//system\//}" "$APKTOOL_DIR/system/${SSI//system\//}" << 'PYEOF' || ABORT "Failed to patch the Settings search cold start"
import glob, os, re, sys
SS, SSI = sys.argv[1], sys.argv[2]

def one(root, rel):
    hits = glob.glob(root + "/smali*/" + rel)
    assert len(hits) == 1, "%s: %d" % (rel, len(hits))
    return hits[0]

def method(s, sig):
    m = re.search(r"^\.method [^\n]*" + re.escape(sig) + r"\n.*?^\.end method\n", s, re.M | re.S)
    assert m, "method " + sig
    return m

def sub_once(body, old, new, what):
    assert body.count(old) == 1, "%s: %d matches" % (what, body.count(old))
    return body.replace(old, new)

# ---- 1. SecSettings: SpaSearchRepository.getSearchIndexablePageList waits for the Spa environment ----
WAIT = "Lcom/k4/settings/search/K4SpaEnvWait;"
ENV = "Lcom/android/settingslib/spa/framework/common/SpaEnvironmentFactory;->spaEnvironment:Lcom/android/settings/spa/SettingsSpaEnvironment;"
f = one(SS, "com/android/settingslib/spa/search/SpaSearchRepository.smali")
s = open(f).read()
m = method(s, " getSearchIndexablePageList()Ljava/util/List;")
body = m.group(0)
if WAIT in body:
    print("  - SpaSearchRepository already patched")
else:
    assert body.count(ENV) == 1, "getSearchIndexablePageList: %d spaEnvironment reads" % body.count(ENV)
    assert "Spa environment is not set" in s or "Gson$$ExternalSyntheticBUOutline0" in body, "unexpected not-set handling"
    old = "    sget-object v0, " + ENV + "\n"
    body = sub_once(body, old, "    invoke-static {}, " + WAIT + "->await()V\n\n" + old, "spaEnvironment read")
    s = s[:m.start()] + body + s[m.end():]
    open(f, "w").write(s)
# the field the helper polls must exist with this exact type
fe = open(one(SS, "com/android/settingslib/spa/framework/common/SpaEnvironmentFactory.smali")).read()
assert ".field public static spaEnvironment:Lcom/android/settings/spa/SettingsSpaEnvironment;" in fe, "SpaEnvironmentFactory.spaEnvironment"

dst = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(f))))))
stale = [p for p in glob.glob(SS + "/smali*/com/k4/settings/search/K4SpaEnvWait.smali")
         if not p.startswith(dst + "/")]
assert not stale, "K4SpaEnvWait in another dex dir: " + ", ".join(stale)
os.makedirs(dst + "/com/k4/settings/search", exist_ok=True)
open(dst + "/com/k4/settings/search/K4SpaEnvWait.smali", "w").write("""\
.class public final Lcom/k4/settings/search/K4SpaEnvWait;
.super Ljava/lang/Object;
.source "K4SpaEnvWait.java"


# SettingsApplication sets SpaEnvironmentFactory.spaEnvironment on a background thread at the end of onCreate; the
# search provider can be called (binder thread) before that when the search starts the Settings process. Binder
# threads wait for it (25 ms steps, at most 3 s); the main thread never waits (stock behaviour there).
.method public static await()V
    .locals 4

    sget-object v0, """ + ENV + """

    if-nez v0, :done

    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    if-eq v0, v1, :done

    const/16 v2, 0x78

    :loop
    sget-object v0, """ + ENV + """

    if-nez v0, :ready

    if-lez v2, :timeout

    add-int/lit8 v2, v2, -0x1

    const-wide/16 v0, 0x19

    :try_start_0
    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    goto :loop

    :catch_0
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Thread;->interrupt()V

    return-void

    :ready
    const-string v0, "K4SpaEnvWait"

    const-string v1, "search provider waited for the Spa environment"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :timeout
    const-string v0, "K4SpaEnvWait"

    const-string v1, "Spa environment still not set after 3 s"

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :done
    return-void
.end method
""")

# ---- 2. SecSettingsIntelligence: a failed non-indexable query is "unknown", not "everything available" ----
f = one(SSI, "com/android/settings/intelligence/search/indexing/PreIndexDataCollector.smali")
s = open(f).read()
m = method(s, " getNonIndexablesKeys(Landroid/content/Context;Landroid/net/Uri;[Ljava/lang/String;)Ljava/util/List;")
body = m.group(0)
MARK = "    # k4: no cursor -> null (keep the previous availability)\n"
if MARK in body:
    print("  - getNonIndexablesKeys already patched")
else:
    old = ('    const-string p1, "Cannot add index data for Uri: "\n\n'
           '    invoke-direct {p0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V\n\n'
           '    invoke-virtual {p2}, Landroid/net/Uri;->toString()Ljava/lang/String;\n\n'
           '    move-result-object p1\n\n'
           '    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;\n\n'
           '    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;\n\n'
           '    move-result-object p0\n\n'
           '    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I\n\n'
           '    return-object v3\n')
    new = old[:-len('    return-object v3\n')] + MARK + '    const/4 v3, 0x0\n\n    return-object v3\n'
    body = sub_once(body, old, new, "getNonIndexablesKeys null-cursor branch")
    assert body.count("return-object v3\n") == 2, "getNonIndexablesKeys: return paths changed"
    s = s[:m.start()] + body + s[m.end():]

for name, getter in (("addNonIndexablesKeysFromRemoteProvider", "getNonIndexablesKeysFromRemoteProvider"),
                     ("addSecNonIndexablesKeysFromRemoteProvider", "getSecNonIndexablesKeysFromRemoteProvider")):
    m = method(s, " %s(Ljava/lang/String;Ljava/lang/String;Lcom/android/settings/intelligence/search/indexing/PreIndexData;)V" % name)
    body = m.group(0)
    if ":k4_have_keys" in body:
        print("  - %s already patched" % name)
        continue
    old = ("    invoke-virtual {p0, p1, p2}, Lcom/android/settings/intelligence/search/indexing/PreIndexDataCollector;->%s(Ljava/lang/String;Ljava/lang/String;)Ljava/util/List;\n\n"
           "    move-result-object p0\n\n" % getter)
    new = old + "    if-nez p0, :k4_have_keys\n\n    return-void\n\n    :k4_have_keys\n"
    body = sub_once(body, old, new, name)
    assert body.count("addNonIndexableKeysForAuthority(") == 1, name + ": authority put changed"
    s = s[:m.start()] + body + s[m.end():]

# the two getters must still hand the list through unchanged (null reaches the add* methods)
for getter in ("getNonIndexablesKeysFromRemoteProvider", "getSecNonIndexablesKeysFromRemoteProvider"):
    b = method(s, " %s(Ljava/lang/String;Ljava/lang/String;)Ljava/util/List;" % getter).group(0)
    i = b.index("->getNonIndexablesKeys(Landroid/content/Context;Landroid/net/Uri;[Ljava/lang/String;)Ljava/util/List;")
    tail = b[i:i + 400]
    assert re.search(r"\n\n    move-result-object (\w+)\n(    :try_end_\d+\n    \.catch [^\n]+\n)?\n    return-object \1\n", tail), \
        getter + ": result not returned directly"
open(f, "w").write(s)
PYEOF
unset SECSETTINGS SSI
