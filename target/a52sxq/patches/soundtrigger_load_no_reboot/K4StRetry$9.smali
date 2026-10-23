.class Lcom/k4/soundtrigger/K4StRetry$9;
.super Landroid/media/AudioManager$AudioPlaybackCallback;
.source "K4StRetry.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/k4/soundtrigger/K4StRetry;->registerRetryListeners()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 482
    invoke-direct {p0}, Landroid/media/AudioManager$AudioPlaybackCallback;-><init>()V

    return-void
.end method


# virtual methods
.method public onPlaybackConfigChanged(Ljava/util/List;)V
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/media/AudioPlaybackConfiguration;",
            ">;)V"
        }
    .end annotation

    .line 485
    invoke-static {p1}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smanyActive(Ljava/util/List;)Z

    move-result p1

    .line 486
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsAudioActive()Z

    move-result v0

    if-ne p1, v0, :cond_b

    return-void

    .line 487
    :cond_b
    invoke-static {p1}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfputsAudioActive(Z)V

    .line 488
    const-string v0, "audio stopped"

    if-eqz p1, :cond_28

    .line 489
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsReason()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_2d

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsHandler()Landroid/os/Handler;

    move-result-object p1

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetFIRE()Ljava/lang/Runnable;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    goto :goto_2d

    .line 491
    :cond_28
    const-wide/16 v1, 0x1388

    invoke-static {v1, v2, v0}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smschedule(JLjava/lang/String;)V

    .line 493
    :cond_2d
    :goto_2d
    return-void
.end method
