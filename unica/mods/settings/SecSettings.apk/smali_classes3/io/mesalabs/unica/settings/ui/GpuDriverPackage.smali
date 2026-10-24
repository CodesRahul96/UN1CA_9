.class final Lio/mesalabs/unica/settings/ui/GpuDriverPackage;
.super Ljava/lang/Object;
.source "GpuDriverPackage.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;,
        Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;
    }
.end annotation


# static fields
.field static final ERR_32BIT:Ljava/lang/String; = "32bit"

.field static final ERR_MISSING:Ljava/lang/String; = "missing"

.field static final ERR_NOT_ARM64:Ljava/lang/String; = "not_arm64"

.field static final ERR_NO_DRIVER:Ljava/lang/String; = "no_driver"

.field static final ERR_NO_VERSION:Ljava/lang/String; = "no_version"

.field static final ERR_TOO_LARGE:Ljava/lang/String; = "too_large"

.field static final GLES:Ljava/lang/String; = "lib64/egl/libGLESv2_adreno.so"

.field static final MAX_BYTES:J = 0x12c00000L

.field static final REQUIRED:[Ljava/lang/String;

.field static final SQE:Ljava/lang/String; = "a660_sqe.fw"


# direct methods
.method static constructor <clinit>()V
    .registers 6

    .line 23
    const-string v4, "lib64/libgsl.so"

    const-string v5, "lib64/libllvm-glnext.so"

    const-string v0, "lib64/egl/libGLESv2_adreno.so"

    const-string v1, "lib64/egl/libEGL_adreno.so"

    const-string v2, "lib64/egl/libGLESv1_CM_adreno.so"

    const-string v3, "lib64/hw/vulkan.adreno.so"

    filled-new-array/range {v0 .. v5}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->REQUIRED:[Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 51
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static check(Ljava/io/File;)Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;
    .registers 8

    .line 121
    new-instance v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;

    invoke-direct {v0}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;-><init>()V

    .line 122
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 123
    sget-object v2, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->REQUIRED:[Ljava/lang/String;

    array-length v3, v2

    const/4 v4, 0x0

    :goto_e
    if-ge v4, v3, :cond_3a

    aget-object v5, v2, v4

    .line 124
    new-instance v6, Ljava/io/File;

    invoke-direct {v6, p0, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v6}, Ljava/io/File;->isFile()Z

    move-result v6

    if-nez v6, :cond_37

    .line 125
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->length()I

    move-result v6

    if-lez v6, :cond_28

    const-string v6, ", "

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_28
    const/16 v6, 0x2f

    .line 126
    invoke-virtual {v5, v6}, Ljava/lang/String;->lastIndexOf(I)I

    move-result v6

    add-int/lit8 v6, v6, 0x1

    invoke-virtual {v5, v6}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_37
    add-int/lit8 v4, v4, 0x1

    goto :goto_e

    .line 129
    :cond_3a
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->length()I

    move-result v2

    if-lez v2, :cond_4b

    .line 130
    const-string p0, "missing"

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->error:Ljava/lang/String;

    .line 131
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->detail:Ljava/lang/String;

    return-object v0

    .line 135
    :cond_4b
    invoke-static {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->sets(Ljava/io/File;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    const-wide/16 v2, 0x0

    :cond_55
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_83

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/io/File;

    .line 136
    invoke-virtual {v4}, Ljava/io/File;->length()J

    move-result-wide v5

    add-long/2addr v2, v5

    .line 137
    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v5

    const-string v6, ".so"

    invoke-virtual {v5, v6}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_55

    invoke-static {v4}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->isElf64Arm(Ljava/io/File;)Z

    move-result v5

    if-nez v5, :cond_55

    .line 138
    const-string p0, "not_arm64"

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->error:Ljava/lang/String;

    .line 139
    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->detail:Ljava/lang/String;

    return-object v0

    :cond_83
    const-wide/32 v4, 0x12c00000

    cmp-long v1, v2, v4

    if-lez v1, :cond_99

    .line 144
    const-string p0, "too_large"

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->error:Ljava/lang/String;

    const/16 p0, 0x14

    shr-long v1, v2, p0

    .line 145
    invoke-static {v1, v2}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->detail:Ljava/lang/String;

    return-object v0

    .line 148
    :cond_99
    new-instance v1, Ljava/io/File;

    const-string v2, "lib64/egl/libGLESv2_adreno.so"

    invoke-direct {v1, p0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-static {v1}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->version(Ljava/io/File;)Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->version:Ljava/lang/String;

    .line 149
    iget-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->version:Ljava/lang/String;

    if-nez p0, :cond_b2

    .line 150
    const-string p0, "no_version"

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->error:Ljava/lang/String;

    .line 151
    const-string p0, "libGLESv2_adreno.so"

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->detail:Ljava/lang/String;

    :cond_b2
    return-object v0
.end method

.method private static digits([BI)I
    .registers 5

    const/4 v0, 0x0

    :goto_1
    add-int v1, p1, v0

    .line 227
    array-length v2, p0

    if-ge v1, v2, :cond_13

    aget-byte v1, p0, v1

    const/16 v2, 0x30

    if-lt v1, v2, :cond_13

    const/16 v2, 0x39

    if-gt v1, v2, :cond_13

    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    :cond_13
    return v0
.end method

.method private static endsWithPath(Ljava/lang/String;Ljava/lang/String;)Z
    .registers 4

    .line 257
    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1d

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "/"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_1b

    goto :goto_1d

    :cond_1b
    const/4 p0, 0x0

    return p0

    :cond_1d
    :goto_1d
    const/4 p0, 0x1

    return p0
.end method

.method static findVersion([B)Ljava/lang/String;
    .registers 6

    const/4 v0, 0x0

    :goto_1
    add-int/lit8 v1, v0, 0x1

    .line 205
    array-length v2, p0

    if-ge v1, v2, :cond_58

    .line 206
    aget-byte v2, p0, v0

    const/16 v3, 0x56

    if-ne v2, v3, :cond_56

    aget-byte v2, p0, v1

    const/16 v3, 0x40

    if-eq v2, v3, :cond_13

    goto :goto_56

    :cond_13
    add-int/lit8 v2, v0, 0x2

    .line 208
    invoke-static {p0, v2}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->digits([BI)I

    move-result v3

    const/4 v4, 0x3

    if-lt v3, v4, :cond_56

    const/4 v4, 0x4

    if-le v3, v4, :cond_20

    goto :goto_56

    :cond_20
    add-int/2addr v2, v3

    .line 211
    array-length v3, p0

    if-ge v2, v3, :cond_56

    aget-byte v3, p0, v2

    const/16 v4, 0x2e

    if-eq v3, v4, :cond_2b

    goto :goto_56

    :cond_2b
    add-int/lit8 v3, v2, 0x1

    .line 212
    invoke-static {p0, v3}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->digits([BI)I

    move-result v3

    if-nez v3, :cond_34

    goto :goto_56

    :cond_34
    add-int/lit8 v3, v3, 0x1

    add-int/2addr v2, v3

    .line 215
    array-length v3, p0

    if-ge v2, v3, :cond_49

    aget-byte v3, p0, v2

    if-ne v3, v4, :cond_49

    add-int/lit8 v3, v2, 0x1

    .line 216
    invoke-static {p0, v3}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->digits([BI)I

    move-result v3

    if-lez v3, :cond_49

    add-int/lit8 v3, v3, 0x1

    add-int/2addr v2, v3

    .line 219
    :cond_49
    array-length v3, p0

    if-lt v2, v3, :cond_4d

    goto :goto_56

    .line 220
    :cond_4d
    new-instance v1, Ljava/lang/String;

    sub-int/2addr v2, v0

    sget-object v3, Ljava/nio/charset/StandardCharsets;->US_ASCII:Ljava/nio/charset/Charset;

    invoke-direct {v1, p0, v0, v2, v3}, Ljava/lang/String;-><init>([BIILjava/nio/charset/Charset;)V

    return-object v1

    :cond_56
    :goto_56
    move v0, v1

    goto :goto_1

    :cond_58
    const/4 p0, 0x0

    return-object p0
.end method

.method static flatTarget(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    .line 111
    const-string v0, "vulkan.adreno.so"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_17

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "lib64/hw/"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 112
    :cond_17
    const-string v0, "libEGL_adreno.so"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_57

    const-string v0, "libGLESv1_CM_adreno.so"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_57

    const-string v0, "libGLESv2_adreno.so"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_57

    const-string v0, "eglSubDriverAndroid.so"

    .line 113
    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_57

    const-string v0, "libq3dtools_"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_57

    const-string v0, "libVkLayer_"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_48

    goto :goto_57

    .line 116
    :cond_48
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "lib64/"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 114
    :cond_57
    :goto_57
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "lib64/egl/"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static isDirectChild(Ljava/lang/String;Ljava/lang/String;)Z
    .registers 4

    .line 261
    invoke-virtual {p0, p1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_26

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    if-le v0, v1, :cond_26

    const/16 v0, 0x2f

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    invoke-virtual {p0, v0, p1}, Ljava/lang/String;->indexOf(II)I

    move-result p1

    if-gez p1, :cond_26

    const-string p1, ".so"

    .line 262
    invoke-virtual {p0, p1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_26

    const/4 p0, 0x1

    return p0

    :cond_26
    const/4 p0, 0x0

    return p0
.end method

.method static isElf64Arm(Ljava/io/File;)Z
    .registers 6

    const/16 v0, 0x14

    .line 168
    new-array v1, v0, [B

    const/4 v2, 0x0

    .line 169
    :try_start_5
    new-instance v3, Ljava/io/FileInputStream;

    invoke-direct {v3, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_a
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_a} :catch_5e

    move p0, v2

    :goto_b
    if-ge p0, v0, :cond_25

    rsub-int/lit8 v4, p0, 0x14

    .line 172
    :try_start_f
    invoke-virtual {v3, v1, p0, v4}, Ljava/io/InputStream;->read([BII)I

    move-result v4
    :try_end_13
    .catchall {:try_start_f .. :try_end_13} :catchall_1b

    if-gez v4, :cond_19

    .line 176
    :try_start_15
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_18
    .catch Ljava/io/IOException; {:try_start_15 .. :try_end_18} :catch_5e

    return v2

    :cond_19
    add-int/2addr p0, v4

    goto :goto_b

    :catchall_1b
    move-exception p0

    .line 169
    :try_start_1c
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_1f
    .catchall {:try_start_1c .. :try_end_1f} :catchall_20

    goto :goto_24

    :catchall_20
    move-exception v0

    :try_start_21
    invoke-virtual {p0, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_24
    throw p0

    .line 176
    :cond_25
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_28
    .catch Ljava/io/IOException; {:try_start_21 .. :try_end_28} :catch_5e

    .line 179
    aget-byte p0, v1, v2

    const/16 v0, 0x7f

    if-ne p0, v0, :cond_5e

    const/4 p0, 0x1

    aget-byte v0, v1, p0

    const/16 v3, 0x45

    if-ne v0, v3, :cond_5e

    const/4 v0, 0x2

    aget-byte v3, v1, v0

    const/16 v4, 0x4c

    if-ne v3, v4, :cond_5e

    const/4 v3, 0x3

    aget-byte v3, v1, v3

    const/16 v4, 0x46

    if-ne v3, v4, :cond_5e

    const/4 v3, 0x4

    aget-byte v3, v1, v3

    if-ne v3, v0, :cond_5e

    const/4 v0, 0x5

    aget-byte v0, v1, v0

    if-ne v0, p0, :cond_5e

    const/16 v0, 0x12

    aget-byte v0, v1, v0

    and-int/lit16 v0, v0, 0xff

    const/16 v3, 0xb7

    if-ne v0, v3, :cond_5e

    const/16 v0, 0x13

    aget-byte v0, v1, v0

    if-nez v0, :cond_5e

    return p0

    :catch_5e
    :cond_5e
    return v2
.end method

.method static moduleId([B)Ljava/lang/String;
    .registers 5

    .line 233
    new-instance v0, Ljava/lang/String;

    sget-object v1, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v0, p0, v1}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    .line 234
    const-string p0, "\n"

    invoke-virtual {v0, p0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    array-length v0, p0

    const/4 v1, 0x0

    :goto_f
    if-ge v1, v0, :cond_2c

    aget-object v2, p0, v1

    .line 235
    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    .line 236
    const-string v3, "id="

    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_29

    const/4 p0, 0x3

    invoke-virtual {v2, p0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->sanitize(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_29
    add-int/lit8 v1, v1, 0x1

    goto :goto_f

    :cond_2c
    const/4 p0, 0x0

    return-object p0
.end method

.method static plan(Ljava/util/List;)Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;
    .registers 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;)",
            "Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;"
        }
    .end annotation

    .line 55
    new-instance v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;

    invoke-direct {v0}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;-><init>()V

    .line 58
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    const/4 v2, 0x0

    const/4 v3, 0x0

    move-object v4, v2

    move v5, v3

    :cond_d
    :goto_d
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_43

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    .line 59
    const-string v7, "lib64/egl/libGLESv2_adreno.so"

    invoke-static {v6, v7}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->endsWithPath(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_39

    .line 60
    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v7

    add-int/lit8 v7, v7, -0x1d

    invoke-virtual {v6, v3, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v6

    if-eqz v4, :cond_37

    .line 61
    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v7

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v8

    if-ge v7, v8, :cond_d

    :cond_37
    move-object v4, v6

    goto :goto_d

    .line 62
    :cond_39
    const-string v7, "lib/egl/libGLESv2_adreno.so"

    invoke-static {v6, v7}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->endsWithPath(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_d

    const/4 v5, 0x1

    goto :goto_d

    .line 66
    :cond_43
    const-string v1, "firmware/a660_sqe.fw"

    if-eqz v4, :cond_8a

    .line 67
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_4b
    :goto_4b
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_10b

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    .line 68
    invoke-virtual {v5, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_5e

    goto :goto_4b

    .line 69
    :cond_5e
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v6

    invoke-virtual {v5, v6}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v6

    .line 70
    const-string v7, "lib64/egl/"

    invoke-static {v6, v7}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->isDirectChild(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v7

    if-nez v7, :cond_84

    const-string v7, "lib64/"

    invoke-static {v6, v7}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->isDirectChild(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v7

    if-nez v7, :cond_84

    const-string v7, "lib64/hw/vulkan.adreno.so"

    invoke-virtual {v6, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-nez v7, :cond_84

    .line 71
    invoke-virtual {v6, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_4b

    .line 72
    :cond_84
    iget-object v7, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->files:Ljava/util/Map;

    invoke-interface {v7, v5, v6}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_4b

    :cond_8a
    if-eqz v5, :cond_91

    .line 76
    const-string p0, "32bit"

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->error:Ljava/lang/String;

    return-object v0

    .line 80
    :cond_91
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    move-object v5, v2

    :cond_96
    :goto_96
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_ca

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    .line 81
    const-string v7, "libGLESv2_adreno.so"

    invoke-virtual {v6, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-nez v7, :cond_b2

    const-string v7, "/libGLESv2_adreno.so"

    invoke-virtual {v6, v7}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_96

    .line 82
    :cond_b2
    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v7

    add-int/lit8 v7, v7, -0x13

    invoke-virtual {v6, v3, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v6

    if-eqz v5, :cond_c8

    .line 83
    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v7

    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v8

    if-ge v7, v8, :cond_96

    :cond_c8
    move-object v5, v6

    goto :goto_96

    :cond_ca
    if-nez v5, :cond_d1

    .line 87
    const-string p0, "no_driver"

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->error:Ljava/lang/String;

    return-object v0

    .line 90
    :cond_d1
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_d5
    :goto_d5
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_10b

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 91
    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_e8

    goto :goto_d5

    .line 92
    :cond_e8
    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v6

    invoke-virtual {v4, v6}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v6

    .line 93
    const-string v7, "/"

    invoke-virtual {v6, v7}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v7

    if-nez v7, :cond_d5

    const-string v7, ".so"

    invoke-virtual {v6, v7}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v7

    if-nez v7, :cond_101

    goto :goto_d5

    .line 94
    :cond_101
    iget-object v7, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->files:Ljava/util/Map;

    invoke-static {v6}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->flatTarget(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-interface {v7, v4, v6}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_d5

    .line 97
    :cond_10b
    iget-object v3, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->files:Ljava/util/Map;

    invoke-interface {v3, v1}, Ljava/util/Map;->containsValue(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_14d

    .line 100
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_117
    :goto_117
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_146

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 101
    const-string v4, "a660_sqe.fw"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_134

    const-string v4, "/a660_sqe.fw"

    invoke-virtual {v3, v4}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_134

    goto :goto_117

    :cond_134
    if-eqz v2, :cond_144

    .line 102
    const-string v4, "vendor/firmware/"

    invoke-virtual {v3, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v5

    if-eqz v5, :cond_117

    invoke-virtual {v2, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :cond_117

    :cond_144
    move-object v2, v3

    goto :goto_117

    :cond_146
    if-eqz v2, :cond_14d

    .line 104
    iget-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->files:Ljava/util/Map;

    invoke-interface {p0, v2, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_14d
    return-object v0
.end method

.method static sanitize(Ljava/lang/String;)Ljava/lang/String;
    .registers 6

    .line 243
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v1, 0x0

    .line 244
    :goto_6
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    if-ge v1, v2, :cond_44

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v2

    const/16 v3, 0x18

    if-ge v2, v3, :cond_44

    .line 245
    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v2

    const/16 v3, 0x61

    if-lt v2, v3, :cond_20

    const/16 v3, 0x7a

    if-le v2, v3, :cond_3e

    :cond_20
    const/16 v3, 0x41

    if-lt v2, v3, :cond_28

    const/16 v3, 0x5a

    if-le v2, v3, :cond_3e

    :cond_28
    const/16 v3, 0x30

    if-lt v2, v3, :cond_30

    const/16 v3, 0x39

    if-le v2, v3, :cond_3e

    :cond_30
    const/16 v3, 0x2e

    if-eq v2, v3, :cond_3e

    const/16 v3, 0x5f

    if-eq v2, v3, :cond_3e

    const/16 v4, 0x2d

    if-ne v2, v4, :cond_3d

    goto :goto_3e

    :cond_3d
    move v2, v3

    .line 246
    :cond_3e
    :goto_3e
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_6

    .line 248
    :cond_44
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result p0

    if-nez p0, :cond_4d

    const-string p0, "zip"

    return-object p0

    :cond_4d
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static sets(Ljava/io/File;)Ljava/util/List;
    .registers 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/io/File;",
            ")",
            "Ljava/util/List<",
            "Ljava/io/File;",
            ">;"
        }
    .end annotation

    .line 157
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 158
    const-string v1, "lib64/hw"

    const-string v2, "firmware"

    const-string v3, "lib64/egl"

    const-string v4, "lib64"

    filled-new-array {v3, v4, v1, v2}, [Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    move v3, v2

    :goto_13
    const/4 v4, 0x4

    if-ge v3, v4, :cond_39

    aget-object v4, v1, v3

    .line 159
    new-instance v5, Ljava/io/File;

    invoke-direct {v5, p0, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v5}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v4

    if-nez v4, :cond_24

    goto :goto_36

    .line 161
    :cond_24
    array-length v5, v4

    move v6, v2

    :goto_26
    if-ge v6, v5, :cond_36

    aget-object v7, v4, v6

    invoke-virtual {v7}, Ljava/io/File;->isFile()Z

    move-result v8

    if-eqz v8, :cond_33

    invoke-interface {v0, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_33
    add-int/lit8 v6, v6, 0x1

    goto :goto_26

    :cond_36
    :goto_36
    add-int/lit8 v3, v3, 0x1

    goto :goto_13

    :cond_39
    return-object v0
.end method

.method static slotFor(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 4

    const/4 v0, 0x2

    .line 253
    invoke-virtual {p0, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    const/16 v0, 0x2e

    const/16 v1, 0x5f

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object p0

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "u_"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "_"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static version(Ljava/io/File;)Ljava/lang/String;
    .registers 8

    .line 185
    :try_start_0
    new-instance v0, Ljava/io/FileInputStream;

    invoke-direct {v0, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_5} :catch_44

    const/high16 p0, 0x10000

    .line 186
    :try_start_7
    new-array p0, p0, [B

    const/4 v1, 0x0

    .line 187
    new-array v2, v1, [B

    .line 189
    :goto_c
    invoke-virtual {v0, p0}, Ljava/io/InputStream;->read([B)I

    move-result v3

    if-lez v3, :cond_36

    .line 190
    array-length v4, v2

    add-int/2addr v4, v3

    new-array v5, v4, [B

    .line 191
    array-length v6, v2

    invoke-static {v2, v1, v5, v1, v6}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 192
    array-length v2, v2

    invoke-static {p0, v1, v5, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 193
    invoke-static {v5}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->findVersion([B)Ljava/lang/String;

    move-result-object v2
    :try_end_22
    .catchall {:try_start_7 .. :try_end_22} :catchall_3a

    if-eqz v2, :cond_28

    .line 199
    :try_start_24
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V
    :try_end_27
    .catch Ljava/io/IOException; {:try_start_24 .. :try_end_27} :catch_44

    return-object v2

    :cond_28
    const/16 v2, 0x20

    .line 195
    :try_start_2a
    invoke-static {v4, v2}, Ljava/lang/Math;->min(II)I

    move-result v2

    .line 196
    new-array v3, v2, [B

    sub-int/2addr v4, v2

    .line 197
    invoke-static {v5, v4, v3, v1, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
    :try_end_34
    .catchall {:try_start_2a .. :try_end_34} :catchall_3a

    move-object v2, v3

    goto :goto_c

    .line 199
    :cond_36
    :try_start_36
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V
    :try_end_39
    .catch Ljava/io/IOException; {:try_start_36 .. :try_end_39} :catch_44

    goto :goto_44

    :catchall_3a
    move-exception p0

    .line 185
    :try_start_3b
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V
    :try_end_3e
    .catchall {:try_start_3b .. :try_end_3e} :catchall_3f

    goto :goto_43

    :catchall_3f
    move-exception v0

    :try_start_40
    invoke-virtual {p0, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_43
    throw p0
    :try_end_44
    .catch Ljava/io/IOException; {:try_start_40 .. :try_end_44} :catch_44

    :catch_44
    :goto_44
    const/4 p0, 0x0

    return-object p0
.end method
