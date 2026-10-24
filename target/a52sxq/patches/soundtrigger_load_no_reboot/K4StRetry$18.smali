.class Lcom/k4/soundtrigger/K4StRetry$18;
.super Ljava/lang/Object;
.source "K4StRetry.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/k4/soundtrigger/K4StRetry;->syncSubscriptions()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 768
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 1

    .line 771
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smsyncSubscriptions()V

    .line 772
    return-void
.end method
