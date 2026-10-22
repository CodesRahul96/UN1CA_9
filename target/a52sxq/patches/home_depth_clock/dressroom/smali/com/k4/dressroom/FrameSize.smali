.class public final Lcom/k4/dressroom/FrameSize;
.super Ljava/lang/Object;
.source "FrameSize.java"


# static fields
.field static final BAND_DP:F = 36.0f

.field static final EDGE:F = 0.08f

.field static final EDGE_DP:F = 40.0f

.field static final FADE:F = 0.035f

.field static final MAX:F = 1.6f

.field static final MIN:F = 0.35f

.field static final TAG:Ljava/lang/String; = "K4HomeClock"

.field private static sBase:F = 0.0f

.field private static sBasePath:Landroid/graphics/Path; = null

.field private static sBaseView:Ljava/lang/ref/WeakReference; = null
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field

.field private static sBottomPath:Landroid/graphics/Path; = null

.field private static sCount:I = 0x0

.field private static sFront:Landroid/graphics/Bitmap; = null

.field private static sFrontKey:[Ljava/lang/Object; = null

.field private static sGesture:Z = false

.field private static final sHoles:Ljava/util/WeakHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/WeakHashMap<",
            "Landroid/view/View;",
            "[",
            "Landroid/graphics/RectF;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sHx:F = 0.0f

.field private static volatile sHy:F = 0.0f

.field private static final sLines:Ljava/util/WeakHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/WeakHashMap<",
            "Ljava/lang/Object;",
            "[F>;"
        }
    .end annotation
.end field

.field private static volatile sLive:F = 1.0f

.field private static sMax:F = 0.0f

.field private static sMaybe:Z = false

.field private static sMin:F = 0.0f

.field private static sPathMediator:Ljava/lang/ref/WeakReference; = null
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Ljava/lang/Object;",
            ">;"
        }
    .end annotation
.end field

.field private static final sPlateBmp:Ljava/util/WeakHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/WeakHashMap<",
            "Landroid/view/View;",
            "Landroid/graphics/Bitmap;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile sScale:F = 1.0f

.field private static sSpan0:F

.field private static volatile sVh:F

.field private static volatile sVw:F


