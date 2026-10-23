.class public final Lcom/k4/soundtrigger/K4StRetry;
.super Ljava/lang/Object;
.source "K4StRetry.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/k4/soundtrigger/K4StRetry$Hung;
    }
.end annotation


# static fields
.field private static final AUDIO_IDLE_DELAY_MS:J = 0x1388L

.field private static final CALL_END_DELAY_MS:J = 0x1388L

.field private static final CHECK_HUNG:Ljava/lang/Runnable;

.field private static final CHECK_HUNG_MAX:Ljava/lang/Runnable;

.field private static final ENFORCER_TAG:Ljava/lang/String; = "SoundTriggerHalEnforcer"

.field private static final EXECUTOR:Ljava/util/concurrent/Executor;

.field private static final FIRE:Ljava/lang/Runnable;

.field private static final HUNG_IN_CALL_MAX_MS:J = 0xafc8L

.field private static final INTERNAL_ERROR:I = 0x5

.field private static final MODE_UNKNOWN:I = -0x64

.field private static final NORMAL_GRACE_MS:J = 0xbb8L

.field private static final REGISTER_FAST_TRIES:I = 0x3c

.field private static final REGISTER_MODE:Ljava/lang/Runnable;

.field private static final REGISTER_RETRY:Ljava/lang/Runnable;

.field private static final REGISTER_RETRY_FAST_MS:J = 0x3e8L

.field private static final REGISTER_RETRY_MS:J = 0x3a98L

.field private static final RESOURCE_CONTENTION:I = 0x1

.field private static final RESYNC:Ljava/lang/Runnable;

.field private static final SCREEN_OFF_DELAY_MS:J = 0x7d0L

.field private static final TAG:Ljava/lang/String; = "K4StRetry"

.field private static final UNKNOWN_FALLBACK_MS:J = 0xdbba0L

.field private static final WATCHDOG_MS:J = 0xbb8L

.field private static final WATCHDOG_TAG:Ljava/lang/String; = "SoundTriggerHalWatchdog"

.field private static volatile sAm:Landroid/media/AudioManager;

.field private static sAudioActive:Z

.field private static sAudioWatched:Z

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

.field private static sModeRegisterTries:I

.field private static sModeWatched:Z

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

.field private static sReason:Ljava/lang/String;

.field private static sRetryRegisterPosted:Z

.field private static sScreenWatched:Z

.field private static sUnknownSince:J


# direct methods
.method static bridge synthetic -$$Nest$sfgetFIRE()Ljava/lang/Runnable;
    .registers 1

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->FIRE:Ljava/lang/Runnable;

    return-object v0
.end method

.method static bridge synthetic -$$Nest$sfgetsAudioActive()Z
    .registers 1

    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sAudioActive:Z

    return v0
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

.method static bridge synthetic -$$Nest$sfputsAudioActive(Z)V
    .registers 1

    sput-boolean p0, Lcom/k4/soundtrigger/K4StRetry;->sAudioActive:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$smanyActive(Ljava/util/List;)Z
    .registers 1

    invoke-static {p0}, Lcom/k4/soundtrigger/K4StRetry;->anyActive(Ljava/util/List;)Z

    move-result p0

    return p0
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

.method static bridge synthetic -$$Nest$smonMode(I)V
    .registers 1

    invoke-static {p0}, Lcom/k4/soundtrigger/K4StRetry;->onMode(I)V

    return-void
.end method

.method static bridge synthetic -$$Nest$smregisterModeListener()V
    .registers 0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->registerModeListener()V

    return-void
.end method

.method static bridge synthetic -$$Nest$smregisterRetryListeners()V
    .registers 0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->registerRetryListeners()V

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

.method static constructor <clinit>()V
    .registers 1

    .line 120
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    .line 122
    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sCallbacks:Ljava/util/IdentityHashMap;

    .line 124
    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sPending:Ljava/util/IdentityHashMap;

    .line 126
    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    .line 128
    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    .line 134
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->sClosed:Ljava/util/WeakHashMap;

    .line 140
    const/16 v0, -0x64

    sput v0, Lcom/k4/soundtrigger/K4StRetry;->sMode:I

    .line 150
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$1;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$1;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->FIRE:Ljava/lang/Runnable;

    .line 156
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$2;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$2;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->REGISTER_MODE:Ljava/lang/Runnable;

    .line 162
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$3;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$3;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->REGISTER_RETRY:Ljava/lang/Runnable;

    .line 168
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$4;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$4;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    .line 174
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$5;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$5;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->CHECK_HUNG:Ljava/lang/Runnable;

    .line 180
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$6;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$6;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->EXECUTOR:Ljava/util/concurrent/Executor;

    .line 399
    new-instance v0, Lcom/k4/soundtrigger/K4StRetry$7;

    invoke-direct {v0}, Lcom/k4/soundtrigger/K4StRetry$7;-><init>()V

    sput-object v0, Lcom/k4/soundtrigger/K4StRetry;->CHECK_HUNG_MAX:Ljava/lang/Runnable;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 187
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static anyActive(Ljava/util/List;)Z
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/media/AudioPlaybackConfiguration;",
            ">;)Z"
        }
    .end annotation

    .line 584
    const/4 v0, 0x0

    if-nez p0, :cond_4

    return v0

    .line 585
    :cond_4
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_8
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1f

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/media/AudioPlaybackConfiguration;

    .line 586
    if-eqz v1, :cond_1e

    invoke-virtual {v1}, Landroid/media/AudioPlaybackConfiguration;->isActive()Z

    move-result v1

    if-eqz v1, :cond_1e

    const/4 p0, 0x1

    return p0

    .line 587
    :cond_1e
    goto :goto_8

    .line 588
    :cond_1f
    return v0
