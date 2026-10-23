.class public final Lcom/k4/devicecare/K4RestrictList;
.super Ljava/lang/Object;
.source "K4RestrictList.java"


# static fields
.field private static final FAS:Landroid/net/Uri;

.field private static final ROLES:[Ljava/lang/String;

.field private static final SOFT:J = 0x100008L

.field private static final TAG:Ljava/lang/String; = "K4RestrictList"

.field private static final WAIT_MS:J = 0xfa0L

.field private static sReplay:Z

.field private static sWorker:Ljava/util/concurrent/ExecutorService;


# direct methods
.method static bridge synthetic -$$Nest$sfputsReplay(Z)V
    .registers 1

    sput-boolean p0, Lcom/k4/devicecare/K4RestrictList;->sReplay:Z

    return-void
.end method

.method static constructor <clinit>()V
    .registers 7

    .line 51
    const-string v0, "content://com.sec.android.sdhms.fasprovider/ForcedAppStandby"

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    sput-object v0, Lcom/k4/devicecare/K4RestrictList;->FAS:Landroid/net/Uri;

    .line 53
    const-string v5, "android.app.role.WALLET"

    const-string v6, "android.app.role.SYSTEM_GALLERY"

    const-string v1, "android.app.role.DIALER"

    const-string v2, "android.app.role.SMS"

    const-string v3, "android.app.role.HOME"

    const-string v4, "android.app.role.ASSISTANT"

    filled-new-array/range {v1 .. v6}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/k4/devicecare/K4RestrictList;->ROLES:[Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 60
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static varargs call(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 10

    .line 357
    const/4 v0, 0x0

    if-nez p0, :cond_4

    return-object v0

    .line 359
    :cond_4
    :try_start_4
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x0

    :goto_e
    if-ge v3, v2, :cond_2c

    aget-object v4, v1, v3

    .line 360
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v5, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_29

    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v5

    array-length v5, v5

    array-length v6, p2

    if-ne v5, v6, :cond_29

    invoke-virtual {v4, p0, p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_28
    .catchall {:try_start_4 .. :try_end_28} :catchall_2d

    return-object p0

    .line 359
    :cond_29
    add-int/lit8 v3, v3, 0x1

    goto :goto_e

    .line 364
    :cond_2c
    goto :goto_33

    .line 362
    :catchall_2d
    move-exception p0

    .line 363
    const-string p2, "K4RestrictList"

    invoke-static {p2, p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 365
    :goto_33
    return-object v0
.end method

.method public static canList(Lcom/samsung/android/sdhms/SemAppRestrictionManager;ILjava/lang/String;I)Z
    .registers 7

    .line 126
    const/4 v0, 0x0

    if-nez p2, :cond_4

    return v0

    .line 127
    :cond_4
    invoke-static {p0, p2, p3}, Lcom/k4/devicecare/K4RestrictList;->isTracked(Lcom/samsung/android/sdhms/SemAppRestrictionManager;Ljava/lang/String;I)Z

    move-result v1

    const/4 v2, 0x1

    if-eqz v1, :cond_1b

    invoke-virtual {p0, p1, p2, p3}, Lcom/samsung/android/sdhms/SemAppRestrictionManager;->canRestrictWithReason(ILjava/lang/String;I)J

    move-result-wide p0

    const-wide/32 p2, -0x100009

    and-long/2addr p0, p2

    const-wide/16 p2, 0x0

    cmp-long p0, p0, p2

    if-nez p0, :cond_1a

    move v0, v2

    :cond_1a
    return v0

    .line 129
    :cond_1b
    if-eqz p1, :cond_20

    if-eq p1, v2, :cond_20

    return v0

    .line 131
    :cond_20
    :try_start_20
    invoke-static {p0}, Lcom/k4/devicecare/K4RestrictList;->context(Lcom/samsung/android/sdhms/SemAppRestrictionManager;)Landroid/content/Context;

    move-result-object p0

    .line 132
    if-eqz p0, :cond_37

    invoke-static {p0, p2, p3}, Lcom/k4/devicecare/K4RestrictList;->isCandidate(Landroid/content/Context;Ljava/lang/String;I)Z

    move-result v1

    if-nez v1, :cond_2d

    goto :goto_37

    .line 133
    :cond_2d
    if-eq p1, v2, :cond_35

    invoke-static {p0, p2, p3}, Lcom/k4/devicecare/K4RestrictList;->protection(Landroid/content/Context;Ljava/lang/String;I)Ljava/lang/String;

    move-result-object p0
    :try_end_33
    .catchall {:try_start_20 .. :try_end_33} :catchall_38

    if-nez p0, :cond_36

    :cond_35
    move v0, v2

    :cond_36
    return v0

    .line 132
    :cond_37
    :goto_37
    return v0

    .line 134
    :catchall_38
    move-exception p0

    .line 135
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "canList "

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "K4RestrictList"

    invoke-static {p2, p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 136
    return v0
.end method

.method public static candidates(Landroid/content/Context;)Ljava/util/List;
    .registers 16
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 250
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 251
    invoke-static {}, Lcom/k4/devicecare/K4RestrictList;->deviceIdle()Ljava/lang/Object;

    move-result-object v1

    .line 252
    const/4 v2, 0x0

    new-array v3, v2, [Ljava/lang/Object;

    const-string v4, "getUserPowerWhitelist"

    invoke-static {v1, v4, v3}, Lcom/k4/devicecare/K4RestrictList;->call(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, [Ljava/lang/String;

    .line 253
    if-eqz v3, :cond_b3

    array-length v4, v3

    if-nez v4, :cond_1b

    goto/16 :goto_b3

    .line 254
    :cond_1b
    const-string v4, "getSystemPowerWhitelist"

    new-array v5, v2, [Ljava/lang/Object;

    invoke-static {v1, v4, v5}, Lcom/k4/devicecare/K4RestrictList;->call(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, [Ljava/lang/String;

    .line 255
    new-instance v4, Ljava/util/HashSet;

    if-nez v1, :cond_2f

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    goto :goto_33

    :cond_2f
    invoke-static {v1}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v1

    :goto_33
    invoke-direct {v4, v1}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    .line 256
    new-instance v1, Ljava/util/HashSet;

    invoke-static {v3}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v5

    invoke-direct {v1, v5}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    .line 257
    const-string v5, "android.app.role.SMS"

    invoke-static {p0, v5}, Lcom/k4/devicecare/K4RestrictList;->roleHolders(Landroid/content/Context;Ljava/lang/String;)Ljava/util/List;

    move-result-object v5

    .line 258
    const-string v6, "android.app.role.DIALER"

    invoke-static {p0, v6}, Lcom/k4/devicecare/K4RestrictList;->roleHolders(Landroid/content/Context;Ljava/lang/String;)Ljava/util/List;

    move-result-object v6

    invoke-interface {v5, v6}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 259
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p0

    .line 260
    array-length v6, v3

    move v7, v2

    :goto_54
    if-ge v7, v6, :cond_b2

    aget-object v8, v3, v7

    .line 261
    invoke-virtual {v4, v8}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_af

    invoke-interface {v5, v8}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_65

    goto :goto_af

    .line 264
    :cond_65
    :try_start_65
    invoke-virtual {p0, v8, v2}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;

    move-result-object v9
    :try_end_69
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_65 .. :try_end_69} :catch_ad

    .line 267
    nop

    .line 268
    iget v10, v9, Landroid/content/pm/ApplicationInfo;->flags:I

    and-int/lit16 v10, v10, 0x81

    if-eqz v10, :cond_71

    goto :goto_af

    .line 269
    :cond_71
    iget-boolean v10, v9, Landroid/content/pm/ApplicationInfo;->enabled:Z

    if-eqz v10, :cond_af

    iget v10, v9, Landroid/content/pm/ApplicationInfo;->uid:I

    const v11, 0x186a0

    rem-int/2addr v10, v11

    const/16 v11, 0x2710

    if-ge v10, v11, :cond_80

    goto :goto_af

    .line 270
    :cond_80
    nop

    .line 271
    iget v9, v9, Landroid/content/pm/ApplicationInfo;->uid:I

    invoke-virtual {p0, v9}, Landroid/content/pm/PackageManager;->getPackagesForUid(I)[Ljava/lang/String;

    move-result-object v9

    .line 272
    if-eqz v9, :cond_a6

    array-length v10, v9

    move v11, v2

    move v12, v11

    :goto_8c
    if-ge v11, v10, :cond_a7

    aget-object v13, v9, v11

    invoke-virtual {v13, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v14

    if-nez v14, :cond_a3

    invoke-virtual {v1, v13}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z

    move-result v14

    if-nez v14, :cond_a2

    invoke-virtual {v4, v13}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_a3

    :cond_a2
    const/4 v12, 0x1

    :cond_a3
    add-int/lit8 v11, v11, 0x1

    goto :goto_8c

    :cond_a6
    move v12, v2

    .line 273
    :cond_a7
    if-nez v12, :cond_af

    invoke-virtual {v0, v8}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_af

    .line 265
    :catch_ad
    move-exception v8

    .line 266
    nop

    .line 260
    :cond_af
    :goto_af
    add-int/lit8 v7, v7, 0x1

    goto :goto_54

    .line 275
    :cond_b2
    return-object v0

    .line 253
    :cond_b3
    :goto_b3
    return-object v0
.end method

.method private static context(Lcom/samsung/android/sdhms/SemAppRestrictionManager;)Landroid/content/Context;
    .registers 5

    .line 333
    :try_start_0
    const-class v0, Lcom/samsung/android/sdhms/SemAppRestrictionManager;

    const-string v1, "mContext"

    invoke-virtual {v0, v1}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    .line 334
    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 335
    invoke-virtual {v0, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 336
    instance-of v0, p0, Landroid/content/Context;

    if-eqz v0, :cond_17

    check-cast p0, Landroid/content/Context;
    :try_end_16
    .catchall {:try_start_0 .. :try_end_16} :catchall_18

    return-object p0

    .line 338
    :cond_17
    goto :goto_19

    .line 337
    :catchall_18
    move-exception p0

    .line 340
    :goto_19
    const/4 p0, 0x0

    :try_start_1a
    const-string v0, "android.app.ActivityThread"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    const-string v1, "currentApplication"

    const/4 v2, 0x0

    new-array v3, v2, [Ljava/lang/Class;

    invoke-virtual {v0, v1, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    new-array v1, v2, [Ljava/lang/Object;

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/Context;
    :try_end_31
    .catchall {:try_start_1a .. :try_end_31} :catchall_32

    return-object v0

    .line 341
    :catchall_32
    move-exception v0

    .line 342
    return-object p0
.end method

.method private static deviceIdle()Ljava/lang/Object;
    .registers 6

    .line 348
    const-string v0, "deviceidle"

    const/4 v1, 0x0

    :try_start_3
    const-string v2, "android.os.ServiceManager"

    invoke-static {v2}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v2

    const-string v3, "getService"

    const-class v4, Ljava/lang/String;

    filled-new-array {v4}, [Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v2, v3, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    filled-new-array {v0}, [Ljava/lang/Object;

    move-result-object v3

    invoke-virtual {v2, v1, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/os/IBinder;

    .line 349
    const-string v3, "android.os.IDeviceIdleController$Stub"

    invoke-static {v3}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    const-string v4, "asInterface"

    const-class v5, Landroid/os/IBinder;

    filled-new-array {v5}, [Ljava/lang/Class;

    move-result-object v5

    invoke-virtual {v3, v4, v5}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v3, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_39
    .catchall {:try_start_3 .. :try_end_39} :catchall_3a

    return-object v0

    .line 350
    :catchall_3a
    move-exception v2

    .line 351
    const-string v3, "K4RestrictList"

    invoke-static {v3, v0, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 352
    return-object v1
.end method

.method public static enter(Led/z;Landroid/content/Context;Ljava/util/List;IZLjava/lang/String;)Ljava/util/List;
    .registers 17

    .line 69
    const-string v1, "K4RestrictList"

    if-eqz p4, :cond_80

    if-eqz p3, :cond_9

    const/4 v0, 0x1

    if-ne p3, v0, :cond_80

    :cond_9
    if-eqz p1, :cond_80

    if-eqz p2, :cond_80

    invoke-interface {p2}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_14

    goto :goto_80

    .line 70
    :cond_14
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v0

    .line 71
    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v2

    if-eq v2, v0, :cond_23

    invoke-static/range {p1 .. p4}, Lcom/k4/devicecare/K4RestrictList;->prepare(Landroid/content/Context;Ljava/util/List;IZ)Ljava/util/List;

    move-result-object p0

    return-object p0

    .line 72
    :cond_23
    sget-boolean v2, Lcom/k4/devicecare/K4RestrictList;->sReplay:Z

    if-eqz v2, :cond_28

    return-object p2

    .line 73
    :cond_28
    invoke-static {p2}, Lcom/k4/devicecare/K4RestrictList;->hasAllowlisted(Ljava/util/List;)Z

    move-result v2

    if-nez v2, :cond_2f

    return-object p2

    .line 74
    :cond_2f
    new-instance v8, Landroid/os/Handler;

    invoke-direct {v8, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    .line 75
    new-instance v4, Ljava/util/ArrayList;

    invoke-direct {v4, p2}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 77
    :try_start_39
    invoke-static {}, Lcom/k4/devicecare/K4RestrictList;->worker()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    new-instance v3, Lcom/k4/devicecare/K4RestrictList$1;

    move-object v9, p0

    move-object v5, p1

    move v6, p3

    move v7, p4

    move-object/from16 v10, p5

    invoke-direct/range {v3 .. v10}, Lcom/k4/devicecare/K4RestrictList$1;-><init>(Ljava/util/List;Landroid/content/Context;IZLandroid/os/Handler;Led/z;Ljava/lang/String;)V

    invoke-interface {v0, v3}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V
    :try_end_4b
    .catchall {:try_start_39 .. :try_end_4b} :catchall_78

    .line 105
    nop

    .line 106
    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result p0

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "preparing "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, " app(s) for type "

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, " in the background"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 107
    const/4 p0, 0x0

    return-object p0

    .line 102
    :catchall_78
    move-exception v0

    move-object p0, v0

    .line 103
    const-string p1, "background prepare, restricting without it"

    invoke-static {v1, p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 104
    return-object p2

    .line 69
    :cond_80
    :goto_80
    return-object p2
.end method

.method public static getAllList(Lcom/samsung/android/sdhms/SemAppRestrictionManager;)Ljava/util/List;
    .registers 10

    .line 142
    const-string v0, "K4RestrictList"

    invoke-virtual {p0}, Lcom/samsung/android/sdhms/SemAppRestrictionManager;->getAllList()Ljava/util/List;

    move-result-object v1

    .line 143
    const/4 v2, 0x0

    if-nez v1, :cond_a

    return-object v2

    .line 145
    :cond_a
    :try_start_a
    invoke-static {p0}, Lcom/k4/devicecare/K4RestrictList;->context(Lcom/samsung/android/sdhms/SemAppRestrictionManager;)Landroid/content/Context;

    move-result-object p0

    .line 146
    if-nez p0, :cond_11

    return-object v1

    .line 147
    :cond_11
    new-instance v3, Ljava/util/HashSet;

    invoke-direct {v3}, Ljava/util/HashSet;-><init>()V

    .line 148
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_1a
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_2e

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/samsung/android/sdhms/SemAppRestrictionManager$AppRestrictionInfo;

    invoke-virtual {v5}, Lcom/samsung/android/sdhms/SemAppRestrictionManager$AppRestrictionInfo;->getPackageName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    goto :goto_1a

    .line 149
    :cond_2e
    nop

    .line 150
    invoke-static {p0}, Lcom/k4/devicecare/K4RestrictList;->candidates(Landroid/content/Context;)Ljava/util/List;

    move-result-object v4

    invoke-interface {v4}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_37
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_85

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    .line 151
    invoke-virtual {v3, v5}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_4a

    goto :goto_37

    .line 152
    :cond_4a
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v6

    const/4 v7, 0x0

    invoke-virtual {v6, v5, v7}, Landroid/content/pm/PackageManager;->getApplicationInfo(Ljava/lang/String;I)Landroid/content/pm/ApplicationInfo;

    move-result-object v6

    iget v6, v6, Landroid/content/pm/ApplicationInfo;->uid:I

    .line 153
    if-nez v2, :cond_5c

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2, v1}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 154
    :cond_5c
    new-instance v7, Lcom/samsung/android/sdhms/SemAppRestrictionManager$AppRestrictionInfo;

    invoke-direct {v7, v5, v6}, Lcom/samsung/android/sdhms/SemAppRestrictionManager$AppRestrictionInfo;-><init>(Ljava/lang/String;I)V

    invoke-virtual {v2, v7}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 155
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "offering allowlisted app "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v7, "/"

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v0, v5}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_84
    .catchall {:try_start_a .. :try_end_84} :catchall_8a

    .line 156
    goto :goto_37

    .line 157
    :cond_85
    if-nez v2, :cond_88

    goto :goto_89

    :cond_88
    move-object v1, v2

    :goto_89
    return-object v1

    .line 158
    :catchall_8a
    move-exception p0

    .line 159
    const-string v2, "getAllList"

    invoke-static {v0, v2, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 160
    return-object v1
.end method

.method private static hasAllowlisted(Ljava/util/List;)Z
    .registers 5

    .line 117
    invoke-static {}, Lcom/k4/devicecare/K4RestrictList;->deviceIdle()Ljava/lang/Object;

    move-result-object v0

    const/4 v1, 0x0

    new-array v2, v1, [Ljava/lang/Object;

    const-string v3, "getUserPowerWhitelist"

    invoke-static {v0, v3, v2}, Lcom/k4/devicecare/K4RestrictList;->call(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Ljava/lang/String;

    .line 118
    if-eqz v0, :cond_3d

    array-length v2, v0

    if-nez v2, :cond_15

    goto :goto_3d

    .line 119
    :cond_15
    new-instance v2, Ljava/util/HashSet;

    invoke-static {v0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    invoke-direct {v2, v0}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    .line 120
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_22
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_3c

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    instance-of v3, v0, Lkc/d;

    if-eqz v3, :cond_22

    check-cast v0, Lkc/d;

    iget-object v0, v0, Lkc/d;->a:Ljava/lang/String;

    invoke-virtual {v2, v0}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_22

    const/4 p0, 0x1

    return p0

    .line 121
    :cond_3c
    return v1

    .line 118
    :cond_3d
    :goto_3d
    return v1
.end method

.method public static isCandidate(Landroid/content/Context;Ljava/lang/String;I)Z
    .registers 7

    .line 244
    const v0, 0x186a0

    div-int v1, p2, v0

    invoke-static {}, Landroid/os/Process;->myUid()I

    move-result v2

    div-int/2addr v2, v0

    const/4 v3, 0x0

    if-ne v1, v2, :cond_3e

    rem-int v0, p2, v0

    const/16 v1, 0x2710

    if-ge v0, v1, :cond_14

    goto :goto_3e

    .line 245
    :cond_14
    invoke-static {p0}, Lcom/k4/devicecare/K4RestrictList;->candidates(Landroid/content/Context;)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3c

    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    invoke-virtual {v0, p2}, Landroid/content/pm/PackageManager;->getPackagesForUid(I)[Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_3c

    .line 246
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p0

    invoke-virtual {p0, p2}, Landroid/content/pm/PackageManager;->getPackagesForUid(I)[Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p0

    invoke-interface {p0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_3c

    const/4 v3, 0x1

    goto :goto_3d

    :cond_3c
    nop

    .line 245
    :goto_3d
    return v3

    .line 244
    :cond_3e
    :goto_3e
    return v3
.end method

.method public static isTracked(Lcom/samsung/android/sdhms/SemAppRestrictionManager;Ljava/lang/String;I)Z
    .registers 4

    .line 236
    const/4 v0, 0x1

    :try_start_1
    invoke-virtual {p0, v0, p1, p2}, Lcom/samsung/android/sdhms/SemAppRestrictionManager;->canRestrict(ILjava/lang/String;I)Z

    move-result p0
    :try_end_5
    .catchall {:try_start_1 .. :try_end_5} :catchall_6

    return p0

    .line 237
    :catchall_6
    move-exception p0

    .line 238
    const/4 p0, 0x0

    return p0
.end method

.method public static prepare(Landroid/content/Context;Ljava/util/List;IZ)Ljava/util/List;
    .registers 21

    .line 170
    move-object/from16 v1, p0

    move-object/from16 v2, p1

    move/from16 v3, p2

    const-string v4, "K4RestrictList"

    if-eqz p3, :cond_21c

    if-eqz v3, :cond_f

    const/4 v0, 0x1

    if-ne v3, v0, :cond_21c

    :cond_f
    if-eqz v1, :cond_21c

    if-eqz v2, :cond_21c

    invoke-interface {v2}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1b

    goto/16 :goto_21c

    .line 172
    :cond_1b
    :try_start_1b
    new-instance v5, Lcom/samsung/android/sdhms/SemAppRestrictionManager;

    invoke-direct {v5, v1}, Lcom/samsung/android/sdhms/SemAppRestrictionManager;-><init>(Landroid/content/Context;)V

    .line 173
    new-instance v6, Ljava/util/ArrayList;

    invoke-direct {v6}, Ljava/util/ArrayList;-><init>()V

    .line 174
    new-instance v7, Ljava/util/ArrayList;

    invoke-direct {v7}, Ljava/util/ArrayList;-><init>()V

    .line 175
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v8

    :cond_2e
    :goto_2e
    invoke-interface {v8}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_12e

    invoke-interface {v8}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    .line 176
    instance-of v9, v0, Lkc/d;

    if-nez v9, :cond_3d

    goto :goto_2e

    .line 177
    :cond_3d
    move-object v9, v0

    check-cast v9, Lkc/d;

    .line 178
    iget-object v10, v9, Lkc/d;->a:Ljava/lang/String;

    if-eqz v10, :cond_2e

    iget-object v10, v9, Lkc/d;->a:Ljava/lang/String;

    iget v11, v9, Lkc/d;->c:I

    invoke-static {v5, v10, v11}, Lcom/k4/devicecare/K4RestrictList;->isTracked(Lcom/samsung/android/sdhms/SemAppRestrictionManager;Ljava/lang/String;I)Z

    move-result v10

    if-nez v10, :cond_2e

    iget-object v10, v9, Lkc/d;->a:Ljava/lang/String;

    iget v11, v9, Lkc/d;->c:I

    invoke-static {v1, v10, v11}, Lcom/k4/devicecare/K4RestrictList;->isCandidate(Landroid/content/Context;Ljava/lang/String;I)Z

    move-result v10

    if-nez v10, :cond_59

    goto :goto_2e

    .line 179
    :cond_59
    if-nez v3, :cond_64

    iget-object v10, v9, Lkc/d;->a:Ljava/lang/String;

    iget v11, v9, Lkc/d;->c:I

    invoke-static {v1, v10, v11}, Lcom/k4/devicecare/K4RestrictList;->protection(Landroid/content/Context;Ljava/lang/String;I)Ljava/lang/String;

    move-result-object v10

    goto :goto_65

    :cond_64
    const/4 v10, 0x0

    .line 180
    :goto_65
    if-eqz v10, :cond_8d

    .line 181
    iget-object v9, v9, Lkc/d;->a:Ljava/lang/String;

    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "not deep sleeping "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v11, ": "

    invoke-virtual {v9, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-static {v4, v9}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 182
    invoke-virtual {v7, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 183
    goto :goto_2e

    .line 185
    :cond_8d
    invoke-static {}, Lcom/k4/devicecare/K4RestrictList;->deviceIdle()Ljava/lang/Object;

    move-result-object v10

    .line 186
    const-string v11, "removePowerSaveWhitelistApp"

    iget-object v12, v9, Lkc/d;->a:Ljava/lang/String;

    filled-new-array {v12}, [Ljava/lang/Object;

    move-result-object v12

    invoke-static {v10, v11, v12}, Lcom/k4/devicecare/K4RestrictList;->call(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 187
    sget-object v11, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    const-string v12, "isPowerSaveWhitelistApp"

    iget-object v13, v9, Lkc/d;->a:Ljava/lang/String;

    filled-new-array {v13}, [Ljava/lang/Object;

    move-result-object v13

    invoke-static {v10, v12, v13}, Lcom/k4/devicecare/K4RestrictList;->call(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v10

    invoke-virtual {v11, v10}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_d3

    .line 188
    iget-object v9, v9, Lkc/d;->a:Ljava/lang/String;

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "could not take "

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, " off the doze allowlist"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-static {v4, v9}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 189
    invoke-virtual {v7, v0}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 190
    goto/16 :goto_2e

    .line 192
    :cond_d3
    iget-object v0, v9, Lkc/d;->a:Ljava/lang/String;

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v10, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v10, " taken off the doze allowlist for type "

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v4, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_ef
    .catchall {:try_start_1b .. :try_end_ef} :catchall_215

    .line 194
    :try_start_ef
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 195
    const-string v10, "package_name"

    iget-object v11, v9, Lkc/d;->a:Ljava/lang/String;

    invoke-virtual {v0, v10, v11}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 196
    const-string v10, "uid"

    iget v11, v9, Lkc/d;->c:I

    invoke-static {v11}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v11

    invoke-virtual {v0, v10, v11}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 197
    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v10

    sget-object v11, Lcom/k4/devicecare/K4RestrictList;->FAS:Landroid/net/Uri;

    invoke-virtual {v10, v11, v0}, Landroid/content/ContentResolver;->insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    :try_end_10f
    .catchall {:try_start_ef .. :try_end_10f} :catchall_110

    .line 200
    goto :goto_129

    .line 198
    :catchall_110
    move-exception v0

    .line 199
    :try_start_111
    iget-object v10, v9, Lkc/d;->a:Ljava/lang/String;

    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "FAS insert "

    invoke-virtual {v11, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v11

    invoke-virtual {v11, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    invoke-static {v4, v10, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 201
    :goto_129
    invoke-virtual {v6, v9}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 202
    goto/16 :goto_2e

    .line 203
    :cond_12e
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    const-wide/16 v8, 0xfa0

    add-long/2addr v0, v8

    .line 204
    invoke-virtual {v6}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v6

    :goto_139
    invoke-interface {v6}, Ljava/util/Iterator;->hasNext()Z

    move-result v8

    if-eqz v8, :cond_205

    invoke-interface {v6}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Lkc/d;

    .line 205
    :goto_145
    iget-object v9, v8, Lkc/d;->a:Ljava/lang/String;

    iget v10, v8, Lkc/d;->c:I

    invoke-static {v5, v9, v10}, Lcom/k4/devicecare/K4RestrictList;->isTracked(Lcom/samsung/android/sdhms/SemAppRestrictionManager;Ljava/lang/String;I)Z

    move-result v9

    if-nez v9, :cond_15d

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v9

    cmp-long v9, v9, v0

    if-gez v9, :cond_15d

    const-wide/16 v9, 0x64

    invoke-static {v9, v10}, Landroid/os/SystemClock;->sleep(J)V

    goto :goto_145

    .line 206
    :cond_15d
    iget-object v9, v8, Lkc/d;->a:Ljava/lang/String;

    iget v10, v8, Lkc/d;->c:I

    invoke-static {v5, v9, v10}, Lcom/k4/devicecare/K4RestrictList;->isTracked(Lcom/samsung/android/sdhms/SemAppRestrictionManager;Ljava/lang/String;I)Z

    move-result v9
    :try_end_165
    .catchall {:try_start_111 .. :try_end_165} :catchall_215

    const-string v10, "addPowerSaveWhitelistApp"

    if-nez v9, :cond_192

    .line 207
    :try_start_169
    iget-object v9, v8, Lkc/d;->a:Ljava/lang/String;

    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v11, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v11, " not managed by MARs after 4000 ms, restoring allowlist"

    invoke-virtual {v9, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-static {v4, v9}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 208
    invoke-static {}, Lcom/k4/devicecare/K4RestrictList;->deviceIdle()Ljava/lang/Object;

    move-result-object v9

    iget-object v11, v8, Lkc/d;->a:Ljava/lang/String;

    filled-new-array {v11}, [Ljava/lang/Object;

    move-result-object v11

    invoke-static {v9, v10, v11}, Lcom/k4/devicecare/K4RestrictList;->call(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 209
    invoke-virtual {v7, v8}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 210
    goto :goto_139

    .line 212
    :cond_192
    const-wide/16 v11, 0x0

    if-nez v3, :cond_1a4

    iget-object v9, v8, Lkc/d;->a:Ljava/lang/String;

    iget v13, v8, Lkc/d;->c:I

    const/4 v14, 0x0

    invoke-virtual {v5, v14, v9, v13}, Lcom/samsung/android/sdhms/SemAppRestrictionManager;->canRestrictWithReason(ILjava/lang/String;I)J

    move-result-wide v13

    const-wide/32 v15, -0x100009

    and-long/2addr v13, v15

    goto :goto_1a5

    :cond_1a4
    move-wide v13, v11

    .line 213
    :goto_1a5
    cmp-long v9, v13, v11

    if-eqz v9, :cond_1e7

    .line 214
    iget-object v9, v8, Lkc/d;->a:Ljava/lang/String;

    invoke-static {v13, v14}, Ljava/lang/Long;->toHexString(J)Ljava/lang/String;

    move-result-object v11

    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const-string v13, "MARs protects "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    invoke-virtual {v12, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v12, " (0x"

    invoke-virtual {v9, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v11, "), restoring allowlist"

    invoke-virtual {v9, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-static {v4, v9}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 215
    invoke-static {}, Lcom/k4/devicecare/K4RestrictList;->deviceIdle()Ljava/lang/Object;

    move-result-object v9

    iget-object v11, v8, Lkc/d;->a:Ljava/lang/String;

    filled-new-array {v11}, [Ljava/lang/Object;

    move-result-object v11

    invoke-static {v9, v10, v11}, Lcom/k4/devicecare/K4RestrictList;->call(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 216
    invoke-virtual {v7, v8}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 217
    goto/16 :goto_139

    .line 219
    :cond_1e7
    iget-object v8, v8, Lkc/d;->a:Ljava/lang/String;

    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    const-string v9, " is managed by MARs now, restricting type "

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-static {v4, v8}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 220
    goto/16 :goto_139

    .line 221
    :cond_205
    invoke-virtual {v7}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_20c

    return-object v2

    .line 222
    :cond_20c
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0, v2}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 223
    invoke-virtual {v0, v7}, Ljava/util/ArrayList;->removeAll(Ljava/util/Collection;)Z
    :try_end_214
    .catchall {:try_start_169 .. :try_end_214} :catchall_215

    .line 224
    return-object v0

    .line 225
    :catchall_215
    move-exception v0

    .line 226
    const-string v1, "prepare"

    invoke-static {v4, v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 227
    return-object v2

    .line 170
    :cond_21c
    :goto_21c
    return-object v2
.end method

.method public static protection(Landroid/content/Context;Ljava/lang/String;I)Ljava/lang/String;
    .registers 14

    .line 280
    const v1, 0x186a0

    rem-int v0, p2, v1

    const/16 v2, 0x3e8

    if-ne v0, v2, :cond_c

    const-string p0, "system uid"

    return-object p0

    .line 282
    :cond_c
    const/4 v2, 0x0

    :try_start_d
    const-class v0, Landroid/app/admin/DevicePolicyManager;

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/admin/DevicePolicyManager;

    .line 283
    if-nez v0, :cond_19

    move-object v0, v2

    goto :goto_1d

    :cond_19
    invoke-virtual {v0}, Landroid/app/admin/DevicePolicyManager;->getActiveAdmins()Ljava/util/List;

    move-result-object v0

    .line 284
    :goto_1d
    if-eqz v0, :cond_3c

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_23
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_3c

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/content/ComponentName;

    invoke-virtual {v3}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_23

    const-string p0, "device admin"
    :try_end_3b
    .catchall {:try_start_d .. :try_end_3b} :catchall_3d

    return-object p0

    .line 286
    :cond_3c
    goto :goto_3e

    .line 285
    :catchall_3d
    move-exception v0

    .line 287
    :goto_3e
    sget-object v0, Lcom/k4/devicecare/K4RestrictList;->ROLES:[Ljava/lang/String;

    array-length v3, v0

    const/4 v4, 0x0

    move v5, v4

    :goto_43
    if-ge v5, v3, :cond_55

    aget-object v6, v0, v5

    invoke-static {p0, v6}, Lcom/k4/devicecare/K4RestrictList;->roleHolders(Landroid/content/Context;Ljava/lang/String;)Ljava/util/List;

    move-result-object v7

    invoke-interface {v7, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_52

    return-object v6

    :cond_52
    add-int/lit8 v5, v5, 0x1

    goto :goto_43

    .line 289
    :cond_55
    :try_start_55
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v3, "default_input_method"

    invoke-static {v0, v3}, Landroid/provider/Settings$Secure;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 290
    if-nez v0, :cond_63

    move-object v0, v2

    goto :goto_67

    :cond_63
    invoke-static {v0}, Landroid/content/ComponentName;->unflattenFromString(Ljava/lang/String;)Landroid/content/ComponentName;

    move-result-object v0

    .line 291
    :goto_67
    if-eqz v0, :cond_76

    invoke-virtual {v0}, Landroid/content/ComponentName;->getPackageName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_76

    const-string p0, "keyboard"
    :try_end_75
    .catchall {:try_start_55 .. :try_end_75} :catchall_77

    return-object p0

    .line 293
    :cond_76
    goto :goto_78

    .line 292
    :catchall_77
    move-exception v0

    .line 295
    :goto_78
    :try_start_78
    invoke-static {p0}, Landroid/app/WallpaperManager;->getInstance(Landroid/content/Context;)Landroid/app/WallpaperManager;

    move-result-object v0

    .line 296
    const/4 v3, 0x2

    const/4 v5, 0x1

    filled-new-array {v5, v3}, [I

    move-result-object v5

    move v6, v4

    :goto_83
    if-ge v6, v3, :cond_9d

    aget v7, v5, v6

    .line 297
    invoke-virtual {v0, v7}, Landroid/app/WallpaperManager;->getWallpaperInfo(I)Landroid/app/WallpaperInfo;

    move-result-object v7

    .line 298
    if-eqz v7, :cond_9a

    invoke-virtual {v7}, Landroid/app/WallpaperInfo;->getPackageName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {p1, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_9a

    const-string p0, "wallpaper"
    :try_end_99
    .catchall {:try_start_78 .. :try_end_99} :catchall_9e

    return-object p0

    .line 296
    :cond_9a
    add-int/lit8 v6, v6, 0x1

    goto :goto_83

    .line 301
    :cond_9d
    goto :goto_9f

    .line 300
    :catchall_9e
    move-exception v0

    .line 303
    :goto_9f
    :try_start_9f
    const-class v0, Landroid/content/pm/PackageManager;

    const-string v3, "isPackageStateProtected"

    const-class v5, Ljava/lang/String;

    sget-object v6, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    filled-new-array {v5, v6}, [Ljava/lang/Class;

    move-result-object v5

    invoke-virtual {v0, v3, v5}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    .line 304
    sget-object v3, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v5

    div-int/2addr p2, v1

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    filled-new-array {p1, p2}, [Ljava/lang/Object;

    move-result-object p2

    invoke-virtual {v0, v5, p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    invoke-virtual {v3, p2}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_cb

    const-string p0, "protected package"
    :try_end_ca
    .catchall {:try_start_9f .. :try_end_ca} :catchall_cc

    return-object p0

    .line 306
    :cond_cb
    goto :goto_cd

    .line 305
    :catchall_cc
    move-exception v0

    .line 308
    :goto_cd
    :try_start_cd
    invoke-static {p0}, Landroid/accounts/AccountManager;->get(Landroid/content/Context;)Landroid/accounts/AccountManager;

    move-result-object p2

    invoke-virtual {p2}, Landroid/accounts/AccountManager;->getAuthenticatorTypes()[Landroid/accounts/AuthenticatorDescription;

    move-result-object p2

    array-length v0, p2

    :goto_d6
    if-ge v4, v0, :cond_14d

    aget-object v1, p2, v4

    .line 309
    iget-object v3, v1, Landroid/accounts/AuthenticatorDescription;->packageName:Ljava/lang/String;

    invoke-virtual {p1, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_14a

    iget-object v3, v1, Landroid/accounts/AuthenticatorDescription;->type:Ljava/lang/String;

    if-nez v3, :cond_e7

    goto :goto_14a

    .line 310
    :cond_e7
    const-string v3, "content://com.android.contacts/raw_contacts"

    invoke-static {v3}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    invoke-virtual {v3}, Landroid/net/Uri;->buildUpon()Landroid/net/Uri$Builder;

    move-result-object v3

    const-string v5, "limit"

    const-string v6, "1"

    invoke-virtual {v3, v5, v6}, Landroid/net/Uri$Builder;->appendQueryParameter(Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri$Builder;

    move-result-object v3

    invoke-virtual {v3}, Landroid/net/Uri$Builder;->build()Landroid/net/Uri;

    move-result-object v6

    .line 311
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v5

    const-string v3, "_id"

    filled-new-array {v3}, [Ljava/lang/String;

    move-result-object v7

    const-string v8, "account_type = ? "

    iget-object v3, v1, Landroid/accounts/AuthenticatorDescription;->type:Ljava/lang/String;

    filled-new-array {v3}, [Ljava/lang/String;

    move-result-object v9

    const/4 v10, 0x0

    invoke-virtual/range {v5 .. v10}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v3
    :try_end_114
    .catchall {:try_start_cd .. :try_end_114} :catchall_14e

    .line 312
    if-eqz v3, :cond_145

    :try_start_116
    invoke-interface {v3}, Landroid/database/Cursor;->getCount()I

    move-result v5

    if-lez v5, :cond_145

    iget-object p0, v1, Landroid/accounts/AuthenticatorDescription;->type:Ljava/lang/String;

    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "contacts account "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_131
    .catchall {:try_start_116 .. :try_end_131} :catchall_137

    .line 313
    if-eqz v3, :cond_136

    :try_start_133
    invoke-interface {v3}, Landroid/database/Cursor;->close()V
    :try_end_136
    .catchall {:try_start_133 .. :try_end_136} :catchall_14e

    .line 312
    :cond_136
    return-object p0

    .line 311
    :catchall_137
    move-exception v0

    move-object p0, v0

    if-eqz v3, :cond_144

    :try_start_13b
    invoke-interface {v3}, Landroid/database/Cursor;->close()V
    :try_end_13e
    .catchall {:try_start_13b .. :try_end_13e} :catchall_13f

    goto :goto_144

    :catchall_13f
    move-exception v0

    move-object p1, v0

    :try_start_141
    invoke-virtual {p0, p1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_144
    :goto_144
    throw p0

    .line 313
    :cond_145
    if-eqz v3, :cond_14a

    invoke-interface {v3}, Landroid/database/Cursor;->close()V
    :try_end_14a
    .catchall {:try_start_141 .. :try_end_14a} :catchall_14e

    .line 308
    :cond_14a
    :goto_14a
    add-int/lit8 v4, v4, 0x1

    goto :goto_d6

    .line 316
    :cond_14d
    goto :goto_14f

    .line 315
    :catchall_14e
    move-exception v0

    .line 317
    :goto_14f
    return-object v2
.end method

.method private static roleHolders(Landroid/content/Context;Ljava/lang/String;)Ljava/util/List;
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 323
    :try_start_0
    const-string v0, "role"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    .line 324
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-string v1, "getRoleHolders"

    const-class v2, Ljava/lang/String;

    filled-new-array {v2}, [Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    .line 325
    new-instance v1, Ljava/util/ArrayList;

    filled-new-array {p1}, [Ljava/lang/Object;

    move-result-object p1

    invoke-virtual {v0, p0, p1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/List;

    invoke-direct {v1, p0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V
    :try_end_25
    .catchall {:try_start_0 .. :try_end_25} :catchall_26

    return-object v1

    .line 326
    :catchall_26
    move-exception p0

    .line 327
    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    return-object p0
.end method

.method private static declared-synchronized worker()Ljava/util/concurrent/ExecutorService;
    .registers 2

    const-class v0, Lcom/k4/devicecare/K4RestrictList;

    monitor-enter v0

    .line 111
    :try_start_3
    sget-object v1, Lcom/k4/devicecare/K4RestrictList;->sWorker:Ljava/util/concurrent/ExecutorService;

    if-nez v1, :cond_d

    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v1

    sput-object v1, Lcom/k4/devicecare/K4RestrictList;->sWorker:Ljava/util/concurrent/ExecutorService;

    .line 112
    :cond_d
    sget-object v1, Lcom/k4/devicecare/K4RestrictList;->sWorker:Ljava/util/concurrent/ExecutorService;
    :try_end_f
    .catchall {:try_start_3 .. :try_end_f} :catchall_11

    monitor-exit v0

    return-object v1

    .line 110
    :catchall_11
    move-exception v1

    :try_start_12
    monitor-exit v0
    :try_end_13
    .catchall {:try_start_12 .. :try_end_13} :catchall_11

    throw v1
.end method
