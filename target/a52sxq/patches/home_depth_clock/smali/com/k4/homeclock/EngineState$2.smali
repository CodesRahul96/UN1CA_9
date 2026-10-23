.class Lcom/k4/homeclock/EngineState$2;
.super Landroid/content/BroadcastReceiver;
.source "EngineState.java"


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

    .line 100
    iput-object p1, p0, Lcom/k4/homeclock/EngineState$2;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 6

    .line 103
    iget-object p1, p0, Lcom/k4/homeclock/EngineState$2;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {p1}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetmain(Lcom/k4/homeclock/EngineState;)Landroid/os/Handler;

    move-result-object p1

    iget-object v0, p0, Lcom/k4/homeclock/EngineState$2;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v0}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetreload(Lcom/k4/homeclock/EngineState;)Ljava/lang/Runnable;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 104
    const-string p1, "com.k4.homeclock.extra.WALLPAPER_PENDING"

    const/4 v0, 0x0

    invoke-virtual {p2, p1, v0}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result p1

    .line 105
    iget-object p2, p0, Lcom/k4/homeclock/EngineState$2;->this$0:Lcom/k4/homeclock/EngineState;

    const/4 v0, 0x1

    invoke-static {p2, v0}, Lcom/k4/homeclock/EngineState;->-$$Nest$fputreloadPending(Lcom/k4/homeclock/EngineState;Z)V

    .line 106
    if-eqz p1, :cond_50

    .line 107
    iget-object p2, p0, Lcom/k4/homeclock/EngineState$2;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {p2}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetengine(Lcom/k4/homeclock/EngineState;)Ljava/lang/ref/WeakReference;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Lf3/a;

    .line 108
    if-nez p2, :cond_2e

    const/4 p2, -0x1

    goto :goto_32

    :cond_2e
    invoke-virtual {p2}, Lf3/a;->getWhich()I

    move-result p2

    :goto_32
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "reload from the editor (which="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v0, "): checked when shown, or in 6000 ms"

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    const-string v0, "K4HomeClock"

    invoke-static {v0, p2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 111
    :cond_50
    iget-object p2, p0, Lcom/k4/homeclock/EngineState$2;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {p2}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetmain(Lcom/k4/homeclock/EngineState;)Landroid/os/Handler;

    move-result-object p2

    iget-object v0, p0, Lcom/k4/homeclock/EngineState$2;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v0}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetreload(Lcom/k4/homeclock/EngineState;)Ljava/lang/Runnable;

    move-result-object v0

    invoke-static {p1}, Lcom/k4/homeclock/ReloadPolicy;->checkDelay(Z)J

    move-result-wide v1

    invoke-virtual {p2, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 112
    return-void
.end method
