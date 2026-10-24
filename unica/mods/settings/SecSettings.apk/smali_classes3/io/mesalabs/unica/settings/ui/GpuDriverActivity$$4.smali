.class public final synthetic Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$4;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# instance fields
.field public final synthetic f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

.field public final synthetic f$1:Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;


# direct methods
.method public synthetic constructor <init>(Lio/mesalabs/unica/settings/ui/GpuDriverActivity;Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;)V
    .registers 3

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$4;->f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

    iput-object p2, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$4;->f$1:Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/content/DialogInterface;I)V
    .registers 4

    .line 0
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$4;->f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$4;->f$1:Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;

    invoke-virtual {v0, p0, p1, p2}, Lio/mesalabs/unica/settings/ui/GpuDriverActivity;->lambda$confirmRemove$7$io-mesalabs-unica-settings-ui-GpuDriverActivity(Lio/mesalabs/unica/settings/ui/GpuDriverModel$Entry;Landroid/content/DialogInterface;I)V

    return-void
.end method
