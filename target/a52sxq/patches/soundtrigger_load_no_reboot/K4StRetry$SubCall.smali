.class final Lcom/k4/soundtrigger/K4StRetry$SubCall;
.super Landroid/telephony/TelephonyCallback;
.source "K4StRetry.java"

# interfaces
.implements Landroid/telephony/TelephonyCallback$CallStateListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/k4/soundtrigger/K4StRetry;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "SubCall"
.end annotation


# instance fields
.field state:I

.field final subId:I

.field final tm:Landroid/telephony/TelephonyManager;


# direct methods
.method constructor <init>(ILandroid/telephony/TelephonyManager;)V
    .registers 4

    .line 237
    invoke-direct {p0}, Landroid/telephony/TelephonyCallback;-><init>()V

    .line 235
    const/4 v0, -0x1

    iput v0, p0, Lcom/k4/soundtrigger/K4StRetry$SubCall;->state:I

    .line 238
    iput p1, p0, Lcom/k4/soundtrigger/K4StRetry$SubCall;->subId:I

    .line 239
    iput-object p2, p0, Lcom/k4/soundtrigger/K4StRetry$SubCall;->tm:Landroid/telephony/TelephonyManager;

    .line 240
    return-void
.end method


# virtual methods
.method public onCallStateChanged(I)V
    .registers 2

    .line 244
    iput p1, p0, Lcom/k4/soundtrigger/K4StRetry$SubCall;->state:I

    .line 245
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smupdateTelephony()V

    .line 246
    return-void
.end method
