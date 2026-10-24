# See module.prop. Extends soundtrigger_load_no_reboot (load refusals, never a reboot) to every other HAL error and
# callback mismatch and to SoundTriggerHalWatchdog deadlines: no HAL reboot while a call / VoIP is active, the stock
# resync reboot once it has ended (a hung HAL call: only if it is still hung then, or 45 s past its deadline during the call).
# Needs K4StRetry (halError / callbackError / watchdogExpired / watchdogClosed) from soundtrigger_load_no_reboot, which runs first (LC_ALL=C order).
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
WD = P + "SoundTriggerHalWatchdog;"
WDW = P + "SoundTriggerHalWatchdog$Watchdog;"
WD_EXPIRED = "watchdogExpired(Ljava/lang/Object;%sLjava/lang/Exception;)V" % WD
WD_CLOSED = "watchdogClosed(Ljava/lang/Object;)V"
for m in (HAL_ERROR, CB_ERROR, WD_EXPIRED, WD_CLOSED):
    assert ".method public static " + m in helper, "K4StRetry.%s missing (soundtrigger_load_no_reboot too old?)" % m

# (1) SoundTriggerHalEnforcer.handleException: the "log, reboot(), throw e" branch -> K4StRetry.halError
#     (HalException -> RecoverableException(5); the reboot is owed: no call -> after a 3 s grace with the mode re-read,
#     call/VoIP active -> after the call)
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
    print("  - handleException: HAL error -> K4StRetry.halError (reboot after a 3 s grace outside calls, after the call otherwise)")

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
# (3) SoundTriggerHalWatchdog deadline (a HAL call still running after 3 s): "log, this$0.reboot()" ->
#     K4StRetry.watchdogExpired (no call: stock reboot now; call/VoIP: reboot after the call if still hung, or after
#     45 s past the deadline during the call: below the 60 s system_server Watchdog)
f = one("com/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog$Watchdog$$ExternalSyntheticLambda0.smali")
s = open(f).read()
L = P + "SoundTriggerHalWatchdog$Watchdog$$ExternalSyntheticLambda0;"
sig = ".method public final run()V\n"
assert s.count(sig) == 1, "watchdog lambda: run() %d" % s.count(sig)
i = s.index(sig) + len(sig); j = s.index(".end method", i); body = s[i:j]
GET = "    iget-object p0, p0, %s->f$0:%s\n\n" % (L, WDW)
STOCK = ("    .locals 3\n\n" + GET +
         "    const-string v0, \"HAL deadline expired. Rebooting.\"\n\n"
         "    iget-object v1, p0, %s->mException:Ljava/lang/Exception;\n\n"
         "    const-string/jumbo v2, \"SoundTriggerHalWatchdog\"\n\n"
         "    invoke-static {v2, v0, v1}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I\n\n"
         "    iget-object p0, p0, %s->this$0:%s\n\n"
         "    invoke-virtual {p0}, %s->reboot()V\n\n    return-void\n" % (WDW, WDW, WD, WD))
HOOKED = ("    .locals 2\n\n" + GET +
          "    iget-object v0, p0, %s->this$0:%s\n\n"
          "    iget-object v1, p0, %s->mException:Ljava/lang/Exception;\n\n"
          "    invoke-static {p0, v0, v1}, %s->%s\n\n    return-void\n" % (WDW, WD, WDW, K, WD_EXPIRED))
if body == HOOKED:
    print("  - watchdog deadline already guarded")
else:
    assert body == STOCK, "watchdog lambda: run() body changed"
    writes.append((f, s[:i] + HOOKED + s[j:]))
    print("  - watchdog deadline -> K4StRetry.watchdogExpired (no reboot during calls while the HAL call may still return)")

# (4) SoundTriggerHalWatchdog$Watchdog.close() (every HAL call, after it returned or threw): tell K4StRetry, after the
#     timer is cancelled, so a late return during a call needs no reboot
f = one("com/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog$Watchdog.smali")
s = open(f).read()
sig = ".method public final close()V\n"
assert s.count(sig) == 1, "Watchdog.close: %d" % s.count(sig)
i = s.index(sig) + len(sig); j = s.index(".end method", i); body = s[i:j]
T = P + "UptimeTimer$TaskImpl;"
STOCK = ("    .locals 1\n\n    iget-object p0, p0, %s->mTask:%s\n\n"
         "    iget-object v0, p0, %s->mHandler:Landroid/os/Handler;\n\n"
         "    iget-object p0, p0, %s->mToken:Ljava/lang/Object;\n\n"
         "    invoke-virtual {v0, p0}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V\n\n"
         "    return-void\n" % (WDW, T, T, T))
HOOKED = ("    .locals 2\n\n    iget-object v1, p0, %s->mTask:%s\n\n"
          "    iget-object v0, v1, %s->mHandler:Landroid/os/Handler;\n\n"
          "    iget-object v1, v1, %s->mToken:Ljava/lang/Object;\n\n"
          "    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacksAndMessages(Ljava/lang/Object;)V\n\n"
          "    invoke-static {p0}, %s->%s\n\n    return-void\n" % (WDW, T, T, T, K, WD_CLOSED))
if body == HOOKED:
    print("  - Watchdog.close already hooked")
else:
    assert body == STOCK, "Watchdog.close body changed"
    writes.append((f, s[:i] + HOOKED + s[j:]))
    print("  - Watchdog.close -> K4StRetry.watchdogClosed (a hung HAL call that returns late during a call: no reboot)")
for f, s in writes:
    open(f, "w").write(s)
PYEOF
LOG "- Sound trigger: HAL errors and hung HAL calls no longer restart the shared audio HAL during calls (resync restart after the call)"
unset SERVICES