.end method

.method private static audioManager()Landroid/media/AudioManager;
    .registers 3

    .line 351
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sAm:Landroid/media/AudioManager;

    .line 352
    if-eqz v0, :cond_5

    return-object v0

    .line 354
    :cond_5
    const/4 v0, 0x0

    :try_start_6
    const-string v1, "audio"

    invoke-static {v1}, Landroid/os/ServiceManager;->checkService(Ljava/lang/String;)Landroid/os/IBinder;

    move-result-object v1

    if-nez v1, :cond_f

    return-object v0

    .line 355
    :cond_f
    invoke-static {}, Landroid/app/ActivityThread;->currentActivityThread()Landroid/app/ActivityThread;

    move-result-object v1

    invoke-virtual {v1}, Landroid/app/ActivityThread;->getSystemContext()Landroid/app/ContextImpl;

    move-result-object v1

    const-class v2, Landroid/media/AudioManager;

    invoke-virtual {v1, v2}, Landroid/app/ContextImpl;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/media/AudioManager;

    .line 356
    sput-object v1, Lcom/k4/soundtrigger/K4StRetry;->sAm:Landroid/media/AudioManager;
    :try_end_21
    .catchall {:try_start_6 .. :try_end_21} :catchall_22

    .line 357
    return-object v1

    .line 358
    :catchall_22
    move-exception v1

    .line 359
    return-object v0
.end method

.method public static callbackError(Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;)V
    .registers 2

    .line 264
    const-string v0, "HAL callback broke the sound trigger contract"

    invoke-static {p0, v0}, Lcom/k4/soundtrigger/K4StRetry;->owe(Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;Ljava/lang/String;)V

    .line 265
    return-void
.end method

