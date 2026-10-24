# NandswapManager (RAM Plus zram writeback): StorageManagerService's H_SYSTEM_READY sets the boot quota and then
# schedules two JobScheduler jobs, which hung that handler on this port (see module.prop). schedNextUpdateAverage (the
# bigdata average job) stays a no-op. schedNextLimitReset's job (id 0x32d, every 24 h) was the only thing that tops up
# /sys/block/zram0/writeback_limit (setDailyQuota(false): min(3 x quota, remaining + quota)), so without it writeback
# stops for good once the boot limit is used up. K4NandswapQuota does the same top-up without JobScheduler: a check
# on BackgroundThread every hour, a top-up once 24 h of elapsed realtime (sleep included) have passed since the last.
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali/com/android/server/NandswapManager.smali" "null" "schedNextUpdateAverage()V"
DECODE_APK "system" "system/framework/services.jar" || ABORT "Failed to decode services.jar"
python3 - "$APKTOOL_DIR/system/framework/services.jar" << 'PYEOF' || ABORT "Failed to patch NandswapManager.schedNextLimitReset"
import glob, os, re, sys
root = sys.argv[1]
hits = glob.glob(root + "/smali*/com/android/server/NandswapManager.smali")
assert len(hits) == 1, "NandswapManager: %d" % len(hits)
f = hits[0]
s = open(f).read()
NM = "Lcom/android/server/NandswapManager;"
K4 = "Lcom/android/server/K4NandswapQuota;"
assert re.search(r"^\.method public static setDailyQuota\(Z\)Z$", s, re.M), "NandswapManager.setDailyQuota(Z)Z"
m = re.search(r"^\.method public static schedNextLimitReset\(\)V\n.*?^\.end method\n", s, re.M | re.S)
assert m, "NandswapManager.schedNextLimitReset()V"
body = m.group(0)
new = (".method public static schedNextLimitReset()V\n"
       "    .locals 0\n\n"
       "    invoke-static {}, %s->start()V\n\n"
       "    return-void\n"
       ".end method\n" % K4)
if body == new:
    print("  - schedNextLimitReset already patched")
else:
    # the stock body: the 24 h one-shot job 0x32d through JobScheduler
    for need in ("const/16 v2, 0x32d", "const-wide/32 v2, 0x5265c00", "Landroid/app/job/JobScheduler;->schedule(Landroid/app/job/JobInfo;)I"):
        assert need in body, "schedNextLimitReset is not the stock job scheduler: " + need
    s = s[:m.start()] + new + s[m.end():]
    open(f, "w").write(s)
    print("  - schedNextLimitReset -> K4NandswapQuota.start()")
dst = os.path.join(os.path.dirname(f), "K4NandswapQuota.smali")
stale = [p for p in glob.glob(root + "/smali*/com/android/server/K4NandswapQuota.smali") if p != dst]
assert not stale, "stale helper copies: %s" % stale
open(dst, "w").write("""\
.class public final %(K4)s
.super Ljava/lang/Object;
.source "K4NandswapQuota.java"

# interfaces
.implements Ljava/lang/Runnable;


# a52sxq storage patch: the daily zram writeback quota top-up of NandswapManager's job 0x32d without JobScheduler.
# start() (from schedNextLimitReset, i.e. after the boot quota was set) posts one check per hour on BackgroundThread;
# once 24 h of elapsed realtime have passed since the last top-up (or start), setDailyQuota(false) runs again.

# static fields
.field private static sLast:J

.field private static sStarted:Z


# direct methods
.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static start()V
    .locals 5

    const-class v0, %(K4)s

    monitor-enter v0

    :try_start_0
    sget-boolean v1, %(K4)s->sStarted:Z

    if-nez v1, :cond_done

    const/4 v1, 0x1

    sput-boolean v1, %(K4)s->sStarted:Z

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    sput-wide v2, %(K4)s->sLast:J

    invoke-static {}, Lcom/android/internal/os/BackgroundThread;->getHandler()Landroid/os/Handler;

    move-result-object v1

    new-instance v2, %(K4)s

    invoke-direct {v2}, %(K4)s-><init>()V

    const-wide/32 v3, 0x36ee80

    invoke-virtual {v1, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :cond_done
    monitor-exit v0

    return-void

    :catchall_0
    move-exception v1

    monitor-exit v0

    throw v1
.end method


# virtual methods
.method public run()V
    .locals 6

    :try_start_0
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    sget-wide v2, %(K4)s->sLast:J

    sub-long v2, v0, v2

    const-wide/32 v4, 0x5265c00

    cmp-long v2, v2, v4

    if-ltz v2, :cond_wait

    sput-wide v0, %(K4)s->sLast:J

    const/4 v0, 0x0

    invoke-static {v0}, %(NM)s->setDailyQuota(Z)Z
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    goto :cond_wait

    :catch_0
    move-exception v0

    const-string v1, "NandswapManager"

    const-string v2, "K4: daily quota top-up failed"

    invoke-static {v1, v2, v0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_wait
    invoke-static {}, Lcom/android/internal/os/BackgroundThread;->getHandler()Landroid/os/Handler;

    move-result-object v0

    const-wide/32 v1, 0x36ee80

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method
""" % dict(K4=K4, NM=NM))
print("  - helper %s" % os.path.relpath(dst, root))
PYEOF

# Samsung LockSettingsService passes the Gatekeeper auth token (HAT) to vold's unlockCeStorage when
# ro.product.first_api_level <= 30 (legacy auth-bound CE keys). The A52s launched on R, but the One UI 9 vold (found on the Fold8 base) rejects
# tokens ("Vold doesn't use auth tokens, but non-empty token passed") -> EINVAL -> user 0 never unlocks after a
# reboot with a PIN ("Phone is starting..."). Take the token-less path regardless of first API level.
SMALI_PATCH "system" "system/framework/services.jar" \
    "smali_classes2/com/android/server/locksettings/LockSettingsService.smali" "replace" \
    'unlockCeStorage(ILcom/android/server/locksettings/SyntheticPasswordManager$SyntheticPassword;)V' \
    'const/16 v4, 0x1e' \
    'const/4 v4, 0x0'
