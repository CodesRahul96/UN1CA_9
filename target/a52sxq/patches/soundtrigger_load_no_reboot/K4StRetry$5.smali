.class Lcom/k4/soundtrigger/K4StRetry$5;
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

    .line 189
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 192
    const-wide/16 v0, 0xfa0

    invoke-static {v0, v1}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smhold(J)V

    .line 193
    return-void
.end method
