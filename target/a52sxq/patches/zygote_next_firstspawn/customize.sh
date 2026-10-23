# NativeZygoteProcess (framework.jar) talks to zygote_next over a LocalSocket and reads the spawn reply with a plain
# blocking read() in libandroid_runtime's ReadSpawnResponse. A native child zygote that dies before answering (on
# 2026-10-07: a test app declaring android:nativeService without zygotePreloadNativeLib / native service library
# properties) leaves ActivityManager:procStart blocked forever -> "Blocked in handler on ActivityManager:procStart for
# 70s" -> watchdog restarts system_server. ReadSpawnResponse treats read() == -1 as an error and throws IOException,
# which start() and startChildZygote() already catch (log, return null = that one start fails). So:
#  1. connectToZygote(): after connect(), setSoTimeout(20000) (SO_RCVTIMEO) on the socket. If connect() or
#     setSoTimeout() throws, close the half-made socket before the stock code drops it (else the fd leaks).
#  2. startChildZygote() and start(): in their IOException handler, close and drop mSocket. SO_RCVTIMEO is on the one
#     socket every spawn shares, so after a timeout zygote_next may still write the reply for the failed request;
#     keeping the socket would hand that stale pid to the NEXT request (wrong pid in ActivityManager, queue shifted by
#     one). The next call reconnects.
# start() overwrites p0 (this) with mSocket and then with the pid inside its try block, so `this` is copied into p1
# (an argument the stock body never reads before the try ends) and the try block gets its own handler that resets the
# socket through p1 and then joins the stock logging path. Every edit is anchored, aborts on mismatch and is skipped
# when already present.
DECODE_APK "system" "system/framework/framework.jar"
python3 - "$APKTOOL_DIR/system/framework/framework.jar" << 'PYEOF' || ABORT "Failed to apply the native zygote spawn timeout"
import glob, re, sys
f = glob.glob(sys.argv[1] + "/smali*/android/os/NativeZygoteProcess.smali")
assert len(f) == 1, "NativeZygoteProcess.smali"
s = open(f[0]).read()
SOCK = "Landroid/os/NativeZygoteProcess;->mSocket:Landroid/net/LocalSocket;"
CLOSEQ = "Llibcore/io/IoUtils;->closeQuietly(Ljava/lang/AutoCloseable;)V"

def method(sig):
    start = s.index(sig)
    end = s.index(".end method", start)
    assert s.count(sig) == 1, sig
    return start, end

done = []

# 1a. connectToZygote: set a receive timeout right after a successful connect (inside the existing IOException try).
start, end = method(".method private declared-synchronized blacklist connectToZygote()V")
body = s[start:end]
old = "    invoke-virtual {v0, v1}, Landroid/net/LocalSocket;->connect(Landroid/net/LocalSocketAddress;)V\n"
new = old + ("\n    const/16 v1, 0x4e20\n\n"
             "    invoke-virtual {v0, v1}, Landroid/net/LocalSocket;->setSoTimeout(I)V\n")
if body.count(new) == 1:
    done.append("connect timeout")
else:
    assert body.count(old) == 1 and "setSoTimeout" not in body, "connectToZygote connect call"
    body = body.replace(old, new)

# 1b. connectToZygote: close the socket before nulling it when connect()/setSoTimeout() threw. The close goes inside
#     the stock :try_start_2 range so the catch-all that releases the monitor still covers it.
old = ("    :catch_0\n    move-exception v0\n\n    const/4 v1, 0x0\n\n    :try_start_2\n"
       "    iput-object v1, p0, " + SOCK + "\n")
new = ("    :catch_0\n    move-exception v0\n\n    :try_start_2\n"
       "    iget-object v1, p0, " + SOCK + "\n\n"
       "    invoke-static {v1}, " + CLOSEQ + "\n\n"
       "    const/4 v1, 0x0\n\n"
       "    iput-object v1, p0, " + SOCK + "\n")
if body.count(new) == 1:
    done.append("connect close")
