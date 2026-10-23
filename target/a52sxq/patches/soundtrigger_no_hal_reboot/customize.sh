# See module.prop. Extends soundtrigger_load_no_reboot (load refusals, never a reboot) to every other HAL error and
# callback mismatch: no HAL reboot while a call / VoIP is active, the stock resync reboot once it has ended.
# Needs K4StRetry (halError / callbackError) from soundtrigger_load_no_reboot, which runs first (LC_ALL=C order).
SERVICES="system/framework/services.jar"
DECODE_APK "system" "$SERVICES" || ABORT "Failed to decode $SERVICES"
python3 - "$APKTOOL_DIR/system/${SERVICES//system\//}" << 'PYEOF' || ABORT "Failed to apply the sound trigger no-reboot-during-calls hardening"
import glob, sys
root = sys.argv[1]
P = "Lcom/android/server/soundtrigger_middleware/"
K = "Lcom/k4/soundtrigger/K4StRetry;"
ENF = P + "SoundTriggerHalEnforcer;"
writes = []  # files are written only after every check passed
def one(pattern):
    hits = glob.glob(root + "/smali*/" + pattern)
    assert len(hits) == 1, "%s: %d" % (pattern, len(hits))
    return hits[0]

helper = open(one("com/k4/soundtrigger/K4StRetry.smali")).read()
HAL_ERROR = "halError(%sLjava/lang/RuntimeException;)Ljava/lang/RuntimeException;" % ENF
CB_ERROR = "callbackError(%s)V" % ENF
for m in (HAL_ERROR, CB_ERROR):
    assert ".method public static " + m in helper, "K4StRetry.%s missing (soundtrigger_load_no_reboot too old?)" % m

# (1) SoundTriggerHalEnforcer.handleException: the "log, reboot(), throw e" branch -> K4StRetry.halError
#     (mode NORMAL: same log + reboot; call/VoIP active: HalException -> RecoverableException(5), reboot owed)
f = one("com/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer.smali")
s = open(f).read()
sig = ".method public final handleException(Ljava/lang/RuntimeException;)V"
assert s.count(sig) == 1, "handleException: %d" % s.count(sig)
i = s.index(sig); j = s.index(".end method", i); body = s[i:j]
NEW = ("    :cond_0\n    invoke-static {p0, p1}, %s->%s\n\n    move-result-object p0\n\n    throw p0\n" % (K, HAL_ERROR))
if NEW in body:
    print("  - handleException already guarded")
else:
    assert ":k4_reboot" not in body, "handleException: older soundtrigger_no_hal_reboot guard present"
    OLD = ("    :cond_0\n    const-string v0, \"Exception caught from HAL, rebooting HAL\"\n\n"
           "    invoke-static {v1, v0}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I\n\n"
           "    invoke-virtual {p0}, %s->reboot()V\n\n    throw p1\n" % ENF)
    assert ".locals 2" in body, "handleException: expected .locals 2"
    assert body.count(OLD) == 1, "handleException: reboot branch changed (%d)" % body.count(OLD)
    assert body.count("->reboot()V") == 1, "handleException: unexpected extra reboot calls"
    # the RecoverableException and dead-HAL (RecoverableException(4)) branches stay stock
    assert body.count("instance-of v0, p1, %sRecoverableException;" % P) == 1, "handleException: Recoverable check changed"
    assert body.count("instance-of v0, v0, Landroid/os/DeadObjectException;") == 1, "handleException: dead-HAL check changed"
    s = s[:i] + body.replace(OLD, NEW) + s[j:]
    writes.append((f, s))
    print("  - handleException: HAL error -> K4StRetry.halError (reboot now outside calls, after the call otherwise)")

# (2) ModelCallbackEnforcer contract checks: this$0.reboot() -> K4StRetry.callbackError(this$0); the event is dropped
#     either way (stock returns right after its reboot); wtfStack logging stays
f = one("com/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer$ModelCallbackEnforcer.smali")
s = open(f).read()
GET = "    iget-object p0, p0, %sSoundTriggerHalEnforcer$ModelCallbackEnforcer;->this$0:%s\n\n" % (P, ENF)
REBOOT = GET + "    invoke-virtual {p0}, %s->reboot()V\n" % ENF
HOOK = GET + "    invoke-static {p0}, %s->%s\n" % (K, CB_ERROR)
n, done = s.count(REBOOT), s.count(HOOK)
if n == 0 and done == 6:
    print("  - ModelCallbackEnforcer already guarded")
else:
    assert "k4_no_reboot" not in s, "ModelCallbackEnforcer: older soundtrigger_no_hal_reboot guard present"
    assert n == 6 and done == 0, "ModelCallbackEnforcer: %d reboot sites, %d guarded (expected 6/0)" % (n, done)
    assert s.count("->reboot()V") == 6, "ModelCallbackEnforcer: unexpected extra reboot calls"
    for m in ("modelUnloaded(I)V", "phraseRecognitionCallback(I", "recognitionCallback(I"):
        assert s.count(".method public final " + m) == 1, "ModelCallbackEnforcer: %s missing" % m
    writes.append((f, s.replace(REBOOT, HOOK)))
    print("  - ModelCallbackEnforcer: 6 contract checks -> K4StRetry.callbackError (no reboot during calls)")
for f, s in writes:
    open(f, "w").write(s)
PYEOF
LOG "- Sound trigger: HAL errors no longer restart the shared audio HAL during calls (resync restart after the call)"
unset SERVICES
