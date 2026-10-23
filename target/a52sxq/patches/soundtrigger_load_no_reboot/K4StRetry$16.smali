.class Lcom/k4/soundtrigger/K4StRetry$16;
.super Ljava/lang/Object;
.source "K4StRetry.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/k4/soundtrigger/K4StRetry;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 904
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 907
    const-string v0, "audio stopped"

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsReason()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_17

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsHandler()Landroid/os/Handler;

    move-result-object v0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetFIRE()Ljava/lang/Runnable;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 908
    :cond_17
    return-void
.end method
