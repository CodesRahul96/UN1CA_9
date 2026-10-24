.class Lcom/k4/soundtrigger/K4StRetry$2;
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

    .line 272
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 7

    .line 275
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 276
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsLastRefusal()J

    move-result-wide v2

    sub-long v2, v0, v2

    const-wide/32 v4, 0xdbba0

    cmp-long v2, v2, v4

    if-lez v2, :cond_15

    const/4 v2, 0x0

    invoke-static {v2}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfputsBackoffStep(I)V

    .line 277
    :cond_15
    invoke-static {v0, v1}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfputsLastRefusal(J)V

    .line 278
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsHandler()Landroid/os/Handler;

    move-result-object v0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetBACKOFF_FIRE()Ljava/lang/Runnable;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/os/Handler;->hasCallbacks(Ljava/lang/Runnable;)Z

    move-result v0

    if-eqz v0, :cond_27

    return-void

    .line 279
    :cond_27
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetBACKOFF_MS()[J

    move-result-object v0

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsBackoffStep()I

    move-result v1

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetBACKOFF_MS()[J

    move-result-object v2

    array-length v2, v2

    add-int/lit8 v2, v2, -0x1

    invoke-static {v1, v2}, Ljava/lang/Math;->min(II)I

    move-result v1

    aget-wide v0, v0, v1

    .line 280
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsBackoffStep()I

    move-result v2

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetBACKOFF_MS()[J

    move-result-object v3

    array-length v3, v3

    add-int/lit8 v3, v3, -0x1

    if-ge v2, v3, :cond_52

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsBackoffStep()I

    move-result v2

    add-int/lit8 v2, v2, 0x1

    invoke-static {v2}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfputsBackoffStep(I)V

    .line 281
    :cond_52
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetsHandler()Landroid/os/Handler;

    move-result-object v2

    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$sfgetBACKOFF_FIRE()Ljava/lang/Runnable;

    move-result-object v3

    invoke-virtual {v2, v3, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 282
    const-wide/16 v2, 0x3e8

    div-long/2addr v0, v2

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "refused sound model: next timed load retry in "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " s"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "K4StRetry"

    invoke-static {v1, v0}, Landroid/util/Slog;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 283
    return-void
.end method
