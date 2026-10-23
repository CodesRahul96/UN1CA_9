.class Lcom/k4/devicecare/K4RestrictList$1;
.super Ljava/lang/Object;
.source "K4RestrictList.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/k4/devicecare/K4RestrictList;->enter(Led/z;Landroid/content/Context;Ljava/util/List;IZLjava/lang/String;)Ljava/util/List;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$c:Landroid/content/Context;

.field final synthetic val$copy:Ljava/util/List;

.field final synthetic val$on:Z

.field final synthetic val$reason:Ljava/lang/String;

.field final synthetic val$type:I

.field final synthetic val$ui:Landroid/os/Handler;

.field final synthetic val$z:Led/z;


# direct methods
.method constructor <init>(Ljava/util/List;Landroid/content/Context;IZLandroid/os/Handler;Led/z;Ljava/lang/String;)V
    .registers 8
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 77
    iput-object p1, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$copy:Ljava/util/List;

    iput-object p2, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$c:Landroid/content/Context;

    iput p3, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$type:I

    iput-boolean p4, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$on:Z

    iput-object p5, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$ui:Landroid/os/Handler;

    iput-object p6, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$z:Led/z;

    iput-object p7, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$reason:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 13

    .line 80
    iget-object v1, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$copy:Ljava/util/List;

    .line 82
    :try_start_2
    iget-object v0, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$c:Landroid/content/Context;

    iget-object v2, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$copy:Ljava/util/List;

    iget v3, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$type:I

    iget-boolean v4, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$on:Z

    invoke-static {v0, v2, v3, v4}, Lcom/k4/devicecare/K4RestrictList;->prepare(Landroid/content/Context;Ljava/util/List;IZ)Ljava/util/List;

    move-result-object v1
    :try_end_e
    .catchall {:try_start_2 .. :try_end_e} :catchall_10

    .line 85
    move-object v8, v1

    goto :goto_19

    .line 83
    :catchall_10
    move-exception v0

    .line 84
    const-string v2, "K4RestrictList"

    const-string v3, "prepare"

    invoke-static {v2, v3, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    move-object v8, v1

    .line 86
    :goto_19
    nop

    .line 87
    iget-object v0, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$ui:Landroid/os/Handler;

    new-instance v4, Lcom/k4/devicecare/K4RestrictList$1$1;

    iget-object v6, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$z:Led/z;

    iget-object v7, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$c:Landroid/content/Context;

    iget v9, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$type:I

    iget-boolean v10, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$on:Z

    iget-object v11, p0, Lcom/k4/devicecare/K4RestrictList$1;->val$reason:Ljava/lang/String;

    move-object v5, p0

    invoke-direct/range {v4 .. v11}, Lcom/k4/devicecare/K4RestrictList$1$1;-><init>(Lcom/k4/devicecare/K4RestrictList$1;Led/z;Landroid/content/Context;Ljava/util/List;IZLjava/lang/String;)V

    invoke-virtual {v0, v4}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 100
    return-void
.end method
