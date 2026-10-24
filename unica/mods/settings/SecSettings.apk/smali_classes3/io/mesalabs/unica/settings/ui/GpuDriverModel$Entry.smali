.class final Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;
.super Ljava/lang/Object;
.source "GpuDriverModel.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lio/mesalabs/unica/settings/ui/GpuDriverModel;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Entry"
.end annotation


# instance fields
.field final external:Z

.field final id:Ljava/lang/String;

.field final kind:I

.field final label:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;ILjava/lang/String;Z)V
    .registers 5

    .line 53
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 54
    iput-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->id:Ljava/lang/String;

    .line 55
    iput p2, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->kind:I

    .line 56
    iput-object p3, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->label:Ljava/lang/String;

    .line 57
    iput-boolean p4, p0, Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;->external:Z

    return-void
.end method
