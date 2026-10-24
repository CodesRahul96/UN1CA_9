.class public final synthetic Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$1;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# instance fields
.field public final synthetic f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

.field public final synthetic f$1:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Lio/mesalabs/unica/settings/ui/GpuDriverActivity;Ljava/lang/String;)V
    .registers 3

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$1;->f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

    iput-object p2, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$1;->f$1:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/content/DialogInterface;I)V
    .registers 4

    .line 0
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$1;->f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$1;->f$1:Ljava/lang/String;

    invoke-virtual {v0, p0, p1, p2}, Lio/mesalabs/unica/settings/ui/GpuDriverActivity;->lambda$showResult$2$io-mesalabs-unica-settings-ui-GpuDriverActivity(Ljava/lang/String;Landroid/content/DialogInterface;I)V

    return-void
.end method
