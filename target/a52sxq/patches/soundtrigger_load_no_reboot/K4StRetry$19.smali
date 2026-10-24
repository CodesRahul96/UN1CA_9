.class Lcom/k4/soundtrigger/K4StRetry$19;
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

    .line 977
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 980
    const-wide/16 v0, 0x7d0

    const-string v2, "screen off"

    invoke-static {v0, v1, v2}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smschedule(JLjava/lang/String;)V

    .line 981
    return-void
.end method
