.class public final synthetic Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$0;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

.field public final synthetic f$1:Landroid/net/Uri;


# direct methods
.method public synthetic constructor <init>(Lio/mesalabs/unica/settings/ui/GpuDriverActivity;Landroid/net/Uri;)V
    .registers 3

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$0;->f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

    iput-object p2, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$0;->f$1:Landroid/net/Uri;

    return-void
.end method


# virtual methods
.method public final run()V
    .registers 2

    .line 0
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$0;->f$0:Lio/mesalabs/unica/settings/ui/GpuDriverActivity;

    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverActivity$$0;->f$1:Landroid/net/Uri;

    invoke-virtual {v0, p0}, Lio/mesalabs/unica/settings/ui/GpuDriverActivity;->lambda$onActivityResult$1$io-mesalabs-unica-settings-ui-GpuDriverActivity(Landroid/net/Uri;)V

    return-void
.end method
