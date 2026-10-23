.class final Lcom/k4/soundtrigger/K4StRetry$Hung;
.super Ljava/lang/Object;
.source "K4StRetry.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/k4/soundtrigger/K4StRetry;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Hung"
.end annotation


# instance fields
.field deferred:Z

.field final hal:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

.field final since:J

.field final where:Ljava/lang/Exception;


# direct methods
.method constructor <init>(Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;Ljava/lang/Exception;J)V
    .registers 5

    .line 114
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 115
    iput-object p1, p0, Lcom/k4/soundtrigger/K4StRetry$Hung;->hal:Lcom/android/server/soundtrigger_middleware/SoundTriggerHalWatchdog;

    .line 116
    iput-object p2, p0, Lcom/k4/soundtrigger/K4StRetry$Hung;->where:Ljava/lang/Exception;

    .line 117
    iput-wide p3, p0, Lcom/k4/soundtrigger/K4StRetry$Hung;->since:J

    .line 118
    return-void
.end method
