.class public final Lcom/k4/homeclock/HomeDepthClock;
.super Ljava/lang/Object;
.source "HomeDepthClock.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/k4/homeclock/HomeDepthClock$PostDim;
    }
.end annotation


# static fields
.field public static final ACTION_RELOAD:Ljava/lang/String; = "com.k4.homeclock.action.RELOAD"

.field private static final BUILT:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lh3/a;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private static final CLOCKS:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lh3/a;",
            "Lcom/k4/homeclock/DepthClock;",
            ">;"
        }
    .end annotation
.end field

.field private static final ENGINES:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lf3/a;",
            "Lcom/k4/homeclock/EngineState;",
            ">;"
        }
    .end annotation
.end field

.field public static final EXTRA_WALLPAPER_PENDING:Ljava/lang/String; = "com.k4.homeclock.extra.WALLPAPER_PENDING"

.field private static final POST_DIM:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lf3/a;",
            "Ljava/lang/Boolean;",
            ">;"
        }
    .end annotation
.end field

.field static final PROP:Ljava/lang/String; = "persist.sys.k4.home_depth_clock"

.field static final RELOAD_PERMISSION:Ljava/lang/String; = "android.permission.WRITE_SECURE_SETTINGS"

.field static final TAG:Ljava/lang/String; = "K4HomeClock"


