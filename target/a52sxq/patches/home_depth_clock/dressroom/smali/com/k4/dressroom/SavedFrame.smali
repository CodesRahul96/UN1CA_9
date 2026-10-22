.class final Lcom/k4/dressroom/SavedFrame;
.super Ljava/lang/Object;
.source "SavedFrame.java"


# static fields
.field static final FILE:Ljava/lang/String; = "k4_frame_edit.json"

.field static final HOLE_TOL:F = 0.01f

.field static final MAX_APPLIES:I = 0x4

.field static final TAG:Ljava/lang/String; = "K4HomeClock"

.field static final VERSION:I = 0x1

.field static final WINDOW_MS:J = 0x4e20L

.field private static sApplied:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field

.field private static sApplies:I

.field private static sBounds:Landroid/graphics/RectF;

.field private static volatile sDone:Z

.field private static sPosted:Z

.field private static sRead:Z

.field private static sRec:Lorg/json/JSONObject;

.field private static sUntil:J


# direct methods
.method static bridge synthetic -$$Nest$sfgetsDone()Z
    .locals 1

    sget-boolean v0, Lcom/k4/dressroom/SavedFrame;->sDone:Z

    return v0
.end method

.method static bridge synthetic -$$Nest$sfgetsRec()Lorg/json/JSONObject;
    .locals 1

    sget-object v0, Lcom/k4/dressroom/SavedFrame;->sRec:Lorg/json/JSONObject;

    return-object v0
.end method

.method static bridge synthetic -$$Nest$sfputsPosted(Z)V
    .locals 0

    sput-boolean p0, Lcom/k4/dressroom/SavedFrame;->sPosted:Z

    return-void
.end method

.method static constructor <clinit>()V
    .locals 2

    new-instance v0, Ljava/lang/ref/WeakReference;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v0, Lcom/k4/dressroom/SavedFrame;->sApplied:Ljava/lang/ref/WeakReference;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static apply(Landroid/view/View;)V
    .locals 1

    const/4 v0, 0x1

    sput-boolean v0, Lcom/k4/dressroom/SavedFrame;->sPosted:Z

    new-instance v0, Lcom/k4/dressroom/SavedFrame$1;

    invoke-direct {v0, p0}, Lcom/k4/dressroom/SavedFrame$1;-><init>(Landroid/view/View;)V

    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method static done(Ljava/lang/String;)V
    .locals 2

    const/4 v0, 0x1

    sput-boolean v0, Lcom/k4/dressroom/SavedFrame;->sDone:Z

    sget-object v0, Lcom/k4/dressroom/SavedFrame;->sRec:Lorg/json/JSONObject;

    if-eqz v0, :cond_0

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "saved frame edit: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "K4HomeClock"

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    const/4 p0, 0x0

    sput-object p0, Lcom/k4/dressroom/SavedFrame;->sRec:Lorg/json/JSONObject;

    return-void
.end method

.method static drift(Landroid/view/View;)V
    .locals 5

    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->bounds(Landroid/view/View;)Landroid/graphics/RectF;

    move-result-object v0

    sget-object v1, Lcom/k4/dressroom/SavedFrame;->sBounds:Landroid/graphics/RectF;

    if-eqz v0, :cond_1

    if-eqz v1, :cond_1

    iget v2, v0, Landroid/graphics/RectF;->left:F

    iget v3, v1, Landroid/graphics/RectF;->left:F

    sub-float/2addr v2, v3

    invoke-static {v2}, Ljava/lang/Math;->abs(F)F

    move-result v2

    const/high16 v3, 0x3fc00000    # 1.5f

    cmpl-float v2, v2, v3

    if-gtz v2, :cond_0

    iget v2, v0, Landroid/graphics/RectF;->top:F

    iget v4, v1, Landroid/graphics/RectF;->top:F

    sub-float/2addr v2, v4

    invoke-static {v2}, Ljava/lang/Math;->abs(F)F

    move-result v2

    cmpl-float v2, v2, v3

    if-gtz v2, :cond_0

    iget v2, v0, Landroid/graphics/RectF;->right:F

    iget v4, v1, Landroid/graphics/RectF;->right:F

    sub-float/2addr v2, v4

    invoke-static {v2}, Ljava/lang/Math;->abs(F)F

    move-result v2

    cmpl-float v2, v2, v3

    if-gtz v2, :cond_0

    iget v2, v0, Landroid/graphics/RectF;->bottom:F

    iget v1, v1, Landroid/graphics/RectF;->bottom:F

    sub-float/2addr v2, v1

    invoke-static {v2}, Ljava/lang/Math;->abs(F)F

    move-result v1

    cmpl-float v1, v1, v3

    if-lez v1, :cond_1

    :cond_0
    const/4 v1, 0x1

    goto :goto_0

    :cond_1
    const/4 v1, 0x0

    :goto_0
    invoke-static {p0}, Lcom/k4/dressroom/FrameSize;->holeStale(Landroid/view/View;)Z

    move-result v2

    if-nez v1, :cond_2

    if-nez v2, :cond_2

    return-void

    :cond_2
    sget v2, Lcom/k4/dressroom/SavedFrame;->sApplies:I

    const/4 v3, 0x4

    if-lt v2, v3, :cond_3

    const-string p0, "Samsung keeps changing the frame, left as it is"

    invoke-static {p0}, Lcom/k4/dressroom/SavedFrame;->done(Ljava/lang/String;)V

    return-void

    :cond_3
    if-eqz v1, :cond_4

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "moved the picture to "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_1

    :cond_4
    const-string v0, "set the frame\'s hole again"

    :goto_1
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "saved frame edit: Samsung "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ", restoring again"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "K4HomeClock"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {p0}, Lcom/k4/dressroom/SavedFrame;->apply(Landroid/view/View;)V

    return-void
