.class final Lio/mesalabs/unica/settings/ui/GpuDriverModel;
.super Ljava/lang/Object;
.source "GpuDriverModel.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lio/mesalabs/unica/settings/ui/GpuDriverModel$Props;,
        Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;
    }
.end annotation


# static fields
.field static final ADDED:I = 0x2

.field static final BUILTIN:I = 0x0

.field static final MODULE:I = 0x1

.field static final PROP_ACTIVE:Ljava/lang/String; = "sys.k4.gpu_active"

.field static final PROP_DRIVERS:Ljava/lang/String; = "ro.k4.gpu_drivers"

.field static final PROP_EXTERNAL:Ljava/lang/String; = "sys.k4.gpu_external"

.field static final PROP_FAILED:Ljava/lang/String; = "persist.sys.k4.gpu_failed"

.field static final PROP_MISSING:Ljava/lang/String; = "sys.k4.gpu_missing"

.field static final PROP_PREV:Ljava/lang/String; = "persist.sys.k4.gpu_prev"

.field static final PROP_REJECTED:Ljava/lang/String; = "sys.k4.gpu_rejected"

.field static final PROP_ROOT:Ljava/lang/String; = "sys.k4.gpu_root"

.field static final PROP_SCAN:Ljava/lang/String; = "sys.k4.gpu_scan"

.field static final PROP_SELECTED:Ljava/lang/String; = "persist.sys.k4.gpu_driver"

.field static final PROP_TRIAL:Ljava/lang/String; = "persist.sys.k4.gpu_trial"

.field static final PROP_VENDOR:Ljava/lang/String; = "sys.k4.gpu_vendor"

.field static final STAGED:I = 0x3


# instance fields
.field private final mBase:Ljava/io/File;

.field private mEntries:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;",
            ">;"
        }
    .end annotation
.end field

.field private final mIncoming:Ljava/io/File;

.field private final mProps:Lio/mesalabs/unica/settings/ui/GpuDriverModel$Props;


