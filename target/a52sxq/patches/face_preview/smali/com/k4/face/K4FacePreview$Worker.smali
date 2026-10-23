.class final Lcom/k4/face/K4FacePreview$Worker;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/k4/face/K4FacePreview;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Worker"
.end annotation


# instance fields
.field private mBitmap:Landroid/graphics/Bitmap;

.field private final mBounds:Landroid/graphics/RectF;

.field private final mHandler:Landroid/os/Handler;

.field private final mJpeg:Ljava/io/ByteArrayOutputStream;

.field private final mMatrix:Landroid/graphics/Matrix;

.field private final mPending:Ljava/util/concurrent/atomic/AtomicReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/atomic/AtomicReference<",
            "Lcom/k4/face/K4FacePreview$Frame;",
            ">;"
        }
    .end annotation
.end field

.field private volatile mQuit:Z

.field private final mRect:Landroid/graphics/Rect;

.field private final mSpare:Ljava/util/concurrent/atomic/AtomicReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/concurrent/atomic/AtomicReference<",
            "[B>;"
        }
    .end annotation
.end field

.field private mSurface:Landroid/view/Surface;

.field private mTexture:Landroid/graphics/SurfaceTexture;

.field private final mThread:Landroid/os/HandlerThread;


# direct methods
.method static bridge synthetic -$$Nest$mclose(Lcom/k4/face/K4FacePreview$Worker;)V
    .registers 1

    invoke-direct {p0}, Lcom/k4/face/K4FacePreview$Worker;->close()V

    return-void
.end method

