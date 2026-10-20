# See module.prop. Tester log: /home/kusti420/Downloads/Telegram Desktop/logsrecentes.txt (2026-10-20 08:19:58-08:20:03)
SERVICES="system/framework/services.jar"
DECODE_APK "system" "$SERVICES" || ABORT "Failed to decode $SERVICES"
python3 - "$APKTOOL_DIR/system/${SERVICES//system\//}" << 'PYEOF' || ABORT "Failed to apply the sound trigger load fix"
import glob, sys
root = sys.argv[1]
hits = glob.glob(root + "/smali*/com/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer.smali")
assert len(hits) == 1, "SoundTriggerHalEnforcer: %d" % len(hits)
s = open(hits[0]).read()
P = "Lcom/android/server/soundtrigger_middleware/"
HANDLE = ("    :catch_0\n    move-exception p1\n\n"
          "    invoke-virtual {p0, p1}, %sSoundTriggerHalEnforcer;->handleException(Ljava/lang/RuntimeException;)V\n" % P)
GUARD = ("    :catch_0\n    move-exception p1\n\n"
         "    instance-of v0, p1, %sHalException;\n\n"
         "    if-eqz v0, :k4_not_hal_status\n\n"
         "    const-string/jumbo v1, \"SoundTriggerHalEnforcer\"\n\n"
         "    const-string v2, \"HAL refused the model, not rebooting the HAL: \"\n\n"
         "    invoke-virtual {p1}, Ljava/lang/RuntimeException;->toString()Ljava/lang/String;\n\n"
         "    move-result-object v0\n\n"
         "    invoke-virtual {v2, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;\n\n"
         "    move-result-object v2\n\n"
         "    invoke-static {v1, v2}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I\n\n"
         "    new-instance p0, %sRecoverableException;\n\n"
         "    const/4 v1, 0x5\n\n"
         "    invoke-direct {p0, v1, v0}, %sRecoverableException;-><init>(ILjava/lang/String;)V\n\n"
         "    throw p0\n\n"
         "    :k4_not_hal_status\n" % (P, P, P))
done = 0
for name in ("loadSoundModel(Landroid/media/soundtrigger/SoundModel;", "loadPhraseSoundModel(Landroid/media/soundtrigger/PhraseSoundModel;"):
    sig = ".method public final " + name
    assert s.count(sig) == 1, "%s: %d" % (name, s.count(sig))
    i = s.index(sig); j = s.index(".end method", i)
    body = s[i:j]
    if ":k4_not_hal_status" in body:
        print("  - %s already guarded" % name.split("(")[0]); continue
    assert ".locals 3" in body, "%s: expected .locals 3" % name
    assert body.count(HANDLE) == 1, "%s: catch handler changed (%d)" % (name, body.count(HANDLE))
    body = body.replace(HANDLE, GUARD + "\n" + HANDLE[len("    :catch_0\n    move-exception p1\n\n"):])
    s = s[:i] + body + s[j:]
    done += 1
    print("  - %s: HAL status -> RecoverableException (no HAL reboot)" % name.split("(")[0])
open(hits[0], "w").write(s)
PYEOF
LOG "- Sound trigger: a model the HAL refuses no longer reboots the audio HAL (\"Hey Google\" setup audio drops)"
unset SERVICES
