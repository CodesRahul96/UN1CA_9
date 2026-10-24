.class public final Lcom/k4/soundtrigger/K4StRetry;
.super Ljava/lang/Object;
.source "K4StRetry.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/k4/soundtrigger/K4StRetry$Hung;,
        Lcom/k4/soundtrigger/K4StRetry$SubCall;
    }
.end annotation


# static fields
.field private static final AUDIO_IDLE_DELAY_MS:J = 0x1388L

.field private static final AUDIO_ONLY_MAX_MS:J = 0x1b7740L

.field private static final AUDIO_STARTED:Ljava/lang/Runnable;

.field private static final AUDIO_STOPPED:Ljava/lang/Runnable;

.field private static final CALL_END_DELAY_MS:J = 0x7530L

.field private static final CALL_STATE_UNKNOWN:I = -0x1

.field private static final CHECK_HUNG:Ljava/lang/Runnable;

.field private static final CHECK_HUNG_MAX:Ljava/lang/Runnable;

.field private static final ENFORCER_TAG:Ljava/lang/String; = "SoundTriggerHalEnforcer"

.field private static final EXECUTOR:Ljava/util/concurrent/Executor;

.field private static final FIRE:Ljava/lang/Runnable;

.field private static final HUNG_IN_CALL_MAX_MS:J = 0xafc8L

.field private static final INTERNAL_ERROR:I = 0x5

.field private static final MODE_UNKNOWN:I = -0x64

.field private static final NORMAL_GRACE_MS:J = 0xbb8L

.field private static final OWED_CHECK:Ljava/lang/Runnable;

.field private static final OWED_CHECK_MS:J = 0xea60L

.field private static final POLL_MS:J = 0x1388L

.field private static final REGISTER_FAST_TRIES:I = 0x3c

.field private static final REGISTER_RETRY_FAST_MS:J = 0x3e8L

.field private static final REGISTER_RETRY_MS:J = 0x3a98L

.field private static final REGISTER_STATE:Ljava/lang/Runnable;

.field private static final RESOURCE_CONTENTION:I = 0x1

.field private static final RESYNC:Ljava/lang/Runnable;

.field private static final SCREEN_OFF:Ljava/lang/Runnable;

.field private static final SCREEN_OFF_DELAY_MS:J = 0x7d0L

.field private static final SIGNALS:Ljava/lang/Runnable;

.field private static final STATE_EXECUTOR:Ljava/util/concurrent/Executor;

.field private static final TAG:Ljava/lang/String; = "K4StRetry"

.field private static final UNKNOWN_FALLBACK_MS:J = 0xdbba0L

.field private static final WATCHDOG_MS:J = 0xbb8L

.field private static final WATCHDOG_TAG:Ljava/lang/String; = "SoundTriggerHalWatchdog"

.field private static volatile sAm:Landroid/media/AudioManager;

.field private static volatile sAudioActive:Z

.field private static sAudioOnlySince:J

.field private static sAudioSignalsFailed:Z

.field private static final sCallbacks:Ljava/util/IdentityHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/IdentityHashMap<",
            "Ljava/lang/Object;",
            "Lcom/android/server/soundtrigger_middleware/ISoundTriggerHal$GlobalCallback;",
            ">;"
        }
    .end annotation
.end field

.field private static sCbHandler:Landroid/os/Handler;

.field private static final sClosed:Ljava/util/WeakHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/WeakHashMap<",
            "Ljava/lang/Object;",
            "Ljava/lang/Boolean;",
            ">;"
        }
    .end annotation
.end field

.field private static sHandler:Landroid/os/Handler;

.field private static final sHung:Ljava/util/IdentityHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/IdentityHashMap<",
            "Ljava/lang/Object;",
            "Lcom/k4/soundtrigger/K4StRetry$Hung;",
            ">;"
        }
    .end annotation
.end field

.field private static final sLock:Ljava/lang/Object;

.field private static volatile sMode:I

.field private static volatile sModeWatched:Z

.field private static final sOwed:Ljava/util/IdentityHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/IdentityHashMap<",
            "Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;",
            "Ljava/lang/Boolean;",
            ">;"
        }
    .end annotation
.end field

.field private static sOwedSeenFree:Z

.field private static final sPending:Ljava/util/IdentityHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/IdentityHashMap<",
            "Ljava/lang/Object;",
            "Ljava/lang/Boolean;",
            ">;"
        }
    .end annotation
.end field

.field private static sPlaybackWatched:Z

.field private static sReason:Ljava/lang/String;

.field private static sRecordingWatched:Z

.field private static sScreenWatched:Z

.field private static volatile sSignalsUnknown:Z

.field private static volatile sSignalsUnknownSince:J

.field private static sStateHandler:Landroid/os/Handler;

.field private static sStateRegisterTries:I

.field private static final sSubCalls:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/Integer;",
            "Lcom/k4/soundtrigger/K4StRetry$SubCall;",
            ">;"
        }
    .end annotation
.end field

.field private static sSubs:Landroid/telephony/SubscriptionManager;

.field private static sTel:Landroid/telephony/TelephonyManager;

.field private static volatile sTelBusy:Z

.field private static sTelFailed:Z

.field private static sTelWatched:Z

.field private static sUnknownSince:J

.field private static volatile sVoicePlayback:Z

.field private static volatile sVoiceRecording:Z

.field private static sWakeLock:Landroid/os/PowerManager$WakeLock;

.field private static sWakeUntil:J


# direct methods
.method static bridge synthetic -$$Nest$sfgetFIRE()Ljava/lang/Runnable;
    .registers 1

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->FIRE:Ljava/lang/Runnable;

    return-object v0
.end method

.method static bridge synthetic -$$Nest$sfgetSCREEN_OFF()Ljava/lang/Runnable;
    .registers 1

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->SCREEN_OFF:Ljava/lang/Runnable;

    return-object v0
.end method

.method static bridge synthetic -$$Nest$sfgetsHandler()Landroid/os/Handler;
    .registers 1

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    return-object v0
.end method

.method static bridge synthetic -$$Nest$sfgetsReason()Ljava/lang/String;
    .registers 1

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sReason:Ljava/lang/String;

    return-object v0
.end method

.method static bridge synthetic -$$Nest$sfgetsStateHandler()Landroid/os/Handler;
    .registers 1

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sStateHandler:Landroid/os/Handler;

    return-object v0
.end method

.method static bridge synthetic -$$Nest$smacquire(J)V
    .registers 2

    invoke-static {p0, p1}, Lcom/k4/soundtrigger/K4StRetry;->acquire(J)V

    return-void
.end method

.method static bridge synthetic -$$Nest$smcheckHung()V
    .registers 0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->checkHung()V

    return-void
.end method

.method static bridge synthetic -$$Nest$smcheckHungMax()V
    .registers 0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->checkHungMax()V

    return-void
.end method

.method static bridge synthetic -$$Nest$smfire()V
    .registers 0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->fire()V

    return-void
.end method

.method static bridge synthetic -$$Nest$smonCallSignals()V
    .registers 0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->onCallSignals()V

    return-void
.end method