# direct methods
.method static constructor <clinit>()V
    .locals 2

    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/k4/dressroom/FrameSize;->sHoles:Ljava/util/WeakHashMap;

    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/k4/dressroom/FrameSize;->sPlateBmp:Ljava/util/WeakHashMap;

    new-instance v0, Ljava/lang/ref/WeakReference;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v0, Lcom/k4/dressroom/FrameSize;->sBaseView:Ljava/lang/ref/WeakReference;

    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/k4/dressroom/FrameSize;->sLines:Ljava/util/WeakHashMap;

    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, v1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v0, Lcom/k4/dressroom/FrameSize;->sPathMediator:Ljava/lang/ref/WeakReference;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static applyHole(Landroid/view/View;)V
    .locals 16

    move-object/from16 v0, p0

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    instance-of v1, v1, Landroid/view/ViewGroup;

    if-nez v1, :cond_0

    goto/16 :goto_7

    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup;

    sget v2, Lcom/k4/dressroom/FrameSize;->sScale:F

    const/4 v3, 0x0

    move v5, v3

    const/4 v6, 0x0

    :goto_0
    :try_start_0
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v7

    const/4 v8, 0x0

    if-ge v5, v7, :cond_8

    invoke-virtual {v1, v5}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v7

    const-string v9, "com.samsung.android.app.dressroom.presentation.preview.widget.CropImageView"

    invoke-virtual {v7}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v10

    invoke-virtual {v10}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_7

    invoke-static {v7}, Lcom/k4/dressroom/EditXf;->frameTarget(Landroid/view/View;)Z

    move-result v9

    if-nez v9, :cond_1

    goto/16 :goto_1

    :cond_1
    const-string v9, "getMFrameBounds"

    invoke-static {v7, v9}, Lcom/k4/dressroom/EditXf;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Landroid/graphics/RectF;

    if-eqz v9, :cond_7

    invoke-virtual {v9}, Landroid/graphics/RectF;->isEmpty()Z

    move-result v10

    if-eqz v10, :cond_2

    goto/16 :goto_1

    :cond_2
    sget-object v10, Lcom/k4/dressroom/FrameSize;->sHoles:Ljava/util/WeakHashMap;

    monitor-enter v10
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    :try_start_1
    invoke-virtual {v10, v7}, Ljava/util/WeakHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v11

    check-cast v11, [Landroid/graphics/RectF;

    const/4 v12, 0x1

    if-eqz v11, :cond_3

    aget-object v13, v11, v12

    invoke-virtual {v9, v13}, Landroid/graphics/RectF;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-nez v13, :cond_4

    :cond_3
    new-instance v11, Landroid/graphics/RectF;

    invoke-direct {v11, v9}, Landroid/graphics/RectF;-><init>(Landroid/graphics/RectF;)V

    new-instance v13, Landroid/graphics/RectF;

    invoke-direct {v13, v9}, Landroid/graphics/RectF;-><init>(Landroid/graphics/RectF;)V

    filled-new-array {v11, v13}, [Landroid/graphics/RectF;

    move-result-object v11

    invoke-virtual {v10, v7, v11}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_4
    monitor-exit v10
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    new-instance v10, Landroid/graphics/RectF;

    aget-object v13, v11, v3

    invoke-direct {v10, v13}, Landroid/graphics/RectF;-><init>(Landroid/graphics/RectF;)V

    invoke-virtual {v10}, Landroid/graphics/RectF;->centerX()F

    move-result v13

    invoke-virtual {v10}, Landroid/graphics/RectF;->centerY()F

    move-result v14

    iget v15, v10, Landroid/graphics/RectF;->left:F

    sub-float/2addr v15, v13

    mul-float/2addr v15, v2

    add-float/2addr v15, v13

    iget v3, v10, Landroid/graphics/RectF;->top:F

    sub-float/2addr v3, v14

    mul-float/2addr v3, v2

    add-float/2addr v3, v14

    iget v4, v10, Landroid/graphics/RectF;->right:F

    sub-float/2addr v4, v13

    mul-float/2addr v4, v2

    add-float/2addr v13, v4

    iget v4, v10, Landroid/graphics/RectF;->bottom:F

    sub-float/2addr v4, v14

    mul-float/2addr v4, v2

    add-float/2addr v14, v4

    invoke-virtual {v10, v15, v3, v13, v14}, Landroid/graphics/RectF;->set(FFFF)V

    invoke-virtual {v10, v9}, Landroid/graphics/RectF;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_5

    invoke-virtual {v7}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    const-string v4, "setMFrameBounds"

    const-class v9, Landroid/graphics/RectF;

    filled-new-array {v9}, [Ljava/lang/Class;

    move-result-object v9

    invoke-virtual {v3, v4, v9}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    new-instance v4, Landroid/graphics/RectF;

    invoke-direct {v4, v10}, Landroid/graphics/RectF;-><init>(Landroid/graphics/RectF;)V

    filled-new-array {v4}, [Ljava/lang/Object;

    move-result-object v4

    invoke-virtual {v3, v7, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    new-instance v3, Landroid/graphics/RectF;

    invoke-direct {v3, v10}, Landroid/graphics/RectF;-><init>(Landroid/graphics/RectF;)V

    aput-object v3, v11, v12

    :cond_5
    const-string v3, "getDrawableOriginScaledBounds"

    invoke-static {v7, v3}, Lcom/k4/dressroom/EditXf;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/graphics/RectF;

    if-eqz v3, :cond_6

    invoke-virtual {v3}, Landroid/graphics/RectF;->width()F

    move-result v4

    cmpl-float v4, v4, v8

    if-lez v4, :cond_6

    invoke-virtual {v3}, Landroid/graphics/RectF;->height()F

    move-result v4

    cmpl-float v4, v4, v8

    if-lez v4, :cond_6

    invoke-virtual {v7}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    const-string v8, "setMinScale"

    sget-object v9, Ljava/lang/Float;->TYPE:Ljava/lang/Class;

    filled-new-array {v9}, [Ljava/lang/Class;

    move-result-object v9

    invoke-virtual {v4, v8, v9}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v4

    invoke-virtual {v10}, Landroid/graphics/RectF;->width()F

    move-result v8

    invoke-virtual {v3}, Landroid/graphics/RectF;->width()F

    move-result v9

    div-float/2addr v8, v9

    invoke-virtual {v10}, Landroid/graphics/RectF;->height()F

    move-result v9

    invoke-virtual {v3}, Landroid/graphics/RectF;->height()F

    move-result v3

    div-float/2addr v9, v3

    invoke-static {v8, v9}, Ljava/lang/Math;->max(FF)F

    move-result v3

    invoke-static {v3}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v3

    filled-new-array {v3}, [Ljava/lang/Object;

    move-result-object v3

    invoke-virtual {v4, v7, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    :cond_6
    if-nez v6, :cond_7

    move-object v6, v10

    goto :goto_1

    :catchall_0
    move-exception v0

    :try_start_3
    monitor-exit v10
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :try_start_4
    throw v0

    :cond_7
    :goto_1
    add-int/lit8 v5, v5, 0x1

    const/4 v3, 0x0

    goto/16 :goto_0

    :cond_8
    if-nez v6, :cond_9

    goto/16 :goto_7

    :cond_9
    const-string v1, "FRAME_BACKGROUND"

    invoke-static {v0, v1}, Lcom/k4/dressroom/EditXf;->frameView(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v1

    if-eqz v1, :cond_a

    const-string v2, "getDrawableBounds"

    invoke-static {v1, v2}, Lcom/k4/dressroom/EditXf;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    move-object v4, v1

    check-cast v4, Landroid/graphics/RectF;

    goto :goto_2

    :cond_a
    const/4 v4, 0x0

    :goto_2
    if-eqz v4, :cond_10

    invoke-virtual {v4}, Landroid/graphics/RectF;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_10

    iget v1, v4, Landroid/graphics/RectF;->left:F

    iget v2, v6, Landroid/graphics/RectF;->left:F

    const/high16 v3, 0x3f000000    # 0.5f

    add-float/2addr v2, v3

    cmpg-float v1, v1, v2

    if-gtz v1, :cond_b

    iget v1, v4, Landroid/graphics/RectF;->top:F

    iget v2, v6, Landroid/graphics/RectF;->top:F

    add-float/2addr v2, v3

    cmpg-float v1, v1, v2

    if-gtz v1, :cond_b

    iget v1, v4, Landroid/graphics/RectF;->right:F

    iget v2, v6, Landroid/graphics/RectF;->right:F

    sub-float/2addr v2, v3

    cmpl-float v1, v1, v2

    if-ltz v1, :cond_b

    iget v1, v4, Landroid/graphics/RectF;->bottom:F

    iget v2, v6, Landroid/graphics/RectF;->bottom:F

    sub-float/2addr v2, v3

    cmpl-float v1, v1, v2

    if-ltz v1, :cond_b

    goto/16 :goto_7

    :cond_b
    invoke-virtual {v6}, Landroid/graphics/RectF;->width()F

    move-result v1

    invoke-virtual {v4}, Landroid/graphics/RectF;->width()F

    move-result v2

    div-float/2addr v1, v2

    invoke-virtual {v6}, Landroid/graphics/RectF;->height()F

    move-result v2

    invoke-virtual {v4}, Landroid/graphics/RectF;->height()F

    move-result v3

    div-float/2addr v2, v3

    invoke-static {v1, v2}, Ljava/lang/Math;->max(FF)F

    move-result v1

    const/high16 v2, 0x3f800000    # 1.0f

    invoke-static {v2, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    invoke-virtual {v6}, Landroid/graphics/RectF;->centerX()F

    move-result v2

    invoke-virtual {v6}, Landroid/graphics/RectF;->centerY()F

    move-result v3

    new-instance v5, Landroid/graphics/RectF;

    iget v7, v4, Landroid/graphics/RectF;->left:F

    sub-float/2addr v7, v2

    mul-float/2addr v7, v1

    add-float/2addr v7, v2

    iget v9, v4, Landroid/graphics/RectF;->top:F

    sub-float/2addr v9, v3

    mul-float/2addr v9, v1

    add-float/2addr v9, v3

    iget v10, v4, Landroid/graphics/RectF;->right:F

    sub-float/2addr v10, v2

    mul-float/2addr v10, v1

    add-float/2addr v2, v10

    iget v10, v4, Landroid/graphics/RectF;->bottom:F

    sub-float/2addr v10, v3

    mul-float/2addr v10, v1

    add-float/2addr v3, v10

    invoke-direct {v5, v7, v9, v2, v3}, Landroid/graphics/RectF;-><init>(FFFF)V

    iget v1, v5, Landroid/graphics/RectF;->left:F

    iget v2, v6, Landroid/graphics/RectF;->left:F

    cmpl-float v1, v1, v2

    if-lez v1, :cond_c

    iget v1, v6, Landroid/graphics/RectF;->left:F

    iget v2, v5, Landroid/graphics/RectF;->left:F

    :goto_3
    sub-float/2addr v1, v2

    goto :goto_4

    :cond_c
    iget v1, v5, Landroid/graphics/RectF;->right:F

    iget v2, v6, Landroid/graphics/RectF;->right:F

    cmpg-float v1, v1, v2

    if-gez v1, :cond_d

    iget v1, v6, Landroid/graphics/RectF;->right:F

    iget v2, v5, Landroid/graphics/RectF;->right:F

    goto :goto_3

    :cond_d
    move v1, v8

    :goto_4
    iget v2, v5, Landroid/graphics/RectF;->top:F

    iget v3, v6, Landroid/graphics/RectF;->top:F

    cmpl-float v2, v2, v3

    if-lez v2, :cond_e

    iget v2, v6, Landroid/graphics/RectF;->top:F

    iget v3, v5, Landroid/graphics/RectF;->top:F

    :goto_5
    sub-float v8, v2, v3

    goto :goto_6

    :cond_e
    iget v2, v5, Landroid/graphics/RectF;->bottom:F

    iget v3, v6, Landroid/graphics/RectF;->bottom:F

    cmpg-float v2, v2, v3

    if-gez v2, :cond_f

    iget v2, v6, Landroid/graphics/RectF;->bottom:F

    iget v3, v5, Landroid/graphics/RectF;->bottom:F

    goto :goto_5

    :cond_f
    :goto_6
    invoke-virtual {v5, v1, v8}, Landroid/graphics/RectF;->offset(FF)V

    invoke-static {v0, v5}, Lcom/k4/dressroom/FrameSize;->pictureBounds(Landroid/view/View;Landroid/graphics/RectF;)V

    const-string v0, "K4HomeClock"

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v5}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v6}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "frame size: picture "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " -> "

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " to cover the hole "

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    return-void

    :catchall_1
    move-exception v0

    const-string v1, "K4HomeClock"

    const-string v2, "frame size: hole"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_10
    :goto_7
    return-void
.end method

.method static begin(Landroid/view/View;)Z
    .locals 10

    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->frameRect(Landroid/view/View;)Landroid/graphics/RectF;

    move-result-object v0

    const/4 v1, 0x0

    const-string v2, "K4HomeClock"

    if-eqz v0, :cond_6

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v3

    if-eqz v3, :cond_6

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v3

    if-eqz v3, :cond_6

    const-string v3, "FRAME_BASE"

    invoke-static {p0, v3}, Lcom/k4/dressroom/EditXf;->frameView(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v3

    if-nez v3, :cond_0

    goto/16 :goto_0

    :cond_0
    invoke-virtual {v0}, Landroid/graphics/RectF;->centerX()F

    move-result v3

    invoke-virtual {v0}, Landroid/graphics/RectF;->centerY()F

    move-result v4

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v5

    int-to-float v5, v5

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v6

    int-to-float v6, v6

    const v7, 0x3da3d70a    # 0.08f

    invoke-static {v5, v6}, Ljava/lang/Math;->min(FF)F

    move-result v8

    mul-float/2addr v8, v7

    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    const/high16 v7, 0x42200000    # 40.0f

    mul-float/2addr p0, v7

    invoke-static {v8, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    iget v7, v0, Landroid/graphics/RectF;->left:F

    cmpg-float v7, v7, v3

    const/4 v8, 0x0

    if-gez v7, :cond_1

    sub-float v7, v3, p0

    iget v9, v0, Landroid/graphics/RectF;->left:F

    sub-float v9, v3, v9

    div-float/2addr v7, v9

    invoke-static {v8, v7}, Ljava/lang/Math;->max(FF)F

    move-result v8

    :cond_1
    iget v7, v0, Landroid/graphics/RectF;->right:F

    cmpl-float v7, v7, v3

    if-lez v7, :cond_2

    sub-float v7, v5, p0

    sub-float/2addr v7, v3

    iget v9, v0, Landroid/graphics/RectF;->right:F

    sub-float/2addr v9, v3

    div-float/2addr v7, v9

    invoke-static {v8, v7}, Ljava/lang/Math;->max(FF)F

    move-result v8

    :cond_2
    iget v7, v0, Landroid/graphics/RectF;->top:F

    cmpg-float v7, v7, v4

    if-gez v7, :cond_3

    sub-float v7, v4, p0

    iget v9, v0, Landroid/graphics/RectF;->top:F

    sub-float v9, v4, v9

    div-float/2addr v7, v9

    invoke-static {v8, v7}, Ljava/lang/Math;->max(FF)F

    move-result v8

    :cond_3
    iget v7, v0, Landroid/graphics/RectF;->bottom:F

    cmpl-float v7, v7, v4

    if-lez v7, :cond_4

    sub-float p0, v6, p0

    sub-float/2addr p0, v4

    iget v0, v0, Landroid/graphics/RectF;->bottom:F

    sub-float/2addr v0, v4

    div-float/2addr p0, v0

    invoke-static {v8, p0}, Ljava/lang/Math;->max(FF)F

    move-result v8

    :cond_4
    const p0, 0x3fcccccd    # 1.6f

    sget v0, Lcom/k4/dressroom/FrameSize;->sScale:F

    div-float/2addr p0, v0

    invoke-static {p0, v8}, Ljava/lang/Math;->min(FF)F

    move-result p0

    sput v3, Lcom/k4/dressroom/FrameSize;->sHx:F

    sput v4, Lcom/k4/dressroom/FrameSize;->sHy:F

    sput v5, Lcom/k4/dressroom/FrameSize;->sVw:F

    sput v6, Lcom/k4/dressroom/FrameSize;->sVh:F

    const v0, 0x3eb33333    # 0.35f

    sget v3, Lcom/k4/dressroom/FrameSize;->sScale:F

    div-float/2addr v0, v3

    sput v0, Lcom/k4/dressroom/FrameSize;->sMin:F

    const/high16 v0, 0x3f800000    # 1.0f

    invoke-static {v0, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    sput p0, Lcom/k4/dressroom/FrameSize;->sMax:F

    sput v0, Lcom/k4/dressroom/FrameSize;->sLive:F

    sget-object p0, Ljava/util/Locale;->US:Ljava/util/Locale;

    sget v0, Lcom/k4/dressroom/FrameSize;->sScale:F

    invoke-static {v0}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v0

    sget v3, Lcom/k4/dressroom/FrameSize;->sMin:F

    invoke-static {v3}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v3

    sget v4, Lcom/k4/dressroom/FrameSize;->sMax:F

    invoke-static {v4}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v4

    filled-new-array {v0, v3, v4}, [Ljava/lang/Object;

    move-result-object v0

    const-string v3, "frame size: %.3f now, this gesture %.3f..%.3f"

    invoke-static {p0, v3, v0}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    sget p0, Lcom/k4/dressroom/FrameSize;->sMin:F

    sget v0, Lcom/k4/dressroom/FrameSize;->sMax:F

    cmpg-float p0, p0, v0

    if-gez p0, :cond_5

    const/4 p0, 0x1

    return p0

    :cond_5
    return v1

    :cond_6
    :goto_0
    const-string p0, "frame size: no frame bounds / base plate"

    invoke-static {v2, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return v1
.end method

.method static copy(Landroid/graphics/drawable/Drawable;)Landroid/graphics/drawable/Drawable;
    .locals 2

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v0

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    goto :goto_0

    :cond_0
    move-object v0, p0

    :goto_0
    if-eq v0, p0, :cond_1

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getColorFilter()Landroid/graphics/ColorFilter;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/Drawable;->setColorFilter(Landroid/graphics/ColorFilter;)V

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getAlpha()I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/graphics/drawable/Drawable;->setAlpha(I)V

    :cond_1
    return-object v0
.end method

.method static drawBitmapClamped(Landroid/view/View;Landroid/graphics/Canvas;Landroid/graphics/Bitmap;Landroid/graphics/Rect;Landroid/graphics/Matrix;)V
    .locals 8

    new-instance v0, Landroid/graphics/BitmapShader;

    sget-object v1, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    sget-object v2, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    invoke-direct {v0, p2, v1, v2}, Landroid/graphics/BitmapShader;-><init>(Landroid/graphics/Bitmap;Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V

    new-instance p2, Landroid/graphics/Matrix;

    invoke-direct {p2}, Landroid/graphics/Matrix;-><init>()V

    iget v1, p3, Landroid/graphics/Rect;->left:I

    int-to-float v1, v1

    iget p3, p3, Landroid/graphics/Rect;->top:I

    int-to-float p3, p3

    invoke-virtual {p2, v1, p3}, Landroid/graphics/Matrix;->setTranslate(FF)V

    invoke-virtual {p2, p4}, Landroid/graphics/Matrix;->postConcat(Landroid/graphics/Matrix;)Z

    invoke-virtual {v0, p2}, Landroid/graphics/BitmapShader;->setLocalMatrix(Landroid/graphics/Matrix;)V

    new-instance v7, Landroid/graphics/Paint;

    const/4 p2, 0x3

    invoke-direct {v7, p2}, Landroid/graphics/Paint;-><init>(I)V

    invoke-virtual {v7, v0}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result p2

    int-to-float v5, p2

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result p0

    int-to-float v6, p0

    const/4 v3, 0x0

    const/4 v4, 0x0

    move-object v2, p1

    invoke-virtual/range {v2 .. v7}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    return-void
.end method

.method static drawClamped(Landroid/view/View;Landroid/graphics/Canvas;Landroid/graphics/drawable/Drawable;Landroid/graphics/Matrix;)V
    .locals 5

    invoke-virtual {p2}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;

    move-result-object v0

    sget-object v1, Lcom/k4/dressroom/FrameSize;->sPlateBmp:Ljava/util/WeakHashMap;

    invoke-virtual {v1, p0}, Ljava/util/WeakHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/graphics/Bitmap;

    if-eqz v2, :cond_0

    invoke-virtual {v2}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v3

    invoke-virtual {v0}, Landroid/graphics/Rect;->width()I

    move-result v4

    if-ne v3, v4, :cond_0

    invoke-virtual {v2}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v3

    invoke-virtual {v0}, Landroid/graphics/Rect;->height()I

    move-result v4

    if-eq v3, v4, :cond_1

    :cond_0
    invoke-virtual {v0}, Landroid/graphics/Rect;->width()I

    move-result v2

    invoke-virtual {v0}, Landroid/graphics/Rect;->height()I

    move-result v3

    sget-object v4, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v2, v3, v4}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v2

    invoke-virtual {v1, p0, v2}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1
    const/4 v1, 0x0

    invoke-virtual {v2, v1}, Landroid/graphics/Bitmap;->eraseColor(I)V

    new-instance v1, Landroid/graphics/Canvas;

    invoke-direct {v1, v2}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    iget v3, v0, Landroid/graphics/Rect;->left:I

    neg-int v3, v3

    int-to-float v3, v3

    iget v4, v0, Landroid/graphics/Rect;->top:I

    neg-int v4, v4

    int-to-float v4, v4

    invoke-virtual {v1, v3, v4}, Landroid/graphics/Canvas;->translate(FF)V

    invoke-virtual {p2, v1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    invoke-static {p0, p1, v2, v0, p3}, Lcom/k4/dressroom/FrameSize;->drawBitmapClamped(Landroid/view/View;Landroid/graphics/Canvas;Landroid/graphics/Bitmap;Landroid/graphics/Rect;Landroid/graphics/Matrix;)V

    return-void
.end method

.method static drawPlate(Landroid/view/View;Landroid/graphics/Canvas;)I
    .locals 14

    invoke-static {p0}, Lcom/k4/dressroom/FrameSize;->plate(Landroid/view/View;)Z

    move-result v0

    if-nez v0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    invoke-static {}, Lcom/k4/dressroom/FrameSize;->scaled()F

    move-result v1

    const/high16 v0, 0x3f800000    # 1.0f

    cmpl-float v2, v1, v0

    const/4 v3, 0x1

    if-nez v2, :cond_1

    return v3

    :cond_1
    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->frameRect(Landroid/view/View;)Landroid/graphics/RectF;

    move-result-object v2

    if-nez v2, :cond_2

    return v3

    :cond_2
    move-object v4, p0

    check-cast v4, Landroid/widget/ImageView;

    invoke-virtual {v4}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v6

    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->viewType(Landroid/view/View;)Ljava/lang/String;

    move-result-object v5

    const-string v7, "FRAME_BASE"

    invoke-virtual {v7, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_3

    new-instance v5, Ljava/lang/ref/WeakReference;

    invoke-direct {v5, p0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v5, Lcom/k4/dressroom/FrameSize;->sBaseView:Ljava/lang/ref/WeakReference;

    :cond_3
    cmpg-float v5, v1, v0

    const-string v11, "K4HomeClock"

    const/4 v12, 0x2

    if-gez v5, :cond_5

    if-eqz v6, :cond_5

    const-string v5, "FRAME_BOTTOM"

    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->viewType(Landroid/view/View;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v5, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_5

    invoke-static {p0, v7}, Lcom/k4/dressroom/EditXf;->frameView(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v5

    instance-of v7, v5, Landroid/widget/ImageView;

    if-eqz v7, :cond_4

    check-cast v5, Landroid/widget/ImageView;

    invoke-virtual {v5}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v5

    goto :goto_0

    :cond_4
    const/4 v5, 0x0

    :goto_0
    if-eqz v5, :cond_5

    invoke-virtual {v6}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;

    move-result-object v7

    invoke-virtual {v7}, Landroid/graphics/Rect;->width()I

    move-result v7

    if-lez v7, :cond_5

    invoke-virtual {v6}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;

    move-result-object v7

    invoke-virtual {v7}, Landroid/graphics/Rect;->height()I

    move-result v7

    if-lez v7, :cond_5

    :try_start_0
    move-object v7, p0

    check-cast v7, Landroid/widget/ImageView;

    invoke-static {v7}, Lcom/k4/dressroom/EditXf;->imageMatrix(Landroid/widget/ImageView;)Landroid/graphics/Matrix;

    move-result-object v13

    invoke-virtual {v2}, Landroid/graphics/RectF;->centerX()F

    move-result v7

    invoke-virtual {v2}, Landroid/graphics/RectF;->centerY()F

    move-result v8

    invoke-virtual {v13, v1, v1, v7, v8}, Landroid/graphics/Matrix;->postScale(FFFF)Z

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v7

    int-to-float v7, v7

    const v8, 0x3d0f5c29    # 0.035f

    mul-float/2addr v7, v8

    invoke-virtual {v13, v0}, Landroid/graphics/Matrix;->mapRadius(F)F

    move-result v0

    const v8, 0x3a83126f    # 0.001f

    invoke-static {v8, v0}, Ljava/lang/Math;->max(FF)F

    move-result v0

    div-float v9, v7, v0

    invoke-virtual {v6}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;

    move-result-object v0

    invoke-virtual {v0}, Landroid/graphics/Rect;->width()I

    move-result v7

    invoke-virtual {v6}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;

    move-result-object v0

    invoke-virtual {v0}, Landroid/graphics/Rect;->height()I

    move-result v8

    const/4 v10, 0x1

    invoke-static/range {v5 .. v10}, Lcom/k4/dressroom/FrameSize;->frontPlate(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;IIFZ)Landroid/graphics/Bitmap;

    move-result-object v0

    if-eqz v0, :cond_5

    invoke-virtual {v6}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;

    move-result-object v5

    invoke-static {p0, p1, v0, v5, v13}, Lcom/k4/dressroom/FrameSize;->drawBitmapClamped(Landroid/view/View;Landroid/graphics/Canvas;Landroid/graphics/Bitmap;Landroid/graphics/Rect;Landroid/graphics/Matrix;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return v12

    :catchall_0
    move-exception v0

    const-string v5, "frame size: front plate"

    invoke-static {v11, v5, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_5
    if-eqz v6, :cond_7

    invoke-virtual {v6}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;

    move-result-object v0

    invoke-virtual {v0}, Landroid/graphics/Rect;->width()I

    move-result v0

    if-lez v0, :cond_7

    invoke-virtual {v6}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;

    move-result-object v0

    invoke-virtual {v0}, Landroid/graphics/Rect;->height()I

    move-result v0

    if-lez v0, :cond_7

    invoke-static {v4}, Lcom/k4/dressroom/EditXf;->imageMatrix(Landroid/widget/ImageView;)Landroid/graphics/Matrix;

    move-result-object v0

    invoke-virtual {v2}, Landroid/graphics/RectF;->centerX()F

    move-result v4

    invoke-virtual {v2}, Landroid/graphics/RectF;->centerY()F

    move-result v5

    invoke-virtual {v0, v1, v1, v4, v5}, Landroid/graphics/Matrix;->postScale(FFFF)Z

    new-instance v4, Landroid/graphics/RectF;

    invoke-virtual {v6}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;

    move-result-object v5

    invoke-direct {v4, v5}, Landroid/graphics/RectF;-><init>(Landroid/graphics/Rect;)V

    invoke-virtual {v0, v4}, Landroid/graphics/Matrix;->mapRect(Landroid/graphics/RectF;)Z

    iget v5, v4, Landroid/graphics/RectF;->left:F

    const/high16 v7, 0x3f000000    # 0.5f

    cmpl-float v5, v5, v7

    if-gtz v5, :cond_6

    iget v5, v4, Landroid/graphics/RectF;->top:F

    cmpl-float v5, v5, v7

    if-gtz v5, :cond_6

    iget v5, v4, Landroid/graphics/RectF;->right:F

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v8

    int-to-float v8, v8

    sub-float/2addr v8, v7

    cmpg-float v5, v5, v8

    if-ltz v5, :cond_6

    iget v4, v4, Landroid/graphics/RectF;->bottom:F

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v5

    int-to-float v5, v5

    sub-float/2addr v5, v7

    cmpg-float v4, v4, v5

    if-gez v4, :cond_7

    :cond_6
    :try_start_1
    invoke-static {p0, p1, v6, v0}, Lcom/k4/dressroom/FrameSize;->drawClamped(Landroid/view/View;Landroid/graphics/Canvas;Landroid/graphics/drawable/Drawable;Landroid/graphics/Matrix;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    return v12

    :catchall_1
    move-exception v0

    move-object p0, v0

    const-string v0, "frame size: plate"

    invoke-static {v11, v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_7
    invoke-virtual {v2}, Landroid/graphics/RectF;->centerX()F

    move-result p0

    invoke-virtual {v2}, Landroid/graphics/RectF;->centerY()F

    move-result v0

    invoke-virtual {p1, v1, v1, p0, v0}, Landroid/graphics/Canvas;->scale(FFFF)V

    return v3
.end method

.method public static framePath(Ljava/lang/Object;Landroid/graphics/Path;I)Landroid/graphics/Path;
    .locals 2

    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v0, Lcom/k4/dressroom/FrameSize;->sPathMediator:Ljava/lang/ref/WeakReference;

    if-nez p2, :cond_0

    sput-object p1, Lcom/k4/dressroom/FrameSize;->sBasePath:Landroid/graphics/Path;

    goto :goto_0

    :cond_0
    sput-object p1, Lcom/k4/dressroom/FrameSize;->sBottomPath:Landroid/graphics/Path;

    :goto_0
    sget p0, Lcom/k4/dressroom/FrameSize;->sScale:F

    if-eqz p1, :cond_2

    const/high16 p2, 0x3f800000    # 1.0f

    cmpl-float p2, p0, p2

    if-eqz p2, :cond_2

    sget-boolean p2, Lcom/k4/dressroom/HomeClock;->active:Z

    if-nez p2, :cond_1

    goto :goto_1

    :cond_1
    new-instance p2, Landroid/graphics/Path;

    invoke-direct {p2, p1}, Landroid/graphics/Path;-><init>(Landroid/graphics/Path;)V

    new-instance p1, Landroid/graphics/Matrix;

    invoke-direct {p1}, Landroid/graphics/Matrix;-><init>()V

    sget v0, Lcom/k4/dressroom/FrameSize;->sHx:F

    sget v1, Lcom/k4/dressroom/FrameSize;->sHy:F

    invoke-virtual {p1, p0, p0, v0, v1}, Landroid/graphics/Matrix;->setScale(FFFF)V

    invoke-virtual {p2, p1}, Landroid/graphics/Path;->transform(Landroid/graphics/Matrix;)V

    return-object p2

    :cond_2
    :goto_1
    return-object p1
.end method

.method static frontPlate(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;IIFZ)Landroid/graphics/Bitmap;
    .locals 20

    move/from16 v0, p2

    move/from16 v1, p3

    invoke-virtual/range {p0 .. p0}, Landroid/graphics/drawable/Drawable;->getColorFilter()Landroid/graphics/ColorFilter;

    move-result-object v4

    invoke-virtual/range {p1 .. p1}, Landroid/graphics/drawable/Drawable;->getColorFilter()Landroid/graphics/ColorFilter;

    move-result-object v5

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-static/range {p4 .. p4}, Ljava/lang/Math;->round(F)I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    move-object/from16 v2, p0

    move-object/from16 v3, p1

    filled-new-array/range {v2 .. v8}, [Ljava/lang/Object;

    move-result-object v4

    if-eqz p5, :cond_0

    sget-object v2, Lcom/k4/dressroom/FrameSize;->sFront:Landroid/graphics/Bitmap;

    if-eqz v2, :cond_0

    sget-object v2, Lcom/k4/dressroom/FrameSize;->sFrontKey:[Ljava/lang/Object;

    if-eqz v2, :cond_0

    invoke-static {v4, v2}, Ljava/util/Arrays;->equals([Ljava/lang/Object;[Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    sget-object v0, Lcom/k4/dressroom/FrameSize;->sFront:Landroid/graphics/Bitmap;

    return-object v0

    :cond_0
    invoke-static/range {p1 .. p3}, Lcom/k4/dressroom/FrameSize;->lineOf(Landroid/graphics/drawable/Drawable;II)F

    move-result v2

    const/4 v3, 0x0

    cmpg-float v3, v2, v3

    if-gez v3, :cond_1

    const/4 v0, 0x0

    return-object v0

    :cond_1
    if-eqz p5, :cond_2

    sget-object v3, Lcom/k4/dressroom/FrameSize;->sFront:Landroid/graphics/Bitmap;

    if-eqz v3, :cond_2

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v3

    if-ne v3, v0, :cond_2

    sget-object v3, Lcom/k4/dressroom/FrameSize;->sFront:Landroid/graphics/Bitmap;

    invoke-virtual {v3}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v3

    if-ne v3, v1, :cond_2

    sget-object v3, Lcom/k4/dressroom/FrameSize;->sFront:Landroid/graphics/Bitmap;

    goto :goto_0

    :cond_2
    sget-object v3, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v0, v1, v3}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v3

    :goto_0
    const/4 v5, 0x0

    invoke-virtual {v3, v5}, Landroid/graphics/Bitmap;->eraseColor(I)V

    new-instance v6, Landroid/graphics/Canvas;

    invoke-direct {v6, v3}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    invoke-static/range {p0 .. p0}, Lcom/k4/dressroom/FrameSize;->copy(Landroid/graphics/drawable/Drawable;)Landroid/graphics/drawable/Drawable;

    move-result-object v7

    invoke-virtual {v7, v5, v5, v0, v1}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    invoke-virtual {v7, v6}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    new-instance v11, Landroid/graphics/Paint;

    invoke-direct {v11}, Landroid/graphics/Paint;-><init>()V

    new-instance v12, Landroid/graphics/LinearGradient;

    sub-float v14, v2, p4

    add-float v16, v2, p4

    const/high16 v18, -0x1000000

    sget-object v19, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    const/4 v13, 0x0

    const/4 v15, 0x0

    const/16 v17, 0x0

    invoke-direct/range {v12 .. v19}, Landroid/graphics/LinearGradient;-><init>(FFFFIILandroid/graphics/Shader$TileMode;)V

    invoke-virtual {v11, v12}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    new-instance v2, Landroid/graphics/PorterDuffXfermode;

    sget-object v5, Landroid/graphics/PorterDuff$Mode;->DST_IN:Landroid/graphics/PorterDuff$Mode;

    invoke-direct {v2, v5}, Landroid/graphics/PorterDuffXfermode;-><init>(Landroid/graphics/PorterDuff$Mode;)V

    invoke-virtual {v11, v2}, Landroid/graphics/Paint;->setXfermode(Landroid/graphics/Xfermode;)Landroid/graphics/Xfermode;

    int-to-float v9, v0

    int-to-float v10, v1

    const/4 v7, 0x0

    const/4 v8, 0x0

    invoke-virtual/range {v6 .. v11}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    if-eqz p5, :cond_3

    sput-object v3, Lcom/k4/dressroom/FrameSize;->sFront:Landroid/graphics/Bitmap;

    sput-object v4, Lcom/k4/dressroom/FrameSize;->sFrontKey:[Ljava/lang/Object;

    :cond_3
    return-object v3
.end method

.method static holeStale(Landroid/view/View;)Z
    .locals 4

    sget v0, Lcom/k4/dressroom/FrameSize;->sScale:F

    const/high16 v1, 0x3f800000    # 1.0f

    cmpl-float v0, v0, v1

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    :cond_0
    :try_start_0
    const-string v0, "getMFrameBounds"

    invoke-static {p0, v0}, Lcom/k4/dressroom/EditXf;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/graphics/RectF;

    if-eqz v0, :cond_4

    invoke-virtual {v0}, Landroid/graphics/RectF;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_1

    goto :goto_1

    :cond_1
    sget-object v2, Lcom/k4/dressroom/FrameSize;->sHoles:Ljava/util/WeakHashMap;

    monitor-enter v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    :try_start_1
    invoke-virtual {v2, p0}, Ljava/util/WeakHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [Landroid/graphics/RectF;

    const/4 v3, 0x1

    if-eqz p0, :cond_3

    aget-object p0, p0, v3

    invoke-virtual {v0, p0}, Landroid/graphics/RectF;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_2

    goto :goto_0

    :cond_2
    move v3, v1

    :cond_3
    :goto_0
    monitor-exit v2

    return v3

    :catchall_0
    move-exception p0

    monitor-exit v2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    throw p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    :catchall_1
    :cond_4
    :goto_1
    return v1
.end method

.method static kept()F
    .locals 1

    sget v0, Lcom/k4/dressroom/FrameSize;->sScale:F

    return v0
.end method

.method static lineOf(Landroid/graphics/drawable/Drawable;II)F
    .locals 19

    move/from16 v0, p1

    move/from16 v1, p2

    invoke-virtual/range {p0 .. p0}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v2

    if-eqz v2, :cond_0

    invoke-virtual/range {p0 .. p0}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v2

    goto :goto_0

    :cond_0
    move-object/from16 v2, p0

    :goto_0
    sget-object v3, Lcom/k4/dressroom/FrameSize;->sLines:Ljava/util/WeakHashMap;

    invoke-virtual {v3, v2}, Ljava/util/WeakHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, [F

    const/4 v4, 0x2

    const/4 v5, 0x0

    const/4 v6, 0x1

    if-eqz v3, :cond_1

    aget v7, v3, v6

    int-to-float v8, v0

    cmpl-float v7, v7, v8

    if-nez v7, :cond_1

    aget v7, v3, v4

    int-to-float v8, v1

    cmpl-float v7, v7, v8

    if-nez v7, :cond_1

    aget v0, v3, v5

    return v0

    :cond_1
    div-int/lit8 v3, v0, 0x4

    invoke-static {v6, v3}, Ljava/lang/Math;->max(II)I

    move-result v10

    div-int/lit8 v3, v1, 0x4

    invoke-static {v6, v3}, Ljava/lang/Math;->max(II)I

    move-result v3

    sget-object v7, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v10, v3, v7}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v7

    new-instance v8, Landroid/graphics/Canvas;

    invoke-direct {v8, v7}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    int-to-float v9, v10

    int-to-float v15, v0

    div-float/2addr v9, v15

    int-to-float v11, v3

    int-to-float v12, v1

    div-float v13, v11, v12

    invoke-virtual {v8, v9, v13}, Landroid/graphics/Canvas;->scale(FF)V

    invoke-static/range {p0 .. p0}, Lcom/k4/dressroom/FrameSize;->copy(Landroid/graphics/drawable/Drawable;)Landroid/graphics/drawable/Drawable;

    move-result-object v9

    invoke-virtual {v9, v5, v5, v0, v1}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    invoke-virtual {v9, v8}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    add-int/lit8 v0, v3, 0x1

    new-array v0, v0, [I

    new-array v8, v10, [I

    new-array v1, v10, [I

    const/4 v9, -0x1

    invoke-static {v1, v9}, Ljava/util/Arrays;->fill([II)V

    move v13, v12

    move v12, v5

    :goto_1
    if-ge v12, v3, :cond_4

    move v14, v11

    const/4 v11, 0x0

    move/from16 v16, v14

    const/4 v14, 0x1

    move/from16 v17, v9

    const/4 v9, 0x0

    move/from16 v18, v13

    move v13, v10

    invoke-virtual/range {v7 .. v14}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    move v9, v5

    :goto_2
    if-ge v9, v10, :cond_3

    aget v11, v1, v9

    if-gez v11, :cond_2

    aget v11, v8, v9

    ushr-int/lit8 v11, v11, 0x18

    const/16 v13, 0x80

    if-le v11, v13, :cond_2

    aput v12, v1, v9

    :cond_2
    add-int/lit8 v9, v9, 0x1

    goto :goto_2

    :cond_3
    add-int/lit8 v12, v12, 0x1

    move/from16 v11, v16

    move/from16 v9, v17

    move/from16 v13, v18

    goto :goto_1

    :cond_4
    move/from16 v17, v9

    move/from16 v16, v11

    move/from16 v18, v13

    move v8, v5

    move v9, v8

    :goto_3
    if-ge v8, v10, :cond_6

    aget v11, v1, v8

    if-ltz v11, :cond_5

    aget v12, v0, v11

    add-int/2addr v12, v6

    aput v12, v0, v11

    add-int/lit8 v9, v9, 0x1

    :cond_5
    add-int/lit8 v8, v8, 0x1

    goto :goto_3

    :cond_6
    move v8, v5

    move/from16 v1, v17

    :goto_4
    if-ge v8, v3, :cond_9

    if-ltz v1, :cond_7

    aget v11, v0, v8

    aget v12, v0, v1

    if-le v11, v12, :cond_8

    :cond_7
    move v1, v8

    :cond_8
    add-int/lit8 v8, v8, 0x1

    goto :goto_4

    :cond_9
    invoke-virtual {v7}, Landroid/graphics/Bitmap;->recycle()V

    const/4 v3, 0x3

    if-ltz v1, :cond_a

    if-lez v9, :cond_a

    aget v0, v0, v1

    mul-int/lit8 v0, v0, 0xa

    mul-int/2addr v10, v3

    if-lt v0, v10, :cond_a

    int-to-float v0, v1

    const/high16 v1, 0x3f000000    # 0.5f

    add-float/2addr v0, v1

    mul-float v0, v0, v18

    div-float v0, v0, v16

    goto :goto_5

    :cond_a
    const/high16 v0, -0x40800000    # -1.0f

    :goto_5
    sget-object v1, Lcom/k4/dressroom/FrameSize;->sLines:Ljava/util/WeakHashMap;

    new-array v3, v3, [F

    aput v0, v3, v5

    aput v15, v3, v6

    aput v18, v3, v4

    invoke-virtual {v1, v2, v3}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return v0
.end method

.method static onPlate(Landroid/view/View;FF)Z
    .locals 11

    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    sget-object v2, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    const/4 v3, 0x1

    invoke-static {v3, v3, v2}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v2

    new-instance v4, Landroid/graphics/Canvas;

    invoke-direct {v4, v2}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    move v5, v1

    :goto_0
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v6

    if-ge v5, v6, :cond_3

    invoke-virtual {v0, v5}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v6

    invoke-virtual {v6}, Landroid/view/View;->getVisibility()I

    move-result v7

    if-nez v7, :cond_2

    invoke-static {v6}, Lcom/k4/dressroom/FrameSize;->plate(Landroid/view/View;)Z

    move-result v7

    if-nez v7, :cond_1

    goto :goto_1

    :cond_1
    invoke-virtual {v2, v1}, Landroid/graphics/Bitmap;->eraseColor(I)V

    invoke-virtual {v4}, Landroid/graphics/Canvas;->save()I

    move-result v7

    invoke-virtual {p0}, Landroid/view/View;->getLeft()I

    move-result v8

    int-to-float v8, v8

    add-float/2addr v8, p1

    invoke-virtual {v6}, Landroid/view/View;->getLeft()I

    move-result v9

    int-to-float v9, v9

    sub-float/2addr v8, v9

    neg-float v8, v8

    invoke-virtual {p0}, Landroid/view/View;->getTop()I

    move-result v9

    int-to-float v9, v9

    add-float/2addr v9, p2

    invoke-virtual {v6}, Landroid/view/View;->getTop()I

    move-result v10

    int-to-float v10, v10

    sub-float/2addr v9, v10

    neg-float v9, v9

    invoke-virtual {v4, v8, v9}, Landroid/graphics/Canvas;->translate(FF)V

    invoke-virtual {v6, v4}, Landroid/view/View;->draw(Landroid/graphics/Canvas;)V

    invoke-virtual {v4, v7}, Landroid/graphics/Canvas;->restoreToCount(I)V

    invoke-virtual {v2, v1, v1}, Landroid/graphics/Bitmap;->getPixel(II)I

    move-result v6

    invoke-static {v6}, Landroid/graphics/Color;->alpha(I)I

    move-result v6

    const/16 v7, 0x80

    if-le v6, v7, :cond_2

    return v3

    :cond_2
    :goto_1
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    :cond_3
    return v1
.end method

.method static pictureBounds(Landroid/view/View;Landroid/graphics/RectF;)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-nez v0, :cond_0

    goto :goto_1

    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    check-cast p0, Landroid/view/ViewGroup;

    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-ge v0, v1, :cond_2

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    const-string v3, "com.samsung.android.app.dressroom.presentation.preview.widget.CropImageView"

    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-static {v1}, Lcom/k4/dressroom/EditXf;->frameTarget(Landroid/view/View;)Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    const-class v3, Landroid/graphics/RectF;

    filled-new-array {v3}, [Ljava/lang/Class;

    move-result-object v3

    const-string v4, "setDrawableBoundsExternal"

    invoke-virtual {v2, v4, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    new-instance v3, Landroid/graphics/RectF;

    invoke-direct {v3, p1}, Landroid/graphics/RectF;-><init>(Landroid/graphics/RectF;)V

    filled-new-array {v3}, [Ljava/lang/Object;

    move-result-object v3

    invoke-virtual {v2, v1, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_2
    :goto_1
    return-void
.end method

.method static plate(Landroid/view/View;)Z
    .locals 1

    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->viewType(Landroid/view/View;)Ljava/lang/String;

    move-result-object p0

    const-string v0, "FRAME_BASE"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "FRAME_BOTTOM"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    return p0

    :cond_1
    :goto_0
    const/4 p0, 0x1

    return p0
.end method

.method static refit(Landroid/view/View;)V
    .locals 10

    sget-object v0, Lcom/k4/dressroom/FrameSize;->sPathMediator:Ljava/lang/ref/WeakReference;

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_0

    invoke-static {}, Lcom/k4/dressroom/EditXf;->refit()V

    return-void

    :cond_0
    :try_start_0
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    const-string v2, "o"

    const-class v3, Landroid/graphics/Path;

    const-class v4, Landroid/graphics/Path;

    filled-new-array {v3, v4}, [Ljava/lang/Class;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    sget-object v2, Lcom/k4/dressroom/FrameSize;->sBasePath:Landroid/graphics/Path;

    sget-object v3, Lcom/k4/dressroom/FrameSize;->sBottomPath:Landroid/graphics/Path;

    filled-new-array {v2, v3}, [Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v1, v0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v1

    array-length v2, v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v3, 0x0

    const/4 v4, 0x0

    move v5, v3

    :goto_0
    const-string v6, "com.samsung.android.app.dressroom.presentation.preview.widget.CropImageView"

    if-ge v5, v2, :cond_2

    :try_start_1
    aget-object v7, v1, v5

    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v8

    const-string v9, "n"

    invoke-virtual {v8, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_1

    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getParameterCount()I

    move-result v8

    const/4 v9, 0x1

    if-ne v8, v9, :cond_1

    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v8

    aget-object v8, v8, v3

    invoke-virtual {v8}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v8, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_1

    move-object v4, v7

    :cond_1
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    :cond_2
    if-eqz v4, :cond_4

    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    instance-of v1, v1, Landroid/view/ViewGroup;

    if-eqz v1, :cond_4

    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    check-cast p0, Landroid/view/ViewGroup;

    :goto_1
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-ge v3, v1, :cond_4

    invoke-virtual {p0, v3}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v6, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_3

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v4, v0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    :cond_3
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    :cond_4
    invoke-static {}, Lcom/k4/dressroom/EditXf;->refit()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    return-void

    :catchall_0
    move-exception p0

    const-string v0, "K4HomeClock"

    const-string v1, "frame size: clock fit"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method

.method static relayoutDone()Z
    .locals 1

    const/4 v0, 0x0

    return v0
.end method

.method static reset()V
    .locals 2

    const/high16 v0, 0x3f800000    # 1.0f

    sput v0, Lcom/k4/dressroom/FrameSize;->sScale:F

    sput v0, Lcom/k4/dressroom/FrameSize;->sLive:F

    const/4 v0, 0x0

    sput-boolean v0, Lcom/k4/dressroom/FrameSize;->sGesture:Z

    sget-object v0, Lcom/k4/dressroom/FrameSize;->sHoles:Ljava/util/WeakHashMap;

    monitor-enter v0

    :try_start_0
    invoke-virtual {v0}, Ljava/util/WeakHashMap;->clear()V

    monitor-exit v0

    return-void

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method static restore(Landroid/view/View;F)V
    .locals 1

    const v0, 0x3fcccccd    # 1.6f

    invoke-static {v0, p1}, Ljava/lang/Math;->min(FF)F

    move-result p1

    const v0, 0x3eb33333    # 0.35f

    invoke-static {v0, p1}, Ljava/lang/Math;->max(FF)F

    move-result p1

    sput p1, Lcom/k4/dressroom/FrameSize;->sScale:F

    const/high16 p1, 0x3f800000    # 1.0f

    sput p1, Lcom/k4/dressroom/FrameSize;->sLive:F

    const/4 p1, 0x0

    sput-boolean p1, Lcom/k4/dressroom/FrameSize;->sGesture:Z

    invoke-static {p0}, Lcom/k4/dressroom/FrameSize;->applyHole(Landroid/view/View;)V

    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->frameRect(Landroid/view/View;)Landroid/graphics/RectF;

    move-result-object p1

    if-eqz p1, :cond_0

    invoke-virtual {p1}, Landroid/graphics/RectF;->centerX()F

    move-result v0

    sput v0, Lcom/k4/dressroom/FrameSize;->sHx:F

    invoke-virtual {p1}, Landroid/graphics/RectF;->centerY()F

    move-result v0

    sput v0, Lcom/k4/dressroom/FrameSize;->sHy:F

    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    int-to-float v0, v0

    sput v0, Lcom/k4/dressroom/FrameSize;->sVw:F

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result p0

    int-to-float p0, p0

    sput p0, Lcom/k4/dressroom/FrameSize;->sVh:F

    sget-object p0, Ljava/util/Locale;->US:Ljava/util/Locale;

    sget v0, Lcom/k4/dressroom/FrameSize;->sScale:F

    invoke-static {v0}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v0

    filled-new-array {v0, p1}, [Ljava/lang/Object;

    move-result-object p1

    const-string v0, "frame size: %.3f of Samsung\'s (saved), hole %s"

    invoke-static {p0, v0, p1}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    const-string p1, "K4HomeClock"

    invoke-static {p1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method static samsungHole(Landroid/view/View;)Landroid/graphics/RectF;
    .locals 5

    const/4 v0, 0x0

    :try_start_0
    const-string v1, "getMFrameBounds"

    invoke-static {p0, v1}, Lcom/k4/dressroom/EditXf;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/graphics/RectF;

    if-eqz v1, :cond_2

    invoke-virtual {v1}, Landroid/graphics/RectF;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_0

    goto :goto_0

    :cond_0
    sget-object v2, Lcom/k4/dressroom/FrameSize;->sHoles:Ljava/util/WeakHashMap;

    monitor-enter v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    :try_start_1
    invoke-virtual {v2, p0}, Ljava/util/WeakHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, [Landroid/graphics/RectF;

    if-eqz v3, :cond_1

    const/4 v4, 0x1

    aget-object v4, v3, v4

    invoke-virtual {v1, v4}, Landroid/graphics/RectF;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    const/4 v1, 0x0

    aget-object v1, v3, v1

    :cond_1
    monitor-exit v2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :try_start_2
    new-instance v2, Landroid/graphics/RectF;

    invoke-direct {v2, v1}, Landroid/graphics/RectF;-><init>(Landroid/graphics/RectF;)V

    check-cast p0, Landroid/widget/ImageView;

    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->imageMatrix(Landroid/widget/ImageView;)Landroid/graphics/Matrix;

    move-result-object p0

    invoke-virtual {p0, v2}, Landroid/graphics/Matrix;->mapRect(Landroid/graphics/RectF;)Z
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    return-object v2

    :catchall_0
    move-exception p0

    :try_start_3
    monitor-exit v2
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :try_start_4
    throw p0
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    :catchall_1
    :cond_2
    :goto_0
    return-object v0
.end method

.method public static saveFront(Landroid/graphics/drawable/Drawable;Ljava/lang/Object;)Landroid/graphics/drawable/Drawable;
    .locals 12

    const-string v1, "K4HomeClock"

    sget v0, Lcom/k4/dressroom/FrameSize;->sScale:F

    if-eqz p0, :cond_7

    sget-boolean v2, Lcom/k4/dressroom/HomeClock;->active:Z

    if-eqz v2, :cond_7

    const/high16 v2, 0x3f800000    # 1.0f

    cmpl-float v3, v0, v2

    if-ltz v3, :cond_0

    goto/16 :goto_5

    :cond_0
    :try_start_0
    sget-object v3, Lcom/k4/dressroom/FrameSize;->sBaseView:Ljava/lang/ref/WeakReference;

    invoke-virtual {v3}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/view/View;

    instance-of v4, v3, Landroid/widget/ImageView;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_2

    const/4 v5, 0x0

    if-eqz v4, :cond_1

    :try_start_1
    check-cast v3, Landroid/widget/ImageView;

    invoke-virtual {v3}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v3

    goto :goto_0

    :catchall_0
    move-exception v0

    move-object p1, v0

    move-object v7, p0

    goto/16 :goto_4

    :cond_1
    move-object v3, v5

    :goto_0
    if-eqz v3, :cond_2

    invoke-virtual {v3}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v4

    if-eqz v4, :cond_2

    invoke-virtual {v3}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v3

    invoke-virtual {v3}, Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v3
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    move-object v6, v3

    goto :goto_1

    :cond_2
    move-object v6, v5

    :goto_1
    :try_start_2
    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getIntrinsicWidth()I

    move-result v8

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result v9

    if-eqz v6, :cond_6

    if-lez v8, :cond_6

    if-gtz v9, :cond_3

    goto :goto_2

    :cond_3
    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getColorFilter()Landroid/graphics/ColorFilter;

    move-result-object v3

    invoke-virtual {v6, v3}, Landroid/graphics/drawable/Drawable;->setColorFilter(Landroid/graphics/ColorFilter;)V

    const-string v3, "a"

    invoke-static {p1, v3}, Lcom/k4/dressroom/HomeClock;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/graphics/RectF;

    invoke-static {}, Landroid/content/res/Resources;->getSystem()Landroid/content/res/Resources;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v3

    iget v4, v3, Landroid/util/DisplayMetrics;->widthPixels:I

    iget v7, v3, Landroid/util/DisplayMetrics;->heightPixels:I

    invoke-static {v4, v7}, Ljava/lang/Math;->min(II)I

    move-result v4

    int-to-float v4, v4

    iget v7, v3, Landroid/util/DisplayMetrics;->widthPixels:I

    iget v3, v3, Landroid/util/DisplayMetrics;->heightPixels:I

    invoke-static {v7, v3}, Ljava/lang/Math;->max(II)I

    move-result v3
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_2

    int-to-float v3, v3

    if-eqz p1, :cond_4

    :try_start_3
    iget v7, p1, Landroid/graphics/RectF;->left:F

    sub-float/2addr v2, v7

    iget p1, p1, Landroid/graphics/RectF;->right:F
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    sub-float/2addr v2, p1

    int-to-float p1, v8

    mul-float/2addr v2, p1

    div-float/2addr v2, v0

    div-float/2addr v2, v4

    :cond_4
    const p1, 0x3d0f5c29    # 0.035f

    mul-float/2addr v3, p1

    mul-float v10, v3, v2

    const/4 v11, 0x0

    move-object v7, p0

    :try_start_4
    invoke-static/range {v6 .. v11}, Lcom/k4/dressroom/FrameSize;->frontPlate(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;IIFZ)Landroid/graphics/Bitmap;

    move-result-object p0

    if-nez p0, :cond_5

    goto :goto_6

    :cond_5
    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Landroid/graphics/Bitmap;->setDensity(I)V

    sget-object p1, Ljava/util/Locale;->US:Ljava/util/Locale;

    const-string v0, "frame size: saved front plate faded (%dx%d, fade %.0f px)"

    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-static {v10}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v4

    filled-new-array {v2, v3, v4}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {p1, v0, v2}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    new-instance p1, Landroid/graphics/drawable/BitmapDrawable;

    invoke-direct {p1, v5, p0}, Landroid/graphics/drawable/BitmapDrawable;-><init>(Landroid/content/res/Resources;Landroid/graphics/Bitmap;)V

    return-object p1

    :cond_6
    :goto_2
    move-object v7, p0

    const-string p0, "frame size: no base plate for the saved front plate, Samsung\'s kept"

    invoke-static {v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    return-object v7

    :catchall_1
    move-exception v0

    goto :goto_3

    :catchall_2
    move-exception v0

    move-object v7, p0

    :goto_3
    move-object p1, v0

    :goto_4
    const-string p0, "frame size: saved front plate"

    invoke-static {v1, p0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v7

    :cond_7
    :goto_5
    move-object v7, p0

    :goto_6
    return-object v7
.end method

.method public static saveRatios(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 11

    const-string v0, " -> "

    const-string v1, "K4HomeClock"

    const-string v2, "frame size: saved frame crops "

    sget v3, Lcom/k4/dressroom/FrameSize;->sScale:F

    const/high16 v4, 0x3f800000    # 1.0f

    cmpl-float v5, v3, v4

    if-eqz v5, :cond_2

    if-eqz p0, :cond_2

    sget-boolean v5, Lcom/k4/dressroom/HomeClock;->active:Z

    if-eqz v5, :cond_2

    sget v5, Lcom/k4/dressroom/FrameSize;->sVw:F

    const/4 v6, 0x0

    cmpg-float v5, v5, v6

    if-lez v5, :cond_2

    sget v5, Lcom/k4/dressroom/FrameSize;->sVh:F

    cmpg-float v5, v5, v6

    if-gtz v5, :cond_0

    goto/16 :goto_0

    :cond_0
    :try_start_0
    const-string v5, "a"

    invoke-static {p0, v5}, Lcom/k4/dressroom/HomeClock;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/graphics/RectF;

    const-string v6, "b"

    invoke-static {p0, v6}, Lcom/k4/dressroom/HomeClock;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Landroid/graphics/RectF;

    if-eqz v5, :cond_2

    if-nez v6, :cond_1

    goto/16 :goto_0

    :cond_1
    iget v7, v5, Landroid/graphics/RectF;->left:F

    sget v8, Lcom/k4/dressroom/FrameSize;->sHx:F

    sget v9, Lcom/k4/dressroom/FrameSize;->sVw:F

    div-float/2addr v8, v9

    iget v9, v5, Landroid/graphics/RectF;->left:F

    sub-float v9, v4, v9

    iget v10, v5, Landroid/graphics/RectF;->right:F

    sub-float/2addr v9, v10

    mul-float/2addr v8, v9

    add-float/2addr v7, v8

    iget v8, v5, Landroid/graphics/RectF;->top:F

    sget v9, Lcom/k4/dressroom/FrameSize;->sHy:F

    sget v10, Lcom/k4/dressroom/FrameSize;->sVh:F

    div-float/2addr v9, v10

    iget v10, v5, Landroid/graphics/RectF;->top:F

    sub-float/2addr v4, v10

    iget v10, v5, Landroid/graphics/RectF;->bottom:F

    sub-float/2addr v4, v10

    mul-float/2addr v9, v4

    add-float/2addr v8, v9

    new-instance v4, Landroid/graphics/RectF;

    invoke-direct {v4, v5}, Landroid/graphics/RectF;-><init>(Landroid/graphics/RectF;)V

    new-instance v9, Landroid/graphics/RectF;

    invoke-direct {v9, v6}, Landroid/graphics/RectF;-><init>(Landroid/graphics/RectF;)V

    invoke-static {v4, v7, v8, v3}, Lcom/k4/dressroom/FrameSize;->scale(Landroid/graphics/RectF;FFF)V

    invoke-static {v9, v7, v8, v3}, Lcom/k4/dressroom/FrameSize;->scale(Landroid/graphics/RectF;FFF)V

    invoke-static {v5}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-static {v6}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    invoke-static {v9}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v7

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v8, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ", land "

    invoke-virtual {v8, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-class v2, Ljava/lang/Object;

    const-class v3, Ljava/lang/Object;

    filled-new-array {v2, v3}, [Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v0

    filled-new-array {v4, v9}, [Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-object p0

    :catchall_0
    move-exception v0

    const-string v2, "frame size: save"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_2
    :goto_0
    return-object p0
.end method

.method public static saveResult(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 25

    move-object/from16 v1, p0

    const-string v2, "K4HomeClock"

    const-string v0, "a"

    const-string v3, "b"

    if-eqz v1, :cond_b

    sget-boolean v4, Lcom/k4/dressroom/HomeClock;->active:Z

    if-eqz v4, :cond_b

    sget v4, Lcom/k4/dressroom/FrameSize;->sScale:F

    const/high16 v5, 0x3f800000    # 1.0f

    cmpl-float v4, v4, v5

    if-ltz v4, :cond_0

    goto/16 :goto_3

    :cond_0
    :try_start_0
    invoke-static {v1, v0}, Lcom/k4/dressroom/HomeClock;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/graphics/Bitmap;

    invoke-static {v1, v3}, Lcom/k4/dressroom/HomeClock;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v6

    if-eqz v4, :cond_b

    if-nez v6, :cond_1

    goto/16 :goto_3

    :cond_1
    invoke-static {v6, v0}, Lcom/k4/dressroom/HomeClock;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v7

    invoke-static {v7, v3}, Lcom/k4/dressroom/HomeClock;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/graphics/RectF;

    invoke-static {v6, v3}, Lcom/k4/dressroom/HomeClock;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v8

    invoke-static {v8, v3}, Lcom/k4/dressroom/HomeClock;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/graphics/RectF;

    filled-new-array {v7, v8}, [Landroid/graphics/RectF;

    move-result-object v7

    invoke-virtual {v4}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v8

    int-to-float v8, v8

    invoke-virtual {v4}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v9

    int-to-float v9, v9

    move/from16 v16, v5

    const/4 v5, 0x0

    const/4 v12, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    const/16 v17, 0x0

    :goto_0
    const/4 v10, 0x2

    if-ge v12, v10, :cond_3

    aget-object v10, v7, v12

    if-nez v10, :cond_2

    goto/16 :goto_3

    :cond_2
    const/16 v18, 0x0

    iget v11, v10, Landroid/graphics/RectF;->left:F

    neg-float v11, v11

    invoke-static {v13, v11}, Ljava/lang/Math;->max(FF)F

    move-result v13

    iget v11, v10, Landroid/graphics/RectF;->top:F

    neg-float v11, v11

    invoke-static {v14, v11}, Ljava/lang/Math;->max(FF)F

    move-result v14

    iget v11, v10, Landroid/graphics/RectF;->right:F

    sub-float/2addr v11, v8

    invoke-static {v15, v11}, Ljava/lang/Math;->max(FF)F

    move-result v15

    iget v10, v10, Landroid/graphics/RectF;->bottom:F

    sub-float/2addr v10, v9

    invoke-static {v5, v10}, Ljava/lang/Math;->max(FF)F

    move-result v5

    add-int/lit8 v12, v12, 0x1

    goto :goto_0

    :cond_3
    const/16 v18, 0x0

    const/high16 v11, 0x3f000000    # 0.5f

    cmpg-float v12, v13, v11

    if-gez v12, :cond_4

    cmpg-float v12, v14, v11

    if-gez v12, :cond_4

    cmpg-float v12, v15, v11

    if-gez v12, :cond_4

    cmpg-float v11, v5, v11

    if-gez v11, :cond_4

    goto/16 :goto_3

    :cond_4
    invoke-static {v6, v0}, Lcom/k4/dressroom/HomeClock;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    invoke-static {v6, v3}, Lcom/k4/dressroom/HomeClock;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    filled-new-array {v0, v3}, [Ljava/lang/Object;

    move-result-object v0

    move/from16 v3, v17

    move/from16 v11, v18

    :goto_1
    if-ge v3, v10, :cond_6

    aget-object v12, v0, v3

    const-string v10, "c"

    invoke-static {v12, v10}, Lcom/k4/dressroom/HomeClock;->field(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Landroid/graphics/RectF;

    if-eqz v10, :cond_5

    aget-object v12, v7, v3

    invoke-virtual {v12}, Landroid/graphics/RectF;->width()F

    move-result v12

    cmpl-float v12, v12, v18

    if-lez v12, :cond_5

    aget-object v12, v7, v3

    invoke-virtual {v12}, Landroid/graphics/RectF;->height()F

    move-result v12

    cmpl-float v12, v12, v18

    if-lez v12, :cond_5

    invoke-virtual {v10}, Landroid/graphics/RectF;->width()F

    move-result v12

    aget-object v19, v7, v3

    invoke-virtual/range {v19 .. v19}, Landroid/graphics/RectF;->width()F

    move-result v19

    div-float v12, v12, v19

    invoke-virtual {v10}, Landroid/graphics/RectF;->height()F

    move-result v10

    aget-object v19, v7, v3

    invoke-virtual/range {v19 .. v19}, Landroid/graphics/RectF;->height()F

    move-result v19

    div-float v10, v10, v19

    invoke-static {v12, v10}, Ljava/lang/Math;->max(FF)F

    move-result v10

    invoke-static {v11, v10}, Ljava/lang/Math;->max(FF)F

    move-result v11

    :cond_5
    add-int/lit8 v3, v3, 0x1

    const/4 v10, 0x2

    goto :goto_1

    :cond_6
    cmpg-float v0, v11, v18

    if-lez v0, :cond_7

    cmpl-float v0, v11, v16

    if-lez v0, :cond_8

    :cond_7
    move/from16 v11, v16

    :cond_8
    float-to-double v12, v13

    invoke-static {v12, v13}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v12

    double-to-int v0, v12

    float-to-double v12, v14

    invoke-static {v12, v13}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v12

    double-to-int v3, v12

    int-to-float v0, v0

    add-float/2addr v8, v0

    float-to-double v12, v8

    float-to-double v14, v15

    invoke-static {v14, v15}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v14

    add-double/2addr v12, v14

    float-to-double v14, v11

    mul-double/2addr v12, v14

    invoke-static {v12, v13}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v12

    double-to-int v8, v12

    int-to-float v3, v3

    add-float/2addr v9, v3

    float-to-double v9, v9

    float-to-double v12, v5

    invoke-static {v12, v13}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v12

    add-double/2addr v9, v12

    mul-double/2addr v9, v14

    invoke-static {v9, v10}, Ljava/lang/Math;->ceil(D)D

    move-result-wide v9
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    double-to-int v5, v9

    int-to-long v9, v8

    int-to-long v12, v5

    mul-long/2addr v9, v12

    const-wide/32 v12, 0x2800000

    cmp-long v9, v9, v12

    const-string v10, "x"

    if-lez v9, :cond_9

    :try_start_1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "frame size: padded plate would be "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v3, ", saved without"

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-object v1

    :cond_9
    sget-object v9, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v8, v5, v9}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v9

    new-instance v12, Landroid/graphics/BitmapShader;

    sget-object v13, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    sget-object v14, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    invoke-direct {v12, v4, v13, v14}, Landroid/graphics/BitmapShader;-><init>(Landroid/graphics/Bitmap;Landroid/graphics/Shader$TileMode;Landroid/graphics/Shader$TileMode;)V

    new-instance v13, Landroid/graphics/Matrix;

    invoke-direct {v13}, Landroid/graphics/Matrix;-><init>()V

    invoke-virtual {v13, v0, v3}, Landroid/graphics/Matrix;->setTranslate(FF)V

    invoke-virtual {v13, v11, v11}, Landroid/graphics/Matrix;->postScale(FF)Z

    invoke-virtual {v12, v13}, Landroid/graphics/BitmapShader;->setLocalMatrix(Landroid/graphics/Matrix;)V

    new-instance v13, Landroid/graphics/Paint;

    const/4 v14, 0x2

    invoke-direct {v13, v14}, Landroid/graphics/Paint;-><init>(I)V

    invoke-virtual {v13, v12}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    new-instance v12, Landroid/graphics/Canvas;

    invoke-direct {v12, v9}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    int-to-float v14, v8

    int-to-float v15, v5

    const/16 v20, 0x0

    const/16 v21, 0x0

    move-object/from16 v19, v12

    move-object/from16 v24, v13

    move/from16 v22, v14

    move/from16 v23, v15

    invoke-virtual/range {v19 .. v24}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    move/from16 v12, v17

    :goto_2
    const/4 v14, 0x2

    if-ge v12, v14, :cond_a

    aget-object v13, v7, v12

    invoke-virtual {v13, v0, v3}, Landroid/graphics/RectF;->offset(FF)V

    iget v15, v13, Landroid/graphics/RectF;->left:F

    mul-float/2addr v15, v11

    iget v14, v13, Landroid/graphics/RectF;->top:F

    mul-float/2addr v14, v11

    move/from16 v16, v0

    iget v0, v13, Landroid/graphics/RectF;->right:F

    mul-float/2addr v0, v11

    iget v1, v13, Landroid/graphics/RectF;->bottom:F

    mul-float/2addr v1, v11

    invoke-virtual {v13, v15, v14, v0, v1}, Landroid/graphics/RectF;->set(FFFF)V

    add-int/lit8 v12, v12, 0x1

    move-object/from16 v1, p0

    move/from16 v0, v16

    goto :goto_2

    :cond_a
    invoke-virtual {v4}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v0

    invoke-virtual {v4}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v1

    aget-object v3, v7, v17

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x1

    aget-object v4, v7, v4

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v12, "frame size: saved plate "

    invoke-virtual {v7, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " padded to "

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " (edges extended, scale "

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v11}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v0, "), port "

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ", land "

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    invoke-virtual/range {p0 .. p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    const-class v1, Ljava/lang/Object;

    const-class v3, Ljava/lang/Object;

    filled-new-array {v1, v3}, [Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v0

    filled-new-array {v9, v6}, [Ljava/lang/Object;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    return-object v0

    :catchall_0
    move-exception v0

    const-string v1, "frame size: save padding"

    invoke-static {v2, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_b
    :goto_3
    return-object p0
.end method

.method static scale(Landroid/graphics/RectF;FFF)V
    .locals 5

    iget v0, p0, Landroid/graphics/RectF;->left:F

    iget v1, p0, Landroid/graphics/RectF;->top:F

    iget v2, p0, Landroid/graphics/RectF;->right:F

    const/high16 v3, 0x3f800000    # 1.0f

    sub-float v2, v3, v2

    iget v4, p0, Landroid/graphics/RectF;->bottom:F

    sub-float v4, v3, v4

    sub-float v0, p1, v0

    div-float/2addr v0, p3

    sub-float v0, p1, v0

    sub-float/2addr v2, p1

    div-float/2addr v2, p3

    add-float/2addr p1, v2

    sub-float v1, p2, v1

    div-float/2addr v1, p3

    sub-float v1, p2, v1

    sub-float/2addr v4, p2

    div-float/2addr v4, p3

    add-float/2addr p2, v4

    sub-float p1, v3, p1

    sub-float/2addr v3, p2

    invoke-virtual {p0, v0, v1, p1, v3}, Landroid/graphics/RectF;->set(FFFF)V

    return-void
.end method

.method static scaled()F
    .locals 2

    sget v0, Lcom/k4/dressroom/FrameSize;->sScale:F

    sget v1, Lcom/k4/dressroom/FrameSize;->sLive:F

    mul-float/2addr v0, v1

    return v0
.end method

.method static touch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 11

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const-string v1, "K4HomeClock"

    const/4 v2, 0x2

    const/high16 v3, 0x3f800000    # 1.0f

    const/4 v4, 0x0

    const/4 v5, 0x1

    if-nez v0, :cond_5

    :try_start_0
    invoke-static {p0}, Lcom/k4/dressroom/FrameSize;->applyHole(Landroid/view/View;)V

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v6

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v7

    invoke-static {p0, v6, v7}, Lcom/k4/dressroom/FrameSize;->zone(Landroid/view/View;FF)I

    move-result v6

    if-ne v6, v2, :cond_0

    invoke-static {p0}, Lcom/k4/dressroom/FrameSize;->begin(Landroid/view/View;)Z

    move-result v7

    if-eqz v7, :cond_0

    move v7, v5

    goto :goto_0

    :cond_0
    move v7, v4

    :goto_0
    sput-boolean v7, Lcom/k4/dressroom/FrameSize;->sGesture:Z

    if-ne v6, v5, :cond_1

    move v7, v5

    goto :goto_1

    :cond_1
    move v7, v4

    :goto_1
    sput-boolean v7, Lcom/k4/dressroom/FrameSize;->sMaybe:Z

    sput v4, Lcom/k4/dressroom/FrameSize;->sCount:I

    sget-object v7, Ljava/util/Locale;->US:Ljava/util/Locale;

    const-string v8, "frame size: touch at %.0f,%.0f on the %s"

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v9

    invoke-static {v9}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v9

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v10

    invoke-static {v10}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v10

    if-ne v6, v2, :cond_3

    sget-boolean v6, Lcom/k4/dressroom/FrameSize;->sGesture:Z

    if-eqz v6, :cond_2

    const-string v6, "frame"

    goto :goto_2

    :cond_2
    const-string v6, "frame (cannot size it)"

    goto :goto_2

    :cond_3
    if-ne v6, v5, :cond_4

    const-string v6, "hole\'s edge"

    goto :goto_2

    :cond_4
    const-string v6, "picture"

    :goto_2
    filled-new-array {v9, v10, v6}, [Ljava/lang/Object;

    move-result-object v6

    invoke-static {v7, v8, v6}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    invoke-static {v1, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_3

    :cond_5
    sget-boolean v6, Lcom/k4/dressroom/FrameSize;->sGesture:Z

    if-nez v6, :cond_7

    const/4 v6, 0x5

    if-ne v0, v6, :cond_7

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getPointerCount()I

    move-result v6

    if-ne v6, v2, :cond_7

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result v6

    sget-boolean v7, Lcom/k4/dressroom/FrameSize;->sMaybe:Z

    if-nez v7, :cond_6

    invoke-virtual {p1, v6}, Landroid/view/MotionEvent;->getX(I)F

    move-result v7

    invoke-virtual {p1, v6}, Landroid/view/MotionEvent;->getY(I)F

    move-result v6

    invoke-static {p0, v7, v6}, Lcom/k4/dressroom/FrameSize;->zone(Landroid/view/View;FF)I

    move-result v6

    if-lt v6, v5, :cond_7

    :cond_6
    invoke-static {p0}, Lcom/k4/dressroom/FrameSize;->begin(Landroid/view/View;)Z

    move-result v6

    if-eqz v6, :cond_7

    sput-boolean v5, Lcom/k4/dressroom/FrameSize;->sGesture:Z

    sput v4, Lcom/k4/dressroom/FrameSize;->sCount:I

    const-string v6, "frame size: pinch at the frame\'s edge sizes the frame"

    invoke-static {v1, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_7
    :goto_3
    sget-boolean v6, Lcom/k4/dressroom/FrameSize;->sGesture:Z

    if-nez v6, :cond_8

    return v4

    :cond_8
    const/4 v6, 0x6

    if-eq v0, v6, :cond_a

    if-ne v0, v5, :cond_9

    goto :goto_4

    :cond_9
    const/4 v6, -0x1

    goto :goto_5

    :cond_a
    :goto_4
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result v6

    :goto_5
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getPointerCount()I

    move-result v7

    if-ltz v6, :cond_b

    move v8, v5

    goto :goto_6

    :cond_b
    move v8, v4

    :goto_6
    sub-int/2addr v7, v8

    invoke-static {p1, v6}, Lcom/k4/dressroom/EditXf;->span(Landroid/view/MotionEvent;I)F

    move-result p1

    sget v6, Lcom/k4/dressroom/FrameSize;->sCount:I

    if-ne v7, v6, :cond_d

    if-eq v0, v2, :cond_c

    goto :goto_7

    :cond_c
    if-lt v7, v2, :cond_e

    sget v2, Lcom/k4/dressroom/FrameSize;->sSpan0:F

    cmpl-float v6, v2, v3

    if-lez v6, :cond_e

    cmpl-float v6, p1, v3

    if-lez v6, :cond_e

    sget v6, Lcom/k4/dressroom/FrameSize;->sMin:F

    sget v7, Lcom/k4/dressroom/FrameSize;->sMax:F

    sget v8, Lcom/k4/dressroom/FrameSize;->sBase:F

    mul-float/2addr v8, p1

    div-float/2addr v8, v2

    invoke-static {v7, v8}, Ljava/lang/Math;->min(FF)F

    move-result p1

    invoke-static {v6, p1}, Ljava/lang/Math;->max(FF)F

    move-result p1

    sget v2, Lcom/k4/dressroom/FrameSize;->sLive:F

    cmpl-float v2, p1, v2

    if-eqz v2, :cond_e

    sput p1, Lcom/k4/dressroom/FrameSize;->sLive:F

    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->redraw(Landroid/view/View;)V

    goto :goto_8

    :cond_d
    :goto_7
    sput v7, Lcom/k4/dressroom/FrameSize;->sCount:I

    sput p1, Lcom/k4/dressroom/FrameSize;->sSpan0:F

    sget p1, Lcom/k4/dressroom/FrameSize;->sLive:F

    sput p1, Lcom/k4/dressroom/FrameSize;->sBase:F

    :cond_e
    :goto_8
    if-eq v0, v5, :cond_f

    const/4 p1, 0x3

    if-ne v0, p1, :cond_11

    :cond_f
    sput-boolean v4, Lcom/k4/dressroom/FrameSize;->sGesture:Z

    sget p1, Lcom/k4/dressroom/FrameSize;->sLive:F

    sget v0, Lcom/k4/dressroom/FrameSize;->sScale:F

    mul-float/2addr v0, p1

    sput v0, Lcom/k4/dressroom/FrameSize;->sScale:F

    sput v3, Lcom/k4/dressroom/FrameSize;->sLive:F

    sub-float/2addr p1, v3

    invoke-static {p1}, Ljava/lang/Math;->abs(F)F

    move-result p1

    const v0, 0x3b03126f    # 0.002f

    cmpl-float p1, p1, v0

    if-lez p1, :cond_10

    invoke-static {p0}, Lcom/k4/dressroom/FrameSize;->applyHole(Landroid/view/View;)V

    invoke-static {p0}, Lcom/k4/dressroom/FrameSize;->refit(Landroid/view/View;)V

    sget-object p1, Ljava/util/Locale;->US:Ljava/util/Locale;

    const-string v0, "frame size: %.3f of Samsung\'s"

    sget v2, Lcom/k4/dressroom/FrameSize;->sScale:F

    invoke-static {v2}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v2

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {p1, v0, v2}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :cond_10
    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->redraw(Landroid/view/View;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :cond_11
    return v5

    :catchall_0
    move-exception p0

    const-string p1, "frame size: touch"

    invoke-static {v1, p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    sput-boolean v4, Lcom/k4/dressroom/FrameSize;->sGesture:Z

    sput v3, Lcom/k4/dressroom/FrameSize;->sLive:F

    return v4
.end method

.method static zone(Landroid/view/View;FF)I
    .locals 4

    invoke-static {p0}, Lcom/k4/dressroom/EditXf;->frameRect(Landroid/view/View;)Landroid/graphics/RectF;

    move-result-object v0

    invoke-static {p0, p1, p2}, Lcom/k4/dressroom/FrameSize;->onPlate(Landroid/view/View;FF)Z

    move-result v1

    if-nez v1, :cond_2

    if-eqz v0, :cond_0

    invoke-virtual {v0, p1, p2}, Landroid/graphics/RectF;->contains(FF)Z

    move-result v1

    if-nez v1, :cond_0

    goto :goto_0

    :cond_0
    if-nez v0, :cond_1

    const/4 p0, 0x0

    return p0

    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    const/high16 v1, 0x42100000    # 36.0f

    mul-float/2addr p0, v1

    new-instance v1, Landroid/graphics/RectF;

    invoke-direct {v1, v0}, Landroid/graphics/RectF;-><init>(Landroid/graphics/RectF;)V

    invoke-virtual {v0}, Landroid/graphics/RectF;->width()F

    move-result v2

    const/high16 v3, 0x40800000    # 4.0f

    div-float/2addr v2, v3

    invoke-static {p0, v2}, Ljava/lang/Math;->min(FF)F

    move-result v2

    invoke-virtual {v0}, Landroid/graphics/RectF;->height()F

    move-result v0

    div-float/2addr v0, v3

    invoke-static {p0, v0}, Ljava/lang/Math;->min(FF)F

    move-result p0

    invoke-virtual {v1, v2, p0}, Landroid/graphics/RectF;->inset(FF)V

    invoke-virtual {v1, p1, p2}, Landroid/graphics/RectF;->contains(FF)Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0

    :cond_2
    :goto_0
    const/4 p0, 0x2

    return p0
.end method