.method constructor <init>()V
    .registers 3

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    new-instance v0, Landroid/os/HandlerThread;

    const-string v1, "K4FacePreview"

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mThread:Landroid/os/HandlerThread;

    new-instance v1, Ljava/util/concurrent/atomic/AtomicReference;

    invoke-direct {v1}, Ljava/util/concurrent/atomic/AtomicReference;-><init>()V

    iput-object v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mPending:Ljava/util/concurrent/atomic/AtomicReference;

    new-instance v1, Ljava/util/concurrent/atomic/AtomicReference;

    invoke-direct {v1}, Ljava/util/concurrent/atomic/AtomicReference;-><init>()V

    iput-object v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mSpare:Ljava/util/concurrent/atomic/AtomicReference;

    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    iput-object v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mJpeg:Ljava/io/ByteArrayOutputStream;

    new-instance v1, Landroid/graphics/Rect;

    invoke-direct {v1}, Landroid/graphics/Rect;-><init>()V

    iput-object v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mRect:Landroid/graphics/Rect;

    new-instance v1, Landroid/graphics/Matrix;

    invoke-direct {v1}, Landroid/graphics/Matrix;-><init>()V

    iput-object v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mMatrix:Landroid/graphics/Matrix;

    new-instance v1, Landroid/graphics/RectF;

    invoke-direct {v1}, Landroid/graphics/RectF;-><init>()V

    iput-object v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mBounds:Landroid/graphics/RectF;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    new-instance v1, Landroid/os/Handler;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-direct {v1, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mHandler:Landroid/os/Handler;

    return-void
.end method

.method private close()V
    .registers 3

    iget-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mSurface:Landroid/view/Surface;

    if-eqz v0, :cond_7

    invoke-virtual {v0}, Landroid/view/Surface;->release()V

    :cond_7
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mSurface:Landroid/view/Surface;

    iput-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mTexture:Landroid/graphics/SurfaceTexture;

    iget-object v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mBitmap:Landroid/graphics/Bitmap;

    if-eqz v1, :cond_13

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->recycle()V

    :cond_13
    iput-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mBitmap:Landroid/graphics/Bitmap;

    return-void
.end method

.method private decode([BI)Landroid/graphics/Bitmap;
    .registers 6

    new-instance v0, Landroid/graphics/BitmapFactory$Options;

    invoke-direct {v0}, Landroid/graphics/BitmapFactory$Options;-><init>()V

    const/4 v1, 0x1

    iput-boolean v1, v0, Landroid/graphics/BitmapFactory$Options;->inMutable:Z

    iget-object v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mBitmap:Landroid/graphics/Bitmap;

    if-eqz v1, :cond_16

    invoke-virtual {v1}, Landroid/graphics/Bitmap;->isRecycled()Z

    move-result v1

    if-nez v1, :cond_16

    iget-object v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mBitmap:Landroid/graphics/Bitmap;

    iput-object v1, v0, Landroid/graphics/BitmapFactory$Options;->inBitmap:Landroid/graphics/Bitmap;

    :cond_16
    const/4 v1, 0x0

    :try_start_17
    invoke-static {p1, v1, p2, v0}, Landroid/graphics/BitmapFactory;->decodeByteArray([BIILandroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    move-result-object p1
    :try_end_1b
    .catch Ljava/lang/IllegalArgumentException; {:try_start_17 .. :try_end_1b} :catch_1c

    goto :goto_23

    :catch_1c
    const/4 v2, 0x0

    iput-object v2, v0, Landroid/graphics/BitmapFactory$Options;->inBitmap:Landroid/graphics/Bitmap;

    invoke-static {p1, v1, p2, v0}, Landroid/graphics/BitmapFactory;->decodeByteArray([BIILandroid/graphics/BitmapFactory$Options;)Landroid/graphics/Bitmap;

    move-result-object p1

    :goto_23
    if-eqz p1, :cond_30

    iget-object p2, p0, Lcom/k4/face/K4FacePreview$Worker;->mBitmap:Landroid/graphics/Bitmap;

    if-eq p1, p2, :cond_30

    if-eqz p2, :cond_2e

    invoke-virtual {p2}, Landroid/graphics/Bitmap;->recycle()V

    :cond_2e
    iput-object p1, p0, Lcom/k4/face/K4FacePreview$Worker;->mBitmap:Landroid/graphics/Bitmap;

    :cond_30
    return-object p1
.end method

.method private draw(Lcom/k4/face/K4FacePreview$Frame;)V
    .registers 13

    iget-object v0, p1, Lcom/k4/face/K4FacePreview$Frame;->texture:Landroid/graphics/SurfaceTexture;

    invoke-virtual {v0}, Landroid/graphics/SurfaceTexture;->isReleased()Z

    move-result v0

    if-eqz v0, :cond_a

    goto/16 :goto_fc

    :cond_a
    iget-object v0, p1, Lcom/k4/face/K4FacePreview$Frame;->texture:Landroid/graphics/SurfaceTexture;

    iget-object v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mTexture:Landroid/graphics/SurfaceTexture;

    if-eq v0, v1, :cond_24

    iget-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mSurface:Landroid/view/Surface;

    if-eqz v0, :cond_17

    invoke-virtual {v0}, Landroid/view/Surface;->release()V

    :cond_17
    iget-object v0, p1, Lcom/k4/face/K4FacePreview$Frame;->texture:Landroid/graphics/SurfaceTexture;

    iput-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mTexture:Landroid/graphics/SurfaceTexture;

    new-instance v0, Landroid/view/Surface;

    iget-object v1, p1, Lcom/k4/face/K4FacePreview$Frame;->texture:Landroid/graphics/SurfaceTexture;

    invoke-direct {v0, v1}, Landroid/view/Surface;-><init>(Landroid/graphics/SurfaceTexture;)V

    iput-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mSurface:Landroid/view/Surface;

    :cond_24
    iget-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mJpeg:Ljava/io/ByteArrayOutputStream;

    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->reset()V

    iget-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mRect:Landroid/graphics/Rect;

    iget v1, p1, Lcom/k4/face/K4FacePreview$Frame;->w:I

    iget v2, p1, Lcom/k4/face/K4FacePreview$Frame;->h:I

    const/4 v3, 0x0

    invoke-virtual {v0, v3, v3, v1, v2}, Landroid/graphics/Rect;->set(IIII)V

    new-instance v4, Landroid/graphics/YuvImage;

    iget-object v5, p1, Lcom/k4/face/K4FacePreview$Frame;->data:[B

    iget v7, p1, Lcom/k4/face/K4FacePreview$Frame;->w:I

    iget v8, p1, Lcom/k4/face/K4FacePreview$Frame;->h:I

    const/4 v9, 0x0

    const/16 v6, 0x11

    invoke-direct/range {v4 .. v9}, Landroid/graphics/YuvImage;-><init>([BIII[I)V

    iget-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mRect:Landroid/graphics/Rect;

    const/16 v1, 0x55

    iget-object v2, p0, Lcom/k4/face/K4FacePreview$Worker;->mJpeg:Ljava/io/ByteArrayOutputStream;

    invoke-virtual {v4, v0, v1, v2}, Landroid/graphics/YuvImage;->compressToJpeg(Landroid/graphics/Rect;ILjava/io/OutputStream;)Z

    iget-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mJpeg:Ljava/io/ByteArrayOutputStream;

    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0

    iget-object v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mJpeg:Ljava/io/ByteArrayOutputStream;

    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->size()I

    move-result v1

    invoke-direct {p0, v0, v1}, Lcom/k4/face/K4FacePreview$Worker;->decode([BI)Landroid/graphics/Bitmap;

    move-result-object v0

    if-nez v0, :cond_5e

    goto/16 :goto_fc

    :cond_5e
    iget-object v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mSurface:Landroid/view/Surface;

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/view/Surface;->lockCanvas(Landroid/graphics/Rect;)Landroid/graphics/Canvas;

    move-result-object v1

    const-string v3, "K4FacePreview"

    if-nez v1, :cond_6f

    const-string p0, "lockCanvas returned null"

    invoke-static {v3, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_6f
    const/high16 v4, -0x1000000

    :try_start_71
    invoke-virtual {v1, v4}, Landroid/graphics/Canvas;->drawColor(I)V

    iget-object v4, p0, Lcom/k4/face/K4FacePreview$Worker;->mMatrix:Landroid/graphics/Matrix;

    invoke-virtual {v4}, Landroid/graphics/Matrix;->reset()V

    iget v5, p1, Lcom/k4/face/K4FacePreview$Frame;->orientation:I

    int-to-float v5, v5

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v6

    int-to-float v6, v6

    const/high16 v7, 0x40000000    # 2.0f

    div-float/2addr v6, v7

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v8

    int-to-float v8, v8

    div-float/2addr v8, v7

    invoke-virtual {v4, v5, v6, v8}, Landroid/graphics/Matrix;->postRotate(FFF)Z

    iget-object v5, p0, Lcom/k4/face/K4FacePreview$Worker;->mBounds:Landroid/graphics/RectF;

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v6

    int-to-float v6, v6

    invoke-virtual {v0}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v8

    int-to-float v8, v8

    const/4 v9, 0x0

    invoke-virtual {v5, v9, v9, v6, v8}, Landroid/graphics/RectF;->set(FFFF)V

    iget-object v5, p0, Lcom/k4/face/K4FacePreview$Worker;->mBounds:Landroid/graphics/RectF;

    invoke-virtual {v4, v5}, Landroid/graphics/Matrix;->mapRect(Landroid/graphics/RectF;)Z

    iget-object v5, p0, Lcom/k4/face/K4FacePreview$Worker;->mBounds:Landroid/graphics/RectF;

    iget v5, v5, Landroid/graphics/RectF;->left:F

    neg-float v5, v5

    iget-object v6, p0, Lcom/k4/face/K4FacePreview$Worker;->mBounds:Landroid/graphics/RectF;

    iget v6, v6, Landroid/graphics/RectF;->top:F

    neg-float v6, v6

    invoke-virtual {v4, v5, v6}, Landroid/graphics/Matrix;->postTranslate(FF)Z

    iget-object v5, p0, Lcom/k4/face/K4FacePreview$Worker;->mBounds:Landroid/graphics/RectF;

    invoke-virtual {v5}, Landroid/graphics/RectF;->width()F

    move-result v5

    iget-object v6, p0, Lcom/k4/face/K4FacePreview$Worker;->mBounds:Landroid/graphics/RectF;

    invoke-virtual {v6}, Landroid/graphics/RectF;->height()F

    move-result v6

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getWidth()I

    move-result v8

    int-to-float v8, v8

    div-float/2addr v8, v5

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getHeight()I

    move-result v9

    int-to-float v9, v9

    div-float/2addr v9, v6

    invoke-static {v8, v9}, Ljava/lang/Math;->max(FF)F

    move-result v8

    neg-float v9, v8

    invoke-virtual {v4, v9, v8}, Landroid/graphics/Matrix;->postScale(FF)Z

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getWidth()I

    move-result v9

    int-to-float v9, v9

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getWidth()I

    move-result v10

    int-to-float v10, v10

    mul-float/2addr v5, v8

    sub-float/2addr v10, v5

    div-float/2addr v10, v7

    sub-float/2addr v9, v10

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getHeight()I

    move-result v5

    int-to-float v5, v5

    mul-float/2addr v6, v8

    sub-float/2addr v5, v6

    div-float/2addr v5, v7

    invoke-virtual {v4, v9, v5}, Landroid/graphics/Matrix;->postTranslate(FF)Z

    invoke-virtual {v1, v0, v4, v2}, Landroid/graphics/Canvas;->drawBitmap(Landroid/graphics/Bitmap;Landroid/graphics/Matrix;Landroid/graphics/Paint;)V
    :try_end_eb
    .catchall {:try_start_71 .. :try_end_eb} :catchall_129

    iget-object p0, p0, Lcom/k4/face/K4FacePreview$Worker;->mSurface:Landroid/view/Surface;

    invoke-virtual {p0, v1}, Landroid/view/Surface;->unlockCanvasAndPost(Landroid/graphics/Canvas;)V

    iget p0, p1, Lcom/k4/face/K4FacePreview$Frame;->number:I

    const/4 v0, 0x3

    if-le p0, v0, :cond_fd

    iget p0, p1, Lcom/k4/face/K4FacePreview$Frame;->number:I

    rem-int/lit8 p0, p0, 0x1e

    if-nez p0, :cond_fc

    goto :goto_fd

    :cond_fc
    :goto_fc
    return-void

    :cond_fd
    :goto_fd
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "drew frame "

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget p1, p1, Lcom/k4/face/K4FacePreview$Frame;->number:I

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " canvas="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getWidth()I

    move-result p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, "x"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Landroid/graphics/Canvas;->getHeight()I

    move-result p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v3, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :catchall_129
    move-exception v0

    move-object p1, v0

    iget-object p0, p0, Lcom/k4/face/K4FacePreview$Worker;->mSurface:Landroid/view/Surface;

    invoke-virtual {p0, v1}, Landroid/view/Surface;->unlockCanvasAndPost(Landroid/graphics/Canvas;)V

    throw p1
.end method


# virtual methods
.method offer(Lcom/k4/face/K4FacePreview$Frame;)V
    .registers 3

    iget-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mPending:Ljava/util/concurrent/atomic/AtomicReference;

    invoke-virtual {v0, p1}, Ljava/util/concurrent/atomic/AtomicReference;->getAndSet(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/k4/face/K4FacePreview$Frame;

    if-nez p1, :cond_10

    iget-object p1, p0, Lcom/k4/face/K4FacePreview$Worker;->mHandler:Landroid/os/Handler;

    invoke-virtual {p1, p0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void

    :cond_10
    iget-object p0, p0, Lcom/k4/face/K4FacePreview$Worker;->mSpare:Ljava/util/concurrent/atomic/AtomicReference;

    iget-object p1, p1, Lcom/k4/face/K4FacePreview$Frame;->data:[B

    invoke-virtual {p0, p1}, Ljava/util/concurrent/atomic/AtomicReference;->set(Ljava/lang/Object;)V

    return-void
.end method

.method quit()V
    .registers 3

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mQuit:Z

    iget-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mPending:Ljava/util/concurrent/atomic/AtomicReference;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicReference;->set(Ljava/lang/Object;)V

    iget-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mHandler:Landroid/os/Handler;

    new-instance v1, Lcom/k4/face/K4FacePreview$Worker$1;

    invoke-direct {v1, p0}, Lcom/k4/face/K4FacePreview$Worker$1;-><init>(Lcom/k4/face/K4FacePreview$Worker;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    iget-object p0, p0, Lcom/k4/face/K4FacePreview$Worker;->mThread:Landroid/os/HandlerThread;

    invoke-virtual {p0}, Landroid/os/HandlerThread;->quitSafely()Z

    return-void
.end method

.method public run()V
    .registers 5

    iget-object v0, p0, Lcom/k4/face/K4FacePreview$Worker;->mPending:Ljava/util/concurrent/atomic/AtomicReference;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicReference;->getAndSet(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/k4/face/K4FacePreview$Frame;

    if-eqz v0, :cond_23

    iget-boolean v1, p0, Lcom/k4/face/K4FacePreview$Worker;->mQuit:Z

    if-eqz v1, :cond_10

    goto :goto_23

    :cond_10
    :try_start_10
    invoke-direct {p0, v0}, Lcom/k4/face/K4FacePreview$Worker;->draw(Lcom/k4/face/K4FacePreview$Frame;)V
    :try_end_13
    .catchall {:try_start_10 .. :try_end_13} :catchall_14

    goto :goto_1c

    :catchall_14
    move-exception v1

    const-string v2, "K4FacePreview"

    const-string v3, "render failed"

    invoke-static {v2, v3, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_1c
    iget-object p0, p0, Lcom/k4/face/K4FacePreview$Worker;->mSpare:Ljava/util/concurrent/atomic/AtomicReference;

    iget-object v0, v0, Lcom/k4/face/K4FacePreview$Frame;->data:[B

    invoke-virtual {p0, v0}, Ljava/util/concurrent/atomic/AtomicReference;->set(Ljava/lang/Object;)V

    :cond_23
    :goto_23
    return-void
.end method

.method spare(I)[B
    .registers 4

    iget-object p0, p0, Lcom/k4/face/K4FacePreview$Worker;->mSpare:Ljava/util/concurrent/atomic/AtomicReference;

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Ljava/util/concurrent/atomic/AtomicReference;->getAndSet(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [B

    if-eqz p0, :cond_f

    array-length v1, p0

    if-ne v1, p1, :cond_f

    return-object p0

    :cond_f
    return-object v0
.end method
