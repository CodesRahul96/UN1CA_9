.class final Lcom/k4/homeclock/EngineState;
.super Ljava/lang/Object;
.source "EngineState.java"


# instance fields
.field private final context:Landroid/content/Context;

.field private final engine:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Lf3/a;",
            ">;"
        }
    .end annotation
.end field

.field private lastSkip:Ljava/lang/String;

.field private lastSkipAt:J

.field private final main:Landroid/os/Handler;

.field private final reload:Ljava/lang/Runnable;

.field private reloadOn:Z

.field private reloadPending:Z

.field private final reloadReceiver:Landroid/content/BroadcastReceiver;

.field private final tickReceiver:Landroid/content/BroadcastReceiver;

.field private tickerOn:Z

.field private visible:Z


# direct methods
.method static bridge synthetic -$$Nest$fgetengine(Lcom/k4/homeclock/EngineState;)Ljava/lang/ref/WeakReference;
    .registers 1

    iget-object p0, p0, Lcom/k4/homeclock/EngineState;->engine:Ljava/lang/ref/WeakReference;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetmain(Lcom/k4/homeclock/EngineState;)Landroid/os/Handler;
    .registers 1

    iget-object p0, p0, Lcom/k4/homeclock/EngineState;->main:Landroid/os/Handler;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fgetreload(Lcom/k4/homeclock/EngineState;)Ljava/lang/Runnable;
    .registers 1

    iget-object p0, p0, Lcom/k4/homeclock/EngineState;->reload:Ljava/lang/Runnable;

    return-object p0
.end method

.method static bridge synthetic -$$Nest$fputreloadPending(Lcom/k4/homeclock/EngineState;Z)V
    .registers 2

    iput-boolean p1, p0, Lcom/k4/homeclock/EngineState;->reloadPending:Z

    return-void
.end method

.method static bridge synthetic -$$Nest$mcheck(Lcom/k4/homeclock/EngineState;Lf3/a;)V
    .registers 2

    invoke-direct {p0, p1}, Lcom/k4/homeclock/EngineState;->check(Lf3/a;)V

    return-void
.end method

.method static bridge synthetic -$$Nest$mretryWeather(Lcom/k4/homeclock/EngineState;Ljava/lang/String;)V
    .registers 2

    invoke-direct {p0, p1}, Lcom/k4/homeclock/EngineState;->retryWeather(Ljava/lang/String;)V

    return-void
.end method

.method constructor <init>(Lf3/a;)V
    .registers 4

    .line 129
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 31
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/k4/homeclock/EngineState;->main:Landroid/os/Handler;

    .line 38
    new-instance v0, Lcom/k4/homeclock/EngineState$1;

    invoke-direct {v0, p0}, Lcom/k4/homeclock/EngineState$1;-><init>(Lcom/k4/homeclock/EngineState;)V

    iput-object v0, p0, Lcom/k4/homeclock/EngineState;->reload:Ljava/lang/Runnable;

    .line 107
    new-instance v0, Lcom/k4/homeclock/EngineState$2;

    invoke-direct {v0, p0}, Lcom/k4/homeclock/EngineState$2;-><init>(Lcom/k4/homeclock/EngineState;)V

    iput-object v0, p0, Lcom/k4/homeclock/EngineState;->reloadReceiver:Landroid/content/BroadcastReceiver;

    .line 121
    new-instance v0, Lcom/k4/homeclock/EngineState$3;

    invoke-direct {v0, p0}, Lcom/k4/homeclock/EngineState$3;-><init>(Lcom/k4/homeclock/EngineState;)V

    iput-object v0, p0, Lcom/k4/homeclock/EngineState;->tickReceiver:Landroid/content/BroadcastReceiver;

    .line 130
    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    iput-object v0, p0, Lcom/k4/homeclock/EngineState;->engine:Ljava/lang/ref/WeakReference;

    .line 131
    invoke-virtual {p1}, Lf3/a;->getAppContext()Landroid/content/Context;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    iput-object p1, p0, Lcom/k4/homeclock/EngineState;->context:Landroid/content/Context;

    .line 132
    return-void
