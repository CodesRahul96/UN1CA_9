.class final Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;
.super Ljava/lang/Object;
.source "GpuDriverPackage.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lio/mesalabs/unica/settings/ui/GpuDriverPackage;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Result"
.end annotation


# instance fields
.field detail:Ljava/lang/String;

.field error:Ljava/lang/String;

.field version:Ljava/lang/String;


# direct methods
.method constructor <init>()V
    .registers 2

    .line 45
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 47
    const-string v0, ""

    iput-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Result;->detail:Ljava/lang/String;

    return-void
.end method
