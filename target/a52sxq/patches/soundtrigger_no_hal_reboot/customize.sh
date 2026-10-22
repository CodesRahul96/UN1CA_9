# See module.prop. Generalises soundtrigger_load_no_reboot (load only) to every HAL status error and callback mismatch.
SERVICES="system/framework/services.jar"
DECODE_APK "system" "$SERVICES" || ABORT "Failed to decode $SERVICES"
python3 - "$APKTOOL_DIR/system/${SERVICES//system\//}" << 'PYEOF' || ABORT "Failed to apply the sound trigger no-reboot hardening"
import glob, sys
root = sys.argv[1]
P = "Lcom/android/server/soundtrigger_middleware/"
writes = []  # files are written only after every check passed
def one(pattern):
    hits = glob.glob(root + "/smali*/com/android/server/soundtrigger_middleware/" + pattern)
    assert len(hits) == 1, "%s: %d" % (pattern, len(hits))
    return hits[0]

# (1) SoundTriggerHalEnforcer.handleException: HalException -> RecoverableException(5), no reboot
f = one("SoundTriggerHalEnforcer.smali")
s = open(f).read()
sig = ".method public final handleException(Ljava/lang/RuntimeException;)V"
assert s.count(sig) == 1, "handleException: %d" % s.count(sig)
i = s.index(sig); j = s.index(".end method", i); body = s[i:j]
if ":k4_reboot" in body:
    print("  - handleException already guarded")
else:
    OLD = ("    :cond_0\n    const-string v0, \"Exception caught from HAL, rebooting HAL\"\n\n"
           "    invoke-static {v1, v0}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I\n\n"
           "    invoke-virtual {p0}, %sSoundTriggerHalEnforcer;->reboot()V\n\n    throw p1\n" % P)
    assert ".locals 2" in body, "handleException: expected .locals 2"
    assert body.count(OLD) == 1, "handleException: reboot branch changed (%d)" % body.count(OLD)
    assert body.count("const-string/jumbo v1, \"SoundTriggerHalEnforcer\"") == 1, "handleException: tag register changed"
    NEW = ("    :cond_0\n    instance-of v0, p1, %sHalException;\n\n    if-eqz v0, :k4_reboot\n\n"
           "    invoke-virtual {p1}, Ljava/lang/RuntimeException;->toString()Ljava/lang/String;\n\n    move-result-object p0\n\n"
           "    const-string v0, \"HAL returned an error, not rebooting the HAL (shared with the audio HAL): \"\n\n"
           "    invoke-virtual {v0, p0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;\n\n    move-result-object v0\n\n"
           "    invoke-static {v1, v0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I\n\n"
           "    new-instance v0, %sRecoverableException;\n\n    const/4 v1, 0x5\n\n"
           "    invoke-direct {v0, v1, p0}, %sRecoverableException;-><init>(ILjava/lang/String;)V\n\n    throw v0\n\n"
           "    :k4_reboot\n" % (P, P, P)) + OLD[len("    :cond_0\n"):]
    s = s[:i] + body.replace(OLD, NEW) + s[j:]
    writes.append((f, s))
    print("  - handleException: HalException -> RecoverableException (no HAL reboot)")

# (2) ModelCallbackEnforcer: keep wtfStack, drop the event, no reboot
f = one("SoundTriggerHalEnforcer$ModelCallbackEnforcer.smali")
s = open(f).read()
REBOOT = ("    iget-object p0, p0, %sSoundTriggerHalEnforcer$ModelCallbackEnforcer;->this$0:%sSoundTriggerHalEnforcer;\n\n"
          "    invoke-virtual {p0}, %sSoundTriggerHalEnforcer;->reboot()V\n" % (P, P, P))
DROP = "    # k4_no_reboot: event dropped, HAL kept running (it shares the audio HAL process)\n"
n, done = s.count(REBOOT), s.count(DROP)
if n == 0 and done == 6:
    print("  - ModelCallbackEnforcer already guarded")
else:
    assert n == 6 and done == 0, "ModelCallbackEnforcer: %d reboot sites, %d guarded (expected 6/0)" % (n, done)
    assert s.count("->reboot()V") == 6, "ModelCallbackEnforcer: unexpected extra reboot calls"
    for m in ("modelUnloaded(I)V", "phraseRecognitionCallback(I", "recognitionCallback(I"):
        assert s.count(".method public final " + m) == 1, "ModelCallbackEnforcer: %s missing" % m
    writes.append((f, s.replace(REBOOT, DROP)))
    print("  - ModelCallbackEnforcer: 6 contract checks log and drop instead of rebooting the HAL")
for f, s in writes:
    open(f, "w").write(s)
PYEOF
LOG "- Sound trigger: HAL errors no longer restart the shared audio HAL (calls keep their audio)"
unset SERVICES