.method private static checkHung()V
    .registers 8

    .line 365
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->currentMode()I

    move-result v0

    .line 366
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 367
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 368
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v3

    .line 369
    if-eqz v0, :cond_39

    const/16 v4, -0x64

    if-ne v0, v4, :cond_18

    goto :goto_39

    .line 373
    :cond_18
    :try_start_18
    sget-object v4, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v4}, Ljava/util/IdentityHashMap;->values()Ljava/util/Collection;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_22
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_47

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/k4/soundtrigger/K4StRetry$Hung;

    .line 374
    iget-boolean v6, v5, Lcom/k4/soundtrigger/K4StRetry$Hung;->deferred:Z

    if-nez v6, :cond_38

    .line 375
    const/4 v6, 0x1

    iput-boolean v6, v5, Lcom/k4/soundtrigger/K4StRetry$Hung;->deferred:Z

    .line 376
    invoke-interface {v2, v5}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 378
    :cond_38
    goto :goto_22

    .line 370
    :cond_39
    :goto_39
    sget-object v4, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v4}, Ljava/util/IdentityHashMap;->values()Ljava/util/Collection;

    move-result-object v4

    invoke-interface {v1, v4}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 371
    sget-object v4, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v4}, Ljava/util/IdentityHashMap;->clear()V

    .line 380
    :cond_47
    monitor-exit v3
    :try_end_48
    .catchall {:try_start_18 .. :try_end_48} :catchall_d5

    .line 381
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_4c
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_79

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/k4/soundtrigger/K4StRetry$Hung;

    .line 382
    const-string v5, "K4StRetry"

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "sound trigger HAL call still running after 3000 ms during a call (mode "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, "): NOT rebooting the audio HAL (shared with call audio); rebooting it after the call if the call into the HAL is still hung"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    iget-object v4, v4, Lcom/k4/soundtrigger/K4StRetry$Hung;->where:Ljava/lang/Exception;

    invoke-static {v5, v6, v4}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 385
    goto :goto_4c

    .line 386
    :cond_79
    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_ac

    .line 387
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->CHECK_HUNG_MAX:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->hasCallbacks(Ljava/lang/Runnable;)Z

    move-result v0

    if-nez v0, :cond_93

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->CHECK_HUNG_MAX:Ljava/lang/Runnable;

    const-wide/32 v3, 0xafc8

    invoke-virtual {v0, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 389
    :cond_93
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->listenerSaysCall()Z

    move-result v0

    if-nez v0, :cond_ac

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {v0, v2}, Landroid/os/Handler;->hasCallbacks(Ljava/lang/Runnable;)Z

    move-result v0

    if-nez v0, :cond_ac

    .line 390
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    const-wide/16 v3, 0x1388

    invoke-virtual {v0, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 393
    :cond_ac
    invoke-interface {v1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_d4

    .line 394
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_b6
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_cc

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/k4/soundtrigger/K4StRetry$Hung;

    const-string v3, "SoundTriggerHalWatchdog"

    const-string v4, "HAL deadline expired. Rebooting."

    iget-object v2, v2, Lcom/k4/soundtrigger/K4StRetry$Hung;->where:Ljava/lang/Exception;

    invoke-static {v3, v4, v2}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_b6

    .line 395
    :cond_cc
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    invoke-static {v0, v1}, Lcom/k4/soundtrigger/K4StRetry;->rebootAll(Ljava/util/List;Ljava/util/List;)V

    .line 397
    :cond_d4
    return-void

    .line 380
    :catchall_d5
    move-exception v0

    :try_start_d6
    monitor-exit v3
    :try_end_d7
    .catchall {:try_start_d6 .. :try_end_d7} :catchall_d5

    throw v0
.end method

.method private static checkHungMax()V
    .registers 15

    .line 408
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 409
    nop

    .line 410
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 411
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v3

    .line 412
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

    .line 413
    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Lcom/k4/soundtrigger/K4StRetry$Hung;

    .line 414
    iget-wide v10, v9, Lcom/k4/soundtrigger/K4StRetry$Hung;->since:J

    sub-long v10, v0, v10

    .line 415
    const-wide/32 v12, 0xafc8

    cmp-long v14, v10, v12

    if-ltz v14, :cond_3b

    .line 416
    invoke-interface {v2, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 417
    invoke-interface {v4}, Ljava/util/Iterator;->remove()V

    goto :goto_40

    .line 419
    :cond_3b
    sub-long/2addr v12, v10

    invoke-static {v7, v8, v12, v13}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v7

    .line 421
    :goto_40
    goto :goto_1d

    .line 422
    :cond_41
    monitor-exit v3
    :try_end_42
    .catchall {:try_start_d .. :try_end_42} :catchall_64

    .line 423
    cmp-long v0, v7, v5

    if-eqz v0, :cond_4d

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->CHECK_HUNG_MAX:Ljava/lang/Runnable;

    invoke-virtual {v0, v1, v7, v8}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 424
    :cond_4d
    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_54

    return-void

    .line 425
    :cond_54
    const-string v0, "K4StRetry"

    const-string v1, "sound trigger HAL call hung for 48 s during a call: treating the HAL as dead, rebooting it now before blocked system_server threads trip the system_server watchdog (this restarts the audio HAL)"

    invoke-static {v0, v1}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 428
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    invoke-static {v0, v2}, Lcom/k4/soundtrigger/K4StRetry;->rebootAll(Ljava/util/List;Ljava/util/List;)V

    .line 429
    return-void

    .line 422
    :catchall_64
    move-exception v0

    :try_start_65
    monitor-exit v3
    :try_end_66
    .catchall {:try_start_65 .. :try_end_66} :catchall_64

    throw v0
.end method

.method private static currentMode()I
    .registers 2

    .line 339
    sget v0, Lcom/k4/soundtrigger/K4StRetry;->sMode:I

    .line 340
    if-eqz v0, :cond_9

    const/16 v1, -0x64

    if-eq v0, v1, :cond_9

    return v0

    .line 341
    :cond_9
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->audioManager()Landroid/media/AudioManager;

    move-result-object v1

    .line 342
    if-nez v1, :cond_10

    return v0

    .line 344
    :cond_10
    :try_start_10
    invoke-virtual {v1}, Landroid/media/AudioManager;->getMode()I

    move-result v0
    :try_end_14
    .catchall {:try_start_10 .. :try_end_14} :catchall_15

    return v0

    .line 345
    :catchall_15
    move-exception v1

    .line 346
    return v0
.end method

.method public static detached(Ljava/lang/Object;)V
    .registers 6

    .line 213
    nop

    .line 214
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 215
    :try_start_4
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sCallbacks:Ljava/util/IdentityHashMap;

    invoke-virtual {v1, p0}, Ljava/util/IdentityHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 216
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sPending:Ljava/util/IdentityHashMap;

    invoke-virtual {v1, p0}, Ljava/util/IdentityHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 217
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    invoke-virtual {v1, p0}, Ljava/util/IdentityHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    const/4 v2, 0x0

    if-eqz v1, :cond_19

    const/4 v1, 0x1

    goto :goto_1a

    :cond_19
    move v1, v2

    .line 218
    :goto_1a
    instance-of v3, p0, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;

    if-eqz v3, :cond_42

    .line 219
    check-cast p0, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;

    iget-object p0, p0, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;->mUnderlying:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    .line 220
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

    .line 221
    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/k4/soundtrigger/K4StRetry$Hung;

    iget-object v4, v4, Lcom/k4/soundtrigger/K4StRetry$Hung;->hal:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    if-ne v4, p0, :cond_2c

    .line 222
    invoke-interface {v3}, Ljava/util/Iterator;->remove()V

    .line 223
    add-int/lit8 v2, v2, 0x1

    goto :goto_2c

    .line 227
    :cond_42
    monitor-exit v0
    :try_end_43
    .catchall {:try_start_4 .. :try_end_43} :catchall_4f

    .line 228
    if-nez v1, :cond_47

    if-lez v2, :cond_4e

    :cond_47
    const-string p0, "K4StRetry"

    const-string v0, "HAL died: the deferred sound trigger HAL reboot is no longer needed"

    invoke-static {p0, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 229
    :cond_4e
    return-void

    .line 227
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

    .line 191
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    if-nez v0, :cond_35

    .line 192
    new-instance v0, Landroid/os/HandlerThread;

    const-string v1, "K4StRetry"

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    .line 193
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 194
    new-instance v1, Landroid/os/Handler;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-direct {v1, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v1, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    .line 195
    new-instance v0, Landroid/os/HandlerThread;

    const-string v1, "K4StRetryCb"

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    .line 196
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 197
    new-instance v1, Landroid/os/Handler;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-direct {v1, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v1, Lcom/k4/soundtrigger/K4StRetry;->sCbHandler:Landroid/os/Handler;

    .line 198
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->REGISTER_MODE:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 200
    :cond_35
    return-void
.end method

.method private static fire()V
    .registers 5

    .line 604
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 605
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v1

    .line 606
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

    .line 607
    sget-object v4, Lcom/k4/soundtrigger/K4StRetry;->sCallbacks:Ljava/util/IdentityHashMap;

    invoke-virtual {v4, v3}, Ljava/util/IdentityHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/android/server/soundtrigger_middleware/ISoundTriggerHal$GlobalCallback;

    .line 608
    if-eqz v3, :cond_29

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 609
    :cond_29
    goto :goto_12

    .line 610
    :cond_2a
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sPending:Ljava/util/IdentityHashMap;

    invoke-virtual {v2}, Ljava/util/IdentityHashMap;->clear()V

    .line 611
    monitor-exit v1
    :try_end_30
    .catchall {:try_start_8 .. :try_end_30} :catchall_44

    .line 612
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_37

    return-void

    .line 613
    :cond_37
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sReason:Ljava/lang/String;

    .line 614
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sCbHandler:Landroid/os/Handler;

    new-instance v3, Lcom/k4/soundtrigger/K4StRetry$11;

    invoke-direct {v3, v0, v1}, Lcom/k4/soundtrigger/K4StRetry$11;-><init>(Ljava/util/List;Ljava/lang/String;)V

    invoke-virtual {v2, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 627
    return-void

    .line 611
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

    .line 257
    invoke-virtual {p1}, Ljava/lang/RuntimeException;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/k4/soundtrigger/K4StRetry;->owe(Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;Ljava/lang/String;)V

    .line 258
    instance-of p0, p1, Lcom/android/server/soundtrigger_middleware/HalException;

    if-eqz p0, :cond_16

    new-instance p0, Lcom/android/server/soundtrigger_middleware/RecoverableException;

    const/4 v0, 0x5

    invoke-virtual {p1}, Ljava/lang/RuntimeException;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, v0, p1}, Lcom/android/server/soundtrigger_middleware/RecoverableException;-><init>(ILjava/lang/String;)V

    return-object p0

    .line 259
    :cond_16
    return-object p1
.end method

.method private static listenerSaysCall()Z
    .registers 2

    .line 465
    sget v0, Lcom/k4/soundtrigger/K4StRetry;->sMode:I

    .line 466
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

.method private static onMode(I)V
    .registers 4

    .line 472
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 473
    :try_start_3
    sput p0, Lcom/k4/soundtrigger/K4StRetry;->sMode:I

    .line 474
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

    .line 475
    :goto_19
    monitor-exit v0
    :try_end_1a
    .catchall {:try_start_3 .. :try_end_1a} :catchall_37

    .line 476
    if-eqz p0, :cond_24

    .line 477
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    goto :goto_36

    .line 478
    :cond_24
    if-eqz v1, :cond_36

    .line 479
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 480
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    const-wide/16 v1, 0x1388

    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 482
    :cond_36
    :goto_36
    return-void

    .line 475
    :catchall_37
    move-exception p0

    :try_start_38
    monitor-exit v0
    :try_end_39
    .catchall {:try_start_38 .. :try_end_39} :catchall_37

    throw p0
.end method

.method private static owe(Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;Ljava/lang/String;)V
    .registers 7

    .line 270
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 271
    :try_start_3
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->ensureHandlerLocked()V

    .line 272
    sget v1, Lcom/k4/soundtrigger/K4StRetry;->sMode:I

    .line 273
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    sget-object v3, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v2, p0, v3}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 274
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->listenerSaysCall()Z

    move-result p0

    if-nez p0, :cond_28

    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {p0, v2}, Landroid/os/Handler;->hasCallbacks(Ljava/lang/Runnable;)Z

    move-result p0

    if-nez p0, :cond_28

    .line 275
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    const-wide/16 v3, 0xbb8

    invoke-virtual {p0, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 277
    :cond_28
    monitor-exit v0
    :try_end_29
    .catchall {:try_start_3 .. :try_end_29} :catchall_67

    .line 278
    if-nez v1, :cond_44

    .line 279
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

    goto :goto_66

    .line 282
    :cond_44
    const-string p0, "K4StRetry"

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "HAL error during a call or before the audio mode is watched (mode "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "), not rebooting the HAL (shared with call audio); resync reboot once there is no call: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 285
    :goto_66
    return-void

    .line 277
    :catchall_67
    move-exception p0

    :try_start_68
    monitor-exit v0
    :try_end_69
    .catchall {:try_start_68 .. :try_end_69} :catchall_67

    throw p0
.end method

.method private static rebootAll(Ljava/util/List;Ljava/util/List;)V
    .registers 7
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

    .line 523
    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    .line 524
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_9
    :goto_9
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    const-string v2, "K4StRetry"

    if-eqz v1, :cond_2f

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;

    .line 525
    iget-object v3, v1, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;->mUnderlying:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    .line 526
    if-eqz v3, :cond_9

    sget-object v4, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v0, v3, v4}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    if-eqz v3, :cond_24

    goto :goto_9

    .line 528
    :cond_24
    :try_start_24
    invoke-virtual {v1}, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalEnforcer;->reboot()V
    :try_end_27
    .catchall {:try_start_24 .. :try_end_27} :catchall_28

    .line 531
    goto :goto_2e

    .line 529
    :catchall_28
    move-exception v1

    .line 530
    const-string v3, "deferred HAL reboot failed"

    invoke-static {v2, v3, v1}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 532
    :goto_2e
    goto :goto_9

    .line 533
    :cond_2f
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_33
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result p1

    if-eqz p1, :cond_57

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/k4/soundtrigger/K4StRetry$Hung;

    .line 534
    iget-object v1, p1, Lcom/k4/soundtrigger/K4StRetry$Hung;->hal:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    sget-object v3, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v0, v1, v3}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    if-eqz v1, :cond_4a

    goto :goto_33

    .line 536
    :cond_4a
    :try_start_4a
    iget-object p1, p1, Lcom/k4/soundtrigger/K4StRetry$Hung;->hal:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    invoke-virtual {p1}, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;->reboot()V
    :try_end_4f
    .catchall {:try_start_4a .. :try_end_4f} :catchall_50

    .line 539
    goto :goto_56

    .line 537
    :catchall_50
    move-exception p1

    .line 538
    const-string v1, "HAL reboot failed"

    invoke-static {v2, v1, p1}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 540
    :goto_56
    goto :goto_33

    .line 541
    :cond_57
    return-void
.end method

.method public static refused(Ljava/lang/Object;Lcom/android/server/soundtrigger_middleware/HalException;)Ljava/lang/RuntimeException;
    .registers 5

    .line 233
    invoke-virtual {p1}, Lcom/android/server/soundtrigger_middleware/HalException;->toString()Ljava/lang/String;

    move-result-object v0

    .line 234
    iget p1, p1, Lcom/android/server/soundtrigger_middleware/HalException;->errorCode:I

    .line 235
    const/16 v1, -0x13

    if-eq p1, v1, :cond_35

    const/16 v1, -0x10

    if-eq p1, v1, :cond_35

    const/16 v1, -0xc

    if-eq p1, v1, :cond_35

    const/16 v1, -0xb

    if-eq p1, v1, :cond_35

    .line 236
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

    .line 237
    new-instance p0, Lcom/android/server/soundtrigger_middleware/RecoverableException;

    const/4 p1, 0x5

    invoke-direct {p0, p1, v0}, Lcom/android/server/soundtrigger_middleware/RecoverableException;-><init>(ILjava/lang/String;)V

    return-object p0

    .line 239
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

    .line 241
    sget-object p1, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter p1

    .line 242
    :try_start_50
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sPending:Ljava/util/IdentityHashMap;

    sget-object v2, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v1, p0, v2}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 243
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->ensureHandlerLocked()V

    .line 244
    sget-boolean p0, Lcom/k4/soundtrigger/K4StRetry;->sRetryRegisterPosted:Z

    const/4 v1, 0x1

    if-nez p0, :cond_68

    .line 245
    sput-boolean v1, Lcom/k4/soundtrigger/K4StRetry;->sRetryRegisterPosted:Z

    .line 246
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->REGISTER_RETRY:Ljava/lang/Runnable;

    invoke-virtual {p0, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 248
    :cond_68
    monitor-exit p1
    :try_end_69
    .catchall {:try_start_50 .. :try_end_69} :catchall_6f

    .line 249
    new-instance p0, Lcom/android/server/soundtrigger_middleware/RecoverableException;

    invoke-direct {p0, v1, v0}, Lcom/android/server/soundtrigger_middleware/RecoverableException;-><init>(ILjava/lang/String;)V

    return-object p0

    .line 248
    :catchall_6f
    move-exception p0

    :try_start_70
    monitor-exit p1
    :try_end_71
    .catchall {:try_start_70 .. :try_end_71} :catchall_6f

    throw p0
.end method

.method private static registerModeListener()V
    .registers 7

    .line 433
    const-string v0, "K4StRetry"

    sget-boolean v1, Lcom/k4/soundtrigger/K4StRetry;->sModeWatched:Z

    if-eqz v1, :cond_7

    return-void

    .line 437
    :cond_7
    const/4 v1, 0x1

    :try_start_8
    const-string v2, "audio"

    invoke-static {v2}, Landroid/os/ServiceManager;->checkService(Ljava/lang/String;)Landroid/os/IBinder;

    move-result-object v2

    if-eqz v2, :cond_55

    .line 438
    invoke-static {}, Landroid/app/ActivityThread;->currentActivityThread()Landroid/app/ActivityThread;

    move-result-object v2

    invoke-virtual {v2}, Landroid/app/ActivityThread;->getSystemContext()Landroid/app/ContextImpl;

    move-result-object v2

    .line 439
    const-class v3, Landroid/media/AudioManager;

    invoke-virtual {v2, v3}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/media/AudioManager;

    .line 440
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->EXECUTOR:Ljava/util/concurrent/Executor;

    new-instance v4, Lcom/k4/soundtrigger/K4StRetry$8;

    invoke-direct {v4}, Lcom/k4/soundtrigger/K4StRetry$8;-><init>()V

    invoke-virtual {v2, v3, v4}, Landroid/media/AudioManager;->addOnModeChangedListener(Ljava/util/concurrent/Executor;Landroid/media/AudioManager$OnModeChangedListener;)V

    .line 446
    sput-boolean v1, Lcom/k4/soundtrigger/K4StRetry;->sModeWatched:Z

    .line 447
    sput-object v2, Lcom/k4/soundtrigger/K4StRetry;->sAm:Landroid/media/AudioManager;

    .line 448
    const/4 v3, 0x0

    sput v3, Lcom/k4/soundtrigger/K4StRetry;->sModeRegisterTries:I

    .line 449
    invoke-virtual {v2}, Landroid/media/AudioManager;->getMode()I

    move-result v2

    .line 450
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "watching the audio mode for deferred sound trigger HAL reboots (mode "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, ")"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v0, v3}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 451
    invoke-static {v2}, Lcom/k4/soundtrigger/K4StRetry;->onMode(I)V

    .line 460
    goto :goto_b3

    .line 437
    :cond_55
    new-instance v2, Ljava/lang/IllegalStateException;

    const-string v3, "no audio service"

    invoke-direct {v2, v3}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v2
    :try_end_5d
    .catchall {:try_start_8 .. :try_end_5d} :catchall_5d

    .line 452
    :catchall_5d
    move-exception v2

    .line 454
    sget v3, Lcom/k4/soundtrigger/K4StRetry;->sModeRegisterTries:I

    add-int/2addr v3, v1

    sput v3, Lcom/k4/soundtrigger/K4StRetry;->sModeRegisterTries:I

    .line 455
    const/16 v4, 0x3c

    if-eq v3, v1, :cond_6f

    if-eq v3, v4, :cond_6f

    if-le v3, v4, :cond_a5

    rem-int/lit8 v1, v3, 0x14

    if-nez v1, :cond_a5

    .line 456
    :cond_6f
    nop

    .line 457
    if-ge v3, v4, :cond_75

    const-string v1, "1 s"

    goto :goto_77

    :cond_75
    const-string v1, "15 s"

    :goto_77
    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "cannot watch the audio mode yet (attempt "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "), retrying every "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v5, ": "

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 456
    invoke-static {v0, v1}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 459
    :cond_a5
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->REGISTER_MODE:Ljava/lang/Runnable;

    if-ge v3, v4, :cond_ae

    const-wide/16 v2, 0x3e8

    goto :goto_b0

    :cond_ae
    const-wide/16 v2, 0x3a98

    :goto_b0
    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 461
    :goto_b3
    return-void
.end method

.method private static registerRetryListeners()V
    .registers 9

    .line 546
    const-string v1, "K4StRetry"

    :try_start_2
    const-string v0, "audio"

    invoke-static {v0}, Landroid/os/ServiceManager;->checkService(Ljava/lang/String;)Landroid/os/IBinder;

    move-result-object v0

    if-eqz v0, :cond_6d

    .line 547
    invoke-static {}, Landroid/app/ActivityThread;->currentActivityThread()Landroid/app/ActivityThread;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/ActivityThread;->getSystemContext()Landroid/app/ContextImpl;

    move-result-object v2

    .line 548
    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sAudioWatched:Z

    const/4 v8, 0x1

    if-nez v0, :cond_35

    .line 549
    const-class v0, Landroid/media/AudioManager;

    invoke-virtual {v2, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/media/AudioManager;

    .line 550
    invoke-virtual {v0}, Landroid/media/AudioManager;->getActivePlaybackConfigurations()Ljava/util/List;

    move-result-object v3

    invoke-static {v3}, Lcom/k4/soundtrigger/K4StRetry;->anyActive(Ljava/util/List;)Z

    move-result v3

    sput-boolean v3, Lcom/k4/soundtrigger/K4StRetry;->sAudioActive:Z

    .line 551
    new-instance v3, Lcom/k4/soundtrigger/K4StRetry$9;

    invoke-direct {v3}, Lcom/k4/soundtrigger/K4StRetry$9;-><init>()V

    sget-object v4, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    invoke-virtual {v0, v3, v4}, Landroid/media/AudioManager;->registerAudioPlaybackCallback(Landroid/media/AudioManager$AudioPlaybackCallback;Landroid/os/Handler;)V

    .line 564
    sput-boolean v8, Lcom/k4/soundtrigger/K4StRetry;->sAudioWatched:Z

    .line 566
    :cond_35
    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sScreenWatched:Z

    if-nez v0, :cond_4e

    .line 567
    new-instance v3, Lcom/k4/soundtrigger/K4StRetry$10;

    invoke-direct {v3}, Lcom/k4/soundtrigger/K4StRetry$10;-><init>()V

    new-instance v4, Landroid/content/IntentFilter;

    const-string v0, "android.intent.action.SCREEN_OFF"

    invoke-direct {v4, v0}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    sget-object v6, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    const/4 v7, 0x4

    const/4 v5, 0x0

    invoke-virtual/range {v2 .. v7}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;I)Landroid/content/Intent;

    .line 573
    sput-boolean v8, Lcom/k4/soundtrigger/K4StRetry;->sScreenWatched:Z

    .line 575
    :cond_4e
    sget-boolean v0, Lcom/k4/soundtrigger/K4StRetry;->sAudioActive:Z

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "watching playback and screen-off for refused sound models (audio active "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, ")"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 580
    goto :goto_84

    .line 546
    :cond_6d
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v2, "no audio service"

    invoke-direct {v0, v2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_75
    .catchall {:try_start_2 .. :try_end_75} :catchall_75

    .line 576
    :catchall_75
    move-exception v0

    .line 578
    const-string v2, "cannot watch playback / screen state, retrying in 30 s"

    invoke-static {v1, v2, v0}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 579
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->REGISTER_RETRY:Ljava/lang/Runnable;

    const-wide/16 v2, 0x7530

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 581
    :goto_84
    return-void
.end method

.method private static resync()V
    .registers 8

    .line 486
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->currentMode()I

    move-result v0

    .line 487
    const/16 v1, -0x64

    const-wide/16 v2, 0x1388

    const-wide/16 v4, 0x0

    if-ne v0, v1, :cond_34

    .line 489
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 490
    sget-wide v6, Lcom/k4/soundtrigger/K4StRetry;->sUnknownSince:J

    cmp-long v4, v6, v4

    if-nez v4, :cond_18

    sput-wide v0, Lcom/k4/soundtrigger/K4StRetry;->sUnknownSince:J

    .line 491
    :cond_18
    sget-wide v4, Lcom/k4/soundtrigger/K4StRetry;->sUnknownSince:J

    sub-long/2addr v0, v4

    const-wide/32 v4, 0xdbba0

    cmp-long v0, v0, v4

    if-gez v0, :cond_2a

    .line 492
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 493
    return-void

    .line 495
    :cond_2a
    const-string v0, "K4StRetry"

    const-string v1, "audio mode still unknown after 15 min: owed sound trigger HAL reboots run now (stock)"

    invoke-static {v0, v1}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 497
    nop

    .line 498
    const/4 v0, 0x0

    goto :goto_36

    .line 499
    :cond_34
    sput-wide v4, Lcom/k4/soundtrigger/K4StRetry;->sUnknownSince:J

    .line 503
    :goto_36
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v1

    .line 504
    if-eqz v0, :cond_4a

    .line 507
    :try_start_3b
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->listenerSaysCall()Z

    move-result v0

    if-nez v0, :cond_48

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v4, Lcom/k4/soundtrigger/K4StRetry;->RESYNC:Ljava/lang/Runnable;

    invoke-virtual {v0, v4, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 508
    :cond_48
    monitor-exit v1

    return-void

    .line 510
    :cond_4a
    new-instance v0, Ljava/util/ArrayList;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    invoke-virtual {v2}, Ljava/util/IdentityHashMap;->keySet()Ljava/util/Set;

    move-result-object v2

    invoke-direct {v0, v2}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 511
    new-instance v2, Ljava/util/ArrayList;

    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v3}, Ljava/util/IdentityHashMap;->values()Ljava/util/Collection;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 512
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sOwed:Ljava/util/IdentityHashMap;

    invoke-virtual {v3}, Ljava/util/IdentityHashMap;->clear()V

    .line 513
    sget-object v3, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v3}, Ljava/util/IdentityHashMap;->clear()V

    .line 514
    monitor-exit v1
    :try_end_6b
    .catchall {:try_start_3b .. :try_end_6b} :catchall_ac

    .line 515
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_78

    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_78

    return-void

    .line 516
    :cond_78
    const-string v1, "K4StRetry"

    .line 517
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

    .line 516
    invoke-static {v1, v3}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 518
    invoke-static {v0, v2}, Lcom/k4/soundtrigger/K4StRetry;->rebootAll(Ljava/util/List;Ljava/util/List;)V

    .line 519
    return-void

    .line 514
    :catchall_ac
    move-exception v0

    :try_start_ad
    monitor-exit v1
    :try_end_ae
    .catchall {:try_start_ad .. :try_end_ae} :catchall_ac

    throw v0
.end method

.method private static schedule(JLjava/lang/String;)V
    .registers 5

    .line 593
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 594
    :try_start_3
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sPending:Ljava/util/IdentityHashMap;

    invoke-virtual {v1}, Ljava/util/IdentityHashMap;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_d

    monitor-exit v0

    return-void

    .line 595
    :cond_d
    monitor-exit v0
    :try_end_e
    .catchall {:try_start_3 .. :try_end_e} :catchall_1f

    .line 596
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->FIRE:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 597
    sput-object p2, Lcom/k4/soundtrigger/K4StRetry;->sReason:Ljava/lang/String;

    .line 598
    sget-object p2, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->FIRE:Ljava/lang/Runnable;

    invoke-virtual {p2, v0, p0, p1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 599
    return-void

    .line 595
    :catchall_1f
    move-exception p0

    :try_start_20
    monitor-exit v0
    :try_end_21
    .catchall {:try_start_20 .. :try_end_21} :catchall_1f

    throw p0
.end method

.method public static setCallback(Ljava/lang/Object;Lcom/android/server/soundtrigger_middleware/ISoundTriggerHal$GlobalCallback;)V
    .registers 4

    .line 204
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 205
    :try_start_3
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sCallbacks:Ljava/util/IdentityHashMap;

    invoke-virtual {v1, p0, p1}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 206
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->ensureHandlerLocked()V

    .line 207
    monitor-exit v0

    .line 208
    return-void

    .line 207
    :catchall_d
    move-exception p0

    monitor-exit v0
    :try_end_f
    .catchall {:try_start_3 .. :try_end_f} :catchall_d

    throw p0
.end method

.method public static watchdogClosed(Ljava/lang/Object;)V
    .registers 5

    .line 322
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 323
    :try_start_3
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    invoke-virtual {v1, p0}, Ljava/util/IdentityHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/k4/soundtrigger/K4StRetry$Hung;

    .line 324
    if-nez v1, :cond_14

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sClosed:Ljava/util/WeakHashMap;

    sget-object v3, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v2, p0, v3}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 325
    :cond_14
    monitor-exit v0
    :try_end_15
    .catchall {:try_start_3 .. :try_end_15} :catchall_40

    .line 326
    if-eqz v1, :cond_3f

    .line 327
    const-string p0, "K4StRetry"

    .line 328
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

    .line 327
    invoke-static {p0, v0}, Landroid/util/Slog;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 330
    :cond_3f
    return-void

    .line 325
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

    .line 293
    sget-object v0, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v0

    .line 294
    :try_start_3
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->ensureHandlerLocked()V

    .line 297
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sClosed:Ljava/util/WeakHashMap;

    invoke-virtual {v1, p0}, Ljava/util/WeakHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    if-eqz v1, :cond_10

    monitor-exit v0

    return-void

    .line 298
    :cond_10
    monitor-exit v0
    :try_end_11
    .catchall {:try_start_3 .. :try_end_11} :catchall_51

    .line 300
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->currentMode()I

    move-result v0

    const/16 v1, -0x64

    if-ne v0, v1, :cond_1b

    const/4 v0, 0x1

    goto :goto_1c

    :cond_1b
    const/4 v0, 0x0

    .line 301
    :goto_1c
    sget-object v1, Lcom/k4/soundtrigger/K4StRetry;->sLock:Ljava/lang/Object;

    monitor-enter v1

    .line 302
    :try_start_1f
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sClosed:Ljava/util/WeakHashMap;

    invoke-virtual {v2, p0}, Ljava/util/WeakHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_29

    monitor-exit v1

    return-void

    .line 303
    :cond_29
    if-nez v0, :cond_40

    .line 304
    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->sHung:Ljava/util/IdentityHashMap;

    new-instance v3, Lcom/k4/soundtrigger/K4StRetry$Hung;

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v4

    invoke-direct {v3, p1, p2, v4, v5}, Lcom/k4/soundtrigger/K4StRetry$Hung;-><init>(Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;Ljava/lang/Exception;J)V

    invoke-virtual {v2, p0, v3}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 305
    sget-object p0, Lcom/k4/soundtrigger/K4StRetry;->sHandler:Landroid/os/Handler;

    sget-object v2, Lcom/k4/soundtrigger/K4StRetry;->CHECK_HUNG:Ljava/lang/Runnable;

    invoke-virtual {p0, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 307
    :cond_40
    monitor-exit v1
    :try_end_41
    .catchall {:try_start_1f .. :try_end_41} :catchall_4e

    .line 308
    if-eqz v0, :cond_4d

    .line 311
    const-string p0, "SoundTriggerHalWatchdog"

    const-string v0, "HAL deadline expired. Rebooting."

    invoke-static {p0, v0, p2}, Landroid/util/Slog;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 312
    invoke-virtual {p1}, Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;->reboot()V

    .line 314
    :cond_4d
    return-void

    .line 307
    :catchall_4e
    move-exception p0

    :try_start_4f
    monitor-exit v1
    :try_end_50
    .catchall {:try_start_4f .. :try_end_50} :catchall_4e

    throw p0

    .line 298
    :catchall_51
    move-exception p0

    :try_start_52
    monitor-exit v0
    :try_end_53
    .catchall {:try_start_52 .. :try_end_53} :catchall_51

    throw p0
.end method
