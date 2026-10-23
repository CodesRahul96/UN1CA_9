.class Lcom/k4/homeclock/EngineState$1;
.super Ljava/lang/Object;
.source "EngineState.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/k4/homeclock/EngineState;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/k4/homeclock/EngineState;


# direct methods
.method constructor <init>(Lcom/k4/homeclock/EngineState;)V
    .registers 2
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 31
    iput-object p1, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 9

    .line 34
    iget-object v0, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v0}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetengine(Lcom/k4/homeclock/EngineState;)Ljava/lang/ref/WeakReference;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lf3/a;

    .line 35
    if-nez v0, :cond_f

    .line 36
    return-void

    .line 38
    :cond_f
    invoke-virtual {v0}, Lf3/a;->getWhich()I

    move-result v1

    .line 39
    invoke-static {}, Lcom/k4/homeclock/HomeDepthClock;->enabled()Z

    move-result v2

    .line 40
    invoke-static {}, Lcom/k4/homeclock/HomeDepthClock;->sharedEnabled()Z

    move-result v3

    .line 41
    const/4 v4, 0x0

    const/4 v5, 0x1

    if-eqz v2, :cond_27

    and-int/lit8 v6, v1, 0x3

    if-eq v6, v5, :cond_25

    if-eqz v3, :cond_27

    :cond_25
    move v6, v5

    goto :goto_28

    :cond_27
    move v6, v4

    .line 42
    :goto_28
    invoke-static {v0}, Lcom/k4/homeclock/HomeDepthClock;->clockOf(Lf3/a;)Lcom/k4/homeclock/DepthClock;

    move-result-object v7

    if-nez v7, :cond_34

    iget-object v7, v0, Lf3/a;->g:Lh3/a;

    instance-of v7, v7, Lcom/k4/homeclock/HomeClockPresenter;

    if-eqz v7, :cond_35

    :cond_34
    move v4, v5

    .line 43
    :cond_35
    if-nez v6, :cond_3f

    if-nez v4, :cond_3f

    .line 44
    iget-object v0, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v0, v1, v2, v3}, Lcom/k4/homeclock/EngineState;->-$$Nest$mlogNothingToDo(Lcom/k4/homeclock/EngineState;IZZ)V

    .line 45
    return-void

    .line 47
    :cond_3f
    invoke-virtual {v0}, Lf3/a;->getWhich()I

    move-result v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "reload (which="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ", clock "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " -> "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "): rebuilding the engine"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "K4HomeClock"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 48
    invoke-virtual {v0}, Lf3/a;->stopSelf()V

    .line 49
    return-void
.end method
