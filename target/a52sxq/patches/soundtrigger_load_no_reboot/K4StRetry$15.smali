.class Lcom/k4/soundtrigger/K4StRetry$15;
.super Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;
.source "K4StRetry.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/k4/soundtrigger/K4StRetry;->registerTelephony(Landroid/content/Context;)Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 674
    invoke-direct {p0}, Landroid/telephony/SubscriptionManager$OnSubscriptionsChangedListener;-><init>()V

    return-void
.end method


# virtual methods
.method public onSubscriptionsChanged()V
    .registers 1

    .line 677
    invoke-static {}, Lcom/k4/soundtrigger/K4StRetry;->-$$Nest$smsyncSubscriptions()V

    .line 678
    return-void
.end method
