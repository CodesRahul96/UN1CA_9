.class public Lcom/k4/settings/display/K4PureBlackPreferenceController;
.super Lcom/android/settings/display/HdrBrightnessPreferenceController;

# interfaces
.implements Ljava/lang/Runnable;

# Settings > Display > "Pure black dark mode" (a52sxq pure_black_theme patch): enables or disables the runtime resource
# overlay com.k4.overlay.pureblack (target "android") for the current user through OverlayManager; the overlay
# manager persists the state, so it survives a reboot. Settings runs as android.uid.system, which may switch any
# mutable overlay. The switch is hidden when the overlay package is not installed.
#
# The parent is only borrowed as a complete, concrete TogglePreferenceController: this R8-processed SecSettings
# leaves several BasePreferenceController / Sliceable methods abstract and gives every controller its own copies
# (see the hfr patch). Everything the parent does itself (availability, isChecked, setChecked) is overridden here.
#
# setEnabled() on an overlay for "android" rebuilds the idmap and pushes a configuration change to every process, so
# it runs on a worker thread. There is only one such worker at a time (for every controller instance): it applies the
# newest requested state and goes again if a newer request came in during its binder call, so the last tap wins.
# While it runs isChecked() reports the requested state, not the old one. Source: src/ (src/build.sh).


# static fields
.field private static sRunning:Z

.field private static sSeq:I

.field private static sWant:Z


# direct methods
.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    invoke-direct {p0, p1, p2}, Lcom/android/settings/display/HdrBrightnessPreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method private info()Landroid/content/om/OverlayInfo;
    .registers 4

    const/4 v0, 0x0

    :try_start_1
    iget-object p0, p0, Lcom/k4/settings/display/K4PureBlackPreferenceController;->mContext:Landroid/content/Context;

    const-class v1, Landroid/content/om/OverlayManager;

    invoke-virtual {p0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/content/om/OverlayManager;

    if-nez p0, :cond_e

    return-object v0

    :cond_e
    const-string v1, "com.k4.overlay.pureblack"

    invoke-static {}, Landroid/os/Process;->myUserHandle()Landroid/os/UserHandle;

    move-result-object v2

    invoke-virtual {p0, v1, v2}, Landroid/content/om/OverlayManager;->getOverlayInfo(Ljava/lang/String;Landroid/os/UserHandle;)Landroid/content/om/OverlayInfo;

    move-result-object p0
    :try_end_18
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_18} :catch_19

    return-object p0

    :catch_19
    return-object v0
.end method


# virtual methods
.method public getAvailabilityStatus()I
    .registers 1

    invoke-direct {p0}, Lcom/k4/settings/display/K4PureBlackPreferenceController;->info()Landroid/content/om/OverlayInfo;

    move-result-object p0

    if-eqz p0, :cond_8

    const/4 p0, 0x0

    return p0

    :cond_8
    const/4 p0, 0x3

    return p0
.end method

.method public isChecked()Z
    .registers 3

    const-class v0, Lcom/k4/settings/display/K4PureBlackPreferenceController;

    monitor-enter v0

    :try_start_3
    sget-boolean v1, Lcom/k4/settings/display/K4PureBlackPreferenceController;->sRunning:Z

    if-eqz v1, :cond_b

    sget-boolean p0, Lcom/k4/settings/display/K4PureBlackPreferenceController;->sWant:Z

    monitor-exit v0

    return p0

    :cond_b
    monitor-exit v0
    :try_end_c
    .catchall {:try_start_3 .. :try_end_c} :catchall_1c

    invoke-direct {p0}, Lcom/k4/settings/display/K4PureBlackPreferenceController;->info()Landroid/content/om/OverlayInfo;

    move-result-object p0

    if-eqz p0, :cond_1a

    invoke-virtual {p0}, Landroid/content/om/OverlayInfo;->isEnabled()Z

    move-result p0

    if-eqz p0, :cond_1a

    const/4 p0, 0x1

    return p0

    :cond_1a
    const/4 p0, 0x0

    return p0

    :catchall_1c
    move-exception p0

    :try_start_1d
    monitor-exit v0
    :try_end_1e
    .catchall {:try_start_1d .. :try_end_1e} :catchall_1c

    throw p0