.end method

.method private check(Lf3/a;)V
    .registers 11

    .line 55
    invoke-virtual {p1}, Lf3/a;->getWhich()I

    move-result v0

    .line 56
    invoke-static {}, Lcom/k4/homeclock/HomeDepthClock;->enabled()Z

    move-result v1

    .line 57
    invoke-static {}, Lcom/k4/homeclock/HomeDepthClock;->sharedEnabled()Z

    move-result v2

    .line 58
    and-int/lit8 v3, v0, 0x1

    if-nez v3, :cond_14

    .line 62
    invoke-direct {p0, v0, v1, v2}, Lcom/k4/homeclock/EngineState;->logNothingToDo(IZZ)V

    .line 63
    return-void

    .line 65
    :cond_14
    iget-object v3, p1, Lf3/a;->g:Lh3/a;

    .line 68
    const/4 v4, 0x0

    const/4 v5, 0x1

    if-eqz v1, :cond_2f

    and-int/lit8 v6, v0, 0x3

    if-eq v6, v5, :cond_2d

    if-eqz v2, :cond_2f

    const/4 v7, 0x3

    if-ne v6, v7, :cond_2f

    if-eqz v3, :cond_2f

    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v6

    const-class v7, Lh3/b;

    if-ne v6, v7, :cond_2f

    :cond_2d
    move v6, v5

    goto :goto_30

    :cond_2f
    move v6, v4

    .line 69
    :goto_30
    invoke-static {p1}, Lcom/k4/homeclock/HomeDepthClock;->clockOf(Lf3/a;)Lcom/k4/homeclock/DepthClock;

    move-result-object v7

    if-nez v7, :cond_3a

    instance-of v7, v3, Lcom/k4/homeclock/HomeClockPresenter;

    if-eqz v7, :cond_3b

    :cond_3a
    move v4, v5

    .line 70
    :cond_3b
    const/4 v5, 0x0

    if-eqz v4, :cond_45

    if-eqz v3, :cond_45

    invoke-static {v3}, Lcom/k4/homeclock/HomeDepthClock;->builtFrom(Lh3/a;)Ljava/lang/String;

    move-result-object v3

    goto :goto_46

    :cond_45
    move-object v3, v5

    .line 71
    :goto_46
    if-eqz v6, :cond_50

    if-eqz v4, :cond_50

    iget-object v5, p0, Lcom/k4/homeclock/EngineState;->context:Landroid/content/Context;

    invoke-static {v5}, Lcom/k4/homeclock/HomeDepthClock;->fingerprint(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v5

    .line 72
    :cond_50
    sget-object v7, Lcom/k4/homeclock/EngineState$4;->$SwitchMap$com$k4$homeclock$ReloadPolicy$Action:[I

    invoke-static {v6, v4, v3, v5}, Lcom/k4/homeclock/ReloadPolicy;->decide(ZZLjava/lang/String;Ljava/lang/String;)Lcom/k4/homeclock/ReloadPolicy$Action;

    move-result-object v5

    invoke-virtual {v5}, Lcom/k4/homeclock/ReloadPolicy$Action;->ordinal()I

    move-result v5

    aget v5, v7, v5

    const-string v7, "reload (which="

    const-string v8, "K4HomeClock"

    packed-switch v5, :pswitch_data_da

    .line 80
    nop

    .line 81
    if-eqz v6, :cond_a2

    if-eqz v4, :cond_a2

    if-nez v3, :cond_8c

    const-string v1, "build settings unknown"

    goto :goto_8e

    .line 77
    :pswitch_6d
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p1, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, "): clock already built from the current settings, no rebuild"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v8, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 78
    return-void

    .line 74
    :pswitch_88
    invoke-direct {p0, v0, v1, v2}, Lcom/k4/homeclock/EngineState;->logNothingToDo(IZZ)V

    .line 75
    return-void

    .line 81
    :cond_8c
    const-string v1, "settings changed since the build"

    :goto_8e
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, ", "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_a4

    :cond_a2
    const-string v1, ""

    :goto_a4
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, ", clock "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " -> "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "): rebuilding the engine"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 80
    invoke-static {v8, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 83
    invoke-virtual {p1}, Lf3/a;->stopSelf()V

    .line 85
    return-void

    :pswitch_data_da
    .packed-switch 0x1
        :pswitch_88
        :pswitch_6d
    .end packed-switch
.end method

.method private logNothingToDo(IZZ)V
    .registers 12

    .line 92
    if-nez p2, :cond_5

    const-string v0, "switch off"

    goto :goto_18

    .line 93
    :cond_5
    and-int/lit8 v0, p1, 0x1

    if-nez v0, :cond_c

    const-string v0, "not a home screen wallpaper"

    goto :goto_18

    .line 94
    :cond_c
    and-int/lit8 v0, p1, 0x3

    const/4 v1, 0x3

    if-ne v0, v1, :cond_16

    if-nez p3, :cond_16

    const-string v0, "home+lock wallpaper, persist.sys.k4.home_depth_clock_shared=0"

    goto :goto_18

    .line 95
    :cond_16
    const-string v0, "no clock for this wallpaper"

    .line 96
    :goto_18
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "/"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 97
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    .line 98
    iget-object v4, p0, Lcom/k4/homeclock/EngineState;->lastSkip:Ljava/lang/String;

    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_4f

    iget-wide v4, p0, Lcom/k4/homeclock/EngineState;->lastSkipAt:J

    sub-long v4, v2, v4

    const-wide/32 v6, 0xea60

    cmp-long v4, v4, v6

    if-gez v4, :cond_4f

    .line 99
    return-void

    .line 101
    :cond_4f
    iput-object v1, p0, Lcom/k4/homeclock/EngineState;->lastSkip:Ljava/lang/String;

    .line 102
    iput-wide v2, p0, Lcom/k4/homeclock/EngineState;->lastSkipAt:J

    .line 103
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "reload (which="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, ", enabled="

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, ", shared="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, "): no clock wanted or shown, nothing to rebuild ("

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, ")"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "K4HomeClock"

    invoke-static {p2, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 105
    return-void
.end method

.method private retryWeather(Ljava/lang/String;)V
    .registers 4

    .line 180
    :try_start_0
    iget-object v0, p0, Lcom/k4/homeclock/EngineState;->engine:Ljava/lang/ref/WeakReference;

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lf3/a;

    .line 181
    if-eqz v0, :cond_14

    iget-boolean v1, p0, Lcom/k4/homeclock/EngineState;->visible:Z

    if-nez v1, :cond_f

    goto :goto_14

    :cond_f
    invoke-static {v0}, Lcom/k4/homeclock/HomeDepthClock;->clockOf(Lf3/a;)Lcom/k4/homeclock/DepthClock;

    move-result-object v0

    goto :goto_15

    :cond_14
    :goto_14
    const/4 v0, 0x0

    .line 182
    :goto_15
    if-eqz v0, :cond_1a

    .line 183
    invoke-virtual {v0, p1}, Lcom/k4/homeclock/DepthClock;->retryWeather(Ljava/lang/String;)V
    :try_end_1a
    .catchall {:try_start_0 .. :try_end_1a} :catchall_1b

    .line 187
    :cond_1a
    goto :goto_23

    .line 185
    :catchall_1b
    move-exception p1

    .line 186
    const-string v0, "K4HomeClock"

    const-string v1, "weather retry"

    invoke-static {v0, v1, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 188
    :goto_23
    return-void
.end method

.method private unregister(Landroid/content/BroadcastReceiver;)V
    .registers 3

    .line 215
    :try_start_0
    iget-object v0, p0, Lcom/k4/homeclock/EngineState;->context:Landroid/content/Context;

    invoke-virtual {v0, p1}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V
    :try_end_5
    .catch Ljava/lang/IllegalArgumentException; {:try_start_0 .. :try_end_5} :catch_6

    .line 217
    goto :goto_7

    .line 216
    :catch_6
    move-exception p1

    .line 218
    :goto_7
    return-void
.end method


# virtual methods
.method redrawIfStale(Ljava/lang/String;)V
    .registers 3

    .line 191
    const/4 v0, 0x0

    invoke-virtual {p0, p1, v0}, Lcom/k4/homeclock/EngineState;->redrawIfStale(Ljava/lang/String;Z)V

    .line 192
    return-void
.end method

.method redrawIfStale(Ljava/lang/String;Z)V
    .registers 8

    .line 197
    const-string v0, "K4HomeClock"

    :try_start_2
    iget-object v1, p0, Lcom/k4/homeclock/EngineState;->engine:Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lf3/a;

    .line 198
    if-nez v1, :cond_e

    const/4 v2, 0x0

    goto :goto_12

    :cond_e
    invoke-static {v1}, Lcom/k4/homeclock/HomeDepthClock;->clockOf(Lf3/a;)Lcom/k4/homeclock/DepthClock;

    move-result-object v2

    .line 199
    :goto_12
    if-eqz v2, :cond_62

    iget-boolean v3, p0, Lcom/k4/homeclock/EngineState;->visible:Z

    if-nez v3, :cond_1b

    if-nez p2, :cond_1b

    goto :goto_62

    .line 202
    :cond_1b
    invoke-virtual {v2}, Lcom/k4/homeclock/DepthClock;->expected()Ljava/lang/String;

    move-result-object p2

    .line 203
    iget-object v3, v2, Lcom/k4/homeclock/DepthClock;->lastDrawn:Ljava/lang/String;

    invoke-virtual {p2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_28

    .line 204
    return-void

    .line 206
    :cond_28
    iget-object v2, v2, Lcom/k4/homeclock/DepthClock;->lastDrawn:Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "redraw ("

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v3, "): \'"

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, "\' -> \'"

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, "\'"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 207
    invoke-virtual {v1}, Lf3/a;->getSurfaceHolder()Landroid/view/SurfaceHolder;

    move-result-object p1

    invoke-virtual {v1, p1}, Lf3/a;->b(Landroid/view/SurfaceHolder;)V
    :try_end_61
    .catchall {:try_start_2 .. :try_end_61} :catchall_63

    .line 210
    goto :goto_69

    .line 200
    :cond_62
    :goto_62
    return-void

    .line 208
    :catchall_63
    move-exception p1

    .line 209
    const-string p2, "redraw"

    invoke-static {v0, p2, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 211
    :goto_69
    return-void
.end method

.method setVisible(Z)V
    .registers 8

    .line 151
    iput-boolean p1, p0, Lcom/k4/homeclock/EngineState;->visible:Z

    .line 152
    if-eqz p1, :cond_16

    iget-boolean v0, p0, Lcom/k4/homeclock/EngineState;->reloadPending:Z

    if-eqz v0, :cond_16

    .line 155
    iget-object v0, p0, Lcom/k4/homeclock/EngineState;->main:Landroid/os/Handler;

    iget-object v1, p0, Lcom/k4/homeclock/EngineState;->reload:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 156
    iget-object v0, p0, Lcom/k4/homeclock/EngineState;->main:Landroid/os/Handler;

    iget-object v1, p0, Lcom/k4/homeclock/EngineState;->reload:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 158
    :cond_16
    iget-object v0, p0, Lcom/k4/homeclock/EngineState;->engine:Ljava/lang/ref/WeakReference;

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lf3/a;

    .line 159
    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz p1, :cond_2c

    if-eqz v0, :cond_2c

    invoke-static {v0}, Lcom/k4/homeclock/HomeDepthClock;->clockOf(Lf3/a;)Lcom/k4/homeclock/DepthClock;

    move-result-object p1

    if-eqz p1, :cond_2c

    move p1, v1

    goto :goto_2d

    :cond_2c
    move p1, v2

    .line 160
    :goto_2d
    if-eqz p1, :cond_54

    iget-boolean v0, p0, Lcom/k4/homeclock/EngineState;->tickerOn:Z

    if-nez v0, :cond_54

    .line 161
    new-instance v0, Landroid/content/IntentFilter;

    const-string v3, "android.intent.action.TIME_TICK"

    invoke-direct {v0, v3}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    .line 162
    const-string v3, "android.intent.action.TIME_SET"

    invoke-virtual {v0, v3}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 163
    const-string v3, "android.intent.action.TIMEZONE_CHANGED"

    invoke-virtual {v0, v3}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 164
    const-string v3, "android.intent.action.LOCALE_CHANGED"

    invoke-virtual {v0, v3}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    .line 165
    iget-object v3, p0, Lcom/k4/homeclock/EngineState;->context:Landroid/content/Context;

    iget-object v4, p0, Lcom/k4/homeclock/EngineState;->tickReceiver:Landroid/content/BroadcastReceiver;

    const/4 v5, 0x4

    invoke-virtual {v3, v4, v0, v5}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;I)Landroid/content/Intent;

    .line 166
    iput-boolean v1, p0, Lcom/k4/homeclock/EngineState;->tickerOn:Z

    goto :goto_62

    .line 167
    :cond_54
    if-nez p1, :cond_62

    iget-boolean v0, p0, Lcom/k4/homeclock/EngineState;->tickerOn:Z

    if-eqz v0, :cond_62

    .line 168
    iget-object v0, p0, Lcom/k4/homeclock/EngineState;->tickReceiver:Landroid/content/BroadcastReceiver;

    invoke-direct {p0, v0}, Lcom/k4/homeclock/EngineState;->unregister(Landroid/content/BroadcastReceiver;)V

    .line 169
    iput-boolean v2, p0, Lcom/k4/homeclock/EngineState;->tickerOn:Z

    goto :goto_63

    .line 167
    :cond_62
    :goto_62
    nop

    .line 171
    :goto_63
    if-eqz p1, :cond_6d

    .line 172
    const-string p1, "visible"

    invoke-virtual {p0, p1, v2}, Lcom/k4/homeclock/EngineState;->redrawIfStale(Ljava/lang/String;Z)V

    .line 173
    invoke-direct {p0, p1}, Lcom/k4/homeclock/EngineState;->retryWeather(Ljava/lang/String;)V

    .line 175
    :cond_6d
    return-void
.end method

.method start()V
    .registers 7

    .line 135
    new-instance v2, Landroid/content/IntentFilter;

    const-string v0, "com.k4.homeclock.action.RELOAD"

    invoke-direct {v2, v0}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    .line 136
    iget-object v0, p0, Lcom/k4/homeclock/EngineState;->context:Landroid/content/Context;

    iget-object v1, p0, Lcom/k4/homeclock/EngineState;->reloadReceiver:Landroid/content/BroadcastReceiver;

    const/4 v4, 0x0

    const/4 v5, 0x2

    const-string v3, "android.permission.WRITE_SECURE_SETTINGS"

    invoke-virtual/range {v0 .. v5}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;Ljava/lang/String;Landroid/os/Handler;I)Landroid/content/Intent;

    .line 137
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/k4/homeclock/EngineState;->reloadOn:Z

    .line 138
    return-void
.end method

.method stop()V
    .registers 3

    .line 141
    iget-object v0, p0, Lcom/k4/homeclock/EngineState;->main:Landroid/os/Handler;

    iget-object v1, p0, Lcom/k4/homeclock/EngineState;->reload:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 142
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/k4/homeclock/EngineState;->reloadPending:Z

    .line 143
    invoke-virtual {p0, v0}, Lcom/k4/homeclock/EngineState;->setVisible(Z)V

    .line 144
    iget-boolean v1, p0, Lcom/k4/homeclock/EngineState;->reloadOn:Z

    if-eqz v1, :cond_18

    .line 145
    iget-object v1, p0, Lcom/k4/homeclock/EngineState;->reloadReceiver:Landroid/content/BroadcastReceiver;

    invoke-direct {p0, v1}, Lcom/k4/homeclock/EngineState;->unregister(Landroid/content/BroadcastReceiver;)V

    .line 146
    iput-boolean v0, p0, Lcom/k4/homeclock/EngineState;->reloadOn:Z

    .line 148
    :cond_18
    return-void
.end method
