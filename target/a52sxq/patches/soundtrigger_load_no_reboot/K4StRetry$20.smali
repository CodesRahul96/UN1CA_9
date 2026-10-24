.class Lcom/k4/soundtrigger/K4StRetry$20;
.super Ljava/lang/Object;
.source "K4StRetry.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/k4/soundtrigger/K4StRetry;->hold(J)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$until:J


# direct methods
.method constructor <init>(J)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 1026
    iput-wide p1, p0, Lcom/k4/soundtrigger/K4StRetry$20;->val$until:J

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 1029
    iget-wide v0, p0, Lcom/k4/soundtrigger/K4StRetry$20;->val$until:J

    invoke-static {v0, v1}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smacquire(J)V

    .line 1030
    return-void
.end method