.method static bridge synthetic -$$Nest$smonMode(I)V
    .registers 1

    invoke-static {p0}, Lcom/k4/soundtrigger/K4StRetry;->onMode(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$smonPlayback(Ljava/util/List;)V
    .registers 1

    invoke-static {p0}, Lcom/k4/soundtrigger/K4StRetry;->onPlayback(Ljava/util/List;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$smonRecording(Ljava/util/List;)V
    .registers 1

    invoke-static {p0}, Lcom/k4/soundtrigger/K4StRetry;->onRecording(Ljava/util/List;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$smowedCheck()V
    .registers 0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->owedCheck()V

    return-void
.end method

.method static bridge synthetic -$$Nest$smregisterState()V
    .registers 0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->registerState()V

    return-void
.end method

.method static bridge synthetic -$$Nest$smresync()V
    .registers 0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->resync()V

    return-void
.end method

.method static bridge synthetic -$$Nest$smschedule(JLjava/lang/String;)V
    .registers 3

    invoke-static {p0, p1, p2}, Lcom/k4/soundtrigger/K4StRetry;->schedule(JLjava/lang/String;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$smsyncSubscriptions()V
    .registers 0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->syncSubscriptions()V

    return-void
.end method

.method static bridge synthetic -$$Nest$smupdateTelephony()V
    .registers 0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->updateTelephony()V

    return-void
.end method

.method static constructor <clinit>()V
    .registers 1

    .line 179
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    .line 181
    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sCallbacks:Ljava/util/IdentityHashMap;

    .line 183
    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sPending:Ljava/util/IdentityHashMap;

    .line 185
    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    .line 187
    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    .line 193
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sClosed:Ljava/util/WeakHashMap;

    .line 219
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sSubCalls:Ljava/util/HashMap;

    .line 221
    const/16 v0, -0x64

    sput v0, Lcom/k4/soundtrigger/K4StRetry;->sMode:I

    .line 249
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$1;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$1;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->FIRE:Ljava/lang/Runnable;

    .line 255
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$2;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$2;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->REGISTER_STATE:Ljava/lang/Runnable;

    .line 261
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$3;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$3;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->SIGNALS:Ljava/lang/Runnable;

    .line 267
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$4;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$4;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    .line 273
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$5;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$5;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->OWED_CHECK:Ljava/lang/Runnable;

    .line 281
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$6;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$6;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->CHECK_HUNG:Ljava/lang/Runnable;

    .line 287
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$7;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$7;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->EXECUTOR:Ljava/util/concurrent/Executor;

    .line 293
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$8;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$8;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->STATE_EXECUTOR:Ljava/util/concurrent/Executor;

    .line 528
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$9;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$9;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->CHECK_HUNG_MAX:Ljava/lang/Runnable;

    .line 995
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$17;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$17;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->AUDIO_STARTED:Ljava/lang/Runnable;

    .line 1001
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$18;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$18;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->AUDIO_STOPPED:Ljava/lang/Runnable;

    .line 1007
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$19;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$19;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->SCREEN_OFF:Ljava/lang/Runnable;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 300
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static acquire(J)V
    .registers 7

    .line 1042
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    sub-long v0, p0, v0

    .line 1043
    sget-wide v2, Lcom/k4/soundtrigger/K4StRetry;->sWakeUntil:J

    cmp-long v2, p0, v2

    if-lez v2, :cond_3e

    const-wide/16 v2, 0x0

    cmp-long v2, v0, v2

    if-gtz v2, :cond_13

    goto :goto_3e

    .line 1045
    :cond_13
    :try_start_13
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sWakeLock:Landroid/os/PowerManager$WakeLock;

    if-nez v2, :cond_34

    .line 1046
    invoke-static {}, Landroid/app/ActivityThread;->currentActivityThread()Landroid/app/ActivityThread;

    move-result-object v2

    invoke-virtual {v2}, Landroid/app/ActivityThread;->getSystemContext()Landroid/app/ContextImpl;

    move-result-object v2

    const-class v3, Landroid/os/PowerManager;

    .line 1047
    invoke-virtual {v2, v3}, Landroid/app/ContextImpl;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/os/PowerManager;

    .line 1048
    const-string v3, "K4StRetry"

    const/4 v4, 0x1

    invoke-virtual {v2, v4, v3}, Landroid/os/PowerManager;->newWakeLock(ILjava/lang/String;)Landroid/os/PowerManager$WakeLock;

    move-result-object v2

    .line 1049
    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/os/PowerManager$WakeLock;->setReferenceCounted(Z)V

    .line 1050
    sput-object v2, Lcom/k4/soundtrigger/K4StRetry;->sWakeLock:Landroid/os/PowerManager$WakeLock;

    .line 1052
    :cond_34
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sWakeLock:Landroid/os/PowerManager$WakeLock;

    invoke-virtual {v2, v0, v1}, Landroid/os/PowerManager$WakeLock;->acquire(J)V

    .line 1053
    sput-wide p0, Lcom/k4/soundtrigger/K4StRetry;->sWakeUntil:J
    :try_end_3b
    .catchall {:try_start_13 .. :try_end_3b} :catchall_3c

    .line 1056
    goto :goto_3d

    .line 1054
    :catchall_3c
    move-exception p0

    .line 1057
    :goto_3d
    return-void

    .line 1043
    :cond_3e
    :goto_3e
    return-void
.end method

.method private static callBySignals()Z
    .registers 6

    .line 468
    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sTelBusy:Z

    const/4 v1, 0x1

    if-nez v0, :cond_23

    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sVoicePlayback:Z

    if-nez v0, :cond_23

    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sVoiceRecording:Z

    if-eqz v0, :cond_e

    goto :goto_23

    .line 469
    :cond_e
    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sSignalsUnknown:Z

    if-eqz v0, :cond_21

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v2

    sget-wide v4, Lcom/k4/soundtrigger/K4StRetry;->sSignalsUnknownSince:J

    sub-long/2addr v2, v4

    const-wide/32 v4, 0xdbba0

    cmp-long v0, v2, v4

    if-gez v0, :cond_21

    goto :goto_22

    :cond_21
    const/4 v1, 0x0

    :goto_22
    return v1

    .line 468
    :cond_23
    :goto_23
    return v1
.end method

.method private static callState(I)Ljava/lang/String;
    .registers 7

    .line 483
    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sTelBusy:Z

    const-string v1, ""

    if-eqz v0, :cond_9

    const-string v0, ", telephony call"

    goto :goto_a

    :cond_9
    move-object v0, v1

    :goto_a
    sget-boolean v2, Lcom/k4/soundtrigger/K4StRetry;->sVoicePlayback:Z

    if-eqz v2, :cond_11

    const-string v2, ", voice/ring playback"

    goto :goto_12

    :cond_11
    move-object v2, v1

    .line 484
    :goto_12
    sget-boolean v3, Lcom/k4/soundtrigger/K4StRetry;->sVoiceRecording:Z

    if-eqz v3, :cond_19

    const-string v3, ", voice recording"

    goto :goto_1a

    :cond_19
    move-object v3, v1

    :goto_1a
    sget-boolean v4, Lcom/k4/soundtrigger/K4StRetry;->sSignalsUnknown:Z

    if-eqz v4, :cond_20

    const-string v1, ", call signals not known"

    :cond_20
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "mode "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 483
    return-object p0
.end method

.method public static callbackError(Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;)V
    .registers 2

    .line 376
    const-string v0, "HAL callback broke the sound trigger contract"

    invoke-static {p0, v0}, Lcom/k4/soundtrigger/K4StRetry;->owe(Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;Ljava/lang/String;)V

    .line 377
    return-void
.end method

.method private static checkHung()V
    .registers 10

    .line 489
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->currentMode()I

    move-result v0

    .line 490
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 491
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 492
    const/4 v3, 0x1

    const/16 v4, -0x64

    if-eq v0, v4, :cond_1c

    invoke-static {v0}, Lcom/k4/soundtrigger/K4StRetry;->noCall(I)Z

    move-result v5

    if-eqz v5, :cond_1a

    goto :goto_1c

    :cond_1a
    const/4 v5, 0x0

    goto :goto_1d

    :cond_1c
    :goto_1c
    move v5, v3

    .line 493
    :goto_1d
    sget-object v6, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v6

    .line 494
    if-eqz v5, :cond_31

    .line 495
    :try_start_22
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v3}, Ljava/util/IdentityHashMap;->values()Ljava/util/Collection;

    move-result-object v3

    invoke-interface {v1, v3}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 496
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v3}, Ljava/util/IdentityHashMap;->clear()V

    goto :goto_62

    .line 498
    :cond_31
    sget-object v5, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v5}, Ljava/util/IdentityHashMap;->values()Ljava/util/Collection;

    move-result-object v5

    invoke-interface {v5}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v5

    :goto_3b
    invoke-interface {v5}, Ljava/util/Iterator;->hasNext()Z

    move-result v7

    if-eqz v7, :cond_62

    invoke-interface {v5}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Lcom/k4/soundtrigger/K4StRetry$Hung;

    .line 499
    iget-boolean v8, v7, Lcom/k4/soundtrigger/K4StRetry$Hung;->deferred:Z

    if-nez v8, :cond_61

    .line 500
    iput-boolean v3, v7, Lcom/k4/soundtrigger/K4StRetry$Hung;->deferred:Z

    .line 501
    if-eqz v0, :cond_51

    if-ne v0, v4, :cond_57

    :cond_51
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->signalWillReport()Z

    move-result v8

    if-eqz v8, :cond_5a

    .line 502
    :cond_57
    const-string v8, "during a call"

    goto :goto_5c

    :cond_5a
    const-string v8, "while the call state was unknown"

    :goto_5c
    iput-object v8, v7, Lcom/k4/soundtrigger/K4StRetry$Hung;->when:Ljava/lang/String;

    .line 503
    invoke-interface {v2, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 505
    :cond_61
    goto :goto_3b

    .line 507
    :cond_62
    :goto_62
    monitor-exit v6
    :try_end_63
    .catchall {:try_start_22 .. :try_end_63} :catchall_11a

    .line 508
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_67
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_a4

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/k4/soundtrigger/K4StRetry$Hung;

    .line 509
    const-string v5, "K4StRetry"

    iget-object v6, v4, Lcom/k4/soundtrigger/K4StRetry$Hung;->when:Ljava/lang/String;

    .line 510
    invoke-static {v0}, Lcom/k4/soundtrigger/K4StRetry;->callState(I)Ljava/lang/String;

    move-result-object v7

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "sound trigger HAL call still running after 3000 ms "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v8, " ("

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, "): NOT rebooting the audio HAL (shared with call audio); rebooting it 30 s after the call if the call into the HAL is still hung, or at once if it is still hung 48 s after it started (dead HAL)"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    iget-object v4, v4, Lcom/k4/soundtrigger/K4StRetry$Hung;->where:Ljava/lang/Exception;

    .line 509
    invoke-static {v5, v6, v4}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 513
    goto :goto_67

    .line 514
    :cond_a4
    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_f1

    .line 515
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->CHECK_HUNG_MAX:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->hasCallbacks(Ljava/lang/Runnable;)Z

    move-result v0

    if-nez v0, :cond_be

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->CHECK_HUNG_MAX:Ljava/lang/Runnable;

    const-wide/32 v3, 0xafc8

    invoke-virtual {v0, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 516
    :cond_be
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->OWED_CHECK:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->hasCallbacks(Ljava/lang/Runnable;)Z

    move-result v0

    if-nez v0, :cond_d2

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->OWED_CHECK:Ljava/lang/Runnable;

    const-wide/32 v3, 0xea60

    invoke-virtual {v0, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 518
    :cond_d2
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->listenerSaysCall()Z

    move-result v0

    if-nez v0, :cond_f1

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->signalWillReport()Z

    move-result v0

    if-nez v0, :cond_f1

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->hasCallbacks(Ljava/lang/Runnable;)Z

    move-result v0

    if-nez v0, :cond_f1

    .line 519
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    const-wide/16 v3, 0x1388

    invoke-virtual {v0, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 522
    :cond_f1
    invoke-interface {v1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_119

    .line 523
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_fb
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_111

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/k4/soundtrigger/K4StRetry$Hung;

    const-string v3, "SoundTriggerHalWatchdog"

    const-string v4, "HAL deadline expired. Rebooting."

    iget-object v2, v2, Lcom/k4/soundtrigger/K4StRetry$Hung;->where:Ljava/lang/Exception;

    invoke-static {v3, v4, v2}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_fb

    .line 524
    :cond_111
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    invoke-static {v0, v1}, Lcom/k4/soundtrigger/K4StRetry;->rebootAll(Ljava/util/List;Ljava/util/List;)V

    .line 526
    :cond_119
    return-void

    .line 507
    :catchall_11a
    move-exception v0

    :try_start_11b
    monitor-exit v6
    :try_end_11c
    .catchall {:try_start_11b .. :try_end_11c} :catchall_11a

    throw v0
.end method

.method private static checkHungMax()V
    .registers 15

    .line 537
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 538
    nop

    .line 539
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 540
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v3

    .line 541
    :try_start_d
    sget-object v4, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v4}, Ljava/util/IdentityHashMap;->values()Ljava/util/Collection;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v4

    const-wide v5, 0x7fffffffffffffffL

    move-wide v7, v5

    :goto_1d
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v9

    if-eqz v9, :cond_41

    .line 542
    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Lcom/k4/soundtrigger/K4StRetry$Hung;

    .line 543
    iget-wide v10, v9, Lcom/k4/soundtrigger/K4StRetry$Hung;->since:J

    sub-long v10, v0, v10

    .line 544
    const-wide/32 v12, 0xafc8

    cmp-long v14, v10, v12

    if-ltz v14, :cond_3b

    .line 545
    invoke-interface {v2, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 546
    invoke-interface {v4}, Ljava/util/Iterator;->remove()V

    goto :goto_40

    .line 548
    :cond_3b
    sub-long/2addr v12, v10

    invoke-static {v7, v8, v12, v13}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v7

    .line 550
    :goto_40
    goto :goto_1d

    .line 551
    :cond_41
    monitor-exit v3
    :try_end_42
    .catchall {:try_start_d .. :try_end_42} :catchall_84

    .line 552
    cmp-long v0, v7, v5

    if-eqz v0, :cond_4d

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->CHECK_HUNG_MAX:Ljava/lang/Runnable;

    invoke-virtual {v0, v1, v7, v8}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 553
    :cond_4d
    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_54

    return-void

    .line 554
    :cond_54
    const-string v0, "K4StRetry"

    .line 555
    const/4 v1, 0x0

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/k4/soundtrigger/K4StRetry$Hung;

    iget-object v1, v1, Lcom/k4/soundtrigger/K4StRetry$Hung;->when:Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "sound trigger HAL call hung for 48 s "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, ": treating the HAL as dead, rebooting it now before blocked system_server threads trip the system_server watchdog (this restarts the audio HAL)"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 554
    invoke-static {v0, v1}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 557
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    invoke-static {v0, v2}, Lcom/k4/soundtrigger/K4StRetry;->rebootAll(Ljava/util/List;Ljava/util/List;)V

    .line 558
    return-void

    .line 551
    :catchall_84
    move-exception v0

    :try_start_85
    monitor-exit v3
    :try_end_86
    .catchall {:try_start_85 .. :try_end_86} :catchall_84

    throw v0
.end method

.method private static currentMode()I
    .registers 2

    .line 455
    sget v0, Lcom/k4/soundtrigger/K4StRetry;->sMode:I

    .line 456
    if-eqz v0, :cond_9

    const/16 v1, -0x64

    if-eq v0, v1, :cond_9

    return v0

    .line 457
    :cond_9
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sAm:Landroid/media/AudioManager;

    .line 458
    if-nez v1, :cond_e

    return v0

    .line 460
    :cond_e
    :try_start_e
    invoke-virtual {v1}, Landroid/media/AudioManager;->getMode()I

    move-result v0
    :try_end_12
    .catchall {:try_start_e .. :try_end_12} :catchall_13

    return v0

    .line 461
    :catchall_13
    move-exception v1

    .line 462
    return v0
.end method

.method public static detached(Ljava/lang/Object;)V
    .registers 6

    .line 329
    nop

    .line 330
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 331
    :try_start_4
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sCallbacks:Ljava/util/IdentityHashMap;

    invoke-virtual {v1, p0}, Ljava/util/IdentityHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 332
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sPending:Ljava/util/IdentityHashMap;

    invoke-virtual {v1, p0}, Ljava/util/IdentityHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 333
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    invoke-virtual {v1, p0}, Ljava/util/IdentityHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    const/4 v2, 0x0

    if-eqz v1, :cond_19

    const/4 v1, 0x1

    goto :goto_1a

    :cond_19
    move v1, v2

    .line 334
    :goto_1a
    instance-of v3, p0, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;

    if-eqz v3, :cond_42

    .line 335
    check-cast p0, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;

    iget-object p0, p0, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;->mUnderlying:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    .line 336
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v3}, Ljava/util/IdentityHashMap;->values()Ljava/util/Collection;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_2c
    :goto_2c
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_42

    .line 337
    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/k4/soundtrigger/K4StRetry$Hung;

    iget-object v4, v4, Lcom/k4/soundtrigger/K4StRetry$Hung;->hal:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    if-ne v4, p0, :cond_2c

    .line 338
    invoke-interface {v3}, Ljava/util/Iterator;->remove()V

    .line 339
    add-int/lit8 v2, v2, 0x1

    goto :goto_2c

    .line 343
    :cond_42
    monitor-exit v0
    :try_end_43
    .catchall {:try_start_4 .. :try_end_43} :catchall_4f

    .line 344
    if-nez v1, :cond_47

    if-lez v2, :cond_4e

    :cond_47
    const-string p0, "K4StRetry"

    const-string v0, "HAL died: the deferred sound trigger HAL reboot is no longer needed"

    invoke-static {p0, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 345
    :cond_4e
    return-void

    .line 343
    :catchall_4f
    move-exception p0

    :try_start_50
    monitor-exit v0
    :try_end_51
    .catchall {:try_start_50 .. :try_end_51} :catchall_4f

    throw p0
.end method

.method private static ensureHandlerLocked()V
    .registers 2

    .line 304
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    if-nez v0, :cond_4a

    .line 305
    new-instance v0, Landroid/os/HandlerThread;

    const-string v1, "K4StRetry"

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    .line 306
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 307
    new-instance v1, Landroid/os/Handler;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-direct {v1, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v1, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    .line 308
    new-instance v0, Landroid/os/HandlerThread;

    const-string v1, "K4StRetryCb"

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    .line 309
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 310
    new-instance v1, Landroid/os/Handler;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-direct {v1, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v1, Lcom/k4/soundtrigger/K4StRetry;->sCbHandler:Landroid/os/Handler;

    .line 311
    new-instance v0, Landroid/os/HandlerThread;

    const-string v1, "K4StRetryState"

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    .line 312
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 313
    new-instance v1, Landroid/os/Handler;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-direct {v1, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v1, Lcom/k4/soundtrigger/K4StRetry;->sStateHandler:Landroid/os/Handler;

    .line 314
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sStateHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->REGISTER_STATE:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 316
    :cond_4a
    return-void
.end method

.method private static fire()V
    .registers 5

    .line 1062
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 1063
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v1

    .line 1064
    :try_start_8
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sPending:Ljava/util/IdentityHashMap;

    invoke-virtual {v2}, Ljava/util/IdentityHashMap;->keySet()Ljava/util/Set;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_12
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_2a

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    .line 1065
    sget-object v4, Lcom/k4/soundtrigger/K4StRetry;->sCallbacks:Ljava/util/IdentityHashMap;

    invoke-virtual {v4, v3}, Ljava/util/IdentityHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/server/soundtrigger_middleware/ISoundTriggerHal$GlobalCallback;

    .line 1066
    if-eqz v3, :cond_29

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 1067
    :cond_29
    goto :goto_12

    .line 1068
    :cond_2a
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sPending:Ljava/util/IdentityHashMap;

    invoke-virtual {v2}, Ljava/util/IdentityHashMap;->clear()V

    .line 1069
    monitor-exit v1
    :try_end_30
    .catchall {:try_start_8 .. :try_end_30} :catchall_44

    .line 1070
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_37

    return-void

    .line 1071
    :cond_37
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sReason:Ljava/lang/String;

    .line 1072
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sCbHandler:Landroid/os/Handler;

    new-instance v3, Lcom/k4/soundtrigger/K4StRetry$21;

    invoke-direct {v3, v0, v1}, Lcom/k4/soundtrigger/K4StRetry$21;-><init>(Ljava/util/List;Ljava/lang/String;)V

    invoke-virtual {v2, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 1085
    return-void

    .line 1069
    :catchall_44
    move-exception v0

    :try_start_45
    monitor-exit v1
    :try_end_46
    .catchall {:try_start_45 .. :try_end_46} :catchall_44

    throw v0
.end method

.method public static halError(Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;Ljava/lang/RuntimeException;)Ljava/lang/RuntimeException;
    .registers 3

    .line 369
    invoke-virtual {p1}, Ljava/lang/RuntimeException;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/k4/soundtrigger/K4StRetry;->owe(Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;Ljava/lang/String;)V

    .line 370
    instance-of p0, p1, Lcom/android/server/soundtrigger_middleware/HalException;

    if-eqz p0, :cond_16

    new-instance p0, Lcom/android/server/soundtrigger_middleware/RecoverableException;

    const/4 v0, 0x5

    invoke-virtual {p1}, Ljava/lang/RuntimeException;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, v0, p1}, Lcom/android/server/soundtrigger_middleware/RecoverableException;-><init>(ILjava/lang/String;)V

    return-object p0

    .line 371
    :cond_16
    return-object p1
.end method

.method private static hold(J)V
    .registers 4

    .line 1031
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    add-long/2addr v0, p0

    .line 1032
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sStateHandler:Landroid/os/Handler;

    new-instance p1, Lcom/k4/soundtrigger/K4StRetry$20;

    invoke-direct {p1, v0, v1}, Lcom/k4/soundtrigger/K4StRetry$20;-><init>(J)V

    invoke-virtual {p0, p1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 1038
    return-void
.end method

.method private static listenerSaysCall()Z
    .registers 2

    .line 819
    sget v0, Lcom/k4/soundtrigger/K4StRetry;->sMode:I

    .line 820
    if-eqz v0, :cond_a

    const/16 v1, -0x64

    if-eq v0, v1, :cond_a

    const/4 v0, 0x1

    goto :goto_b

    :cond_a
    const/4 v0, 0x0

    :goto_b
    return v0
.end method

.method private static noCall(I)Z
    .registers 1

    .line 479
    if-nez p0, :cond_a

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->callBySignals()Z

    move-result p0

    if-nez p0, :cond_a

    const/4 p0, 0x1

    goto :goto_b

    :cond_a
    const/4 p0, 0x0

    :goto_b
    return p0
.end method

.method private static onCallSignals()V
    .registers 4

    .line 842
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 843
    :try_start_3
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    invoke-virtual {v1}, Ljava/util/IdentityHashMap;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_16

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v1}, Ljava/util/IdentityHashMap;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_14

    goto :goto_16

    :cond_14
    const/4 v1, 0x0

    goto :goto_17

    :cond_16
    :goto_16
    const/4 v1, 0x1

    .line 844
    :goto_17
    monitor-exit v0
    :try_end_18
    .catchall {:try_start_3 .. :try_end_18} :catchall_5c

    .line 845
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->listenerSaysCall()Z

    move-result v0

    if-nez v0, :cond_3d

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->callBySignals()Z

    move-result v0

    if-eqz v0, :cond_25

    goto :goto_3d

    .line 850
    :cond_25
    if-eqz v1, :cond_5b

    .line 851
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 852
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    const-wide/16 v2, 0x7530

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 853
    const-wide/16 v0, 0x7918

    invoke-static {v0, v1}, Lcom/k4/soundtrigger/K4StRetry;->hold(J)V

    goto :goto_5b

    .line 846
    :cond_3d
    :goto_3d
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 847
    if-eqz v1, :cond_5b

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->signalWillReport()Z

    move-result v0

    if-nez v0, :cond_5b

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->listenerSaysCall()Z

    move-result v0

    if-nez v0, :cond_5b

    .line 848
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    const-wide/16 v2, 0x1388

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 855
    :cond_5b
    :goto_5b
    return-void

    .line 844
    :catchall_5c
    move-exception v1

    :try_start_5d
    monitor-exit v0
    :try_end_5e
    .catchall {:try_start_5d .. :try_end_5e} :catchall_5c

    throw v1
.end method

.method private static onMode(I)V
    .registers 4

    .line 826
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 827
    :try_start_3
    sput p0, Lcom/k4/soundtrigger/K4StRetry;->sMode:I

    .line 828
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    invoke-virtual {v1}, Ljava/util/IdentityHashMap;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_18

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v1}, Ljava/util/IdentityHashMap;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_16

    goto :goto_18

    :cond_16
    const/4 v1, 0x0

    goto :goto_19

    :cond_18
    :goto_18
    const/4 v1, 0x1

    .line 829
    :goto_19
    monitor-exit v0
    :try_end_1a
    .catchall {:try_start_3 .. :try_end_1a} :catchall_43

    .line 830
    if-nez p0, :cond_3b

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->signalWillReport()Z

    move-result p0

    if-eqz p0, :cond_23

    goto :goto_3b

    .line 832
    :cond_23
    if-eqz v1, :cond_42

    .line 833
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 834
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    const-wide/16 v1, 0x7530

    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 835
    const-wide/16 v0, 0x7918

    invoke-static {v0, v1}, Lcom/k4/soundtrigger/K4StRetry;->hold(J)V

    goto :goto_42

    .line 831
    :cond_3b
    :goto_3b
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 837
    :cond_42
    :goto_42
    return-void

    .line 829
    :catchall_43
    move-exception p0

    :try_start_44
    monitor-exit v0
    :try_end_45
    .catchall {:try_start_44 .. :try_end_45} :catchall_43

    throw p0
.end method

.method private static onPlayback(Ljava/util/List;)V
    .registers 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/media/AudioPlaybackConfiguration;",
            ">;)V"
        }
    .end annotation

    .line 752
    nop

    .line 753
    nop

    .line 754
    const/4 v0, 0x1

    const/4 v1, 0x0

    if-eqz p0, :cond_3b

    .line 755
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    move v2, v1

    :cond_b
    :goto_b
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_38

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/media/AudioPlaybackConfiguration;

    .line 756
    if-eqz v3, :cond_b

    invoke-virtual {v3}, Landroid/media/AudioPlaybackConfiguration;->isActive()Z

    move-result v4

    if-nez v4, :cond_20

    goto :goto_b

    .line 757
    :cond_20
    nop

    .line 760
    :try_start_21
    invoke-virtual {v3}, Landroid/media/AudioPlaybackConfiguration;->getAudioAttributes()Landroid/media/AudioAttributes;

    move-result-object v1

    invoke-virtual {v1}, Landroid/media/AudioAttributes;->getUsage()I

    move-result v1
    :try_end_29
    .catchall {:try_start_21 .. :try_end_29} :catchall_2a

    .line 763
    goto :goto_2c

    .line 761
    :catchall_2a
    move-exception v1

    .line 762
    const/4 v1, -0x1

    .line 764
    :goto_2c
    const/4 v3, 0x2

    if-eq v1, v3, :cond_35

    const/4 v3, 0x3

    if-eq v1, v3, :cond_35

    const/4 v3, 0x6

    if-ne v1, v3, :cond_36

    .line 767
    :cond_35
    move v2, v0

    .line 769
    :cond_36
    move v1, v0

    goto :goto_b

    .line 755
    :cond_38
    move p0, v1

    move v1, v2

    goto :goto_3c

    .line 754
    :cond_3b
    move p0, v1

    .line 771
    :goto_3c
    invoke-static {v0, v1}, Lcom/k4/soundtrigger/K4StRetry;->setSignal(IZ)V

    .line 772
    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sAudioActive:Z

    if-eq p0, v0, :cond_51

    .line 773
    sput-boolean p0, Lcom/k4/soundtrigger/K4StRetry;->sAudioActive:Z

    .line 774
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    if-eqz p0, :cond_4c

    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->AUDIO_STARTED:Ljava/lang/Runnable;

    goto :goto_4e

    :cond_4c
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->AUDIO_STOPPED:Ljava/lang/Runnable;

    :goto_4e
    invoke-virtual {v0, p0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 776
    :cond_51
    return-void
.end method

.method private static onRecording(Ljava/util/List;)V
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/media/AudioRecordingConfiguration;",
            ">;)V"
        }
    .end annotation

    .line 780
    nop

    .line 781
    const/4 v0, 0x2

    const/4 v1, 0x0

    if-eqz p0, :cond_2f

    .line 782
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_9
    :goto_9
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2f

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/media/AudioRecordingConfiguration;

    .line 783
    if-eqz v2, :cond_9

    invoke-virtual {v2}, Landroid/media/AudioRecordingConfiguration;->isClientSilenced()Z

    move-result v3

    if-eqz v3, :cond_1e

    goto :goto_9

    .line 784
    :cond_1e
    invoke-virtual {v2}, Landroid/media/AudioRecordingConfiguration;->getClientAudioSource()I

    move-result v2

    .line 785
    const/4 v3, 0x7

    if-eq v2, v3, :cond_2d

    const/4 v3, 0x4

    if-eq v2, v3, :cond_2d

    if-eq v2, v0, :cond_2d

    const/4 v3, 0x3

    if-ne v2, v3, :cond_2e

    .line 788
    :cond_2d
    const/4 v1, 0x1

    .line 790
    :cond_2e
    goto :goto_9

    .line 792
    :cond_2f
    invoke-static {v0, v1}, Lcom/k4/soundtrigger/K4StRetry;->setSignal(IZ)V

    .line 793
    return-void
.end method

.method private static owe(Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;Ljava/lang/String;)V
    .registers 8

    .line 382
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->callBySignals()Z

    move-result v0

    .line 383
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v1

    .line 384
    :try_start_7
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->ensureHandlerLocked()V

    .line 385
    sget v2, Lcom/k4/soundtrigger/K4StRetry;->sMode:I

    .line 386
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    sget-object v4, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v3, p0, v4}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 387
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->OWED_CHECK:Ljava/lang/Runnable;

    invoke-virtual {p0, v3}, Landroid/os/Handler;->hasCallbacks(Ljava/lang/Runnable;)Z

    move-result p0

    if-nez p0, :cond_27

    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->OWED_CHECK:Ljava/lang/Runnable;

    const-wide/32 v4, 0xea60

    invoke-virtual {p0, v3, v4, v5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 388
    :cond_27
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->listenerSaysCall()Z

    move-result p0

    if-nez p0, :cond_4b

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->signalWillReport()Z

    move-result p0

    if-nez p0, :cond_4b

    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {p0, v3}, Landroid/os/Handler;->hasCallbacks(Ljava/lang/Runnable;)Z

    move-result p0

    if-nez p0, :cond_4b

    .line 389
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    const-wide/16 v4, 0xbb8

    invoke-virtual {p0, v3, v4, v5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 390
    const-wide/16 v3, 0xfa0

    invoke-static {v3, v4}, Lcom/k4/soundtrigger/K4StRetry;->hold(J)V

    .line 392
    :cond_4b
    monitor-exit v1
    :try_end_4c
    .catchall {:try_start_7 .. :try_end_4c} :catchall_90

    .line 393
    if-nez v2, :cond_69

    if-nez v0, :cond_69

    .line 394
    const-string p0, "SoundTriggerHalEnforcer"

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "Exception caught from HAL, rebooting HAL in 3000 ms unless a call starts: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_8f

    .line 397
    :cond_69
    const-string p0, "K4StRetry"

    invoke-static {v2}, Lcom/k4/soundtrigger/K4StRetry;->callState(I)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "HAL error during a call or before the call state is known ("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "), not rebooting the HAL (shared with call audio); resync reboot once there is no call: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 400
    :goto_8f
    return-void

    .line 392
    :catchall_90
    move-exception p0

    :try_start_91
    monitor-exit v1
    :try_end_92
    .catchall {:try_start_91 .. :try_end_92} :catchall_90

    throw p0
.end method

.method private static owedCheck()V
    .registers 10

    .line 898
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 899
    :try_start_3
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    invoke-virtual {v1}, Ljava/util/IdentityHashMap;->isEmpty()Z

    move-result v1

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v1, :cond_18

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v1}, Ljava/util/IdentityHashMap;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_16

    goto :goto_18

    :cond_16
    move v1, v3

    goto :goto_19

    :cond_18
    :goto_18
    move v1, v2

    .line 900
    :goto_19
    monitor-exit v0
    :try_end_1a
    .catchall {:try_start_3 .. :try_end_1a} :catchall_113

    .line 901
    if-nez v1, :cond_1f

    .line 902
    sput-boolean v3, Lcom/k4/soundtrigger/K4StRetry;->sOwedSeenFree:Z

    .line 903
    return-void

    .line 905
    :cond_1f
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->OWED_CHECK:Ljava/lang/Runnable;

    const-wide/32 v4, 0xea60

    invoke-virtual {v0, v1, v4, v5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 906
    nop

    .line 907
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sAm:Landroid/media/AudioManager;

    .line 908
    const/16 v1, -0x64

    if-eqz v0, :cond_37

    .line 910
    :try_start_30
    invoke-virtual {v0}, Landroid/media/AudioManager;->getMode()I

    move-result v1
    :try_end_34
    .catchall {:try_start_30 .. :try_end_34} :catchall_35

    .line 913
    goto :goto_37

    .line 911
    :catchall_35
    move-exception v0

    .line 912
    nop

    .line 916
    :cond_37
    :goto_37
    if-nez v1, :cond_4b

    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sTelBusy:Z

    if-nez v0, :cond_4b

    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sSignalsUnknown:Z

    if-nez v0, :cond_4b

    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sVoicePlayback:Z

    if-eqz v0, :cond_4b

    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sVoiceRecording:Z

    if-nez v0, :cond_4b

    move v0, v2

    goto :goto_4c

    :cond_4b
    move v0, v3

    .line 918
    :goto_4c
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v4

    .line 919
    const-wide/16 v6, 0x0

    if-nez v0, :cond_57

    .line 920
    sput-wide v6, Lcom/k4/soundtrigger/K4StRetry;->sAudioOnlySince:J

    goto :goto_5f

    .line 921
    :cond_57
    sget-wide v8, Lcom/k4/soundtrigger/K4StRetry;->sAudioOnlySince:J

    cmp-long v8, v8, v6

    if-nez v8, :cond_5f

    .line 922
    sput-wide v4, Lcom/k4/soundtrigger/K4StRetry;->sAudioOnlySince:J

    .line 924
    :cond_5f
    :goto_5f
    if-eqz v0, :cond_6d

    sget-wide v8, Lcom/k4/soundtrigger/K4StRetry;->sAudioOnlySince:J

    sub-long/2addr v4, v8

    const-wide/32 v8, 0x1b7740

    cmp-long v0, v4, v8

    if-ltz v0, :cond_6d

    move v0, v2

    goto :goto_6e

    :cond_6d
    move v0, v3

    .line 925
    :goto_6e
    if-nez v0, :cond_94

    .line 926
    if-nez v1, :cond_91

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->callBySignals()Z

    move-result v0

    if-eqz v0, :cond_79

    goto :goto_91

    .line 930
    :cond_79
    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sOwedSeenFree:Z

    if-nez v0, :cond_80

    .line 931
    sput-boolean v2, Lcom/k4/soundtrigger/K4StRetry;->sOwedSeenFree:Z

    .line 932
    return-void

    .line 934
    :cond_80
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->listenerSaysCall()Z

    move-result v0

    if-nez v0, :cond_9d

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->hasCallbacks(Ljava/lang/Runnable;)Z

    move-result v0

    if-eqz v0, :cond_9d

    return-void

    .line 927
    :cond_91
    :goto_91
    sput-boolean v3, Lcom/k4/soundtrigger/K4StRetry;->sOwedSeenFree:Z

    .line 928
    return-void

    .line 936
    :cond_94
    const-string v0, "K4StRetry"

    const-string v1, "only a voice playback, no voice recording, for 30 min with AudioService NORMAL and every SIM idle: not a call, running the owed reboots"

    invoke-static {v0, v1}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 938
    sput-wide v6, Lcom/k4/soundtrigger/K4StRetry;->sAudioOnlySince:J

    .line 940
    :cond_9d
    sput-boolean v3, Lcom/k4/soundtrigger/K4StRetry;->sOwedSeenFree:Z

    .line 943
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v1

    .line 944
    :try_start_a2
    new-instance v0, Ljava/util/ArrayList;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    invoke-virtual {v2}, Ljava/util/IdentityHashMap;->keySet()Ljava/util/Set;

    move-result-object v2

    invoke-direct {v0, v2}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 945
    new-instance v2, Ljava/util/ArrayList;

    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v3}, Ljava/util/IdentityHashMap;->values()Ljava/util/Collection;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 946
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    invoke-virtual {v3}, Ljava/util/IdentityHashMap;->clear()V

    .line 947
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v3}, Ljava/util/IdentityHashMap;->clear()V

    .line 948
    monitor-exit v1
    :try_end_c3
    .catchall {:try_start_a2 .. :try_end_c3} :catchall_110

    .line 949
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_d0

    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_d0

    return-void

    .line 950
    :cond_d0
    const-string v1, "K4StRetry"

    sget v3, Lcom/k4/soundtrigger/K4StRetry;->sMode:I

    .line 951
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v4

    .line 952
    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v5

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "owed for a while: the audio mode listener says mode "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v6, ", AudioService has said NORMAL with no call signal for 60 s: rebooting the sound trigger HAL now ("

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " HAL error(s), "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " hung HAL call(s))"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 950
    invoke-static {v1, v3}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 953
    invoke-static {v0, v2}, Lcom/k4/soundtrigger/K4StRetry;->rebootAll(Ljava/util/List;Ljava/util/List;)V

    .line 954
    return-void

    .line 948
    :catchall_110
    move-exception v0

    :try_start_111
    monitor-exit v1
    :try_end_112
    .catchall {:try_start_111 .. :try_end_112} :catchall_110

    throw v0

    .line 900
    :catchall_113
    move-exception v1

    :try_start_114
    monitor-exit v0
    :try_end_115
    .catchall {:try_start_114 .. :try_end_115} :catchall_113

    throw v1
.end method

.method private static rebootAll(Ljava/util/List;Ljava/util/List;)V
    .registers 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;",
            ">;",
            "Ljava/util/List<",
            "Lcom/k4/soundtrigger/K4StRetry$Hung;",
            ">;)V"
        }
    .end annotation

    .line 962
    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    .line 963
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_9
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_21

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;

    .line 964
    iget-object v3, v2, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;->mUnderlying:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    if-eqz v3, :cond_20

    iget-object v2, v2, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;->mUnderlying:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    sget-object v3, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v0, v2, v3}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 965
    :cond_20
    goto :goto_9

    .line 966
    :cond_21
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_25
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_39

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/k4/soundtrigger/K4StRetry$Hung;

    iget-object v2, v2, Lcom/k4/soundtrigger/K4StRetry$Hung;->hal:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    sget-object v3, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v0, v2, v3}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_25

    .line 967
    :cond_39
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v1

    .line 968
    :try_start_3c
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    invoke-virtual {v2}, Ljava/util/IdentityHashMap;->keySet()Ljava/util/Set;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_46
    :goto_46
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_5e

    .line 969
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;

    iget-object v3, v3, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;->mUnderlying:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    invoke-virtual {v0, v3}, Ljava/util/IdentityHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_46

    invoke-interface {v2}, Ljava/util/Iterator;->remove()V

    goto :goto_46

    .line 971
    :cond_5e
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v2}, Ljava/util/IdentityHashMap;->values()Ljava/util/Collection;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_68
    :goto_68
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_80

    .line 972
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/k4/soundtrigger/K4StRetry$Hung;

    iget-object v3, v3, Lcom/k4/soundtrigger/K4StRetry$Hung;->hal:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    invoke-virtual {v0, v3}, Ljava/util/IdentityHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_68

    invoke-interface {v2}, Ljava/util/Iterator;->remove()V

    goto :goto_68

    .line 974
    :cond_80
    monitor-exit v1
    :try_end_81
    .catchall {:try_start_3c .. :try_end_81} :catchall_db

    .line 975
    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    .line 976
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_8a
    :goto_8a
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_b0

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;

    .line 977
    iget-object v2, v1, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;->mUnderlying:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    .line 978
    if-eqz v2, :cond_8a

    sget-object v3, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v0, v2, v3}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_a3

    goto :goto_8a

    .line 980
    :cond_a3
    :try_start_a3
    invoke-virtual {v1}, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;->reboot()V
    :try_end_a6
    .catchall {:try_start_a3 .. :try_end_a6} :catchall_a7

    .line 983
    goto :goto_af

    .line 981
    :catchall_a7
    move-exception v1

    .line 982
    const-string v2, "K4StRetry"

    const-string v3, "deferred HAL reboot failed"

    invoke-static {v2, v3, v1}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 984
    :goto_af
    goto :goto_8a

    .line 985
    :cond_b0
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_b4
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result p1

    if-eqz p1, :cond_da

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/k4/soundtrigger/K4StRetry$Hung;

    .line 986
    iget-object v1, p1, Lcom/k4/soundtrigger/K4StRetry$Hung;->hal:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    sget-object v2, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v0, v1, v2}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    if-eqz v1, :cond_cb

    goto :goto_b4

    .line 988
    :cond_cb
    :try_start_cb
    iget-object p1, p1, Lcom/k4/soundtrigger/K4StRetry$Hung;->hal:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    invoke-virtual {p1}, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;->reboot()V
    :try_end_d0
    .catchall {:try_start_cb .. :try_end_d0} :catchall_d1

    .line 991
    goto :goto_d9

    .line 989
    :catchall_d1
    move-exception p1

    .line 990
    const-string v1, "K4StRetry"

    const-string v2, "HAL reboot failed"

    invoke-static {v1, v2, p1}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 992
    :goto_d9
    goto :goto_b4

    .line 993
    :cond_da
    return-void

    .line 974
    :catchall_db
    move-exception p0

    :try_start_dc
    monitor-exit v1
    :try_end_dd
    .catchall {:try_start_dc .. :try_end_dd} :catchall_db

    throw p0
