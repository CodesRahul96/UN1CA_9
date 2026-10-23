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

    .line 222
    invoke-direct {p0}, Landroid/telephony/TelephonyCallback;-><init>()V

    .line 220
    const/4 v0, -0x1

    iput v0, p0, Lcom/k4/soundtrigger/K4StRetry$SubCall;->state:I

    .line 223
    iput p1, p0, Lcom/k4/soundtrigger/K4StRetry$SubCall;->subId:I

    .line 224
    iput-object p2, p0, Lcom/k4/soundtrigger/K4StRetry$SubCall;->tm:Landroid/telephony/TelephonyManager;

    .line 225
    return-void
.end method


# virtual methods
.method public onCallStateChanged(I)V
    .registers 2

    .line 229
    iput p1, p0, Lcom/k4/soundtrigger/K4StRetry$SubCall;->state:I

    .line 230
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smupdateTelephony()V

    .line 231
    return-void
.end method
