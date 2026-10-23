.class Lcom/k4/soundtrigger/K4StRetry$10;
.super Landroid/content/BroadcastReceiver;
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

    .line 516
    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 4

    .line 519
    const-wide/16 p1, 0x7d0

    const-string v0, "screen off"

    invoke-static {p1, p2, v0}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smschedule(JLjava/lang/String;)V

    .line 520
    return-void
.end method
