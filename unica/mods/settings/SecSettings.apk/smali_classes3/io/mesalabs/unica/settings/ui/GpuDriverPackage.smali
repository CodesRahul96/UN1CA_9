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
.field static final ALLOW_EGL:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static final ALLOW_LIB:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static final ERR_32BIT:Ljava/lang/String; = "32bit"

.field static final ERR_MISSING:Ljava/lang/String; = "missing"

.field static final ERR_NOT_ARM64:Ljava/lang/String; = "not_arm64"

.field static final ERR_NO_DRIVER:Ljava/lang/String; = "no_driver"

.field static final ERR_NO_VERSION:Ljava/lang/String; = "no_version"

.field static final ERR_TOO_LARGE:Ljava/lang/String; = "too_large"

.field static final ERR_UNEXPECTED:Ljava/lang/String; = "unexpected"

.field static final GLES:Ljava/lang/String; = "lib64/egl/libGLESv2_adreno.so"

.field static final MAX_BYTES:J = 0x12c00000L

.field static final REQUIRED:[Ljava/lang/String;

.field static final SQE:Ljava/lang/String; = "a660_sqe.fw"


# direct methods
.method static constructor <clinit>()V
    .registers 17

    .line 24
    const-string v4, "lib64/libgsl.so"

    const-string v5, "lib64/libllvm-glnext.so"

    const-string v0, "lib64/egl/libGLESv2_adreno.so"

    const-string v1, "lib64/egl/libEGL_adreno.so"

    const-string v2, "lib64/egl/libGLESv1_CM_adreno.so"

    const-string v3, "lib64/hw/vulkan.adreno.so"

    filled-new-array/range {v0 .. v5}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->REQUIRED:[Ljava/lang/String;

    .line 33
    new-instance v0, Ljava/util/HashSet;

    const-string v6, "libq3dtools_esx.so"

    const-string v7, "libVkLayer_ADRENO_qprofiler.so"

    const-string v1, "eglSubDriverAndroid.so"

    const-string v2, "libEGL_adreno.so"

    const-string v3, "libGLESv1_CM_adreno.so"

    const-string v4, "libGLESv2_adreno.so"

    const-string v5, "libq3dtools_adreno.so"

    filled-new-array/range {v1 .. v7}, [Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    sput-object v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->ALLOW_EGL:Ljava/util/Set;

    .line 36
    new-instance v0, Ljava/util/HashSet;

    const-string v15, "libOpenCL.so"

    const-string v16, "libVkLayer_q3dtools.so"

    const-string v1, "libadreno_app_profiles.so"

    const-string v2, "libadreno_compiler_cl.so"

    const-string v3, "libadreno_utils.so"

    const-string v4, "libCB.so"

    const-string v5, "libdmabufheap.so"

    const-string v6, "libgame_enhance.so"

    const-string v7, "libgpudataproducer.so"

    const-string v8, "libgpu_tonemapper.so"

    const-string v9, "libgsl.so"

    const-string v10, "libkcl.so"

    const-string v11, "libkernelmanager.so"

    const-string v12, "libllvm-glnext.so"

    const-string v13, "libllvm-qcom.so"

    const-string v14, "libllvm-qgl.so"

    filled-new-array/range {v1 .. v16}, [Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    sput-object v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->ALLOW_LIB:Ljava/util/Set;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 64
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static check(Ljava/io/File;)Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;
    .registers 8

    .line 151
    new-instance v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;

    invoke-direct {v0}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;-><init>()V

    .line 152
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 153
    sget-object v2, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->REQUIRED:[Ljava/lang/String;

    array-length v3, v2

    const/4 v4, 0x0

    :goto_e
    if-ge v4, v3, :cond_3a

    aget-object v5, v2, v4

    .line 154
    new-instance v6, Ljava/io/File;

    invoke-direct {v6, p0, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v6}, Ljava/io/File;->isFile()Z

    move-result v6

    if-nez v6, :cond_37

    .line 155
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->length()I

    move-result v6

    if-lez v6, :cond_28

    const-string v6, ", "

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_28
    const/16 v6, 0x2f

    .line 156
    invoke-virtual {v5, v6}, Ljava/lang/String;->lastIndexOf(I)I

    move-result v6

    add-int/lit8 v6, v6, 0x1

    invoke-virtual {v5, v6}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :cond_37
    add-int/lit8 v4, v4, 0x1

    goto :goto_e

    .line 159
    :cond_3a
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->length()I

    move-result v2

    if-lez v2, :cond_4b

    .line 160
    const-string p0, "missing"

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->error:Ljava/lang/String;

    .line 161
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->detail:Ljava/lang/String;

    return-object v0

    .line 165
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

    .line 166
    invoke-virtual {v4}, Ljava/io/File;->length()J

    move-result-wide v5

    add-long/2addr v2, v5

    .line 167
    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v5

    const-string v6, ".so"

    invoke-virtual {v5, v6}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_55

    invoke-static {v4}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->isElf64Arm(Ljava/io/File;)Z

    move-result v5

    if-nez v5, :cond_55

    .line 168
    const-string p0, "not_arm64"

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->error:Ljava/lang/String;

    .line 169
    invoke-virtual {v4}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->detail:Ljava/lang/String;

    return-object v0

    :cond_83
    const-wide/32 v4, 0x12c00000

    cmp-long v1, v2, v4

    if-lez v1, :cond_99

    .line 174
    const-string p0, "too_large"

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->error:Ljava/lang/String;

    const/16 p0, 0x14

    shr-long v1, v2, p0

    .line 175
    invoke-static {v1, v2}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->detail:Ljava/lang/String;

    return-object v0

    .line 178
    :cond_99
    new-instance v1, Ljava/io/File;

    const-string v2, "lib64/egl/libGLESv2_adreno.so"

    invoke-direct {v1, p0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-static {v1}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->version(Ljava/io/File;)Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->version:Ljava/lang/String;

    .line 179
    iget-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->version:Ljava/lang/String;

    if-nez p0, :cond_b2

    .line 180
    const-string p0, "no_version"

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->error:Ljava/lang/String;

    .line 181
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

    .line 257
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

    .line 287
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

    .line 235
    array-length v2, p0

    if-ge v1, v2, :cond_58

    .line 236
    aget-byte v2, p0, v0

    const/16 v3, 0x56

    if-ne v2, v3, :cond_56

    aget-byte v2, p0, v1

    const/16 v3, 0x40

    if-eq v2, v3, :cond_13

    goto :goto_56

    :cond_13
    add-int/lit8 v2, v0, 0x2

    .line 238
    invoke-static {p0, v2}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->digits([BI)I

    move-result v3

    const/4 v4, 0x3

    if-lt v3, v4, :cond_56

    const/4 v4, 0x4

    if-le v3, v4, :cond_20

    goto :goto_56

    :cond_20
    add-int/2addr v2, v3

    .line 241
    array-length v3, p0

    if-ge v2, v3, :cond_56

    aget-byte v3, p0, v2

    const/16 v4, 0x2e

    if-eq v3, v4, :cond_2b

    goto :goto_56

    :cond_2b
    add-int/lit8 v3, v2, 0x1

    .line 242
    invoke-static {p0, v3}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->digits([BI)I

    move-result v3

    if-nez v3, :cond_34

    goto :goto_56

    :cond_34
    add-int/lit8 v3, v3, 0x1

    add-int/2addr v2, v3

    .line 245
    array-length v3, p0

    if-ge v2, v3, :cond_49

    aget-byte v3, p0, v2

    if-ne v3, v4, :cond_49

    add-int/lit8 v3, v2, 0x1

    .line 246
    invoke-static {p0, v3}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->digits([BI)I

    move-result v3

    if-lez v3, :cond_49

    add-int/lit8 v3, v3, 0x1

    add-int/2addr v2, v3

    .line 249
    :cond_49
    array-length v3, p0

    if-lt v2, v3, :cond_4d

    goto :goto_56

    .line 250
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

    .line 144
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

    .line 145
    :cond_17
    sget-object v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->ALLOW_EGL:Ljava/util/Set;

    invoke-interface {v0, p0}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2e

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "lib64/egl/"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 146
    :cond_2e
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "lib64/"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static isDirectChild(Ljava/lang/String;Ljava/lang/String;)Z
    .registers 4

    .line 291
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

    .line 292
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

    .line 198
    new-array v1, v0, [B

    const/4 v2, 0x0

    .line 199
    :try_start_5
    new-instance v3, Ljava/io/FileInputStream;

    invoke-direct {v3, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_a
    .catch Ljava/io/IOException; {:try_start_5 .. :try_end_a} :catch_5e

    move p0, v2

    :goto_b
    if-ge p0, v0, :cond_25

    rsub-int/lit8 v4, p0, 0x14

    .line 202
    :try_start_f
    invoke-virtual {v3, v1, p0, v4}, Ljava/io/InputStream;->read([BII)I

    move-result v4
    :try_end_13
    .catchall {:try_start_f .. :try_end_13} :catchall_1b

    if-gez v4, :cond_19

    .line 206
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

    .line 199
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

    .line 206
    :cond_25
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V
    :try_end_28
    .catch Ljava/io/IOException; {:try_start_21 .. :try_end_28} :catch_5e

    .line 209
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

    .line 263
    new-instance v0, Ljava/lang/String;

    sget-object v1, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v0, p0, v1}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    .line 264
    const-string p0, "\n"

    invoke-virtual {v0, p0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    array-length v0, p0

    const/4 v1, 0x0

    :goto_f
    if-ge v1, v0, :cond_2c

    aget-object v2, p0, v1

    .line 265
    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    .line 266
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

    .line 68
    new-instance v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;

    invoke-direct {v0}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;-><init>()V

    .line 71
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

    .line 72
    const-string v7, "lib64/egl/libGLESv2_adreno.so"

    invoke-static {v6, v7}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->endsWithPath(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_39

    .line 73
    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v7

    add-int/lit8 v7, v7, -0x1d

    invoke-virtual {v6, v3, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v6

    if-eqz v4, :cond_37

    .line 74
    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v7

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v8

    if-ge v7, v8, :cond_d

    :cond_37
    move-object v4, v6

    goto :goto_d

    .line 75
    :cond_39
    const-string v7, "lib/egl/libGLESv2_adreno.so"

    invoke-static {v6, v7}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->endsWithPath(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_d

    const/4 v5, 0x1

    goto :goto_d

    .line 79
    :cond_43
    const-string v1, "firmware/a660_sqe.fw"

    if-eqz v4, :cond_e2

    .line 80
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_4b
    :goto_4b
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_181

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    .line 81
    invoke-virtual {v5, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_5e

    goto :goto_4b

    .line 82
    :cond_5e
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v6

    invoke-virtual {v5, v6}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v6

    .line 83
    const-string v7, "lib64/hw/vulkan.adreno.so"

    invoke-virtual {v6, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-nez v7, :cond_db

    invoke-virtual {v6, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_75

    goto :goto_db

    .line 85
    :cond_75
    const-string v7, "lib64/egl/"

    invoke-static {v6, v7}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->isDirectChild(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_9f

    const/16 v7, 0xa

    .line 86
    invoke-virtual {v6, v7}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v7

    .line 87
    sget-object v8, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->ALLOW_EGL:Ljava/util/Set;

    invoke-interface {v8, v7}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_99

    sget-object v8, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->ALLOW_LIB:Ljava/util/Set;

    invoke-interface {v8, v7}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_94

    goto :goto_99

    .line 88
    :cond_94
    invoke-static {v0, v7}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->unexpected(Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;

    move-result-object p0

    return-object p0

    .line 87
    :cond_99
    :goto_99
    iget-object v7, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->files:Ljava/util/Map;

    invoke-interface {v7, v5, v6}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_4b

    .line 89
    :cond_9f
    const-string v7, "lib64/"

    invoke-static {v6, v7}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->isDirectChild(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_c8

    const/4 v7, 0x6

    .line 90
    invoke-virtual {v6, v7}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v7

    .line 91
    sget-object v8, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->ALLOW_LIB:Ljava/util/Set;

    invoke-interface {v8, v7}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v8

    if-nez v8, :cond_c2

    sget-object v8, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->ALLOW_EGL:Ljava/util/Set;

    invoke-interface {v8, v7}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_bd

    goto :goto_c2

    .line 92
    :cond_bd
    invoke-static {v0, v7}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->unexpected(Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;

    move-result-object p0

    return-object p0

    .line 91
    :cond_c2
    :goto_c2
    iget-object v7, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->files:Ljava/util/Map;

    invoke-interface {v7, v5, v6}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_4b

    .line 93
    :cond_c8
    const-string v5, "lib64/hw/"

    invoke-static {v6, v5}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->isDirectChild(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_4b

    const/16 p0, 0x9

    .line 94
    invoke-virtual {v6, p0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->unexpected(Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;

    move-result-object p0

    return-object p0

    .line 84
    :cond_db
    :goto_db
    iget-object v7, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->files:Ljava/util/Map;

    invoke-interface {v7, v5, v6}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto/16 :goto_4b

    :cond_e2
    if-eqz v5, :cond_e9

    .line 98
    const-string p0, "32bit"

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->error:Ljava/lang/String;

    return-object v0

    .line 102
    :cond_e9
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    move-object v5, v2

    :cond_ee
    :goto_ee
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_122

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    .line 103
    const-string v7, "libGLESv2_adreno.so"

    invoke-virtual {v6, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-nez v7, :cond_10a

    const-string v7, "/libGLESv2_adreno.so"

    invoke-virtual {v6, v7}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_ee

    .line 104
    :cond_10a
    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v7

    add-int/lit8 v7, v7, -0x13

    invoke-virtual {v6, v3, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v6

    if-eqz v5, :cond_120

    .line 105
    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v7

    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v8

    if-ge v7, v8, :cond_ee

    :cond_120
    move-object v5, v6

    goto :goto_ee

    :cond_122
    if-nez v5, :cond_129

    .line 109
    const-string p0, "no_driver"

    iput-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->error:Ljava/lang/String;

    return-object v0

    .line 112
    :cond_129
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_12d
    :goto_12d
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_181

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 113
    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_140

    goto :goto_12d

    .line 114
    :cond_140
    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v6

    invoke-virtual {v4, v6}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v6

    .line 115
    const-string v7, "/"

    invoke-virtual {v6, v7}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v7

    if-nez v7, :cond_12d

    const-string v7, ".so"

    invoke-virtual {v6, v7}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v7

    if-nez v7, :cond_159

    goto :goto_12d

    .line 116
    :cond_159
    const-string v7, "vulkan.adreno.so"

    invoke-virtual {v6, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-nez v7, :cond_177

    sget-object v7, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->ALLOW_EGL:Ljava/util/Set;

    invoke-interface {v7, v6}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v7

    if-nez v7, :cond_177

    sget-object v7, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->ALLOW_LIB:Ljava/util/Set;

    invoke-interface {v7, v6}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_172

    goto :goto_177

    .line 119
    :cond_172
    invoke-static {v0, v6}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->unexpected(Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;

    move-result-object p0

    return-object p0

    .line 117
    :cond_177
    :goto_177
    iget-object v7, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->files:Ljava/util/Map;

    invoke-static {v6}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->flatTarget(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-interface {v7, v4, v6}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_12d

    .line 123
    :cond_181
    iget-object v3, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->files:Ljava/util/Map;

    invoke-interface {v3, v1}, Ljava/util/Map;->containsValue(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_1c3

    .line 126
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :cond_18d
    :goto_18d
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1bc

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 127
    const-string v4, "a660_sqe.fw"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_1aa

    const-string v4, "/a660_sqe.fw"

    invoke-virtual {v3, v4}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_1aa

    goto :goto_18d

    :cond_1aa
    if-eqz v2, :cond_1ba

    .line 128
    const-string v4, "vendor/firmware/"

    invoke-virtual {v3, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v5

    if-eqz v5, :cond_18d

    invoke-virtual {v2, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :cond_18d

    :cond_1ba
    move-object v2, v3

    goto :goto_18d

    :cond_1bc
    if-eqz v2, :cond_1c3

    .line 130
    iget-object p0, v0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->files:Ljava/util/Map;

    invoke-interface {p0, v2, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1c3
    return-object v0
.end method

.method static sanitize(Ljava/lang/String;)Ljava/lang/String;
    .registers 6

    .line 273
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v1, 0x0

    .line 274
    :goto_6
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    if-ge v1, v2, :cond_44

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v2

    const/16 v3, 0x18

    if-ge v2, v3, :cond_44

    .line 275
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

    .line 276
    :cond_3e
    :goto_3e
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    add-int/lit8 v1, v1, 0x1

    goto :goto_6

    .line 278
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

    .line 187
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 188
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

    .line 189
    new-instance v5, Ljava/io/File;

    invoke-direct {v5, p0, v4}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v5}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v4

    if-nez v4, :cond_24

    goto :goto_36

    .line 191
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

    .line 283
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

.method private static unexpected(Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;Ljava/lang/String;)Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;
    .registers 3

    .line 136
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->files:Ljava/util/Map;

    invoke-interface {v0}, Ljava/util/Map;->clear()V

    .line 137
    const-string v0, "unexpected"

    iput-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->error:Ljava/lang/String;

    .line 138
    iput-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->detail:Ljava/lang/String;

    return-object p0
.end method

.method static version(Ljava/io/File;)Ljava/lang/String;
    .registers 8

    .line 215
    :try_start_0
    new-instance v0, Ljava/io/FileInputStream;

    invoke-direct {v0, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_5
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_5} :catch_44

    const/high16 p0, 0x10000

    .line 216
    :try_start_7
    new-array p0, p0, [B

    const/4 v1, 0x0

    .line 217
    new-array v2, v1, [B

    .line 219
    :goto_c
    invoke-virtual {v0, p0}, Ljava/io/InputStream;->read([B)I

    move-result v3

    if-lez v3, :cond_36

    .line 220
    array-length v4, v2

    add-int/2addr v4, v3

    new-array v5, v4, [B

    .line 221
    array-length v6, v2

    invoke-static {v2, v1, v5, v1, v6}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 222
    array-length v2, v2

    invoke-static {p0, v1, v5, v2, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 223
    invoke-static {v5}, Lio/mesalabs/unica/settings/ui/GpuDriverPackage;->findVersion([B)Ljava/lang/String;

    move-result-object v2
    :try_end_22
    .catchall {:try_start_7 .. :try_end_22} :catchall_3a

    if-eqz v2, :cond_28

    .line 229
    :try_start_24
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V
    :try_end_27
    .catch Ljava/io/IOException; {:try_start_24 .. :try_end_27} :catch_44

    return-object v2

    :cond_28
    const/16 v2, 0x20

    .line 225
    :try_start_2a
    invoke-static {v4, v2}, Ljava/lang/Math;->min(II)I

    move-result v2

    .line 226
    new-array v3, v2, [B

    sub-int/2addr v4, v2

    .line 227
    invoke-static {v5, v4, v3, v1, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V
    :try_end_34
    .catchall {:try_start_2a .. :try_end_34} :catchall_3a

    move-object v2, v3

    goto :goto_c

    .line 229
    :cond_36
    :try_start_36
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V
    :try_end_39
    .catch Ljava/io/IOException; {:try_start_36 .. :try_end_39} :catch_44

    goto :goto_44

    :catchall_3a
    move-exception p0

    .line 215
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
