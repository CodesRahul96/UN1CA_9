.class public final synthetic Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$7;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/content/DialogInterface$OnDismissListener;


# instance fields
.field public final synthetic f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;


# direct methods
.method public synthetic constructor <init>(Lio/mesalabs/unica/settings/ui/GpuDriverActivity;)V
    .registers 2

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$7;->f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

    return-void
.end method


# virtual methods
.method public final onDismiss(Landroid/content/DialogInterface;)V
    .registers 2

    .line 0
    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$7;->f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

    invoke-virtual {p0, p1}, Lio/mesalabs/unica/settings/ui/GpuDriverActivity;->lambda$showRemoveList$5$io-mesalabs-unica-settings-ui-GpuDriverActivity(Landroid/content/DialogInterface;)V

    return-void
.end method
