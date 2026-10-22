.class Lcom/k4/dressroom/SavedFrame$1;
.super Ljava/lang/Object;
.source "SavedFrame.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/k4/dressroom/SavedFrame;->apply(Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$bg:Landroid/view/View;


# direct methods
.method constructor <init>(Landroid/view/View;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    iput-object p1, p0, Lcom/k4/dressroom/SavedFrame$1;->val$bg:Landroid/view/View;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    const/4 v0, 0x0

    invoke-static {v0}, Lcom/k4/dressroom/SavedFrame;->-$$Nest$sfputsPosted(Z)V

    invoke-static {}, Lcom/k4/dressroom/SavedFrame;->-$$Nest$sfgetsDone()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-static {}, Lcom/k4/dressroom/SavedFrame;->-$$Nest$sfgetsRec()Lorg/json/JSONObject;

    move-result-object v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/k4/dressroom/SavedFrame$1;->val$bg:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->isAttachedToWindow()Z

    move-result v0

    if-eqz v0, :cond_1

    sget-boolean v0, Lcom/k4/dressroom/EditXf;->sFrameLayout:Z

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    :try_start_0
    iget-object p0, p0, Lcom/k4/dressroom/SavedFrame$1;->val$bg:Landroid/view/View;

    invoke-static {}, Lcom/k4/dressroom/SavedFrame;->-$$Nest$sfgetsRec()Lorg/json/JSONObject;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/k4/dressroom/SavedFrame;->restore(Landroid/view/View;Lorg/json/JSONObject;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-void

    :catchall_0
    move-exception p0

    const-string v0, "K4HomeClock"

    const-string v1, "saved frame edit: restore"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    const-string p0, "restore failed"

    invoke-static {p0}, Lcom/k4/dressroom/SavedFrame;->done(Ljava/lang/String;)V

    :cond_1
    :goto_0
    return-void
.end method