# direct methods
.method constructor <init>(Lio/mesalabs/unica/settings/ui/GpuDriverModel$Props;Ljava/io/File;)V
    .registers 4

    .line 66
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 67
    iput-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mProps:Lio/mesalabs/unica/settings/ui/GpuDriverModel$Props;

    .line 68
    iput-object p2, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mBase:Ljava/io/File;

    .line 69
    new-instance p1, Ljava/io/File;

    const-string v0, "incoming"

    invoke-direct {p1, p2, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    iput-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mIncoming:Ljava/io/File;

    return-void
.end method

.method static addedLabel(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    .line 224
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " (added: "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static deleteTree(Ljava/io/File;)Z
    .registers 6

    .line 279
    invoke-virtual {p0}, Ljava/io/File;->isDirectory()Z

    move-result v0

    if-eqz v0, :cond_b

    invoke-virtual {p0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v0

    goto :goto_c

    :cond_b
    const/4 v0, 0x0

    :goto_c
    const/4 v1, 0x0

    if-eqz v0, :cond_1b

    .line 280
    array-length v2, v0

    move v3, v1

    :goto_11
    if-ge v3, v2, :cond_1b

    aget-object v4, v0, v3

    invoke-static {v4}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->deleteTree(Ljava/io/File;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_11

    .line 281
    :cond_1b
    invoke-virtual {p0}, Ljava/io/File;->delete()Z

    move-result v0

    if-nez v0, :cond_29

    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result p0

    if-nez p0, :cond_28

    goto :goto_29

    :cond_28
    return v1

    :cond_29
    :goto_29
    const/4 p0, 0x1

    return p0
.end method

.method private static find(Ljava/util/List;Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;",
            ">;",
            "Ljava/lang/String;",
            ")",
            "Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;"
        }
    .end annotation

    const/4 v0, 0x0

    if-eqz p1, :cond_23

    .line 246
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_a

    goto :goto_23

    .line 247
    :cond_a
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_e
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_23

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    iget-object v2, v1, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->id:Ljava/lang/String;

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_e

    return-object v1

    :cond_23
    :goto_23
    return-object v0
.end method

.method static info(Ljava/io/File;Ljava/lang/String;)Ljava/lang/String;
    .registers 5

    .line 252
    invoke-static {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->readLines(Ljava/io/File;)Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_8
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_36

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 253
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_8

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p0

    add-int/lit8 p0, p0, 0x1

    invoke-virtual {v0, p0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 255
    :cond_36
    const-string p0, ""

    return-object p0
.end method

.method static isSlot(Ljava/lang/String;)Z
    .registers 3

    .line 228
    const-string v0, "m_"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_10

    const-string v0, "u_"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_21

    :cond_10
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x2

    if-le v0, v1, :cond_21

    const-string v0, "[A-Za-z0-9._-]+"

    invoke-virtual {p0, v0}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_21

    const/4 p0, 0x1

    return p0

    :cond_21
    const/4 p0, 0x0

    return p0
.end method

.method private marker(Ljava/lang/String;Ljava/lang/String;)Ljava/io/File;
    .registers 5

    .line 237
    new-instance v0, Ljava/io/File;

    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mIncoming:Ljava/io/File;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v0, p0, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    return-object v0
.end method

.method static moduleId(Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    .line 233
    const-string v0, "m_"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_d

    const/4 v0, 0x2

    invoke-virtual {p0, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    :cond_d
    return-object p0
.end method

.method private prop(Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    .line 241
    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mProps:Lio/mesalabs/unica/settings/ui/GpuDriverModel$Props;

    invoke-interface {p0, p1}, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Props;->get(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-nez p0, :cond_b

    .line 242
    const-string p0, ""

    return-object p0

    :cond_b
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static readLines(Ljava/io/File;)Ljava/util/List;
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/io/File;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 259
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 260
    invoke-virtual {p0}, Ljava/io/File;->isFile()Z

    move-result v1

    if-nez v1, :cond_c

    goto :goto_3d

    .line 261
    :cond_c
    :try_start_c
    new-instance v1, Ljava/io/BufferedReader;

    new-instance v2, Ljava/io/InputStreamReader;

    new-instance v3, Ljava/io/FileInputStream;

    invoke-direct {v3, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    sget-object p0, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v2, v3, p0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/nio/charset/Charset;)V

    invoke-direct {v1, v2}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    :try_end_1d
    .catch Ljava/io/IOException; {:try_start_c .. :try_end_1d} :catch_3d

    .line 263
    :goto_1d
    :try_start_1d
    invoke-virtual {v1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_2f

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v2

    const/16 v3, 0x100

    if-ge v2, v3, :cond_2f

    invoke-interface {v0, p0}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_2e
    .catchall {:try_start_1d .. :try_end_2e} :catchall_33

    goto :goto_1d

    .line 264
    :cond_2f
    :try_start_2f
    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V
    :try_end_32
    .catch Ljava/io/IOException; {:try_start_2f .. :try_end_32} :catch_3d

    return-object v0

    :catchall_33
    move-exception p0

    .line 261
    :try_start_34
    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V
    :try_end_37
    .catchall {:try_start_34 .. :try_end_37} :catchall_38

    goto :goto_3c

    :catchall_38
    move-exception v1

    :try_start_39
    invoke-virtual {p0, v1}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_3c
    throw p0
    :try_end_3d
    .catch Ljava/io/IOException; {:try_start_39 .. :try_end_3d} :catch_3d

    :catch_3d
    :goto_3d
    return-object v0
.end method

.method static touch(Ljava/io/File;)Z
    .registers 2

    .line 271
    :try_start_0
    new-instance v0, Ljava/io/FileOutputStream;

    invoke-direct {v0, p0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_8
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_8} :catch_a

    const/4 p0, 0x1

    return p0

    :catch_a
    const/4 p0, 0x0

    return p0
.end method


# virtual methods
.method active()Ljava/lang/String;
    .registers 3

    .line 138
    const-string v0, "sys.k4.gpu_active"

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 139
    invoke-virtual {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->isKnown(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_18

    invoke-static {v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->isSlot(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_13

    goto :goto_18

    :cond_13
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->defaultDriver()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_18
    :goto_18
    return-object v0
.end method

.method available()Z
    .registers 2

    .line 86
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->builtins()[Ljava/lang/String;

    move-result-object p0

    array-length p0, p0

    const/4 v0, 0x1

    if-le p0, v0, :cond_9

    return v0

    :cond_9
    const/4 p0, 0x0

    return p0
.end method

.method builtins()[Ljava/lang/String;
    .registers 2

    .line 81
    const-string v0, "ro.k4.gpu_drivers"

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 82
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_14

    const/4 p0, 0x0

    new-array p0, p0, [Ljava/lang/String;

    return-object p0

    :cond_14
    const-string v0, "\\s+"

    invoke-virtual {p0, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method defaultDriver()Ljava/lang/String;
    .registers 2

    .line 90
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->builtins()[Ljava/lang/String;

    move-result-object p0

    .line 91
    array-length v0, p0

    if-lez v0, :cond_b

    const/4 v0, 0x0

    aget-object p0, p0, v0

    return-object p0

    :cond_b
    const-string p0, ""

    return-object p0
.end method

.method duplicateOf(Ljava/lang/String;Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;
    .registers 5

    .line 215
    invoke-static {p1, p2}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->addedLabel(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 216
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->entries()Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_c
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result p2

    if-eqz p2, :cond_2b

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    .line 217
    iget v0, p2, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->kind:I

    const/4 v1, 0x2

    if-eq v0, v1, :cond_22

    iget v0, p2, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->kind:I

    const/4 v1, 0x3

    if-ne v0, v1, :cond_c

    :cond_22
    iget-object v0, p2, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->label:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_c

    return-object p2

    :cond_2b
    const/4 p0, 0x0

    return-object p0
.end method

.method entries()Ljava/util/List;
    .registers 13
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;",
            ">;"
        }
    .end annotation

    .line 96
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mEntries:Ljava/util/List;

    if-eqz v0, :cond_5

    return-object v0

    .line 97
    :cond_5
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 98
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->builtins()[Ljava/lang/String;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x0

    move v4, v3

    :goto_11
    if-ge v4, v2, :cond_21

    aget-object v5, v1, v4

    new-instance v6, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    const/4 v7, 0x0

    invoke-direct {v6, v5, v3, v7, v3}, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;-><init>(Ljava/lang/String;ILjava/lang/String;Z)V

    invoke-interface {v0, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v4, v4, 0x1

    goto :goto_11

    .line 99
    :cond_21
    const-string v1, "sys.k4.gpu_scan"

    invoke-direct {p0, v1}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "1"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    const/4 v2, 0x3

    if-eqz v1, :cond_a9

    .line 100
    new-instance v1, Ljava/io/File;

    iget-object v4, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mBase:Ljava/io/File;

    const-string v5, "drivers"

    invoke-direct {v1, v4, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-static {v1}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->readLines(Ljava/io/File;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_41
    :goto_41
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_a9

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 101
    const-string v5, "\t"

    const/4 v6, 0x4

    invoke-virtual {v4, v5, v6}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v4

    .line 102
    array-length v5, v4

    if-lt v5, v6, :cond_41

    aget-object v5, v4, v3

    invoke-static {v5}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->isSlot(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_41

    aget-object v5, v4, v3

    invoke-static {v0, v5}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->find(Ljava/util/List;Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    move-result-object v5

    if-eqz v5, :cond_68

    goto :goto_41

    .line 103
    :cond_68
    const-string v5, "external"

    const/4 v6, 0x2

    aget-object v7, v4, v6

    invoke-virtual {v5, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_90

    .line 104
    aget-object v7, v4, v3

    const-string v8, ".remove"

    invoke-direct {p0, v7, v8}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->marker(Ljava/lang/String;Ljava/lang/String;)Ljava/io/File;

    move-result-object v7

    invoke-virtual {v7}, Ljava/io/File;->exists()Z

    move-result v7

    if-nez v7, :cond_41

    aget-object v7, v4, v3

    const-string v8, ".hide"

    invoke-direct {p0, v7, v8}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->marker(Ljava/lang/String;Ljava/lang/String;)Ljava/io/File;

    move-result-object v7

    invoke-virtual {v7}, Ljava/io/File;->exists()Z

    move-result v7

    if-eqz v7, :cond_90

    goto :goto_41

    .line 105
    :cond_90
    new-instance v7, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    aget-object v8, v4, v3

    const-string v9, "module"

    const/4 v10, 0x1

    aget-object v11, v4, v10

    invoke-virtual {v9, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_a0

    move v6, v10

    :cond_a0
    aget-object v4, v4, v2

    invoke-direct {v7, v8, v6, v4, v5}, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;-><init>(Ljava/lang/String;ILjava/lang/String;Z)V

    invoke-interface {v0, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_41

    .line 108
    :cond_a9
    iget-object v1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mIncoming:Ljava/io/File;

    invoke-virtual {v1}, Ljava/io/File;->list()[Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_104

    .line 110
    invoke-static {v1}, Ljava/util/Arrays;->sort([Ljava/lang/Object;)V

    .line 111
    array-length v4, v1

    move v5, v3

    :goto_b6
    if-ge v5, v4, :cond_104

    aget-object v6, v1, v5

    .line 112
    new-instance v7, Ljava/io/File;

    iget-object v8, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mIncoming:Ljava/io/File;

    invoke-direct {v7, v8, v6}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 113
    const-string v8, "u_"

    invoke-virtual {v6, v8}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v8

    if-eqz v8, :cond_101

    new-instance v8, Ljava/io/File;

    const-string v9, "ready"

    invoke-direct {v8, v7, v9}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v8}, Ljava/io/File;->isFile()Z

    move-result v8

    if-eqz v8, :cond_101

    invoke-static {v0, v6}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->find(Ljava/util/List;Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    move-result-object v8

    if-eqz v8, :cond_dd

    goto :goto_101

    .line 114
    :cond_dd
    new-instance v8, Ljava/io/File;

    const-string v9, "info"

    invoke-direct {v8, v7, v9}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    const-string v10, "version"

    invoke-static {v8, v10}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->info(Ljava/io/File;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 115
    new-instance v10, Ljava/io/File;

    invoke-direct {v10, v7, v9}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    const-string v7, "name"

    invoke-static {v10, v7}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->info(Ljava/io/File;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 116
    new-instance v9, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    invoke-static {v8, v7}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->addedLabel(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    invoke-direct {v9, v6, v2, v7, v3}, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;-><init>(Ljava/lang/String;ILjava/lang/String;Z)V

    invoke-interface {v0, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_101
    :goto_101
    add-int/lit8 v5, v5, 0x1

    goto :goto_b6

    .line 119
    :cond_104
    iput-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mEntries:Ljava/util/List;

    return-object v0
.end method

.method entry(Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;
    .registers 2

    .line 124
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->entries()Ljava/util/List;

    move-result-object p0

    invoke-static {p0, p1}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->find(Ljava/util/List;Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    move-result-object p0

    return-object p0
.end method

.method external()Ljava/lang/String;
    .registers 2

    .line 158
    const-string v0, "sys.k4.gpu_external"

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 159
    invoke-virtual {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->entry(Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    move-result-object p0

    if-eqz p0, :cond_11

    .line 160
    iget-boolean p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->external:Z

    if-eqz p0, :cond_11

    return-object v0

    :cond_11
    const-string p0, ""

    return-object p0
.end method

.method failed()Ljava/lang/String;
    .registers 2

    .line 144
    const-string v0, "persist.sys.k4.gpu_failed"

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 145
    invoke-virtual {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->isKnown(Ljava/lang/String;)Z

    move-result p0

    if-nez p0, :cond_16

    invoke-static {v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->isSlot(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_13

    goto :goto_16

    :cond_13
    const-string p0, ""

    return-object p0

    :cond_16
    :goto_16
    return-object v0
.end method

.method hasUserEntries()Z
    .registers 2

    .line 174
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->entries()Ljava/util/List;

    move-result-object p0

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_8
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_1a

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    iget v0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->kind:I

    if-eqz v0, :cond_8

    const/4 p0, 0x1

    return p0

    :cond_1a
    const/4 p0, 0x0

    return p0
.end method

.method incoming()Ljava/io/File;
    .registers 1

    .line 73
    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mIncoming:Ljava/io/File;

    return-object p0
.end method

.method isKnown(Ljava/lang/String;)Z
    .registers 2

    .line 128
    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->entry(Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    move-result-object p0

    if-eqz p0, :cond_8

    const/4 p0, 0x1

    return p0

    :cond_8
    const/4 p0, 0x0

    return p0
.end method

.method missing()Ljava/lang/String;
    .registers 2

    .line 149
    const-string v0, "sys.k4.gpu_missing"

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method rejected()Ljava/lang/String;
    .registers 2

    .line 153
    const-string v0, "sys.k4.gpu_rejected"

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method reload()V
    .registers 2

    const/4 v0, 0x0

    .line 77
    iput-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mEntries:Ljava/util/List;

    return-void
.end method

.method remove(Ljava/lang/String;)Z
    .registers 7

    .line 195
    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->entry(Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_60

    .line 196
    iget v2, v0, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->kind:I

    if-eqz v2, :cond_60

    iget-boolean v2, v0, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->external:Z

    if-eqz v2, :cond_10

    goto :goto_60

    .line 198
    :cond_10
    iget v2, v0, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->kind:I

    const/4 v3, 0x3

    const/4 v4, 0x1

    if-ne v2, v3, :cond_22

    .line 199
    new-instance v0, Ljava/io/File;

    iget-object v2, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mIncoming:Ljava/io/File;

    invoke-direct {v0, v2, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-static {v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->deleteTree(Ljava/io/File;)Z

    move-result v0

    goto :goto_33

    .line 201
    :cond_22
    iget v0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->kind:I

    if-ne v0, v4, :cond_29

    const-string v0, ".hide"

    goto :goto_2b

    :cond_29
    const-string v0, ".remove"

    :goto_2b
    invoke-direct {p0, p1, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->marker(Ljava/lang/String;Ljava/lang/String;)Ljava/io/File;

    move-result-object v0

    invoke-static {v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->touch(Ljava/io/File;)Z

    move-result v0

    :goto_33
    if-nez v0, :cond_36

    return v1

    .line 204
    :cond_36
    const-string v0, "persist.sys.k4.gpu_driver"

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    .line 205
    iput-object v1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mEntries:Ljava/util/List;

    if-eqz v0, :cond_5f

    .line 207
    const-string v0, "persist.sys.k4.gpu_prev"

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 208
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_58

    invoke-virtual {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->isKnown(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_58

    goto :goto_5c

    :cond_58
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->defaultDriver()Ljava/lang/String;

    move-result-object v0

    :goto_5c
    invoke-virtual {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->select(Ljava/lang/String;)Z

    :cond_5f
    return v4

    :cond_60
    :goto_60
    return v1
.end method

.method root()Ljava/lang/String;
    .registers 2

    .line 164
    const-string v0, "sys.k4.gpu_root"

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 165
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_16

    const-string v0, "none"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_15

    goto :goto_16

    :cond_15
    return-object p0

    :cond_16
    :goto_16
    const-string p0, ""

    return-object p0
.end method

.method select(Ljava/lang/String;)Z
    .registers 5

    .line 180
    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->isKnown(Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_8

    return v1

    .line 181
    :cond_8
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->external()Ljava/lang/String;

    move-result-object v0

    .line 182
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_19

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_19

    return v1

    .line 183
    :cond_19
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mProps:Lio/mesalabs/unica/settings/ui/GpuDriverModel$Props;

    const-string v1, "persist.sys.k4.gpu_driver"

    invoke-interface {v0, v1, p1}, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Props;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 184
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mProps:Lio/mesalabs/unica/settings/ui/GpuDriverModel$Props;

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->active()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2f

    const-string p1, "ok"

    goto :goto_31

    :cond_2f
    const-string p1, "pending"

    :goto_31
    const-string v1, "persist.sys.k4.gpu_trial"

    invoke-interface {v0, v1, p1}, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Props;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 185
    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->mProps:Lio/mesalabs/unica/settings/ui/GpuDriverModel$Props;

    const-string p1, "persist.sys.k4.gpu_failed"

    const-string v0, ""

    invoke-interface {p0, p1, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Props;->set(Ljava/lang/String;Ljava/lang/String;)V

    const/4 p0, 0x1

    return p0
.end method

.method selected()Ljava/lang/String;
    .registers 3

    .line 132
    const-string v0, "persist.sys.k4.gpu_driver"

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 133
    invoke-virtual {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->isKnown(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_d

    return-object v0

    :cond_d
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->defaultDriver()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method vendorVersion()Ljava/lang/String;
    .registers 2

    .line 170
    const-string v0, "sys.k4.gpu_vendor"

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverModel;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