# direct methods
.method static constructor <clinit>()V
    .registers 1

    .line 44
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/k4/homeclock/HomeDepthClock;->ENGINES:Ljava/util/Map;

    .line 45
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/k4/homeclock/HomeDepthClock;->CLOCKS:Ljava/util/Map;

    .line 156
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/k4/homeclock/HomeDepthClock;->BUILT:Ljava/util/Map;

    .line 231
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/k4/homeclock/HomeDepthClock;->POST_DIM:Ljava/util/Map;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 47
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static afterBuild(Lh3/a;)V
    .registers 16

    .line 95
    const-string v1, "K4HomeClock"

    :try_start_2
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-class v2, Lh3/b;

    if-eq v0, v2, :cond_b

    .line 96
    return-void

    .line 101
    :cond_b
    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/k4/homeclock/HomeDepthClock;->setClock(Lh3/a;Lcom/k4/homeclock/DepthClock;)V

    .line 102
    invoke-static {p0, v0}, Lcom/k4/homeclock/HomeDepthClock;->built(Lh3/a;Ljava/lang/String;)V

    .line 103
    iget v2, p0, Lh3/a;->c:I

    const/4 v3, 0x3

    and-int/2addr v2, v3

    if-ne v2, v3, :cond_ce

    invoke-static {}, Lcom/k4/homeclock/HomeDepthClock;->enabled()Z

    move-result v2

    if-eqz v2, :cond_ce

    invoke-static {}, Lcom/k4/homeclock/HomeDepthClock;->sharedEnabled()Z

    move-result v2

    if-nez v2, :cond_26

    goto/16 :goto_ce

    .line 106
    :cond_26
    iget-object v2, p0, Lh3/a;->e:Lg0/a;

    .line 107
    if-nez v2, :cond_2b

    .line 108
    return-void

    .line 110
    :cond_2b
    iget-object v3, p0, Lh3/a;->f:Li3/k;

    iget-object v3, v3, Li3/k;->c:Ljava/util/ArrayList;

    .line 111
    iget-object v4, v2, Lg0/a;->d:Ljava/lang/Object;

    if-nez v4, :cond_35

    const/4 v4, -0x1

    goto :goto_3b

    :cond_35
    iget-object v4, v2, Lg0/a;->d:Ljava/lang/Object;

    invoke-virtual {v3, v4}, Ljava/util/ArrayList;->indexOf(Ljava/lang/Object;)I

    move-result v4

    .line 112
    :goto_3b
    if-gez v4, :cond_41

    .line 113
    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v4

    .line 116
    :cond_41
    iget-object v5, p0, Lh3/a;->a:Landroid/content/Context;

    invoke-static {v5}, Lcom/k4/homeclock/KeyguardWatch;->ensure(Landroid/content/Context;)Z

    move-result v5
    :try_end_47
    .catchall {:try_start_2 .. :try_end_47} :catchall_cf

    const-string v6, "shared home+lock wallpaper (which="

    if-nez v5, :cond_68

    .line 117
    :try_start_4b
    iget p0, p0, Lh3/a;->c:I

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, "): keyguard state unavailable, no clock"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 118
    return-void

    .line 120
    :cond_68
    iget-object v5, v2, Lg0/a;->d:Ljava/lang/Object;

    instance-of v5, v5, Li3/c;

    if-eqz v5, :cond_73

    iget-object v5, v2, Lg0/a;->d:Ljava/lang/Object;

    check-cast v5, Li3/c;

    goto :goto_74

    :cond_73
    move-object v5, v0

    .line 121
    :goto_74
    iget-object v7, v2, Lg0/a;->c:Ljava/lang/Object;

    instance-of v7, v7, Li3/c;

    if-eqz v7, :cond_7e

    iget-object v0, v2, Lg0/a;->c:Ljava/lang/Object;

    check-cast v0, Li3/c;

    :cond_7e
    move-object v12, v0

    .line 122
    iget-object v0, p0, Lh3/a;->a:Landroid/content/Context;

    invoke-static {v0}, Lcom/k4/homeclock/HomeDepthClock;->fingerprint(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 123
    iget-object v7, p0, Lh3/a;->a:Landroid/content/Context;

    iget v8, p0, Lh3/a;->g:I

    iget v9, p0, Lh3/a;->h:I

    invoke-static {v5}, Lcom/k4/homeclock/HomeClockPresenter;->subjectTop(Li3/c;)F

    move-result v10

    const/4 v11, 0x0

    const/4 v14, 0x1

    move-object v13, p0

    invoke-static/range {v7 .. v14}, Lcom/k4/homeclock/HomeDepthClock;->makeClock(Landroid/content/Context;IIFLandroid/graphics/Bitmap;Li3/c;Lh3/a;Z)Lcom/k4/homeclock/DepthClock;

    move-result-object p0

    .line 124
    invoke-virtual {v3, v4, p0}, Ljava/util/ArrayList;->add(ILjava/lang/Object;)V

    .line 125
    invoke-static {v13, p0}, Lcom/k4/homeclock/HomeDepthClock;->setClock(Lh3/a;Lcom/k4/homeclock/DepthClock;)V

    .line 126
    invoke-static {v13, v0}, Lcom/k4/homeclock/HomeDepthClock;->built(Lh3/a;Ljava/lang/String;)V

    .line 127
    iget p0, v13, Lh3/a;->c:I

    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I

    move-result v0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v2, "): gated clock at layer "

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v2, "/"

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_cd
    .catchall {:try_start_4b .. :try_end_cd} :catchall_cf

    .line 130
    goto :goto_d6

    .line 104
    :cond_ce
    :goto_ce
    return-void

    .line 128
    :catchall_cf
    move-exception v0

    move-object p0, v0

    .line 129
    const-string v0, "afterBuild"

    invoke-static {v1, v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 131
    :goto_d6
    return-void
.end method

.method static built(Lh3/a;Ljava/lang/String;)V
    .registers 4

    .line 179
    sget-object v0, Lcom/k4/homeclock/HomeDepthClock;->BUILT:Ljava/util/Map;

    monitor-enter v0

    .line 180
    if-nez p1, :cond_b

    .line 181
    :try_start_5
    sget-object p1, Lcom/k4/homeclock/HomeDepthClock;->BUILT:Ljava/util/Map;

    invoke-interface {p1, p0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_10

    .line 183
    :cond_b
    sget-object v1, Lcom/k4/homeclock/HomeDepthClock;->BUILT:Ljava/util/Map;

    invoke-interface {v1, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 185
    :goto_10
    monitor-exit v0

    .line 186
    return-void

    .line 185
    :catchall_12
    move-exception p0

    monitor-exit v0
    :try_end_14
    .catchall {:try_start_5 .. :try_end_14} :catchall_12

    throw p0
.end method

.method static builtFrom(Lh3/a;)Ljava/lang/String;
    .registers 3

    .line 189
    sget-object v0, Lcom/k4/homeclock/HomeDepthClock;->BUILT:Ljava/util/Map;

    monitor-enter v0

    .line 190
    :try_start_3
    sget-object v1, Lcom/k4/homeclock/HomeDepthClock;->BUILT:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/String;

    monitor-exit v0

    return-object p0

    .line 191
    :catchall_d
    move-exception p0

    monitor-exit v0
    :try_end_f
    .catchall {:try_start_3 .. :try_end_f} :catchall_d

    throw p0
.end method

.method static clockOf(Lf3/a;)Lcom/k4/homeclock/DepthClock;
    .registers 3

    .line 209
    sget-object v0, Lcom/k4/homeclock/HomeDepthClock;->CLOCKS:Ljava/util/Map;

    monitor-enter v0

    .line 210
    :try_start_3
    iget-object v1, p0, Lf3/a;->g:Lh3/a;

    if-nez v1, :cond_9

    const/4 p0, 0x0

    goto :goto_13

    :cond_9
    sget-object v1, Lcom/k4/homeclock/HomeDepthClock;->CLOCKS:Ljava/util/Map;

    iget-object p0, p0, Lf3/a;->g:Lh3/a;

    invoke-interface {v1, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/k4/homeclock/DepthClock;

    :goto_13
    monitor-exit v0

    return-object p0

    .line 211
    :catchall_15
    move-exception p0

    monitor-exit v0
    :try_end_17
    .catchall {:try_start_3 .. :try_end_17} :catchall_15

    throw p0
.end method

.method static dimOf(Lf3/a;)F
    .registers 2

    .line 257
    iget-object p0, p0, Lf3/a;->j:Li3/e;

    .line 258
    if-eqz p0, :cond_17

    iget-boolean v0, p0, Li3/e;->c:Z

    if-eqz v0, :cond_17

    iget v0, p0, Li3/e;->d:I

    if-eqz v0, :cond_17

    iget p0, p0, Li3/e;->d:I

    invoke-static {p0}, Landroid/graphics/Color;->alpha(I)I

    move-result p0

    int-to-float p0, p0

    const/high16 v0, 0x437f0000    # 255.0f

    div-float/2addr p0, v0

    goto :goto_18

    :cond_17
    const/4 p0, 0x0

    :goto_18
    return p0
.end method

.method public static enabled()Z
    .registers 2

    .line 59
    const-string v0, "persist.sys.k4.home_depth_clock"

    invoke-static {v0}, Lcom/k4/homeclock/HomeDepthClock;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 60
    const-string v1, "1"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_19

    const-string v1, "true"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_17

    goto :goto_19

    :cond_17
    const/4 v0, 0x0

    goto :goto_1a

    :cond_19
    :goto_19
    const/4 v0, 0x1

    :goto_1a
    return v0
.end method

.method static engineOf(Lh3/a;)Lf3/a;
    .registers 5

    .line 215
    sget-object v0, Lcom/k4/homeclock/HomeDepthClock;->ENGINES:Ljava/util/Map;

    monitor-enter v0

    .line 216
    :try_start_3
    sget-object v1, Lcom/k4/homeclock/HomeDepthClock;->ENGINES:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_d
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_22

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lf3/a;

    .line 217
    if-eqz v2, :cond_21

    iget-object v3, v2, Lf3/a;->g:Lh3/a;

    if-ne v3, p0, :cond_21

    .line 218
    monitor-exit v0

    return-object v2

    .line 220
    :cond_21
    goto :goto_d

    .line 221
    :cond_22
    monitor-exit v0

    .line 222
    const/4 p0, 0x0

    return-object p0

    .line 221
    :catchall_25
    move-exception p0

    monitor-exit v0
    :try_end_27
    .catchall {:try_start_3 .. :try_end_27} :catchall_25

    throw p0
.end method

.method static fingerprint(Landroid/content/Context;)Ljava/lang/String;
    .registers 9

    .line 165
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    .line 166
    const-string v0, "k4_home_clock_item"

    .line 167
    invoke-static {p0, v0}, Landroid/provider/Settings$System;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v0, "k4_home_clock_item_rect"

    .line 168
    invoke-static {p0, v0}, Landroid/provider/Settings$System;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const-string v0, "k4_home_clock_bundle"

    .line 169
    invoke-static {p0, v0}, Landroid/provider/Settings$System;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    const-string p0, "persist.sys.k4.home_depth_clock"

    .line 170
    invoke-static {p0}, Lcom/k4/homeclock/HomeDepthClock;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string p0, "persist.sys.k4.home_depth_clock_shared"

    invoke-static {p0}, Lcom/k4/homeclock/HomeDepthClock;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const-string p0, "persist.sys.k4.home_depth_clock_y"

    invoke-static {p0}, Lcom/k4/homeclock/HomeDepthClock;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    const-string p0, "persist.sys.k4.home_depth_clock_color"

    invoke-static {p0}, Lcom/k4/homeclock/HomeDepthClock;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    filled-new-array/range {v1 .. v7}, [Ljava/lang/String;

    move-result-object p0

    .line 166
    invoke-static {p0}, Lcom/k4/homeclock/ReloadPolicy;->fingerprint([Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0
    :try_end_36
    .catchall {:try_start_0 .. :try_end_36} :catchall_37

    return-object p0

    .line 171
    :catchall_37
    move-exception v0

    move-object p0, v0

    .line 172
    const-string v0, "K4HomeClock"

    const-string v1, "clock settings fingerprint"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 173
    const/4 p0, 0x0

    return-object p0
.end method

.method static homeCapable(I)Z
    .registers 2

    .line 75
    const/4 v0, 0x1

    and-int/2addr p0, v0

    if-eqz p0, :cond_5

    goto :goto_6

    :cond_5
    const/4 v0, 0x0

    :goto_6
    return v0
.end method

.method static makeClock(Landroid/content/Context;IIFLandroid/graphics/Bitmap;Li3/c;Lh3/a;Z)Lcom/k4/homeclock/DepthClock;
    .registers 18

    .line 140
    new-instance v1, Lcom/k4/homeclock/ClockNode;

    move-object v2, p0

    move v3, p1

    move v4, p2

    move v5, p3

    move-object v6, p4

    move-object v7, p5

    move-object/from16 v8, p6

    move/from16 v9, p7

    invoke-direct/range {v1 .. v9}, Lcom/k4/homeclock/ClockNode;-><init>(Landroid/content/Context;IIFLandroid/graphics/Bitmap;Li3/c;Lh3/a;Z)V

    .line 141
    invoke-static {p0}, Lcom/k4/homeclock/HomeClockItem;->read(Landroid/content/Context;)Lcom/k4/homeclock/HomeClockItem;

    move-result-object v3

    .line 142
    const-string p3, "K4HomeClock"

    if-nez v3, :cond_1d

    .line 143
    const-string p0, "no saved home clock item: plain clock"

    invoke-static {p3, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 144
    return-object v1

    .line 147
    :cond_1d
    move-object v0, p0

    move v2, p2

    move-object v4, p4

    move-object v6, p5

    move-object/from16 v7, p6

    move/from16 v8, p7

    move-object v5, v1

    move v1, p1

    :try_start_27
    invoke-static/range {v0 .. v8}, Lcom/k4/homeclock/AodClockNode;->create(Landroid/content/Context;IILcom/k4/homeclock/HomeClockItem;Landroid/graphics/Bitmap;Lcom/k4/homeclock/ClockNode;Li3/c;Lh3/a;Z)Lcom/k4/homeclock/AodClockNode;

    move-result-object p0
    :try_end_2b
    .catchall {:try_start_27 .. :try_end_2b} :catchall_2c

    return-object p0

    .line 148
    :catchall_2c
    move-exception v0

    move-object v1, v5

    move-object p0, v0

    .line 149
    instance-of p1, p0, Ljava/lang/reflect/InvocationTargetException;

    if-eqz p1, :cond_3d

    invoke-virtual {p0}, Ljava/lang/Throwable;->getCause()Ljava/lang/Throwable;

    move-result-object p1

    if-eqz p1, :cond_3d

    invoke-virtual {p0}, Ljava/lang/Throwable;->getCause()Ljava/lang/Throwable;

    move-result-object p0

    .line 150
    :cond_3d
    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p4, "AOD clock unavailable, plain clock ("

    invoke-virtual {p2, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, ")"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p3, p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 151
    return-object v1
.end method

.method public static onCreate(Lf3/a;)V
    .registers 4

    .line 282
    :try_start_0
    invoke-virtual {p0}, Lf3/a;->getWhich()I

    move-result v0

    invoke-static {v0}, Lcom/k4/homeclock/HomeDepthClock;->homeCapable(I)Z

    move-result v0

    if-nez v0, :cond_b

    .line 283
    return-void

    .line 285
    :cond_b
    iget-object v0, p0, Lf3/a;->g:Lh3/a;

    instance-of v0, v0, Lcom/k4/homeclock/HomeClockPresenter;
    :try_end_f
    .catchall {:try_start_0 .. :try_end_f} :catchall_77

    if-eqz v0, :cond_62

    .line 291
    :try_start_11
    invoke-virtual {p0}, Lf3/a;->d()Z
    :try_end_14
    .catchall {:try_start_11 .. :try_end_14} :catchall_15

    .line 294
    goto :goto_1d

    .line 292
    :catchall_15
    move-exception v0

    .line 293
    :try_start_16
    const-string v1, "K4HomeClock"

    const-string v2, "dark mode dim"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_1d
    .catchall {:try_start_16 .. :try_end_1d} :catchall_77

    .line 296
    :goto_1d
    :try_start_1d
    iget-object v0, p0, Lf3/a;->h:Li3/k;

    if-eqz v0, :cond_52

    iget-object v0, p0, Lf3/a;->h:Li3/k;

    iget-object v0, v0, Li3/k;->c:Ljava/util/ArrayList;

    if-eqz v0, :cond_52

    iget-object v0, p0, Lf3/a;->j:Li3/e;

    if-eqz v0, :cond_52

    iget-object v0, p0, Lf3/a;->h:Li3/k;

    iget-object v0, v0, Li3/k;->c:Ljava/util/ArrayList;

    iget-object v1, p0, Lf3/a;->j:Li3/e;

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_52

    .line 297
    iget-object v0, p0, Lf3/a;->h:Li3/k;

    iget-object v0, v0, Li3/k;->c:Ljava/util/ArrayList;

    new-instance v1, Lcom/k4/homeclock/HomeDepthClock$PostDim;

    invoke-direct {v1, p0}, Lcom/k4/homeclock/HomeDepthClock$PostDim;-><init>(Lf3/a;)V

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 298
    sget-object v0, Lcom/k4/homeclock/HomeDepthClock;->POST_DIM:Ljava/util/Map;

    monitor-enter v0
    :try_end_46
    .catchall {:try_start_1d .. :try_end_46} :catchall_5a

    .line 299
    :try_start_46
    sget-object v1, Lcom/k4/homeclock/HomeDepthClock;->POST_DIM:Ljava/util/Map;

    sget-object v2, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-interface {v1, p0, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 300
    monitor-exit v0

    goto :goto_59

    :catchall_4f
    move-exception v1

    monitor-exit v0
    :try_end_51
    .catchall {:try_start_46 .. :try_end_51} :catchall_4f

    :try_start_51
    throw v1

    .line 302
    :cond_52
    const-string v0, "K4HomeClock"

    const-string v1, "no DarkModeNode in the engine\'s node list: clock drawn under the dark mode dim"

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_59
    .catchall {:try_start_51 .. :try_end_59} :catchall_5a

    .line 306
    :goto_59
    goto :goto_62

    .line 304
    :catchall_5a
    move-exception v0

    .line 305
    :try_start_5b
    const-string v1, "K4HomeClock"

    const-string v2, "post-dim node"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 308
    :cond_62
    :goto_62
    new-instance v0, Lcom/k4/homeclock/EngineState;

    invoke-direct {v0, p0}, Lcom/k4/homeclock/EngineState;-><init>(Lf3/a;)V

    .line 309
    sget-object v1, Lcom/k4/homeclock/HomeDepthClock;->ENGINES:Ljava/util/Map;

    monitor-enter v1
    :try_end_6a
    .catchall {:try_start_5b .. :try_end_6a} :catchall_77

    .line 310
    :try_start_6a
    sget-object v2, Lcom/k4/homeclock/HomeDepthClock;->ENGINES:Ljava/util/Map;

    invoke-interface {v2, p0, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 311
    monitor-exit v1
    :try_end_70
    .catchall {:try_start_6a .. :try_end_70} :catchall_74

    .line 312
    :try_start_70
    invoke-virtual {v0}, Lcom/k4/homeclock/EngineState;->start()V
    :try_end_73
    .catchall {:try_start_70 .. :try_end_73} :catchall_77

    .line 315
    goto :goto_7f

    .line 311
    :catchall_74
    move-exception p0

    :try_start_75
    monitor-exit v1
    :try_end_76
    .catchall {:try_start_75 .. :try_end_76} :catchall_74

    :try_start_76
    throw p0
    :try_end_77
    .catchall {:try_start_76 .. :try_end_77} :catchall_77

    .line 313
    :catchall_77
    move-exception p0

    .line 314
    const-string v0, "K4HomeClock"

    const-string v1, "onCreate"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 316
    :goto_7f
    return-void
.end method

.method public static onDestroy(Lf3/a;)V
    .registers 4

    .line 335
    :try_start_0
    sget-object v0, Lcom/k4/homeclock/HomeDepthClock;->ENGINES:Ljava/util/Map;

    monitor-enter v0
    :try_end_3
    .catchall {:try_start_0 .. :try_end_3} :catchall_2d

    .line 336
    :try_start_3
    sget-object v1, Lcom/k4/homeclock/HomeDepthClock;->ENGINES:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/k4/homeclock/EngineState;

    .line 337
    monitor-exit v0
    :try_end_c
    .catchall {:try_start_3 .. :try_end_c} :catchall_2a

    .line 338
    :try_start_c
    sget-object v0, Lcom/k4/homeclock/HomeDepthClock;->POST_DIM:Ljava/util/Map;

    monitor-enter v0
    :try_end_f
    .catchall {:try_start_c .. :try_end_f} :catchall_2d

    .line 339
    :try_start_f
    sget-object v2, Lcom/k4/homeclock/HomeDepthClock;->POST_DIM:Ljava/util/Map;

    invoke-interface {v2, p0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 340
    monitor-exit v0
    :try_end_15
    .catchall {:try_start_f .. :try_end_15} :catchall_27

    .line 341
    if-eqz v1, :cond_1a

    .line 342
    :try_start_17
    invoke-virtual {v1}, Lcom/k4/homeclock/EngineState;->stop()V

    .line 347
    :cond_1a
    iget-object p0, p0, Lf3/a;->g:Lh3/a;

    .line 348
    if-eqz p0, :cond_26

    instance-of v0, p0, Lcom/k4/homeclock/HomeClockPresenter;

    if-nez v0, :cond_26

    .line 349
    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/k4/homeclock/HomeDepthClock;->setClock(Lh3/a;Lcom/k4/homeclock/DepthClock;)V
    :try_end_26
    .catchall {:try_start_17 .. :try_end_26} :catchall_2d

    .line 353
    :cond_26
    goto :goto_35

    .line 340
    :catchall_27
    move-exception p0

    :try_start_28
    monitor-exit v0
    :try_end_29
    .catchall {:try_start_28 .. :try_end_29} :catchall_27

    :try_start_29
    throw p0
    :try_end_2a
    .catchall {:try_start_29 .. :try_end_2a} :catchall_2d

    .line 337
    :catchall_2a
    move-exception p0

    :try_start_2b
    monitor-exit v0
    :try_end_2c
    .catchall {:try_start_2b .. :try_end_2c} :catchall_2a

    :try_start_2c
    throw p0
    :try_end_2d
    .catchall {:try_start_2c .. :try_end_2d} :catchall_2d

    .line 351
    :catchall_2d
    move-exception p0

    .line 352
    const-string v0, "K4HomeClock"

    const-string v1, "onDestroy"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 354
    :goto_35
    return-void
.end method

.method public static onVisibility(Lf3/a;Z)V
    .registers 4

    .line 321
    :try_start_0
    sget-object v0, Lcom/k4/homeclock/HomeDepthClock;->ENGINES:Ljava/util/Map;

    monitor-enter v0
    :try_end_3
    .catchall {:try_start_0 .. :try_end_3} :catchall_15

    .line 322
    :try_start_3
    sget-object v1, Lcom/k4/homeclock/HomeDepthClock;->ENGINES:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/k4/homeclock/EngineState;

    .line 323
    monitor-exit v0
    :try_end_c
    .catchall {:try_start_3 .. :try_end_c} :catchall_12

    .line 324
    if-eqz p0, :cond_11

    .line 325
    :try_start_e
    invoke-virtual {p0, p1}, Lcom/k4/homeclock/EngineState;->setVisible(Z)V
    :try_end_11
    .catchall {:try_start_e .. :try_end_11} :catchall_15

    .line 329
    :cond_11
    goto :goto_1d

    .line 323
    :catchall_12
    move-exception p0

    :try_start_13
    monitor-exit v0
    :try_end_14
    .catchall {:try_start_13 .. :try_end_14} :catchall_12

    :try_start_14
    throw p0
    :try_end_15
    .catchall {:try_start_14 .. :try_end_15} :catchall_15

    .line 327
    :catchall_15
    move-exception p0

    .line 328
    const-string p1, "K4HomeClock"

    const-string v0, "onVisibility"

    invoke-static {p1, v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 330
    :goto_1d
    return-void
.end method

.method static postDimInstalled(Lh3/a;)Z
    .registers 4

    .line 263
    sget-object v0, Lcom/k4/homeclock/HomeDepthClock;->POST_DIM:Ljava/util/Map;

    monitor-enter v0

    .line 264
    :try_start_3
    sget-object v1, Lcom/k4/homeclock/HomeDepthClock;->POST_DIM:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_d
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_23

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lf3/a;

    .line 265
    if-eqz v2, :cond_22

    iget-object v2, v2, Lf3/a;->g:Lh3/a;

    if-ne v2, p0, :cond_22

    .line 266
    monitor-exit v0

    const/4 p0, 0x1

    return p0

    .line 268
    :cond_22
    goto :goto_d

    .line 269
    :cond_23
    monitor-exit v0

    .line 270
    const/4 p0, 0x0

    return p0

    .line 269
    :catchall_26
    move-exception p0

    monitor-exit v0
    :try_end_28
    .catchall {:try_start_3 .. :try_end_28} :catchall_26

    throw p0
.end method

.method public static presenter(Lh3/a;Landroid/content/Context;ILcom/samsung/android/wallpaper/live/unified/engines/layered/source/b;)Lh3/a;
    .registers 7

    .line 80
    const-string v0, "K4HomeClock"

    and-int/lit8 v1, p2, 0x3

    const/4 v2, 0x1

    if-ne v1, v2, :cond_37

    invoke-static {}, Lcom/k4/homeclock/HomeDepthClock;->enabled()Z

    move-result v1

    if-nez v1, :cond_e

    goto :goto_37

    .line 84
    :cond_e
    :try_start_e
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "home layered wallpaper (which="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "): depth clock presenter"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 85
    new-instance v1, Lcom/k4/homeclock/HomeClockPresenter;

    invoke-direct {v1, p1, p2, p3}, Lcom/k4/homeclock/HomeClockPresenter;-><init>(Landroid/content/Context;ILcom/samsung/android/wallpaper/live/unified/engines/layered/source/b;)V
    :try_end_2f
    .catchall {:try_start_e .. :try_end_2f} :catchall_30

    return-object v1

    .line 86
    :catchall_30
    move-exception p1

    .line 87
    const-string p2, "presenter: falling back to stock"

    invoke-static {v0, p2, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 88
    return-object p0

    .line 81
    :cond_37
    :goto_37
    return-object p0
.end method

.method static prop(Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    .line 51
    const-string v0, ""

    :try_start_2
    invoke-static {p0}, Landroid/os/SemSystemProperties;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 52
    if-nez p0, :cond_9

    goto :goto_d

    :cond_9
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0
    :try_end_d
    .catchall {:try_start_2 .. :try_end_d} :catchall_e

    :goto_d
    return-object v0

    .line 53
    :catchall_e
    move-exception p0

    .line 54
    return-object v0
.end method

.method static redrawStale(Ljava/lang/String;)V
    .registers 5

    .line 275
    invoke-static {}, Lcom/k4/homeclock/HomeDepthClock;->states()[Lcom/k4/homeclock/EngineState;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_6
    if-ge v2, v1, :cond_10

    aget-object v3, v0, v2

    .line 276
    invoke-virtual {v3, p0}, Lcom/k4/homeclock/EngineState;->redrawIfStale(Ljava/lang/String;)V

    .line 275
    add-int/lit8 v2, v2, 0x1

    goto :goto_6

    .line 278
    :cond_10
    return-void
.end method

.method static setClock(Lh3/a;Lcom/k4/homeclock/DepthClock;)V
    .registers 4

    .line 196
    sget-object v0, Lcom/k4/homeclock/HomeDepthClock;->CLOCKS:Ljava/util/Map;

    monitor-enter v0

    .line 197
    if-nez p1, :cond_c

    :try_start_5
    sget-object v1, Lcom/k4/homeclock/HomeDepthClock;->CLOCKS:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    goto :goto_12

    :cond_c
    sget-object v1, Lcom/k4/homeclock/HomeDepthClock;->CLOCKS:Ljava/util/Map;

    invoke-interface {v1, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    :goto_12
    check-cast p0, Lcom/k4/homeclock/DepthClock;

    .line 198
    monitor-exit v0
    :try_end_15
    .catchall {:try_start_5 .. :try_end_15} :catchall_26

    .line 199
    if-eqz p0, :cond_25

    if-eq p0, p1, :cond_25

    .line 201
    :try_start_19
    invoke-virtual {p0}, Lcom/k4/homeclock/DepthClock;->release()V
    :try_end_1c
    .catchall {:try_start_19 .. :try_end_1c} :catchall_1d

    .line 204
    goto :goto_25

    .line 202
    :catchall_1d
    move-exception p0

    .line 203
    const-string p1, "K4HomeClock"

    const-string v0, "release"

    invoke-static {p1, v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 206
    :cond_25
    :goto_25
    return-void

    .line 198
    :catchall_26
    move-exception p0

    :try_start_27
    monitor-exit v0
    :try_end_28
    .catchall {:try_start_27 .. :try_end_28} :catchall_26

    throw p0
.end method

.method static sharedEnabled()Z
    .registers 2

    .line 69
    const-string v0, "persist.sys.k4.home_depth_clock_shared"

    invoke-static {v0}, Lcom/k4/homeclock/HomeDepthClock;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 70
    const-string v1, "0"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_18

    const-string v1, "false"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_18

    const/4 v0, 0x1

    goto :goto_19

    :cond_18
    const/4 v0, 0x0

    :goto_19
    return v0
.end method

.method static states()[Lcom/k4/homeclock/EngineState;
    .registers 3

    .line 226
    sget-object v0, Lcom/k4/homeclock/HomeDepthClock;->ENGINES:Ljava/util/Map;

    monitor-enter v0

    .line 227
    :try_start_3
    sget-object v1, Lcom/k4/homeclock/HomeDepthClock;->ENGINES:Ljava/util/Map;

    invoke-interface {v1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v1

    const/4 v2, 0x0

    new-array v2, v2, [Lcom/k4/homeclock/EngineState;

    invoke-interface {v1, v2}, Ljava/util/Collection;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Lcom/k4/homeclock/EngineState;

    monitor-exit v0

    return-object v1

    .line 228
    :catchall_14
    move-exception v1

    monitor-exit v0
    :try_end_16
    .catchall {:try_start_3 .. :try_end_16} :catchall_14

    throw v1
.end method