.end method

.method public static refused(Ljava/lang/Object;Lcom/android/server/soundtrigger_middleware/HalException;)Ljava/lang/RuntimeException;
    .registers 5

    .line 349
    invoke-virtual {p1}, Lcom/android/server/soundtrigger_middleware/HalException;->toString()Ljava/lang/String;

    move-result-object v0

    .line 350
    iget p1, p1, Lcom/android/server/soundtrigger_middleware/HalException;->errorCode:I

    .line 351
    const/16 v1, -0x13

    if-eq p1, v1, :cond_35

    const/16 v1, -0x10

    if-eq p1, v1, :cond_35

    const/16 v1, -0xc

    if-eq p1, v1, :cond_35

    const/16 v1, -0xb

    if-eq p1, v1, :cond_35

    .line 352
    const-string p0, "K4StRetry"

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "HAL refused the model, not rebooting the HAL: "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 353
    new-instance p0, Lcom/android/server/soundtrigger_middleware/RecoverableException;

    const/4 p1, 0x5

    invoke-direct {p0, p1, v0}, Lcom/android/server/soundtrigger_middleware/RecoverableException;-><init>(ILjava/lang/String;)V

    return-object p0

    .line 355
    :cond_35
    const-string p1, "K4StRetry"

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "HAL refused the model (busy), not rebooting the HAL; loading it again when audio stops or the screen turns off: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {p1, v1}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 357
    sget-object p1, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter p1

    .line 358
    :try_start_50
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sPending:Ljava/util/IdentityHashMap;

    sget-object v2, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v1, p0, v2}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 359
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->ensureHandlerLocked()V

    .line 360
    monitor-exit p1
    :try_end_5b
    .catchall {:try_start_50 .. :try_end_5b} :catchall_62

    .line 361
    new-instance p0, Lcom/android/server/soundtrigger_middleware/RecoverableException;

    const/4 p1, 0x1

    invoke-direct {p0, p1, v0}, Lcom/android/server/soundtrigger_middleware/RecoverableException;-><init>(ILjava/lang/String;)V

    return-object p0

    .line 360
    :catchall_62
    move-exception p0

    :try_start_63
    monitor-exit p1
    :try_end_64
    .catchall {:try_start_63 .. :try_end_64} :catchall_62

    throw p0
