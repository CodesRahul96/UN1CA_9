.class Lcom/k4/soundtrigger/K4StRetry$12;
.super Ljava/lang/Object;
.source "K4StRetry.java"

# interfaces
.implements Landroid/media/AudioManager$OnModeChangedListener;


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

    .line 613
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onModeChanged(I)V
    .registers 2

    .line 616
    invoke-static {p1}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smonMode(I)V

    .line 617
    return-void
.end method
