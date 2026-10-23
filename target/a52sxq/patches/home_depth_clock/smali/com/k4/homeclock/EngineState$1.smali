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

    .line 38
    iput-object p1, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 41
    iget-object v0, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/k4/homeclock/EngineState;->-$$Nest$fputreloadPending(Lcom/k4/homeclock/EngineState;Z)V

    .line 42
    iget-object v0, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v0}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetengine(Lcom/k4/homeclock/EngineState;)Ljava/lang/ref/WeakReference;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lf3/a;

    .line 43
    if-nez v0, :cond_15

    .line 44
    return-void

    .line 47
    :cond_15
    :try_start_15
    iget-object v1, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v1, v0}, Lcom/k4/homeclock/EngineState;->-$$Nest$mcheck(Lcom/k4/homeclock/EngineState;Lf3/a;)V
    :try_end_1a
    .catchall {:try_start_15 .. :try_end_1a} :catchall_1b

    .line 50
    goto :goto_23

    .line 48
    :catchall_1b
    move-exception v0

    .line 49
    const-string v1, "K4HomeClock"

    const-string v2, "reload"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 51
    :goto_23
    return-void
.end method