.end method

.method public run()V
    .registers 6

    :goto_0
    const-class v0, Lcom/k4/settings/display/K4PureBlackPreferenceController;

    monitor-enter v0

    :try_start_3
    sget-boolean v1, Lcom/k4/settings/display/K4PureBlackPreferenceController;->sWant:Z

    sget v2, Lcom/k4/settings/display/K4PureBlackPreferenceController;->sSeq:I

    monitor-exit v0
    :try_end_8
    .catchall {:try_start_3 .. :try_end_8} :catchall_35

    :try_start_8
    iget-object v0, p0, Lcom/k4/settings/display/K4PureBlackPreferenceController;->mContext:Landroid/content/Context;

    const-class v3, Landroid/content/om/OverlayManager;

    invoke-virtual {v0, v3}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/om/OverlayManager;

    const-string v3, "com.k4.overlay.pureblack"

    invoke-static {}, Landroid/os/Process;->myUserHandle()Landroid/os/UserHandle;

    move-result-object v4

    invoke-virtual {v0, v3, v1, v4}, Landroid/content/om/OverlayManager;->setEnabled(Ljava/lang/String;ZLandroid/os/UserHandle;)V
    :try_end_1b
    .catch Ljava/lang/RuntimeException; {:try_start_8 .. :try_end_1b} :catch_1c

    goto :goto_24

    :catch_1c
    move-exception v0

    const-string v1, "K4PureBlack"

    const-string v3, "Could not switch the pure black overlay"

    invoke-static {v1, v3, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_24
    const-class v1, Lcom/k4/settings/display/K4PureBlackPreferenceController;

    monitor-enter v1

    :try_start_27
    sget v0, Lcom/k4/settings/display/K4PureBlackPreferenceController;->sSeq:I

    if-ne v0, v2, :cond_30

    const/4 p0, 0x0

    sput-boolean p0, Lcom/k4/settings/display/K4PureBlackPreferenceController;->sRunning:Z

    monitor-exit v1

    return-void

    :cond_30
    monitor-exit v1

    goto :goto_0

    :catchall_32
    move-exception p0

    monitor-exit v1
    :try_end_34
    .catchall {:try_start_27 .. :try_end_34} :catchall_32

    throw p0

    :catchall_35
    move-exception p0

    :try_start_36
    monitor-exit v0
    :try_end_37
    .catchall {:try_start_36 .. :try_end_37} :catchall_35

    throw p0
.end method

.method public setChecked(Z)Z
    .registers 4

    const-class v0, Lcom/k4/settings/display/K4PureBlackPreferenceController;

    monitor-enter v0

    :try_start_3
    sput-boolean p1, Lcom/k4/settings/display/K4PureBlackPreferenceController;->sWant:Z

    sget p1, Lcom/k4/settings/display/K4PureBlackPreferenceController;->sSeq:I

    const/4 v1, 0x1

    add-int/2addr p1, v1

    sput p1, Lcom/k4/settings/display/K4PureBlackPreferenceController;->sSeq:I

    sget-boolean p1, Lcom/k4/settings/display/K4PureBlackPreferenceController;->sRunning:Z

    sput-boolean v1, Lcom/k4/settings/display/K4PureBlackPreferenceController;->sRunning:Z

    monitor-exit v0
    :try_end_10
    .catchall {:try_start_3 .. :try_end_10} :catchall_1d

    if-nez p1, :cond_1c

    new-instance p1, Ljava/lang/Thread;

    const-string v0, "K4PureBlack"

    invoke-direct {p1, p0, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/Thread;->start()V

    :cond_1c
    return v1

    :catchall_1d
    move-exception p0

    :try_start_1e
    monitor-exit v0
    :try_end_1f
    .catchall {:try_start_1e .. :try_end_1f} :catchall_1d

    throw p0
.end method
