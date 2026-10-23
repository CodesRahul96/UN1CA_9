# See module.prop. Tester log: /home/kusti420/Downloads/Telegram Desktop/logsrecentes.txt (2026-10-20 08:19:58-08:20:03)
# K4StRetry*.smali are generated from src/ by src/build.sh (javac --release 11 against android-36 android.jar +
# src/stubs, d8 --min-api 36, baksmali); rerun it when K4StRetry.java changes. soundtrigger_no_hal_reboot (runs
# after this patch) hooks K4StRetry.halError/callbackError into the enforcer's reboot paths.
SERVICES="system/framework/services.jar"
DECODE_APK "system" "$SERVICES" || ABORT "Failed to decode $SERVICES"
python3 - "$APKTOOL_DIR/system/${SERVICES//system\//}" "$SRC_DIR/target/a52sxq/patches/soundtrigger_load_no_reboot" << 'PYEOF' || ABORT "Failed to apply the sound trigger load fix"
import glob, os, re, shutil, sys
root, patch = sys.argv[1], sys.argv[2]
hits = glob.glob(root + "/smali*/com/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer.smali")
assert len(hits) == 1, "SoundTriggerHalEnforcer: %d" % len(hits)
for c in ("HalException", "RecoverableException", "ISoundTriggerHal$GlobalCallback"):
    assert glob.glob(root + "/smali*/com/android/server/soundtrigger_middleware/%s.smali" % c), "%s missing" % c
s = open(hits[0]).read()
P = "Lcom/android/server/soundtrigger_middleware/"
K = "Lcom/k4/soundtrigger/K4StRetry;"
CATCH = "    :catch_0\n    move-exception p1\n\n"
HANDLE = "    invoke-virtual {p0, p1}, %sSoundTriggerHalEnforcer;->handleException(Ljava/lang/RuntimeException;)V\n" % P
GUARD = ("    instance-of v0, p1, %sHalException;\n\n"
         "    if-eqz v0, :k4_not_hal_status\n\n"
         "    move-object v0, p1\n\n"
         "    check-cast v0, %sHalException;\n\n"
         "    invoke-static {p0, v0}, %s->refused(Ljava/lang/Object;%sHalException;)Ljava/lang/RuntimeException;\n\n"
         "    move-result-object v0\n\n"
         "    throw v0\n\n"
         "    :k4_not_hal_status\n\n" % (P, P, K, P))
# 9.3.63-9.3.70 guard (always INTERNAL_ERROR, no retry): upgraded in place if this tree still has it
OLD = re.compile(r"    instance-of v0, p1, %sHalException;\n\n    if-eqz v0, :k4_not_hal_status\n\n"
                 r"(?:(?!\.end method).)*?    throw p0\n\n    :k4_not_hal_status\n\n?" % re.escape(P), re.S)
for name in ("loadSoundModel(Landroid/media/soundtrigger/SoundModel;", "loadPhraseSoundModel(Landroid/media/soundtrigger/PhraseSoundModel;"):
    sig = ".method public final " + name
    assert s.count(sig) == 1, "%s: %d" % (name, s.count(sig))
    i = s.index(sig); j = s.index(".end method", i)
    body = s[i:j]
    short = name.split("(")[0]
    if K in body:
        print("  - %s already guarded" % short); continue
    assert ".locals 3" in body, "%s: expected .locals 3" % short
    if ":k4_not_hal_status" in body:
        body, n = OLD.subn(GUARD, body)
        assert n == 1, "%s: unknown old guard" % short
        print("  - %s: old guard upgraded" % short)
    else:
        assert body.count(CATCH + HANDLE) == 1, "%s: catch handler changed" % short
        body = body.replace(CATCH + HANDLE, CATCH + GUARD + HANDLE)
        print("  - %s: HAL status -> K4StRetry.refused (busy -> retry on resources available, no HAL reboot)" % short)
    s = s[:i] + body + s[j:]
sig = ".method public final registerCallback(%sISoundTriggerHal$GlobalCallback;)V\n" % P
assert s.count(sig) == 1, "registerCallback signature changed"
i = s.index(sig) + len(sig)
m = re.match(r"(    \.(?:locals|registers) \d+\n\n)", s[i:])
assert m, "registerCallback: no .locals line"
call = "    invoke-static {p0, p1}, %s->setCallback(Ljava/lang/Object;%sISoundTriggerHal$GlobalCallback;)V\n\n" % (K, P)
j = i + len(m.group(1))
if s[j:].startswith(call):
    print("  - registerCallback already hooked")
else:
    s = s[:j] + call + s[j:]
    print("  - registerCallback -> K4StRetry.setCallback")
# detach() runs on the old enforcer when SoundTriggerModule.binderDied replaces the HAL stack: drop its entries
sig = ".method public final detach()V\n"
assert s.count(sig) == 1, "detach signature changed"
i = s.index(sig) + len(sig)
body = s[i:s.index(".end method", i)]
DETACH = ("    .locals 0\n\n    iget-object p0, p0, %sSoundTriggerHalEnforcer;->mUnderlying:%sSoundTriggerHalWatchdog;\n\n"
          "    invoke-virtual {p0}, %sSoundTriggerHalWatchdog;->detach()V\n\n    return-void\n" % (P, P, P))
call = "    invoke-static {p0}, %s->detached(Ljava/lang/Object;)V\n\n" % K
if body.startswith("    .locals 0\n\n" + call):
    print("  - detach already hooked")
else:
    assert body == DETACH, "detach body changed"
    s = s[:i] + "    .locals 0\n\n" + call + body[len("    .locals 0\n\n"):] + s[i + len(body):]
    print("  - detach -> K4StRetry.detached (drops the dead HAL stack's callback / pending retry / owed reboot)")
open(hits[0], "w").write(s)
helpers = sorted(glob.glob(patch + "/K4StRetry*.smali"))
assert len(helpers) == 12, "K4StRetry smali files: %d (expected 12, rerun src/build.sh)" % len(helpers)
dirs = sorted((d for d in glob.glob(root + "/smali_classes*") if re.fullmatch(r"smali_classes\d+", os.path.basename(d))),
              key=lambda d: int(os.path.basename(d)[len("smali_classes"):]))
dst = os.path.join(dirs[-1] if dirs else root + "/smali", "com/k4/soundtrigger")
for old in glob.glob(root + "/smali*/com/k4/soundtrigger/K4StRetry*.smali"):
    os.remove(old)
os.makedirs(dst, exist_ok=True)
for h in helpers:
    shutil.copyfile(h, os.path.join(dst, os.path.basename(h)))
print("  - %d K4StRetry smali files -> %s" % (len(helpers), os.path.relpath(dst, root)))
PYEOF
LOG "- Sound trigger: a model the HAL refuses no longer reboots the audio HAL; a busy refusal is retried when audio stops / screen off"
unset SERVICES
