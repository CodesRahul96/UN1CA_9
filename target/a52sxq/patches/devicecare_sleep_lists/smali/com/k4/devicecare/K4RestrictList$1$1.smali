.class Lcom/k4/devicecare/K4RestrictList$1$1;
.super Ljava/lang/Object;
.source "K4RestrictList.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/k4/devicecare/K4RestrictList$1;->run()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/k4/devicecare/K4RestrictList$1;

.field final synthetic val$c:Landroid/content/Context;

.field final synthetic val$on:Z

.field final synthetic val$out:Ljava/util/List;

.field final synthetic val$reason:Ljava/lang/String;

.field final synthetic val$type:I

.field final synthetic val$z:Led/z;


# direct methods
.method constructor <init>(Lcom/k4/devicecare/K4RestrictList$1;Led/z;Landroid/content/Context;Ljava/util/List;IZLjava/lang/String;)V
    .registers 8
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010,
            0x1010,
            0x1010,
            0x1010,
            0x1010,
            0x1010,
            0x1010
        }
        names = {
            null,
            null,
            null,
            null,
            null,
            null,
            null
        }
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 87
    iput-object p2, p0, Lcom/k4/devicecare/K4RestrictList$1$1;->val$z:Led/z;

    iput-object p3, p0, Lcom/k4/devicecare/K4RestrictList$1$1;->val$c:Landroid/content/Context;

    iput-object p4, p0, Lcom/k4/devicecare/K4RestrictList$1$1;->val$out:Ljava/util/List;

    iput p5, p0, Lcom/k4/devicecare/K4RestrictList$1$1;->val$type:I

    iput-boolean p6, p0, Lcom/k4/devicecare/K4RestrictList$1$1;->val$on:Z

    iput-object p7, p0, Lcom/k4/devicecare/K4RestrictList$1$1;->val$reason:Ljava/lang/String;

    iput-object p1, p0, Lcom/k4/devicecare/K4RestrictList$1$1;->this$0:Lcom/k4/devicecare/K4RestrictList$1;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 9

    .line 90
    const/4 v0, 0x1

    invoke-static {v0}, Lcom/k4/devicecare/K4RestrictList;->-$$Nest$sfputsReplay(Z)V

    .line 92
    const/4 v1, 0x0

    :try_start_5
    iget-object v2, p0, Lcom/k4/devicecare/K4RestrictList$1$1;->val$z:Led/z;

    iget-object v3, p0, Lcom/k4/devicecare/K4RestrictList$1$1;->val$c:Landroid/content/Context;

    iget-object v4, p0, Lcom/k4/devicecare/K4RestrictList$1$1;->val$out:Ljava/util/List;

    iget v5, p0, Lcom/k4/devicecare/K4RestrictList$1$1;->val$type:I

    iget-boolean v6, p0, Lcom/k4/devicecare/K4RestrictList$1$1;->val$on:Z

    iget-object v7, p0, Lcom/k4/devicecare/K4RestrictList$1$1;->val$reason:Ljava/lang/String;

    invoke-virtual/range {v2 .. v7}, Led/z;->c(Landroid/content/Context;Ljava/util/List;IZLjava/lang/String;)V
    :try_end_14
    .catchall {:try_start_5 .. :try_end_14} :catchall_15

    goto :goto_1d

    .line 93
    :catchall_15
    move-exception v0

    .line 94
    :try_start_16
    const-string v2, "K4RestrictList"

    const-string v3, "restrict"

    invoke-static {v2, v3, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_1d
    .catchall {:try_start_16 .. :try_end_1d} :catchall_22

    .line 96
    :goto_1d
    invoke-static {v1}, Lcom/k4/devicecare/K4RestrictList;->-$$Nest$sfputsReplay(Z)V

    .line 97
    nop

    .line 98
    return-void

    .line 96
    :catchall_22
    move-exception v0

    invoke-static {v1}, Lcom/k4/devicecare/K4RestrictList;->-$$Nest$sfputsReplay(Z)V

    .line 97
    throw v0
.end method
