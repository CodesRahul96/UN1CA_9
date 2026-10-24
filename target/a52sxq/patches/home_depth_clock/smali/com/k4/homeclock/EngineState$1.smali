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

    .line 48
    iput-object p1, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 10

    .line 51
    const-string v0, "K4HomeClock"

    iget-object v1, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v1}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetengine(Lcom/k4/homeclock/EngineState;)Ljava/lang/ref/WeakReference;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lf3/a;

    .line 52
    const/4 v2, 0x0

    if-nez v1, :cond_17

    .line 53
    iget-object v0, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v0, v2}, Lcom/k4/homeclock/EngineState;->-$$Nest$fputreloadPending(Lcom/k4/homeclock/EngineState;Z)V

    .line 54
    return-void

    .line 57
    :cond_17
    :try_start_17
    invoke-virtual {v1}, Lf3/a;->getWhich()I

    move-result v3

    .line 58
    iget-object v4, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v4}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgeteditorPending(Lcom/k4/homeclock/EngineState;)Z

    move-result v4

    if-eqz v4, :cond_df

    and-int/lit8 v4, v3, 0x1

    if-eqz v4, :cond_df

    .line 59
    invoke-virtual {v1}, Lf3/a;->getDisplayState()LB2/a;

    move-result-object v4

    .line 60
    instance-of v5, v4, Ljava/lang/Enum;

    const/4 v6, 0x1

    if-eqz v5, :cond_41

    const-string v5, "ON"

    move-object v7, v4

    check-cast v7, Ljava/lang/Enum;

    invoke-virtual {v7}, Ljava/lang/Enum;->name()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v5, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_41

    move v5, v6

    goto :goto_42

    :cond_41
    move v5, v2

    .line 61
    :goto_42
    and-int/lit8 v7, v3, 0x2

    if-eqz v7, :cond_51

    invoke-static {v1}, Lcom/k4/homeclock/HomeDepthClock;->clockOf(Lf3/a;)Lcom/k4/homeclock/DepthClock;

    move-result-object v7

    if-eqz v7, :cond_51

    sget-boolean v7, Lcom/k4/homeclock/KeyguardWatch;->locked:Z

    if-eqz v7, :cond_51

    goto :goto_52

    :cond_51
    move v6, v2

    .line 65
    :goto_52
    iget-object v7, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v7}, Lcom/k4/homeclock/EngineState;->-$$Nest$minteractive(Lcom/k4/homeclock/EngineState;)Z

    move-result v7

    .line 66
    iget-object v8, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v8}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetvisible(Lcom/k4/homeclock/EngineState;)Z

    move-result v8

    if-eqz v8, :cond_66

    if-eqz v5, :cond_66

    if-eqz v7, :cond_66

    if-eqz v6, :cond_df

    .line 67
    :cond_66
    iget-object v1, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v1}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetdeferrals(Lcom/k4/homeclock/EngineState;)I

    move-result v5

    add-int/lit8 v8, v5, 0x1

    invoke-static {v1, v8}, Lcom/k4/homeclock/EngineState;->-$$Nest$fputdeferrals(Lcom/k4/homeclock/EngineState;I)V

    if-nez v5, :cond_c1

    .line 68
    iget-object v1, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v1}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetvisible(Lcom/k4/homeclock/EngineState;)Z

    move-result v1

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "reload from the editor (which="

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v5, "): not on screen (visible="

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, ", display="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, ", interactive="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, ", keyguard="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, "), checked once it is"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 72
    :cond_c1
    iget-object v1, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v1}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetvisible(Lcom/k4/homeclock/EngineState;)Z

    move-result v1

    if-eqz v1, :cond_de

    iget-object v1, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v1}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetdeferrals(Lcom/k4/homeclock/EngineState;)I

    move-result v1

    const/16 v3, 0xa

    if-gt v1, v3, :cond_de

    .line 73
    iget-object v1, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v1}, Lcom/k4/homeclock/EngineState;->-$$Nest$fgetmain(Lcom/k4/homeclock/EngineState;)Landroid/os/Handler;

    move-result-object v1

    const-wide/16 v3, 0x1770

    invoke-virtual {v1, p0, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 75
    :cond_de
    return-void

    .line 78
    :cond_df
    iget-object v3, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v3, v2}, Lcom/k4/homeclock/EngineState;->-$$Nest$fputreloadPending(Lcom/k4/homeclock/EngineState;Z)V

    .line 79
    iget-object v3, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v3, v2}, Lcom/k4/homeclock/EngineState;->-$$Nest$fputeditorPending(Lcom/k4/homeclock/EngineState;Z)V

    .line 80
    iget-object v3, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v3, v2}, Lcom/k4/homeclock/EngineState;->-$$Nest$fputdeferrals(Lcom/k4/homeclock/EngineState;I)V

    .line 81
    iget-object v3, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v3, v1}, Lcom/k4/homeclock/EngineState;->-$$Nest$mcheck(Lcom/k4/homeclock/EngineState;Lf3/a;)V
    :try_end_f3
    .catchall {:try_start_17 .. :try_end_f3} :catchall_f4

    .line 86
    goto :goto_104

    .line 82
    :catchall_f4
    move-exception v1

    .line 83
    iget-object v3, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v3, v2}, Lcom/k4/homeclock/EngineState;->-$$Nest$fputreloadPending(Lcom/k4/homeclock/EngineState;Z)V

    .line 84
    iget-object v3, p0, Lcom/k4/homeclock/EngineState$1;->this$0:Lcom/k4/homeclock/EngineState;

    invoke-static {v3, v2}, Lcom/k4/homeclock/EngineState;->-$$Nest$fputeditorPending(Lcom/k4/homeclock/EngineState;Z)V

    .line 85
    const-string v2, "reload"

    invoke-static {v0, v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 87
    :goto_104
    return-void
.end method