.end method

.method static load(Landroid/view/View;)Z
    .locals 11
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->activity(Landroid/view/View;)Landroid/app/Activity;

    move-result-object p0

    const/4 v0, 0x0

    if-eqz p0, :cond_b

    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    move-result-object v1

    if-eqz v1, :cond_b

    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    move-result-object v1

    const-string v2, "re_edit_screen"

    invoke-virtual {v1, v2, v0}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result v1

    if-nez v1, :cond_0

    goto/16 :goto_7

    :cond_0
    const/4 v1, 0x0

    :try_start_0
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    move-result-object p0

    const-string v2, "saved_bg_region_path_list"

    invoke-virtual {p0, v2}, Landroid/content/Intent;->getStringArrayListExtra(Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catchall_0
    move-object p0, v1

    :goto_0
    const-string v2, "K4HomeClock"

    if-eqz p0, :cond_a

    invoke-virtual {p0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_1

    goto/16 :goto_6

    :cond_1
    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_2
    :goto_1
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_9

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    if-eqz v4, :cond_4

    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-eqz v5, :cond_3

    goto :goto_2

    :cond_3
    new-instance v5, Ljava/io/File;

    invoke-direct {v5, v4}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v4

    goto :goto_3

    :cond_4
    :goto_2
    move-object v4, v1

    :goto_3
    if-eqz v4, :cond_5

    new-instance v5, Ljava/io/File;

    const-string v6, "k4_frame_edit.json"

    invoke-direct {v5, v4, v6}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    goto :goto_4

    :cond_5
    move-object v5, v1

    :goto_4
    if-eqz v5, :cond_2

    invoke-virtual {v5}, Ljava/io/File;->isFile()Z

    move-result v4

    if-nez v4, :cond_6

    goto :goto_1

    :cond_6
    new-instance v4, Lorg/json/JSONObject;

    new-instance v6, Ljava/lang/String;

    invoke-virtual {v5}, Ljava/io/File;->toPath()Ljava/nio/file/Path;

    move-result-object v7

    invoke-static {v7}, Ljava/nio/file/Files;->readAllBytes(Ljava/nio/file/Path;)[B

    move-result-object v7

    sget-object v8, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v6, v7, v8}, Ljava/lang/String;-><init>([BLjava/nio/charset/Charset;)V

    invoke-direct {v4, v6}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v6, "v"

    invoke-virtual {v4, v6, v0}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v6

    const-string v7, "kind"

    const/4 v8, 0x1

    if-lt v6, v8, :cond_8

    if-gt v6, v8, :cond_8

    const-string v9, "frame"

    invoke-virtual {v4, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_7

    goto :goto_5

    :cond_7
    sput-object v4, Lcom/k4/dressroom/SavedFrame;->sRec:Lorg/json/JSONObject;

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    const-wide/16 v6, 0x4e20

    add-long/2addr v0, v6

    sput-wide v0, Lcom/k4/dressroom/SavedFrame;->sUntil:J

    sget-object p0, Ljava/util/Locale;->US:Ljava/util/Locale;

    const-string v0, "k"

    const-wide/high16 v6, 0x3ff0000000000000L    # 1.0

    invoke-virtual {v4, v0, v6, v7}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;D)D

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v0

    const-string v1, "s"

    invoke-virtual {v4, v1, v6, v7}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;D)D

    move-result-wide v6

    invoke-static {v6, v7}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v1

    const-string v3, "deg"

    const-wide/16 v6, 0x0

    invoke-virtual {v4, v3, v6, v7}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;D)D

    move-result-wide v3

    invoke-static {v3, v4}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v3

    filled-new-array {v5, v0, v1, v3}, [Ljava/lang/Object;

    move-result-object v0

    const-string v1, "saved frame edit for this re-edit (%s): frame size %.3f, scale %.3f, %.1f deg; waiting for the frame"

    invoke-static {p0, v1, v0}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return v8

    :cond_8
    :goto_5
    invoke-static {v5}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v7}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    new-instance v7, Ljava/lang/StringBuilder;

    const-string v8, "saved frame edit: "

    invoke-direct {v7, v8}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, " is version "

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, " / "

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ", ignored"

    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v2, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto/16 :goto_1

    :cond_9
    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v3, "saved frame edit: none in "

    invoke-direct {v1, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return v0

    :cond_a
    :goto_6
    const-string p0, "saved frame edit: this re-edit names no layer directory"

    invoke-static {v2, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_b
    :goto_7
    return v0
.end method

.method static otherFrame(Landroid/view/View;Landroid/graphics/RectF;Lorg/json/JSONObject;)Ljava/lang/String;
    .locals 16
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    move-object/from16 v0, p1

    move-object/from16 v1, p2

    invoke-virtual/range {p0 .. p0}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    invoke-virtual/range {p0 .. p0}, Landroid/view/View;->getHeight()I

    move-result v3

    int-to-float v3, v3

    const-string v4, "vw"

    invoke-virtual {v1, v4}, Lorg/json/JSONObject;->getDouble(Ljava/lang/String;)D

    move-result-wide v4

    const-string v6, "vh"

    invoke-virtual {v1, v6}, Lorg/json/JSONObject;->getDouble(Ljava/lang/String;)D

    move-result-wide v6

    div-float v8, v2, v3

    float-to-double v8, v8

    div-double v10, v4, v6

    sub-double/2addr v8, v10

    invoke-static {v8, v9}, Ljava/lang/Math;->abs(D)D

    move-result-wide v8

    const-wide v10, 0x3f847ae147ae147bL    # 0.01

    mul-double/2addr v10, v4

    div-double/2addr v10, v6

    cmpl-double v8, v8, v10

    if-lez v8, :cond_0

    sget-object v0, Ljava/util/Locale;->US:Ljava/util/Locale;

    invoke-static {v2}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v1

    invoke-static {v3}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v2

    invoke-static {v4, v5}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v3

    invoke-static {v6, v7}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v4

    filled-new-array {v1, v2, v3, v4}, [Ljava/lang/Object;

    move-result-object v1

    const-string v2, "preview %.0fx%.0f, saved in %.0fx%.0f"

    invoke-static {v0, v2, v1}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    return-object v0

    :cond_0
    const-string v4, "hole"

    invoke-virtual {v1, v4}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v4

    iget v5, v0, Landroid/graphics/RectF;->left:F

    div-float/2addr v5, v2

    iget v6, v0, Landroid/graphics/RectF;->top:F

    div-float/2addr v6, v3

    iget v7, v0, Landroid/graphics/RectF;->right:F

    div-float/2addr v7, v2

    iget v8, v0, Landroid/graphics/RectF;->bottom:F

    div-float/2addr v8, v3

    const/4 v9, 0x4

    new-array v10, v9, [F

    const/4 v11, 0x0

    aput v5, v10, v11

    const/4 v5, 0x1

    aput v6, v10, v5

    const/4 v6, 0x2

    aput v7, v10, v6

    const/4 v6, 0x3

    aput v8, v10, v6

    move v6, v11

    :goto_0
    const-string v7, ", saved "

    const-string v8, "x"

    if-ge v6, v9, :cond_2

    aget v12, v10, v6

    float-to-double v12, v12

    invoke-virtual {v4, v6}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v14

    sub-double/2addr v12, v14

    invoke-static {v12, v13}, Ljava/lang/Math;->abs(D)D

    move-result-wide v12

    const-wide v14, 0x3f847ae140000000L    # 0.009999999776482582

    cmpl-double v12, v12, v14

    if-lez v12, :cond_1

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "another frame: hole "

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " in "

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    :cond_1
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    :cond_2
    const-string v0, "plate"

    invoke-virtual {v1, v0}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v0

    invoke-static/range {p0 .. p0}, Lcom/k4/dressroom/SavedFrame;->plate(Landroid/view/View;)[I

    move-result-object v1

    if-eqz v0, :cond_4

    if-eqz v1, :cond_4

    aget v2, v1, v11

    invoke-virtual {v0, v11}, Lorg/json/JSONArray;->getInt(I)I

    move-result v3

    sub-int/2addr v2, v3

    invoke-static {v2}, Ljava/lang/Math;->abs(I)I

    move-result v2

    if-gt v2, v5, :cond_3

    aget v2, v1, v5

    invoke-virtual {v0, v5}, Lorg/json/JSONArray;->getInt(I)I

    move-result v3

    sub-int/2addr v2, v3

    invoke-static {v2}, Ljava/lang/Math;->abs(I)I

    move-result v2

    if-le v2, v5, :cond_4

    :cond_3
    aget v2, v1, v11

    aget v1, v1, v5

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "another frame: plate "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    :cond_4
    const/4 v0, 0x0

    return-object v0
.end method

.method static plate(Landroid/view/View;)[I
    .locals 3

    const-string v0, "FRAME_BASE"

    invoke-static {p0, v0}, Lcom/k4/dressroom/EditXf;->frameView(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object p0

    instance-of v0, p0, Landroid/widget/ImageView;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    check-cast p0, Landroid/widget/ImageView;

    invoke-virtual {p0}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object p0

    goto :goto_0

    :cond_0
    move-object p0, v1

    :goto_0
    if-eqz p0, :cond_2

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getIntrinsicWidth()I

    move-result v0

    if-lez v0, :cond_2

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result v0

    if-gtz v0, :cond_1

    goto :goto_1

    :cond_1
    const/4 v0, 0x2

    new-array v0, v0, [I

    const/4 v1, 0x0

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getIntrinsicWidth()I

    move-result v2

    aput v2, v0, v1

    const/4 v1, 0x1

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result p0

    aput p0, v0, v1

    return-object v0

    :cond_2
    :goto_1
    return-object v1
.end method

.method static record()Lorg/json/JSONObject;
    .locals 13
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    invoke-static {}, Lcom/k4/dressroom/FrameSize;->kept()F

    move-result v0

    const/high16 v1, 0x3f800000    # 1.0f

    cmpl-float v1, v0, v1

    const/4 v2, 0x0

    if-nez v1, :cond_0

    invoke-static {}, Lcom/k4/dressroom/EditXf;->identity()Z

    move-result v1

    if-eqz v1, :cond_0

    return-object v2

    :cond_0
    invoke-static {}, Lcom/k4/dressroom/EditXf;->frameBackground()Landroid/view/View;

    move-result-object v1

    const-string v3, "K4HomeClock"

    if-eqz v1, :cond_c

    invoke-virtual {v1}, Landroid/view/View;->getWidth()I

    move-result v4

    if-eqz v4, :cond_c

    invoke-virtual {v1}, Landroid/view/View;->getHeight()I

    move-result v4

    if-nez v4, :cond_1

    goto/16 :goto_5

    :cond_1
    invoke-virtual {v1}, Landroid/view/View;->getWidth()I

    move-result v4

    int-to-float v4, v4

    invoke-virtual {v1}, Landroid/view/View;->getHeight()I

    move-result v5

    int-to-float v5, v5

    invoke-static {v1}, Lcom/k4/dressroom/FrameSize;->samsungHole(Landroid/view/View;)Landroid/graphics/RectF;

    move-result-object v6

    invoke-static {v1}, Lcom/k4/dressroom/EditXf;->bounds(Landroid/view/View;)Landroid/graphics/RectF;

    move-result-object v7

    invoke-static {v1}, Lcom/k4/dressroom/EditXf;->aspect(Landroid/view/View;)F

    move-result v8

    invoke-static {v1}, Lcom/k4/dressroom/EditXf;->fingerprint(Landroid/view/View;)[I

    move-result-object v9

    if-eqz v6, :cond_b

    invoke-virtual {v6}, Landroid/graphics/RectF;->isEmpty()Z

    move-result v10

    if-nez v10, :cond_b

    if-eqz v7, :cond_b

    invoke-virtual {v7}, Landroid/graphics/RectF;->isEmpty()Z

    move-result v10

    if-nez v10, :cond_b

    const/4 v10, 0x0

    cmpl-float v10, v8, v10

    if-eqz v10, :cond_b

    if-nez v9, :cond_2

    goto/16 :goto_4

    :cond_2
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    const-string v3, "v"

    const/4 v10, 0x1

    invoke-virtual {v2, v3, v10}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v3, "kind"

    const-string v11, "frame"

    invoke-virtual {v2, v3, v11}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v3, "vw"

    float-to-double v11, v4

    invoke-virtual {v2, v3, v11, v12}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string v3, "vh"

    float-to-double v11, v5

    invoke-virtual {v2, v3, v11, v12}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string v3, "hole"

    invoke-static {v6, v4, v5}, Lcom/k4/dressroom/SavedFrame;->rect(Landroid/graphics/RectF;FF)Lorg/json/JSONArray;

    move-result-object v6

    invoke-virtual {v2, v3, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    invoke-static {v1}, Lcom/k4/dressroom/SavedFrame;->plate(Landroid/view/View;)[I

    move-result-object v1

    const/4 v3, 0x0

    if-eqz v1, :cond_3

    new-instance v6, Lorg/json/JSONArray;

    invoke-direct {v6}, Lorg/json/JSONArray;-><init>()V

    aget v11, v1, v3

    invoke-virtual {v6, v11}, Lorg/json/JSONArray;->put(I)Lorg/json/JSONArray;

    move-result-object v6

    aget v1, v1, v10

    invoke-virtual {v6, v1}, Lorg/json/JSONArray;->put(I)Lorg/json/JSONArray;

    move-result-object v1

    const-string v6, "plate"

    invoke-virtual {v2, v6, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :cond_3
    const-string v1, "bounds"

    invoke-static {v7, v4, v5}, Lcom/k4/dressroom/SavedFrame;->rect(Landroid/graphics/RectF;FF)Lorg/json/JSONArray;

    move-result-object v6

    invoke-virtual {v2, v1, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v1, "aspect"

    float-to-double v6, v8

    invoke-virtual {v2, v1, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    new-instance v1, Lorg/json/JSONArray;

    invoke-direct {v1}, Lorg/json/JSONArray;-><init>()V

    array-length v6, v9

    :goto_0
    if-ge v3, v6, :cond_4

    aget v7, v9, v3

    invoke-virtual {v1, v7}, Lorg/json/JSONArray;->put(I)Lorg/json/JSONArray;

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_4
    const-string v3, "fp"

    invoke-virtual {v2, v3, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v1, "k"

    float-to-double v6, v0

    invoke-virtual {v2, v1, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    invoke-static {}, Lcom/k4/dressroom/EditXf;->identity()Z

    move-result v0

    if-nez v0, :cond_5

    sget v1, Lcom/k4/dressroom/EditXf;->s:F

    float-to-double v6, v1

    goto :goto_1

    :cond_5
    const-wide/high16 v6, 0x3ff0000000000000L    # 1.0

    :goto_1
    const-string v1, "s"

    invoke-virtual {v2, v1, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-wide/16 v6, 0x0

    if-nez v0, :cond_6

    invoke-static {}, Lcom/k4/dressroom/EditXf;->shownDeg()F

    move-result v1

    float-to-double v8, v1

    goto :goto_2

    :cond_6
    move-wide v8, v6

    :goto_2
    const-string v1, "deg"

    invoke-virtual {v2, v1, v8, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    if-nez v0, :cond_7

    sget v1, Lcom/k4/dressroom/EditXf;->tx:F

    div-float/2addr v1, v4

    float-to-double v3, v1

    goto :goto_3

    :cond_7
    move-wide v3, v6

    :goto_3
    const-string v1, "tx"

    invoke-virtual {v2, v1, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    if-nez v0, :cond_8

    sget v1, Lcom/k4/dressroom/EditXf;->ty:F

    div-float/2addr v1, v5

    float-to-double v6, v1

    :cond_8
    const-string v1, "ty"

    invoke-virtual {v2, v1, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string v1, "fill"

    sget v3, Lcom/k4/dressroom/EditXf;->sFill:I

    invoke-virtual {v2, v1, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    sget-object v1, Lcom/k4/dressroom/EditXf;->sLastFillColor:Ljava/lang/Integer;

    if-nez v0, :cond_9

    sget v0, Lcom/k4/dressroom/EditXf;->sFill:I

    if-nez v0, :cond_9

    if-eqz v1, :cond_9

    const-string v0, "color"

    invoke-virtual {v2, v0, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :cond_9
    invoke-static {}, Lcom/k4/dressroom/HomeClock;->styleName()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_a

    const-string v1, "style"

    invoke-virtual {v2, v1, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :cond_a
    return-object v2

    :cond_b
    :goto_4
    invoke-static {v6}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v7}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "saved frame edit: frame view not set up (hole "

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ", picture "

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ")"

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-object v2

    :cond_c
    :goto_5
    const-string v0, "saved frame edit: no frame picture view"

    invoke-static {v3, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-object v2
.end method

.method static rect(Landroid/graphics/RectF;FF)Lorg/json/JSONArray;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    new-instance v0, Lorg/json/JSONArray;

    invoke-direct {v0}, Lorg/json/JSONArray;-><init>()V

    iget v1, p0, Landroid/graphics/RectF;->left:F

    div-float/2addr v1, p1

    float-to-double v1, v1

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONArray;->put(D)Lorg/json/JSONArray;

    move-result-object v0

    iget v1, p0, Landroid/graphics/RectF;->top:F

    div-float/2addr v1, p2

    float-to-double v1, v1

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONArray;->put(D)Lorg/json/JSONArray;

    move-result-object v0

    iget v1, p0, Landroid/graphics/RectF;->right:F

    div-float/2addr v1, p1

    float-to-double v1, v1

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONArray;->put(D)Lorg/json/JSONArray;

    move-result-object p1

    iget p0, p0, Landroid/graphics/RectF;->bottom:F

    div-float/2addr p0, p2

    float-to-double v0, p0

    invoke-virtual {p1, v0, v1}, Lorg/json/JSONArray;->put(D)Lorg/json/JSONArray;

    move-result-object p0

    return-object p0
.end method

.method static reset()V
    .locals 2

    const/4 v0, 0x0

    sput-boolean v0, Lcom/k4/dressroom/SavedFrame;->sRead:Z

    sput-boolean v0, Lcom/k4/dressroom/SavedFrame;->sDone:Z

    const/4 v1, 0x0

    sput-object v1, Lcom/k4/dressroom/SavedFrame;->sRec:Lorg/json/JSONObject;

    sput-boolean v0, Lcom/k4/dressroom/SavedFrame;->sPosted:Z

    sput v0, Lcom/k4/dressroom/SavedFrame;->sApplies:I

    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, v1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v0, Lcom/k4/dressroom/SavedFrame;->sApplied:Ljava/lang/ref/WeakReference;

    sput-object v1, Lcom/k4/dressroom/SavedFrame;->sBounds:Landroid/graphics/RectF;

    return-void
.end method

.method static restore(Landroid/view/View;Lorg/json/JSONObject;)V
    .locals 18
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v3

    int-to-float v3, v3

    const-string v4, "vw"

    invoke-virtual {v1, v4}, Lorg/json/JSONObject;->getDouble(Ljava/lang/String;)D

    move-result-wide v5

    double-to-float v5, v5

    div-float v5, v2, v5

    const-string v6, "bounds"

    invoke-virtual {v1, v6}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v6

    invoke-virtual {v1, v4}, Lorg/json/JSONObject;->getDouble(Ljava/lang/String;)D

    move-result-wide v7

    const-string v4, "vh"

    invoke-virtual {v1, v4}, Lorg/json/JSONObject;->getDouble(Ljava/lang/String;)D

    move-result-wide v9

    new-instance v4, Landroid/graphics/RectF;

    const/4 v11, 0x0

    invoke-virtual {v6, v11}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v11

    mul-double/2addr v11, v7

    float-to-double v13, v5

    mul-double/2addr v11, v13

    double-to-float v5, v11

    const/4 v11, 0x1

    invoke-virtual {v6, v11}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v15

    mul-double/2addr v15, v9

    move/from16 v17, v11

    mul-double v11, v15, v13

    double-to-float v11, v11

    const/4 v12, 0x2

    invoke-virtual {v6, v12}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v15

    mul-double/2addr v15, v7

    mul-double v7, v15, v13

    double-to-float v7, v7

    const/4 v8, 0x3

    invoke-virtual {v6, v8}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v15

    mul-double/2addr v15, v9

    mul-double v8, v15, v13

    double-to-float v6, v8

    invoke-direct {v4, v5, v11, v7, v6}, Landroid/graphics/RectF;-><init>(FFFF)V

    const-string v5, "k"

    const-wide/high16 v6, 0x3ff0000000000000L    # 1.0

    invoke-virtual {v1, v5, v6, v7}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;D)D

    move-result-wide v5

    double-to-float v5, v5

    invoke-static {v0, v5}, Lcom/k4/dressroom/FrameSize;->restore(Landroid/view/View;F)V

    invoke-static {v0, v4}, Lcom/k4/dressroom/FrameSize;->pictureBounds(Landroid/view/View;Landroid/graphics/RectF;)V

    invoke-static {v0}, Lcom/k4/dressroom/FrameSize;->applyHole(Landroid/view/View;)V

    invoke-static {v0, v1, v2, v3}, Lcom/k4/dressroom/EditXf;->restoreFrame(Landroid/view/View;Lorg/json/JSONObject;FF)V

    invoke-static {v0}, Lcom/k4/dressroom/EditXf;->bounds(Landroid/view/View;)Landroid/graphics/RectF;

    move-result-object v1

    sput-object v1, Lcom/k4/dressroom/SavedFrame;->sBounds:Landroid/graphics/RectF;

    new-instance v1, Ljava/lang/ref/WeakReference;

    invoke-direct {v1, v0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v1, Lcom/k4/dressroom/SavedFrame;->sApplied:Ljava/lang/ref/WeakReference;

    sget v1, Lcom/k4/dressroom/SavedFrame;->sApplies:I

    add-int/lit8 v1, v1, 0x1

    sput v1, Lcom/k4/dressroom/SavedFrame;->sApplies:I

    sget-object v1, Ljava/util/Locale;->US:Ljava/util/Locale;

    sget v2, Lcom/k4/dressroom/SavedFrame;->sApplies:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-static {}, Lcom/k4/dressroom/FrameSize;->kept()F

    move-result v2

    invoke-static {v2}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v4

    sget v2, Lcom/k4/dressroom/EditXf;->s:F

    invoke-static {v2}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v5

    invoke-static {}, Lcom/k4/dressroom/EditXf;->shownDeg()F

    move-result v2

    invoke-static {v2}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v6

    sget v2, Lcom/k4/dressroom/EditXf;->tx:F

    invoke-static {v2}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v7

    sget v2, Lcom/k4/dressroom/EditXf;->ty:F

    invoke-static {v2}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v8

    sget-object v9, Lcom/k4/dressroom/SavedFrame;->sBounds:Landroid/graphics/RectF;

    filled-new-array/range {v3 .. v9}, [Ljava/lang/Object;

    move-result-object v2

    const-string v3, "re-edit: saved frame edit restored (%d): frame size %.3f, scale %.3f, %.1f deg, offset %.0f,%.0f, picture %s"

    invoke-static {v1, v3, v2}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "K4HomeClock"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {v0}, Lcom/k4/dressroom/EditXf;->redraw(Landroid/view/View;)V

    invoke-static {v0}, Lcom/k4/dressroom/FrameSize;->refit(Landroid/view/View;)V

    invoke-static {v0}, Lcom/k4/dressroom/EditXf;->showSwitchLater(Landroid/view/View;)V

    return-void
.end method

.method static save(Ljava/lang/Object;)V
    .locals 8

    const-string v0, "saved frame edit: no layer directory"

    const-string v1, "K4HomeClock"

    const-string v2, "rename to "

    const-string v3, "saved frame edit -> "

    const-string v4, "saved frame edit: nothing to keep for this save, "

    :try_start_0
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    const-string v6, "a"

    const/4 v7, 0x0

    invoke-virtual {v5, v6, v7}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v5

    invoke-virtual {v5, p0, v7}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    instance-of v5, p0, Ljava/lang/String;

    if-eqz v5, :cond_5

    move-object v5, p0

    check-cast v5, Ljava/lang/String;

    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-eqz v5, :cond_0

    goto/16 :goto_1

    :cond_0
    new-instance v5, Ljava/io/File;

    check-cast p0, Ljava/lang/String;

    const-string v6, "k4_frame_edit.json"

    invoke-direct {v5, p0, v6}, Ljava/io/File;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_3

    :try_start_1
    sget-boolean p0, Lcom/k4/dressroom/EditXf;->sFrameLayout:Z

    if-eqz p0, :cond_1

    invoke-static {}, Lcom/k4/dressroom/SavedFrame;->record()Lorg/json/JSONObject;

    move-result-object v7

    :cond_1
    if-nez v7, :cond_2

    invoke-virtual {v5}, Ljava/io/File;->delete()Z

    move-result p0

    if-eqz p0, :cond_4

    invoke-static {v5}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " removed"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_2
    new-instance p0, Ljava/io/File;

    invoke-virtual {v5}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v0

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ".tmp"

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    new-instance v0, Ljava/io/FileOutputStream;

    invoke-direct {v0, p0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_2

    :try_start_2
    invoke-virtual {v7}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v4

    sget-object v6, Ljava/nio/charset/StandardCharsets;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v4, v6}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/io/FileOutputStream;->write([B)V

    invoke-virtual {v0}, Ljava/io/FileOutputStream;->getFD()Ljava/io/FileDescriptor;

    move-result-object v4

    invoke-virtual {v4}, Ljava/io/FileDescriptor;->sync()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    :try_start_3
    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V

    invoke-virtual {p0, v5}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    move-result v0

    if-eqz v0, :cond_3

    invoke-static {v5}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-static {v7}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ": "

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_3
    invoke-virtual {p0}, Ljava/io/File;->delete()Z

    new-instance p0, Ljava/io/IOException;

    invoke-static {v5}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_2

    :catchall_0
    move-exception p0

    :try_start_4
    invoke-virtual {v0}, Ljava/io/FileOutputStream;->close()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    goto :goto_0

    :catchall_1
    move-exception v0

    :try_start_5
    invoke-virtual {p0, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :goto_0
    throw p0
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_2

    :catchall_2
    move-exception p0

    const-string v0, "saved frame edit: not saved"

    invoke-static {v1, v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    invoke-virtual {v5}, Ljava/io/File;->delete()Z

    :cond_4
    return-void

    :cond_5
    :goto_1
    :try_start_6
    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_3

    return-void

    :catchall_3
    move-exception p0

    invoke-static {v1, v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method static tick(Landroid/view/View;)V
    .locals 8

    sget-boolean v0, Lcom/k4/dressroom/SavedFrame;->sDone:Z

    if-eqz v0, :cond_0

    goto/16 :goto_2

    :cond_0
    :try_start_0
    sget-boolean v0, Lcom/k4/dressroom/SavedFrame;->sRead:Z

    if-nez v0, :cond_1

    const/4 v0, 0x1

    sput-boolean v0, Lcom/k4/dressroom/SavedFrame;->sRead:Z

    invoke-static {p0}, Lcom/k4/dressroom/SavedFrame;->load(Landroid/view/View;)Z

    move-result v1

    if-nez v1, :cond_1

    sput-boolean v0, Lcom/k4/dressroom/SavedFrame;->sDone:Z

    return-void

    :cond_1
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/k4/dressroom/SavedFrame;->sUntil:J

    cmp-long v0, v0, v2

    if-lez v0, :cond_3

    sget p0, Lcom/k4/dressroom/SavedFrame;->sApplies:I

    if-lez p0, :cond_2

    const-string p0, "restore window over"

    goto :goto_0

    :cond_2
    const-string p0, "not restored: the saved frame never showed"

    :goto_0
    invoke-static {p0}, Lcom/k4/dressroom/SavedFrame;->done(Ljava/lang/String;)V

    return-void

    :cond_3
    sget-boolean v0, Lcom/k4/dressroom/EditXf;->sFrameLayout:Z

    if-nez v0, :cond_4

    sget p0, Lcom/k4/dressroom/SavedFrame;->sApplies:I

    if-lez p0, :cond_d

    const-string p0, "the frame was taken off"

    invoke-static {p0}, Lcom/k4/dressroom/SavedFrame;->done(Ljava/lang/String;)V

    return-void

    :cond_4
    sget-boolean v0, Lcom/k4/dressroom/SavedFrame;->sPosted:Z

    if-nez v0, :cond_d

    const-string v0, "FRAME_BACKGROUND"

    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->viewType(Landroid/view/View;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_d

    invoke-virtual {p0}, Landroid/view/View;->isShown()Z

    move-result v0

    if-eqz v0, :cond_d

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    if-eqz v0, :cond_d

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v0

    if-nez v0, :cond_5

    goto/16 :goto_2

    :cond_5
    sget-object v0, Lcom/k4/dressroom/SavedFrame;->sApplied:Ljava/lang/ref/WeakReference;

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    if-ne v0, p0, :cond_6

    invoke-static {p0}, Lcom/k4/dressroom/SavedFrame;->drift(Landroid/view/View;)V

    return-void

    :cond_6
    sget-object v0, Lcom/k4/dressroom/SavedFrame;->sRec:Lorg/json/JSONObject;

    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->bounds(Landroid/view/View;)Landroid/graphics/RectF;

    move-result-object v1

    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->aspect(Landroid/view/View;)F

    move-result v2

    invoke-static {p0}, Lcom/k4/dressroom/FrameSize;->samsungHole(Landroid/view/View;)Landroid/graphics/RectF;

    move-result-object v3

    move-object v4, p0

    check-cast v4, Landroid/widget/ImageView;

    invoke-virtual {v4}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v4

    if-eqz v4, :cond_d

    if-eqz v1, :cond_d

    invoke-virtual {v1}, Landroid/graphics/RectF;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_d

    const/4 v1, 0x0

    cmpl-float v1, v2, v1

    if-eqz v1, :cond_d

    if-eqz v3, :cond_d

    invoke-virtual {v3}, Landroid/graphics/RectF;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_7

    goto :goto_2

    :cond_7
    float-to-double v1, v2

    const-string v4, "aspect"

    invoke-virtual {v0, v4}, Lorg/json/JSONObject;->getDouble(Ljava/lang/String;)D

    move-result-wide v4

    sub-double v4, v1, v4

    invoke-static {v4, v5}, Ljava/lang/Math;->abs(D)D

    move-result-wide v4

    const-wide v6, 0x3f747ae147ae147bL    # 0.005

    mul-double/2addr v1, v6

    cmpl-double v1, v4, v1

    if-lez v1, :cond_8

    goto :goto_2

    :cond_8
    invoke-static {p0, v3, v0}, Lcom/k4/dressroom/SavedFrame;->otherFrame(Landroid/view/View;Landroid/graphics/RectF;Lorg/json/JSONObject;)Ljava/lang/String;

    move-result-object v1

    if-nez v1, :cond_9

    const-string v1, "fp"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v0

    invoke-static {v0, p0}, Lcom/k4/dressroom/EditXf;->otherPicture(Lorg/json/JSONArray;Landroid/view/View;)Ljava/lang/String;

    move-result-object v1

    :cond_9
    if-eqz v1, :cond_b

    sget p0, Lcom/k4/dressroom/SavedFrame;->sApplies:I

    if-lez p0, :cond_a

    const-string p0, "frame changed ("

    goto :goto_1

    :cond_a
    const-string p0, "not restored ("

    :goto_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/k4/dressroom/SavedFrame;->done(Ljava/lang/String;)V

    return-void

    :cond_b
    sget v0, Lcom/k4/dressroom/SavedFrame;->sApplies:I

    const/4 v1, 0x4

    if-lt v0, v1, :cond_c

    const-string p0, "Samsung keeps rebuilding the frame, left as it is"

    invoke-static {p0}, Lcom/k4/dressroom/SavedFrame;->done(Ljava/lang/String;)V

    return-void

    :cond_c
    invoke-static {p0}, Lcom/k4/dressroom/SavedFrame;->apply(Landroid/view/View;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-void

    :catchall_0
    move-exception p0

    const-string v0, "K4HomeClock"

    const-string v1, "saved frame edit: restore"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    const-string p0, "restore failed"

    invoke-static {p0}, Lcom/k4/dressroom/SavedFrame;->done(Ljava/lang/String;)V

    :cond_d
    :goto_2
    return-void
.end method

.method static touched()V
    .locals 1

    sget-boolean v0, Lcom/k4/dressroom/SavedFrame;->sDone:Z

    if-nez v0, :cond_1

    sget-boolean v0, Lcom/k4/dressroom/SavedFrame;->sRead:Z

    if-eqz v0, :cond_1

    sget v0, Lcom/k4/dressroom/SavedFrame;->sApplies:I

    if-lez v0, :cond_0

    const-string v0, "the picture was touched, restore window over"

    goto :goto_0

    :cond_0
    const-string v0, "not restored: the picture was touched first"

    :goto_0
    invoke-static {v0}, Lcom/k4/dressroom/SavedFrame;->done(Ljava/lang/String;)V

    :cond_1
    return-void
.end method
