.class Lcom/k4/face/K4FacePreview$Worker$1;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/k4/face/K4FacePreview$Worker;->quit()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/k4/face/K4FacePreview$Worker;


# direct methods
.method constructor <init>(Lcom/k4/face/K4FacePreview$Worker;)V
    .registers 2
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    iput-object p1, p0, Lcom/k4/face/K4FacePreview$Worker$1;->this$0:Lcom/k4/face/K4FacePreview$Worker;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 1

    iget-object p0, p0, Lcom/k4/face/K4FacePreview$Worker$1;->this$0:Lcom/k4/face/K4FacePreview$Worker;

    invoke-static {p0}, Lcom/k4/face/K4FacePreview$Worker;->-$$Nest$mclose(Lcom/k4/face/K4FacePreview$Worker;)V

    return-void
.end method
