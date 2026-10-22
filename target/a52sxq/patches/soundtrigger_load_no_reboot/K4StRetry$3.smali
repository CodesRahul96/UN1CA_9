.class Lcom/k4/soundtrigger/K4StRetry$3;
.super Landroid/media/AudioManager$AudioPlaybackCallback;
.source "K4StRetry.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/k4/soundtrigger/K4StRetry;->registerListeners()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 109
    invoke-direct {p0}, Landroid/media/AudioManager$AudioPlaybackCallback;-><init>()V

    return-void
.end method


# virtual methods
.method public onPlaybackConfigChanged(Ljava/util/List;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/media/AudioPlaybackConfiguration;",
            ">;)V"
        }
    .end annotation

    .line 112
    invoke-static {p1}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smanyActive(Ljava/util/List;)Z

    move-result p0

    .line 113
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsAudioActive()Z

    move-result p1

    if-ne p0, p1, :cond_b

    goto :goto_27

    .line 114
    :cond_b
    invoke-static {p0}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfputsAudioActive(Z)V

    .line 115
    const-string p1, "audio stopped"

    if-eqz p0, :cond_28

    .line 116
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsReason()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_27

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsHandler()Landroid/os/Handler;

    move-result-object p0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetFIRE()Ljava/lang/Runnable;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    :cond_27
    :goto_27
    return-void

    :cond_28
    const-wide/16 v0, 0x1388

    .line 118
    invoke-static {v0, v1, p1}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smschedule(JLjava/lang/String;)V

    return-void
.end method
