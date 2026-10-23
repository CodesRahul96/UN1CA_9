.class Lcom/k4/homeclock/KeyguardWatch$1;
.super Ljava/lang/Object;
.source "KeyguardWatch.java"

# interfaces
.implements Landroid/app/KeyguardManager$KeyguardLockedStateListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/k4/homeclock/KeyguardWatch;->ensure(Landroid/content/Context;)Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 35
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onKeyguardLockedStateChanged(Z)V
    .registers 8

    .line 38
    const-class v0, Lcom/k4/homeclock/KeyguardWatch;

    monitor-enter v0

    .line 39
    :try_start_3
    sput-boolean p1, Lcom/k4/homeclock/KeyguardWatch;->locked:Z

    .line 40
    monitor-exit v0
    :try_end_6
    .catchall {:try_start_3 .. :try_end_6} :catchall_1f

    .line 41
    invoke-static {}, Lcom/k4/homeclock/HomeDepthClock;->states()[Lcom/k4/homeclock/EngineState;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_c
    if-ge v2, v1, :cond_1e

    aget-object v3, v0, v2

    .line 42
    if-eqz p1, :cond_15

    const-string v4, "keyguard shown"

    goto :goto_17

    :cond_15
    const-string v4, "keyguard gone"

    :goto_17
    const/4 v5, 0x1

    invoke-virtual {v3, v4, v5}, Lcom/k4/homeclock/EngineState;->redrawIfStale(Ljava/lang/String;Z)V

    .line 41
    add-int/lit8 v2, v2, 0x1

    goto :goto_c

    .line 44
    :cond_1e
    return-void

    .line 40
    :catchall_1f
    move-exception p1

    :try_start_20
    monitor-exit v0
    :try_end_21
    .catchall {:try_start_20 .. :try_end_21} :catchall_1f

    throw p1
.end method
