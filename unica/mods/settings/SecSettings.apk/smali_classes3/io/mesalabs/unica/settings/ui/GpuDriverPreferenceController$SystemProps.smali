.class final Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController$SystemProps;
.super Ljava/lang/Object;
.source "GpuDriverPreferenceController.java"

# interfaces
.implements Lio/mesalabs/unica/settings/ui/GpuDriverModel$Props;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "SystemProps"
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 45
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public get(Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    .line 48
    const-string p0, ""

    invoke-static {p1, p0}, Landroid/os/SemSystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public set(Ljava/lang/String;Ljava/lang/String;)V
    .registers 3

    .line 53
    invoke-static {p1, p2}, Landroid/os/SemSystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method
