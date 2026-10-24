.class Lcom/k4/soundtrigger/K4StRetry$11;
.super Ljava/lang/Object;
.source "K4StRetry.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/k4/soundtrigger/K4StRetry;->registerState()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$mode:I


# direct methods
.method constructor <init>(I)V
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 574
    iput p1, p0, Lcom/k4/soundtrigger/K4StRetry$11;->val$mode:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 2

    .line 577
    iget v0, p0, Lcom/k4/soundtrigger/K4StRetry$11;->val$mode:I

    invoke-static {v0}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smonMode(I)V

    .line 578
    return-void
.end method