else:
    assert body.count(old) == 1 and CLOSEQ not in body, "connectToZygote catch block"
    body = body.replace(old, new)
s = s[:start] + body + s[end:]

# 2. startChildZygote: reset the socket in the IOException handler.
start, end = method(".method public blacklist startChildZygote(")
body = s[start:end]
if ":unica_nz_reset_done" in body:
    done.append("child zygote reset")
else:
    m = re.search(r"\n    :catch_0\n    move-exception v0\n", body)
    assert m and body.count(":catch_0\n    move-exception") == 1, "startChildZygote catch block"
    assert re.search(r"\.locals (\d+)", body) and int(re.search(r"\.locals (\d+)", body).group(1)) >= 3, "locals"
    assert not re.search(r"\n    \S+ p0,|move-result(-object)? p0\n", body), "startChildZygote writes p0"
    reset = ("\n    move-object/from16 v2, p0\n\n"
             "    iget-object v1, v2, " + SOCK + "\n\n"
             "    if-eqz v1, :unica_nz_reset_done\n\n"
             "    :try_start_unica_nz\n"
             "    invoke-virtual {v1}, Landroid/net/LocalSocket;->close()V\n"
             "    :try_end_unica_nz\n"
             "    .catch Ljava/io/IOException; {:try_start_unica_nz .. :try_end_unica_nz} :unica_nz_close_failed\n\n"
             "    :unica_nz_close_failed\n"
             "    const/4 v1, 0x0\n\n"
             "    iput-object v1, v2, " + SOCK + "\n\n"
             "    :unica_nz_reset_done\n")
    body = body[:m.end()] + reset + body[m.end():]
s = s[:start] + body + s[end:]

# 3. start(): same reset for the ordinary native process spawn.
start, end = method(".method public final blacklist start(Ljava/lang/String;Ljava/lang/String;II[IIIILjava/lang/String;")
body = s[start:end]
if ":unica_nz_start_catch" in body:
    done.append("start reset")
else:
    assert re.search(r"\n    \.locals 12\n", body), "start locals"
    head = "    :try_start_0\n    invoke-direct {p0}, Landroid/os/NativeZygoteProcess;->connectToZygote()V\n\n" \
           "    iget-object p0, p0, " + SOCK + "\n"
    assert body.count(head) == 1, "start try head"
    try0 = body[body.index(head):body.index("    :try_end_0\n")]
    assert not re.search(r"\bp1\b", try0), "start reads p1 inside try_0"
    c0 = "    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0\n"
    assert body.count(c0) == 1, "start try_0 catch"
    c1 = "    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0\n"
    assert body.count(c1) == 1, "start try_1 catch"
    log = ("    :catch_0\n    move-exception v0\n\n    move-object p0, v0\n\n"
           "    const-string p1, \"Failed to start a native process\"\n")
    assert body.count(log) == 1, "start catch block"
    tail = "    const/4 p0, 0x0\n\n    return-object p0\n"
    assert body.endswith(tail), "start tail"
    body = body.replace(head, "    move-object p1, p0\n\n" + head)
    body = body.replace(c0, c0.replace(":catch_0", ":unica_nz_start_catch"))
    body = body.replace(log, log.replace("    move-exception v0\n",
                                         "    move-exception v0\n\n    :unica_nz_start_log\n"))
    body += ("\n    :unica_nz_start_catch\n    move-exception v0\n\n"
             "    iget-object v1, p1, " + SOCK + "\n\n"
             "    invoke-static {v1}, " + CLOSEQ + "\n\n"
             "    const/4 v1, 0x0\n\n"
             "    iput-object v1, p1, " + SOCK + "\n\n"
             "    goto :unica_nz_start_log\n")
s = s[:start] + body + s[end:]

if len(done) == 4:
    print("NativeZygoteProcess: spawn timeout and socket resets already present")
elif done:
    print("NativeZygoteProcess: already present: " + ", ".join(done))
open(f[0], "w").write(s)
PYEOF
LOG "- Native zygote spawns time out after 20 s instead of blocking system_server; a failed spawn drops the connection"
