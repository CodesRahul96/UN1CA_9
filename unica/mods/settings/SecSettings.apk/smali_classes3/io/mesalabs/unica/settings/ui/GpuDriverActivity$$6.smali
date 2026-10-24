.class public final synthetic Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$6;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# instance fields
.field public final synthetic f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

.field public final synthetic f$1:Ljava/util/List;


# direct methods
.method public synthetic constructor <init>(Lio/mesalabs/unica/settings/ui/GpuDriverActivity;Ljava/util/List;)V
    .registers 3

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$6;->f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

    iput-object p2, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$6;->f$1:Ljava/util/List;

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/content/DialogInterface;I)V
    .registers 4

    .line 0
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$6;->f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$6;->f$1:Ljava/util/List;

    invoke-virtual {v0, p0, p1, p2}, Lio/mesalabs/unica/settings/ui/GpuDriverActivity;->lambda$showRemoveList$4$io-mesalabs-unica-settings-ui-GpuDriverActivity(Ljava/util/List;Landroid/content/DialogInterface;I)V

    return-void
.end method
