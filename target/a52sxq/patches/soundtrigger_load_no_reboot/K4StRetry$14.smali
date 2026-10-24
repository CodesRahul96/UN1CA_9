.class Lcom/k4/soundtrigger/K4StRetry$14;
.super Landroid/media/AudioManager$AudioPlaybackCallback;
.source "K4StRetry.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/k4/soundtrigger/K4StRetry;->registerState()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 633
    invoke-direct {p0}, Landroid/media/AudioManager$AudioPlaybackCallback;-><init>()V

    return-void
.end method


# virtual methods
.method public onPlaybackConfigChanged(Ljava/util/List;)V
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroid/media/AudioPlaybackConfiguration;",
            ">;)V"
        }
    .end annotation

    .line 636
    invoke-static {p1}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smonPlayback(Ljava/util/List;)V

    .line 637
    return-void
.end method
