.class final Lcom/k4/face/K4FacePreview$Frame;
.super Ljava/lang/Object;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/k4/face/K4FacePreview;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Frame"
.end annotation


# instance fields
.field final data:[B

.field final h:I

.field final number:I

.field final orientation:I

.field final texture:Landroid/graphics/SurfaceTexture;

.field final w:I


# direct methods
.method constructor <init>(Landroid/graphics/SurfaceTexture;[BIIII)V
    .registers 7

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/k4/face/K4FacePreview$Frame;->texture:Landroid/graphics/SurfaceTexture;

    iput-object p2, p0, Lcom/k4/face/K4FacePreview$Frame;->data:[B

    iput p3, p0, Lcom/k4/face/K4FacePreview$Frame;->w:I

    iput p4, p0, Lcom/k4/face/K4FacePreview$Frame;->h:I

    iput p5, p0, Lcom/k4/face/K4FacePreview$Frame;->orientation:I

    iput p6, p0, Lcom/k4/face/K4FacePreview$Frame;->number:I

    return-void
.end method
