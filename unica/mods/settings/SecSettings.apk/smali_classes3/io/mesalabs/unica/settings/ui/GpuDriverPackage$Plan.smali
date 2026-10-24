.class final Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;
.super Ljava/lang/Object;
.source "GpuDriverPackage.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lio/mesalabs/unica/settings/ui/GpuDriverPackage;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Plan"
.end annotation


# instance fields
.field detail:Ljava/lang/String;

.field error:Ljava/lang/String;

.field final files:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>()V
    .registers 2

    .line 38
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 40
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->files:Ljava/util/Map;

    .line 42
    const-string v0, ""

    iput-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPackage$Plan;->detail:Ljava/lang/String;

    return-void
.end method
