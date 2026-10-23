.class public final Lcom/k4/face/K4FacePreview;
.super Ljava/lang/Object;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/k4/face/K4FacePreview$Worker;,
        Lcom/k4/face/K4FacePreview$Frame;
    }
.end annotation


# static fields
.field private static final NV21:I = 0x11

.field private static final TAG:Ljava/lang/String; = "K4FacePreview"

.field private static sFrames:I

.field private static sWorker:Lcom/k4/face/K4FacePreview$Worker;


# direct methods
.method private constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static release()V
    .registers 3

    :try_start_0
    sget-object v0, Lcom/k4/face/K4FacePreview;->sWorker:Lcom/k4/face/K4FacePreview$Worker;

    const/4 v1, 0x0

    sput-object v1, Lcom/k4/face/K4FacePreview;->sWorker:Lcom/k4/face/K4FacePreview$Worker;

    if-eqz v0, :cond_13

    invoke-virtual {v0}, Lcom/k4/face/K4FacePreview$Worker;->quit()V
    :try_end_a
    .catchall {:try_start_0 .. :try_end_a} :catchall_b

    return-void

    :catchall_b
    move-exception v0

    const-string v1, "K4FacePreview"

    const-string v2, "release failed"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_13
    return-void
.end method

.method public static render(Landroid/view/View;Ljava/lang/Object;[BIIIILandroid/os/Bundle;)V
    .registers 25

    move-object/from16 v0, p0

    move-object/from16 v1, p2

    move/from16 v3, p3

    move/from16 v4, p4

    move-object/from16 v2, p7

    const-string v7, "K4FacePreview"

    const-string v5, "bundle has no memoryfile_descriptor: "

    const-string v6, "onImageProcessed #"

    :try_start_10
    sget v8, Lcom/k4/face/K4FacePreview;->sFrames:I

    invoke-static {v8}, Lcom/k4/face/K4FacePreview;->verbose(I)Z

    move-result v9
    :try_end_16
    .catchall {:try_start_10 .. :try_end_16} :catchall_1ae

    const-string v10, "null"

    if-eqz v9, :cond_6f

    :try_start_1a
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " view="

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v6, " data="

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez v1, :cond_33

    move-object v6, v10

    goto :goto_38

    :cond_33
    array-length v6, v1

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    :goto_38
    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v6, " "

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, "x"

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v6, " ori="

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v6, p5

    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, " fmt="

    invoke-virtual {v9, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v11, p6

    invoke-virtual {v9, v11}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v11, " extras="

    invoke-virtual {v9, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-static {v7, v9}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_71

    :cond_6f
    move/from16 v6, p5

    :goto_71
    add-int/lit8 v8, v8, 0x1

    sput v8, Lcom/k4/face/K4FacePreview;->sFrames:I

    instance-of v8, v0, Landroid/view/TextureView;

    if-eqz v8, :cond_1a8

    if-lez v3, :cond_1a8

    if-gtz v4, :cond_7f

    goto/16 :goto_1a8

    :cond_7f
    mul-int v8, v3, v4

    const/4 v9, 0x3

    mul-int/2addr v8, v9

    div-int/lit8 v8, v8, 0x2
    :try_end_85
    .catchall {:try_start_1a .. :try_end_85} :catchall_1ae

    const-string v11, ")"

    if-eqz v1, :cond_8c

    :try_start_89
    array-length v12, v1

    if-ge v12, v8, :cond_13d

    :cond_8c
    if-eqz v2, :cond_13d

    const-string v12, "memoryfile_descriptor"

    invoke-virtual {v2, v12}, Landroid/os/Bundle;->getParcelable(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object v12

    check-cast v12, Landroid/os/ParcelFileDescriptor;

    if-eqz v12, :cond_125

    sget-object v2, Lcom/k4/face/K4FacePreview;->sWorker:Lcom/k4/face/K4FacePreview$Worker;

    if-eqz v2, :cond_a1

    invoke-virtual {v2, v8}, Lcom/k4/face/K4FacePreview$Worker;->spare(I)[B

    move-result-object v2

    goto :goto_a2

    :cond_a1
    const/4 v2, 0x0

    :goto_a2
    if-nez v2, :cond_a6

    new-array v2, v8, [B
    :try_end_a6
    .catchall {:try_start_89 .. :try_end_a6} :catchall_1ae

    :cond_a6
    :try_start_a6
    new-instance v5, Ljava/io/FileInputStream;

    invoke-virtual {v12}, Landroid/os/ParcelFileDescriptor;->getFileDescriptor()Ljava/io/FileDescriptor;

    move-result-object v13

    invoke-direct {v5, v13}, Ljava/io/FileInputStream;-><init>(Ljava/io/FileDescriptor;)V
    :try_end_af
    .catchall {:try_start_a6 .. :try_end_af} :catchall_120

    :try_start_af
    invoke-static {v2}, Ljava/nio/ByteBuffer;->wrap([B)Ljava/nio/ByteBuffer;

    move-result-object v13

    const-wide/16 v14, 0x0

    :goto_b5
    invoke-virtual {v13}, Ljava/nio/ByteBuffer;->hasRemaining()Z

    move-result v16

    if-eqz v16, :cond_ce

    invoke-virtual {v5}, Ljava/io/FileInputStream;->getChannel()Ljava/nio/channels/FileChannel;

    move-result-object v9

    invoke-virtual {v9, v13, v14, v15}, Ljava/nio/channels/FileChannel;->read(Ljava/nio/ByteBuffer;J)I

    move-result v9

    if-gtz v9, :cond_c6

    goto :goto_ce

    :cond_c6
    int-to-long v0, v9

    add-long/2addr v14, v0

    const/4 v9, 0x3

    move-object/from16 v0, p0

    move-object/from16 v1, p2

    goto :goto_b5

    :cond_ce
    :goto_ce
    sget v0, Lcom/k4/face/K4FacePreview;->sFrames:I

    const/4 v1, 0x3

    if-gt v0, v1, :cond_101

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "read "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v14, v15}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v1, " of "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " bytes from memory file (stat size "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object/from16 p1, v2

    invoke-virtual {v12}, Landroid/os/ParcelFileDescriptor;->getStatSize()J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v7, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_100
    .catchall {:try_start_af .. :try_end_100} :catchall_115

    goto :goto_103

    :cond_101
    move-object/from16 p1, v2

    :goto_103
    :try_start_103
    invoke-virtual {v5}, Ljava/io/FileInputStream;->close()V
    :try_end_106
    .catchall {:try_start_103 .. :try_end_106} :catchall_120

    :try_start_106
    invoke-virtual {v12}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_109
    .catch Ljava/lang/Exception; {:try_start_106 .. :try_end_109} :catch_109
    .catchall {:try_start_106 .. :try_end_109} :catchall_1ae

    :catch_109
    int-to-long v0, v8

    cmp-long v0, v14, v0

    if-ltz v0, :cond_111

    move-object/from16 v0, p1

    goto :goto_113

    :cond_111
    move-object/from16 v0, p2

    :goto_113
    move-object v2, v0

    goto :goto_13f

    :catchall_115
    move-exception v0

    move-object v1, v0

    :try_start_117
    invoke-virtual {v5}, Ljava/io/FileInputStream;->close()V
    :try_end_11a
    .catchall {:try_start_117 .. :try_end_11a} :catchall_11b

    goto :goto_11f

    :catchall_11b
    move-exception v0

    :try_start_11c
    invoke-virtual {v1, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_11f
    throw v1
    :try_end_120
    .catchall {:try_start_11c .. :try_end_120} :catchall_120

    :catchall_120
    move-exception v0

    :try_start_121
    invoke-virtual {v12}, Landroid/os/ParcelFileDescriptor;->close()V
    :try_end_124
    .catch Ljava/lang/Exception; {:try_start_121 .. :try_end_124} :catch_124
    .catchall {:try_start_121 .. :try_end_124} :catchall_1ae

    :catch_124
    :try_start_124
    throw v0

    :cond_125
    sget v0, Lcom/k4/face/K4FacePreview;->sFrames:I

    const/4 v1, 0x3

    if-gt v0, v1, :cond_13d

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Landroid/os/Bundle;->keySet()Ljava/util/Set;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v7, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_13d
    move-object/from16 v2, p2

    :goto_13f
    if-eqz v2, :cond_189

    array-length v0, v2

    if-ge v0, v8, :cond_145

    goto :goto_189

    :cond_145
    move-object/from16 v0, p0

    check-cast v0, Landroid/view/TextureView;

    invoke-virtual {v0}, Landroid/view/TextureView;->getSurfaceTexture()Landroid/graphics/SurfaceTexture;

    move-result-object v1

    if-nez v1, :cond_16f

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "TextureView has no SurfaceTexture yet (available="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object/from16 v1, p0

    check-cast v1, Landroid/view/TextureView;

    invoke-virtual {v1}, Landroid/view/TextureView;->isAvailable()Z

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_16b
    invoke-static {v7, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1b4

    :cond_16f
    sget-object v0, Lcom/k4/face/K4FacePreview;->sWorker:Lcom/k4/face/K4FacePreview$Worker;

    if-nez v0, :cond_17a

    new-instance v0, Lcom/k4/face/K4FacePreview$Worker;

    invoke-direct {v0}, Lcom/k4/face/K4FacePreview$Worker;-><init>()V

    sput-object v0, Lcom/k4/face/K4FacePreview;->sWorker:Lcom/k4/face/K4FacePreview$Worker;

    :cond_17a
    sget-object v8, Lcom/k4/face/K4FacePreview;->sWorker:Lcom/k4/face/K4FacePreview$Worker;

    new-instance v0, Lcom/k4/face/K4FacePreview$Frame;

    sget v6, Lcom/k4/face/K4FacePreview;->sFrames:I

    move/from16 v5, p5

    invoke-direct/range {v0 .. v6}, Lcom/k4/face/K4FacePreview$Frame;-><init>(Landroid/graphics/SurfaceTexture;[BIIII)V

    invoke-virtual {v8, v0}, Lcom/k4/face/K4FacePreview$Worker;->offer(Lcom/k4/face/K4FacePreview$Frame;)V

    goto :goto_1b4

    :cond_189
    :goto_189
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "no frame data ("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez v2, :cond_196

    goto :goto_19b

    :cond_196
    array-length v1, v2

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v10

    :goto_19b
    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v1, " bytes)"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_16b

    :cond_1a8
    :goto_1a8
    const-string v0, "bad view/size"

    invoke-static {v7, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1ad
    .catchall {:try_start_124 .. :try_end_1ad} :catchall_1ae

    return-void

    :catchall_1ae
    move-exception v0

    const-string v1, "render failed"

    invoke-static {v7, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_1b4
    return-void
.end method

.method private static verbose(I)Z
    .registers 2

    const/4 v0, 0x3

    if-lt p0, v0, :cond_a

    rem-int/lit8 p0, p0, 0x1e

    if-nez p0, :cond_8

    goto :goto_a

    :cond_8
    const/4 p0, 0x0

    return p0

    :cond_a
    :goto_a
    const/4 p0, 0x1

    return p0
.end method