.end method

.method private static registerState()V
    .registers 11

    .line 567
    const-string v1, "K4StRetry"

    .line 568
    nop

    .line 570
    const/4 v2, 0x1

    const/4 v3, 0x0

    :try_start_5
    invoke-static {}, Landroid/app/ActivityThread;->currentActivityThread()Landroid/app/ActivityThread;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/ActivityThread;->getSystemContext()Landroid/app/ContextImpl;

    move-result-object v4

    .line 571
    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sModeWatched:Z

    if-nez v0, :cond_62

    .line 574
    const-string v0, "audio"

    invoke-static {v0}, Landroid/os/ServiceManager;->checkService(Ljava/lang/String;)Landroid/os/IBinder;

    move-result-object v0

    if-eqz v0, :cond_5a

    .line 575
    const-class v0, Landroid/media/AudioManager;

    invoke-virtual {v4, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/media/AudioManager;

    .line 576
    sget-object v5, Lcom/k4/soundtrigger/K4StRetry;->EXECUTOR:Ljava/util/concurrent/Executor;

    new-instance v6, Lcom/k4/soundtrigger/K4StRetry$10;

    invoke-direct {v6}, Lcom/k4/soundtrigger/K4StRetry$10;-><init>()V

    invoke-virtual {v0, v5, v6}, Landroid/media/AudioManager;->addOnModeChangedListener(Ljava/util/concurrent/Executor;Landroid/media/AudioManager$OnModeChangedListener;)V

    .line 582
    invoke-virtual {v0}, Landroid/media/AudioManager;->getMode()I

    move-result v5

    .line 583
    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sAm:Landroid/media/AudioManager;

    .line 584
    sput-boolean v2, Lcom/k4/soundtrigger/K4StRetry;->sModeWatched:Z

    .line 585
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "watching the audio mode for deferred sound trigger HAL reboots (mode "

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v6, ")"

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 586
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    new-instance v6, Lcom/k4/soundtrigger/K4StRetry$11;

    invoke-direct {v6, v5}, Lcom/k4/soundtrigger/K4StRetry$11;-><init>(I)V

    invoke-virtual {v0, v6}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    goto :goto_62

    .line 574
    :cond_5a
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v4, "no audio service"

    invoke-direct {v0, v4}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 593
    :cond_62
    :goto_62
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sAm:Landroid/media/AudioManager;
    :try_end_64
    .catchall {:try_start_5 .. :try_end_64} :catchall_d5

    .line 595
    :try_start_64
    sget-boolean v5, Lcom/k4/soundtrigger/K4StRetry;->sPlaybackWatched:Z

    if-nez v5, :cond_7b

    .line 596
    new-instance v5, Lcom/k4/soundtrigger/K4StRetry$12;

    invoke-direct {v5}, Lcom/k4/soundtrigger/K4StRetry$12;-><init>()V

    sget-object v6, Lcom/k4/soundtrigger/K4StRetry;->sStateHandler:Landroid/os/Handler;

    invoke-virtual {v0, v5, v6}, Landroid/media/AudioManager;->registerAudioPlaybackCallback(Landroid/media/AudioManager$AudioPlaybackCallback;Landroid/os/Handler;)V

    .line 602
    sput-boolean v2, Lcom/k4/soundtrigger/K4StRetry;->sPlaybackWatched:Z

    .line 603
    invoke-virtual {v0}, Landroid/media/AudioManager;->getActivePlaybackConfigurations()Ljava/util/List;

    move-result-object v5

    invoke-static {v5}, Lcom/k4/soundtrigger/K4StRetry;->onPlayback(Ljava/util/List;)V

    .line 605
    :cond_7b
    sget-boolean v5, Lcom/k4/soundtrigger/K4StRetry;->sRecordingWatched:Z

    if-nez v5, :cond_92

    .line 606
    new-instance v5, Lcom/k4/soundtrigger/K4StRetry$13;

    invoke-direct {v5}, Lcom/k4/soundtrigger/K4StRetry$13;-><init>()V

    sget-object v6, Lcom/k4/soundtrigger/K4StRetry;->sStateHandler:Landroid/os/Handler;

    invoke-virtual {v0, v5, v6}, Landroid/media/AudioManager;->registerAudioRecordingCallback(Landroid/media/AudioManager$AudioRecordingCallback;Landroid/os/Handler;)V

    .line 612
    sput-boolean v2, Lcom/k4/soundtrigger/K4StRetry;->sRecordingWatched:Z

    .line 613
    invoke-virtual {v0}, Landroid/media/AudioManager;->getActiveRecordingConfigurations()Ljava/util/List;

    move-result-object v0

    invoke-static {v0}, Lcom/k4/soundtrigger/K4StRetry;->onRecording(Ljava/util/List;)V

    .line 615
    :cond_92
    sput-boolean v3, Lcom/k4/soundtrigger/K4StRetry;->sAudioSignalsFailed:Z
    :try_end_94
    .catchall {:try_start_64 .. :try_end_94} :catchall_97

    .line 620
    const/4 v0, 0x0

    move v10, v3

    goto :goto_9c

    .line 616
    :catchall_97
    move-exception v0

    .line 617
    :try_start_98
    sput-boolean v2, Lcom/k4/soundtrigger/K4StRetry;->sAudioSignalsFailed:Z

    .line 618
    nop

    .line 619
    move v10, v2

    .line 621
    :goto_9c
    sget-boolean v5, Lcom/k4/soundtrigger/K4StRetry;->sScreenWatched:Z
    :try_end_9e
    .catchall {:try_start_98 .. :try_end_9e} :catchall_d5

    if-nez v5, :cond_b9

    .line 623
    :try_start_a0
    new-instance v5, Lcom/k4/soundtrigger/K4StRetry$14;

    invoke-direct {v5}, Lcom/k4/soundtrigger/K4StRetry$14;-><init>()V

    new-instance v6, Landroid/content/IntentFilter;

    const-string v7, "android.intent.action.SCREEN_OFF"

    invoke-direct {v6, v7}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    sget-object v8, Lcom/k4/soundtrigger/K4StRetry;->sStateHandler:Landroid/os/Handler;

    const/4 v9, 0x4

    const/4 v7, 0x0

    invoke-virtual/range {v4 .. v9}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;I)Landroid/content/Intent;

    .line 629
    sput-boolean v2, Lcom/k4/soundtrigger/K4StRetry;->sScreenWatched:Z
    :try_end_b5
    .catchall {:try_start_a0 .. :try_end_b5} :catchall_b6

    .line 633
    goto :goto_b9

    .line 630
    :catchall_b6
    move-exception v0

    .line 631
    nop

    .line 632
    move v10, v2

    .line 635
    :cond_b9
    :goto_b9
    :try_start_b9
    sget-boolean v5, Lcom/k4/soundtrigger/K4StRetry;->sTelWatched:Z
    :try_end_bb
    .catchall {:try_start_b9 .. :try_end_bb} :catchall_d5

    if-nez v5, :cond_d4

    .line 637
    :try_start_bd
    invoke-static {v4}, Lcom/k4/soundtrigger/K4StRetry;->registerTelephony(Landroid/content/Context;)Z

    move-result v4

    if-nez v4, :cond_ce

    .line 638
    nop

    .line 639
    if-nez v0, :cond_cd

    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v4, "no telephony service yet"

    invoke-direct {v0, v4}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V
    :try_end_cd
    .catchall {:try_start_bd .. :try_end_cd} :catchall_cf

    :cond_cd
    move v10, v2

    .line 645
    :cond_ce
    goto :goto_d4

    .line 641
    :catchall_cf
    move-exception v0

    .line 642
    :try_start_d0
    sput-boolean v2, Lcom/k4/soundtrigger/K4StRetry;->sTelFailed:Z
    :try_end_d2
    .catchall {:try_start_d0 .. :try_end_d2} :catchall_d5

    .line 643
    nop

    .line 644
    move v10, v2

    .line 651
    :cond_d4
    :goto_d4
    goto :goto_d8

    .line 647
    :catchall_d5
    move-exception v0

    .line 649
    nop

    .line 650
    move v10, v2

    .line 652
    :goto_d8
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->updateUnknown()V

    .line 653
    if-nez v10, :cond_102

    .line 654
    sget v0, Lcom/k4/soundtrigger/K4StRetry;->sStateRegisterTries:I

    if-lez v0, :cond_ff

    sget v0, Lcom/k4/soundtrigger/K4StRetry;->sStateRegisterTries:I

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "call state watched (after "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " retries)"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 655
    :cond_ff
    sput v3, Lcom/k4/soundtrigger/K4StRetry;->sStateRegisterTries:I

    .line 656
    return-void

    .line 658
    :cond_102
    sget v3, Lcom/k4/soundtrigger/K4StRetry;->sStateRegisterTries:I

    add-int/2addr v3, v2

    sput v3, Lcom/k4/soundtrigger/K4StRetry;->sStateRegisterTries:I

    .line 659
    const/16 v4, 0x3c

    if-eq v3, v2, :cond_113

    if-eq v3, v4, :cond_113

    if-le v3, v4, :cond_149

    rem-int/lit8 v2, v3, 0x14

    if-nez v2, :cond_149

    .line 660
    :cond_113
    nop

    .line 661
    if-ge v3, v4, :cond_119

    const-string v2, "1 s"

    goto :goto_11b

    :cond_119
    const-string v2, "15 s"

    :goto_11b
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "cannot watch the audio mode / call state yet (attempt "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "), retrying every "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v5, ": "

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 660
    invoke-static {v1, v0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 663
    :cond_149
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sStateHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->REGISTER_STATE:Ljava/lang/Runnable;

    if-ge v3, v4, :cond_152

    const-wide/16 v2, 0x3e8

    goto :goto_154

    :cond_152
    const-wide/16 v2, 0x3a98

    :goto_154
    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 664
    return-void
.end method

.method private static registerTelephony(Landroid/content/Context;)Z
    .registers 4

    .line 673
    const-string v0, "isub"

    invoke-static {v0}, Landroid/os/ServiceManager;->checkService(Ljava/lang/String;)Landroid/os/IBinder;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_41

    const-string v0, "phone"

    invoke-static {v0}, Landroid/os/ServiceManager;->checkService(Ljava/lang/String;)Landroid/os/IBinder;

    move-result-object v0

    if-nez v0, :cond_12

    goto :goto_41

    .line 677
    :cond_12
    const-class v0, Landroid/telephony/SubscriptionManager;

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/SubscriptionManager;

    .line 678
    const-class v2, Landroid/telephony/TelephonyManager;

    invoke-virtual {p0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/telephony/TelephonyManager;

    .line 679
    const/4 v2, 0x1

    if-eqz v0, :cond_3c

    if-nez p0, :cond_28

    goto :goto_3c

    .line 684
    :cond_28
    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sSubs:Landroid/telephony/SubscriptionManager;

    .line 685
    sput-object p0, Lcom/k4/soundtrigger/K4StRetry;->sTel:Landroid/telephony/TelephonyManager;

    .line 686
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->STATE_EXECUTOR:Ljava/util/concurrent/Executor;

    new-instance v1, Lcom/k4/soundtrigger/K4StRetry$15;

    invoke-direct {v1}, Lcom/k4/soundtrigger/K4StRetry$15;-><init>()V

    invoke-virtual {v0, p0, v1}, Landroid/telephony/SubscriptionManager;->addOnSubscriptionsChangedListener(Ljava/util/concurrent/Executor;Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;)V

    .line 692
    sput-boolean v2, Lcom/k4/soundtrigger/K4StRetry;->sTelWatched:Z

    .line 693
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->syncSubscriptions()V

    .line 694
    return v2

    .line 680
    :cond_3c
    :goto_3c
    sput-boolean v1, Lcom/k4/soundtrigger/K4StRetry;->sTelFailed:Z

    .line 681
    sput-boolean v2, Lcom/k4/soundtrigger/K4StRetry;->sTelWatched:Z

    .line 682
    return v2

    .line 674
    :cond_41
    :goto_41
    sput-boolean v1, Lcom/k4/soundtrigger/K4StRetry;->sTelFailed:Z

    .line 675
    return v1
.end method

.method private static resync()V
    .registers 8

    .line 859
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->currentMode()I

    move-result v0

    .line 860
    const/16 v1, -0x64

    const-wide/16 v2, 0x1388

    const-wide/16 v4, 0x0

    if-ne v0, v1, :cond_34

    .line 862
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 863
    sget-wide v6, Lcom/k4/soundtrigger/K4StRetry;->sUnknownSince:J

    cmp-long v4, v6, v4

    if-nez v4, :cond_18

    sput-wide v0, Lcom/k4/soundtrigger/K4StRetry;->sUnknownSince:J

    .line 864
    :cond_18
    sget-wide v4, Lcom/k4/soundtrigger/K4StRetry;->sUnknownSince:J

    sub-long/2addr v0, v4

    const-wide/32 v4, 0xdbba0

    cmp-long v0, v0, v4

    if-gez v0, :cond_2a

    .line 865
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 866
    return-void

    .line 868
    :cond_2a
    const-string v0, "K4StRetry"

    const-string v1, "audio mode still unknown after 15 min: owed sound trigger HAL reboots run now (stock)"

    invoke-static {v0, v1}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 870
    nop

    .line 871
    const/4 v0, 0x0

    goto :goto_36

    .line 872
    :cond_34
    sput-wide v4, Lcom/k4/soundtrigger/K4StRetry;->sUnknownSince:J

    .line 876
    :goto_36
    invoke-static {v0}, Lcom/k4/soundtrigger/K4StRetry;->noCall(I)Z

    move-result v0

    .line 877
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v1

    .line 878
    if-nez v0, :cond_54

    .line 881
    :try_start_3f
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->listenerSaysCall()Z

    move-result v0

    if-nez v0, :cond_52

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->signalWillReport()Z

    move-result v0

    if-nez v0, :cond_52

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v4, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {v0, v4, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 882
    :cond_52
    monitor-exit v1

    return-void

    .line 884
    :cond_54
    new-instance v0, Ljava/util/ArrayList;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    invoke-virtual {v2}, Ljava/util/IdentityHashMap;->keySet()Ljava/util/Set;

    move-result-object v2

    invoke-direct {v0, v2}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 885
    new-instance v2, Ljava/util/ArrayList;

    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v3}, Ljava/util/IdentityHashMap;->values()Ljava/util/Collection;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 886
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    invoke-virtual {v3}, Ljava/util/IdentityHashMap;->clear()V

    .line 887
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v3}, Ljava/util/IdentityHashMap;->clear()V

    .line 888
    monitor-exit v1
    :try_end_75
    .catchall {:try_start_3f .. :try_end_75} :catchall_b6

    .line 889
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_82

    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_82

    return-void

    .line 890
    :cond_82
    const-string v1, "K4StRetry"

    .line 891
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v3

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v4

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "no call: rebooting the sound trigger HAL now to resync it with the middleware ("

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v5, " HAL error(s), "

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " hung HAL call(s))"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 890
    invoke-static {v1, v3}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 892
    invoke-static {v0, v2}, Lcom/k4/soundtrigger/K4StRetry;->rebootAll(Ljava/util/List;Ljava/util/List;)V

    .line 893
    return-void

    .line 888
    :catchall_b6
    move-exception v0

    :try_start_b7
    monitor-exit v1
    :try_end_b8
    .catchall {:try_start_b7 .. :try_end_b8} :catchall_b6

    throw v0
.end method

.method private static schedule(JLjava/lang/String;)V
    .registers 5

    .line 1016
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 1017
    :try_start_3
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sPending:Ljava/util/IdentityHashMap;

    invoke-virtual {v1}, Ljava/util/IdentityHashMap;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_d

    monitor-exit v0

    return-void

    .line 1018
    :cond_d
    monitor-exit v0
    :try_end_e
    .catchall {:try_start_3 .. :try_end_e} :catchall_25

    .line 1019
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->FIRE:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1020
    sput-object p2, Lcom/k4/soundtrigger/K4StRetry;->sReason:Ljava/lang/String;

    .line 1021
    sget-object p2, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->FIRE:Ljava/lang/Runnable;

    invoke-virtual {p2, v0, p0, p1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 1022
    const-wide/16 v0, 0x3e8

    add-long/2addr p0, v0

    invoke-static {p0, p1}, Lcom/k4/soundtrigger/K4StRetry;->hold(J)V

    .line 1023
    return-void

    .line 1018
    :catchall_25
    move-exception p0

    :try_start_26
    monitor-exit v0
    :try_end_27
    .catchall {:try_start_26 .. :try_end_27} :catchall_25

    throw p0
.end method

.method public static setCallback(Ljava/lang/Object;Lcom/android/server/soundtrigger_middleware/ISoundTriggerHal$GlobalCallback;)V
    .registers 4

    .line 320
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 321
    :try_start_3
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sCallbacks:Ljava/util/IdentityHashMap;

    invoke-virtual {v1, p0, p1}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 322
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->ensureHandlerLocked()V

    .line 323
    monitor-exit v0

    .line 324
    return-void

    .line 323
    :catchall_d
    move-exception p0

    monitor-exit v0
    :try_end_f
    .catchall {:try_start_3 .. :try_end_f} :catchall_d

    throw p0
.end method

.method private static setSignal(IZ)V
    .registers 4

    .line 797
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->callBySignals()Z

    move-result v0

    .line 798
    if-nez p0, :cond_9

    sput-boolean p1, Lcom/k4/soundtrigger/K4StRetry;->sTelBusy:Z

    goto :goto_11

    .line 799
    :cond_9
    const/4 v1, 0x1

    if-ne p0, v1, :cond_f

    sput-boolean p1, Lcom/k4/soundtrigger/K4StRetry;->sVoicePlayback:Z

    goto :goto_11

    .line 800
    :cond_f
    sput-boolean p1, Lcom/k4/soundtrigger/K4StRetry;->sVoiceRecording:Z

    .line 801
    :goto_11
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->updateUnknown()V

    .line 802
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->callBySignals()Z

    move-result p0

    if-eq p0, v0, :cond_21

    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object p1, Lcom/k4/soundtrigger/K4StRetry;->SIGNALS:Ljava/lang/Runnable;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 803
    :cond_21
    return-void
.end method

.method private static signalWillReport()Z
    .registers 1

    .line 474
    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sTelBusy:Z

    if-nez v0, :cond_f

    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sVoicePlayback:Z

    if-nez v0, :cond_f

    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sVoiceRecording:Z

    if-eqz v0, :cond_d

    goto :goto_f

    :cond_d
    const/4 v0, 0x0

    goto :goto_10

    :cond_f
    :goto_f
    const/4 v0, 0x1

    :goto_10
    return v0
.end method

.method private static syncSubscriptions()V
    .registers 5

    .line 700
    :try_start_0
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sSubs:Landroid/telephony/SubscriptionManager;

    invoke-virtual {v0}, Landroid/telephony/SubscriptionManager;->getActiveSubscriptionInfoList()Ljava/util/List;

    move-result-object v0

    .line 701
    new-instance v1, Ljava/util/HashSet;

    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V

    .line 702
    if-eqz v0, :cond_2b

    .line 703
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_11
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2b

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/telephony/SubscriptionInfo;

    .line 704
    if-eqz v2, :cond_2a

    invoke-virtual {v2}, Landroid/telephony/SubscriptionInfo;->getSubscriptionId()I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    .line 705
    :cond_2a
    goto :goto_11

    .line 707
    :cond_2b
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sSubCalls:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_35
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_58

    .line 708
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/k4/soundtrigger/K4StRetry$SubCall;

    .line 709
    iget v3, v2, Lcom/k4/soundtrigger/K4StRetry$SubCall;->subId:I

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_57

    .line 710
    invoke-interface {v0}, Ljava/util/Iterator;->remove()V
    :try_end_50
    .catchall {:try_start_0 .. :try_end_50} :catchall_93

    .line 712
    :try_start_50
    iget-object v3, v2, Lcom/k4/soundtrigger/K4StRetry$SubCall;->tm:Landroid/telephony/TelephonyManager;

    invoke-virtual {v3, v2}, Landroid/telephony/TelephonyManager;->unregisterTelephonyCallback(Landroid/telephony/TelephonyCallback;)V
    :try_end_55
    .catchall {:try_start_50 .. :try_end_55} :catchall_56

    .line 715
    goto :goto_57

    .line 713
    :catchall_56
    move-exception v2

    .line 717
    :cond_57
    :goto_57
    goto :goto_35

    .line 718
    :cond_58
    :try_start_58
    invoke-virtual {v1}, Ljava/util/HashSet;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_5c
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_8f

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    .line 719
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sSubCalls:Ljava/util/HashMap;

    invoke-virtual {v2, v1}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_71

    goto :goto_5c

    .line 720
    :cond_71
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sTel:Landroid/telephony/TelephonyManager;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/telephony/TelephonyManager;->createForSubscriptionId(I)Landroid/telephony/TelephonyManager;

    move-result-object v2

    .line 721
    new-instance v3, Lcom/k4/soundtrigger/K4StRetry$SubCall;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v4

    invoke-direct {v3, v4, v2}, Lcom/k4/soundtrigger/K4StRetry$SubCall;-><init>(ILandroid/telephony/TelephonyManager;)V

    .line 724
    sget-object v4, Lcom/k4/soundtrigger/K4StRetry;->STATE_EXECUTOR:Ljava/util/concurrent/Executor;

    invoke-virtual {v2, v4, v3}, Landroid/telephony/TelephonyManager;->registerTelephonyCallback(Ljava/util/concurrent/Executor;Landroid/telephony/TelephonyCallback;)V

    .line 725
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sSubCalls:Ljava/util/HashMap;

    invoke-virtual {v2, v1, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 726
    goto :goto_5c

    .line 727
    :cond_8f
    const/4 v0, 0x0

    sput-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sTelFailed:Z
    :try_end_92
    .catchall {:try_start_58 .. :try_end_92} :catchall_93

    .line 737
    goto :goto_bf

    .line 728
    :catchall_93
    move-exception v0

    .line 729
    const/4 v1, 0x1

    sput-boolean v1, Lcom/k4/soundtrigger/K4StRetry;->sTelFailed:Z

    .line 730
    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "cannot follow the telephony call state, counting it as a call until it works: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "K4StRetry"

    invoke-static {v1, v0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 731
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sStateHandler:Landroid/os/Handler;

    new-instance v1, Lcom/k4/soundtrigger/K4StRetry$16;

    invoke-direct {v1}, Lcom/k4/soundtrigger/K4StRetry$16;-><init>()V

    const-wide/16 v2, 0x3a98

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 738
    :goto_bf
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->updateTelephony()V

    .line 739
    return-void
.end method

.method private static updateTelephony()V
    .registers 5

    .line 743
    nop

    .line 744
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sSubCalls:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->values()Ljava/util/Collection;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v0

    const/4 v1, 0x0

    move v2, v1

    :goto_d
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_24

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/k4/soundtrigger/K4StRetry$SubCall;

    .line 745
    iget v4, v3, Lcom/k4/soundtrigger/K4StRetry$SubCall;->state:I

    if-eqz v4, :cond_23

    iget v3, v3, Lcom/k4/soundtrigger/K4StRetry$SubCall;->state:I

    const/4 v4, -0x1

    if-eq v3, v4, :cond_23

    const/4 v2, 0x1

    .line 746
    :cond_23
    goto :goto_d

    .line 747
    :cond_24
    invoke-static {v1, v2}, Lcom/k4/soundtrigger/K4StRetry;->setSignal(IZ)V

    .line 748
    return-void
.end method

.method private static updateUnknown()V
    .registers 6

    .line 807
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->callBySignals()Z

    move-result v0

    .line 808
    sget-boolean v1, Lcom/k4/soundtrigger/K4StRetry;->sTelFailed:Z

    const/4 v2, 0x1

    if-nez v1, :cond_1c

    sget-boolean v1, Lcom/k4/soundtrigger/K4StRetry;->sAudioSignalsFailed:Z

    if-nez v1, :cond_1c

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sAm:Landroid/media/AudioManager;

    if-eqz v1, :cond_1a

    sget-boolean v1, Lcom/k4/soundtrigger/K4StRetry;->sPlaybackWatched:Z

    if-eqz v1, :cond_1c

    sget-boolean v1, Lcom/k4/soundtrigger/K4StRetry;->sRecordingWatched:Z

    if-nez v1, :cond_1a

    goto :goto_1c

    :cond_1a
    const/4 v1, 0x0

    goto :goto_1d

    :cond_1c
    :goto_1c
    move v1, v2

    .line 809
    :goto_1d
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sSubCalls:Ljava/util/HashMap;

    invoke-virtual {v3}, Ljava/util/HashMap;->values()Ljava/util/Collection;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_27
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_3a

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/k4/soundtrigger/K4StRetry$SubCall;

    .line 810
    iget v4, v4, Lcom/k4/soundtrigger/K4StRetry$SubCall;->state:I

    const/4 v5, -0x1

    if-ne v4, v5, :cond_39

    move v1, v2

    .line 811
    :cond_39
    goto :goto_27

    .line 812
    :cond_3a
    if-eqz v1, :cond_46

    sget-boolean v2, Lcom/k4/soundtrigger/K4StRetry;->sSignalsUnknown:Z

    if-nez v2, :cond_46

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v2

    sput-wide v2, Lcom/k4/soundtrigger/K4StRetry;->sSignalsUnknownSince:J

    .line 813
    :cond_46
    sput-boolean v1, Lcom/k4/soundtrigger/K4StRetry;->sSignalsUnknown:Z

    .line 814
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->callBySignals()Z

    move-result v1

    if-eq v1, v0, :cond_55

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->SIGNALS:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 815
    :cond_55
    return-void
.end method

.method public static watchdogClosed(Ljava/lang/Object;)V
    .registers 5

    .line 437
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 438
    :try_start_3
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v1, p0}, Ljava/util/IdentityHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/k4/soundtrigger/K4StRetry$Hung;

    .line 439
    if-nez v1, :cond_14

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sClosed:Ljava/util/WeakHashMap;

    sget-object v3, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v2, p0, v3}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 440
    :cond_14
    monitor-exit v0
    :try_end_15
    .catchall {:try_start_3 .. :try_end_15} :catchall_40

    .line 441
    if-eqz v1, :cond_3f

    .line 442
    const-string p0, "K4StRetry"

    .line 443
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v2

    iget-wide v0, v1, Lcom/k4/soundtrigger/K4StRetry$Hung;->since:J

    sub-long/2addr v2, v0

    const-wide/16 v0, 0xbb8

    add-long/2addr v2, v0

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "the hung sound trigger HAL call returned after "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " ms: no HAL reboot"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 442
    invoke-static {p0, v0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 445
    :cond_3f
    return-void

    .line 440
    :catchall_40
    move-exception p0

    :try_start_41
    monitor-exit v0
    :try_end_42
    .catchall {:try_start_41 .. :try_end_42} :catchall_40

    throw p0
.end method

.method public static watchdogExpired(Ljava/lang/Object;Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;Ljava/lang/Exception;)V
    .registers 9

    .line 408
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 409
    :try_start_3
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->ensureHandlerLocked()V

    .line 412
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sClosed:Ljava/util/WeakHashMap;

    invoke-virtual {v1, p0}, Ljava/util/WeakHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    if-eqz v1, :cond_10

    monitor-exit v0

    return-void

    .line 413
    :cond_10
    monitor-exit v0
    :try_end_11
    .catchall {:try_start_3 .. :try_end_11} :catchall_51

    .line 415
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->currentMode()I

    move-result v0

    const/16 v1, -0x64

    if-ne v0, v1, :cond_1b

    const/4 v0, 0x1

    goto :goto_1c

    :cond_1b
    const/4 v0, 0x0

    .line 416
    :goto_1c
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v1

    .line 417
    :try_start_1f
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sClosed:Ljava/util/WeakHashMap;

    invoke-virtual {v2, p0}, Ljava/util/WeakHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_29

    monitor-exit v1

    return-void

    .line 418
    :cond_29
    if-nez v0, :cond_40

    .line 419
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    new-instance v3, Lcom/k4/soundtrigger/K4StRetry$Hung;

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v4

    invoke-direct {v3, p1, p2, v4, v5}, Lcom/k4/soundtrigger/K4StRetry$Hung;-><init>(Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;Ljava/lang/Exception;J)V

    invoke-virtual {v2, p0, v3}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 420
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->CHECK_HUNG:Ljava/lang/Runnable;

    invoke-virtual {p0, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 422
    :cond_40
    monitor-exit v1
    :try_end_41
    .catchall {:try_start_1f .. :try_end_41} :catchall_4e

    .line 423
    if-eqz v0, :cond_4d

    .line 426
    const-string p0, "SoundTriggerHalWatchdog"

    const-string v0, "HAL deadline expired. Rebooting."

    invoke-static {p0, v0, p2}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 427
    invoke-virtual {p1}, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;->reboot()V

    .line 429
    :cond_4d
    return-void

    .line 422
    :catchall_4e
    move-exception p0

    :try_start_4f
    monitor-exit v1
    :try_end_50
    .catchall {:try_start_4f .. :try_end_50} :catchall_4e

    throw p0

    .line 413
    :catchall_51
    move-exception p0

    :try_start_52
    monitor-exit v0
    :try_end_53
    .catchall {:try_start_52 .. :try_end_53} :catchall_51

    throw p0
.end method
