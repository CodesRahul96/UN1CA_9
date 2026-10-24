.class final Lcom/k4/homeclock/KeyguardWatch;
.super Ljava/lang/Object;
.source "KeyguardWatch.java"


# static fields
.field private static installed:Z

.field static volatile locked:Z


# direct methods
.method static constructor <clinit>()V
    .registers 1

    .line 17
    const/4 v0, 0x1

    sput-boolean v0, Lcom/k4/homeclock/KeyguardWatch;->locked:Z

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static declared-synchronized ensure(Landroid/content/Context;)Z
    .registers 6

    const-class v0, Lcom/k4/homeclock/KeyguardWatch;

    monitor-enter v0

    .line 24
    :try_start_3
    sget-boolean v1, Lcom/k4/homeclock/KeyguardWatch;->installed:Z
    :try_end_5
    .catchall {:try_start_3 .. :try_end_5} :catchall_60

    const/4 v2, 0x1

    if-eqz v1, :cond_a

    .line 25
    monitor-exit v0

    return v2

    .line 28
    :cond_a
    :try_start_a
    const-class v1, Landroid/app/KeyguardManager;

    invoke-virtual {p0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/KeyguardManager;

    .line 29
    if-nez v1, :cond_1e

    .line 30
    const-string p0, "K4HomeClock"

    const-string v1, "keyguard watch: no KeyguardManager"

    invoke-static {p0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1b
    .catchall {:try_start_a .. :try_end_1b} :catchall_52

    .line 31
    monitor-exit v0

    const/4 p0, 0x0

    return p0

    .line 34
    :cond_1e
    :try_start_1e
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/Context;->getMainExecutor()Ljava/util/concurrent/Executor;

    move-result-object p0

    new-instance v3, Lcom/k4/homeclock/KeyguardWatch$1;

    invoke-direct {v3}, Lcom/k4/homeclock/KeyguardWatch$1;-><init>()V

    invoke-virtual {v1, p0, v3}, Landroid/app/KeyguardManager;->addKeyguardLockedStateListener(Ljava/util/concurrent/Executor;Landroid/app/KeyguardManager$KeyguardLockedStateListener;)V

    .line 46
    sput-boolean v2, Lcom/k4/homeclock/KeyguardWatch;->installed:Z

    .line 47
    invoke-virtual {v1}, Landroid/app/KeyguardManager;->isKeyguardLocked()Z

    move-result p0

    sput-boolean p0, Lcom/k4/homeclock/KeyguardWatch;->locked:Z

    .line 48
    const-string p0, "K4HomeClock"

    sget-boolean v1, Lcom/k4/homeclock/KeyguardWatch;->locked:Z

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "keyguard watch installed, locked="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {p0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_50
    .catchall {:try_start_1e .. :try_end_50} :catchall_52

    .line 49
    monitor-exit v0

    return v2

    .line 50
    :catchall_52
    move-exception p0

    .line 51
    :try_start_53
    sput-boolean v2, Lcom/k4/homeclock/KeyguardWatch;->locked:Z

    .line 52
    const-string v1, "K4HomeClock"

    const-string v2, "keyguard watch: not installed, the shared clock stays off"

    invoke-static {v1, v2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 53
    sget-boolean p0, Lcom/k4/homeclock/KeyguardWatch;->installed:Z
    :try_end_5e
    .catchall {:try_start_53 .. :try_end_5e} :catchall_60

    monitor-exit v0

    return p0

    .line 23
    :catchall_60
    move-exception p0

    :try_start_61
    monitor-exit v0
    :try_end_62
    .catchall {:try_start_61 .. :try_end_62} :catchall_60

    throw p0
.end method
