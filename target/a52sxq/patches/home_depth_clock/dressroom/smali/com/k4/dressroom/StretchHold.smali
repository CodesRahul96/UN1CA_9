.class final Lcom/k4/dressroom/StretchHold;
.super Ljava/lang/Object;
.source "StretchHold.java"


# static fields
.field static final RATIO_EPS:F = 0.003f

.field static final SCALE_EPS:F = 0.002f


# instance fields
.field private mBRatio:Ljava/lang/Float;

.field private mGravity:I

.field private mHRatio:Ljava/lang/Float;

.field private mHeights:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/Float;",
            ">;"
        }
    .end annotation
.end field

.field private mScale:F

.field released:Ljava/lang/String;


# direct methods
.method constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static floats(Ljava/util/List;)Ljava/util/List;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "*>;)",
            "Ljava/util/List<",
            "Ljava/lang/Float;",
            ">;"
        }
    .end annotation

    const/4 v0, 0x0

    if-eqz p0, :cond_5

    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    goto :goto_2

    :cond_0
    new-instance v1, Ljava/util/ArrayList;

    invoke-interface {p0}, Ljava/util/List;->size()I

    move-result v2

    invoke-direct {v1, v2}, Ljava/util/ArrayList;-><init>(I)V

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_0
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_4

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    instance-of v3, v2, Ljava/lang/Number;

    if-nez v3, :cond_1

    return-object v0

    :cond_1
    check-cast v2, Ljava/lang/Number;

    invoke-virtual {v2}, Ljava/lang/Number;->floatValue()F

    move-result v2

    invoke-static {v2}, Ljava/lang/Float;->isNaN(F)Z

    move-result v3

    if-nez v3, :cond_3

    const/4 v3, 0x0

    cmpg-float v3, v2, v3

    if-gtz v3, :cond_2

    goto :goto_1

    :cond_2
    invoke-static {v2}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_0

    :cond_3
    :goto_1
    return-object v0

    :cond_4
    return-object v1

    :cond_5
    :goto_2
    return-object v0
.end method


# virtual methods
.method apply(Ljava/util/List;IFFF)Ljava/util/List;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "*>;IFFF)",
            "Ljava/util/List<",
            "*>;"
        }
    .end annotation

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/k4/dressroom/StretchHold;->released:Ljava/lang/String;

    iget-object v1, p0, Lcom/k4/dressroom/StretchHold;->mHeights:Ljava/util/List;

    if-nez v1, :cond_0

    return-object p1

    :cond_0
    iget v1, p0, Lcom/k4/dressroom/StretchHold;->mGravity:I

    const-string v2, ")"

    const-string v3, " -> "

    if-eq p2, v1, :cond_1

    new-instance p3, Ljava/lang/StringBuilder;

    const-string p4, "moved (gravity "

    invoke-direct {p3, p4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    goto/16 :goto_0

    :cond_1
    iget p2, p0, Lcom/k4/dressroom/StretchHold;->mScale:F

    sub-float p2, p3, p2

    invoke-static {p2}, Ljava/lang/Math;->abs(F)F

    move-result p2

    const v1, 0x3b03126f    # 0.002f

    cmpl-float p2, p2, v1

    if-lez p2, :cond_2

    iget p2, p0, Lcom/k4/dressroom/StretchHold;->mScale:F

    new-instance p4, Ljava/lang/StringBuilder;

    const-string p5, "resized (scale "

    invoke-direct {p4, p5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p4, p2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p3}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    goto/16 :goto_0

    :cond_2
    iget-object p2, p0, Lcom/k4/dressroom/StretchHold;->mHRatio:Ljava/lang/Float;

    const p3, 0x3b449ba6    # 0.003f

    if-eqz p2, :cond_3

    invoke-virtual {p2}, Ljava/lang/Float;->floatValue()F

    move-result p2

    sub-float p2, p4, p2

    invoke-static {p2}, Ljava/lang/Math;->abs(F)F

    move-result p2

    cmpl-float p2, p2, p3

    if-lez p2, :cond_3

    iget-object p2, p0, Lcom/k4/dressroom/StretchHold;->mHRatio:Ljava/lang/Float;

    new-instance p3, Ljava/lang/StringBuilder;

    const-string p5, "moved (horizontal margin "

    invoke-direct {p3, p5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p4}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    goto :goto_0

    :cond_3
    iget-object p2, p0, Lcom/k4/dressroom/StretchHold;->mBRatio:Ljava/lang/Float;

    if-eqz p2, :cond_4

    invoke-virtual {p2}, Ljava/lang/Float;->floatValue()F

    move-result p2

    sub-float p2, p5, p2

    invoke-static {p2}, Ljava/lang/Math;->abs(F)F

    move-result p2

    cmpl-float p2, p2, p3

    if-lez p2, :cond_4

    iget-object p2, p0, Lcom/k4/dressroom/StretchHold;->mBRatio:Ljava/lang/Float;

    new-instance p3, Ljava/lang/StringBuilder;

    const-string p4, "moved (bottom margin "

    invoke-direct {p3, p4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p5}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    goto :goto_0

    :cond_4
    if-eqz p1, :cond_5

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p2

    iget-object p3, p0, Lcom/k4/dressroom/StretchHold;->mHeights:Ljava/util/List;

    invoke-interface {p3}, Ljava/util/List;->size()I

    move-result p3

    if-eq p2, p3, :cond_5

    iget-object p2, p0, Lcom/k4/dressroom/StretchHold;->mHeights:Ljava/util/List;

    invoke-interface {p2}, Ljava/util/List;->size()I

    move-result p2

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p3

    new-instance p4, Ljava/lang/StringBuilder;

    const-string p5, "other digits ("

    invoke-direct {p4, p5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p4, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4, p3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p2, " heights)"

    invoke-virtual {p4, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    goto :goto_0

    :cond_5
    move-object p2, v0

    :goto_0
    if-eqz p2, :cond_6

    iput-object v0, p0, Lcom/k4/dressroom/StretchHold;->mHeights:Ljava/util/List;

    iput-object p2, p0, Lcom/k4/dressroom/StretchHold;->released:Ljava/lang/String;

    return-object p1

    :cond_6
    new-instance p1, Ljava/util/ArrayList;

    iget-object p0, p0, Lcom/k4/dressroom/StretchHold;->mHeights:Ljava/util/List;

    invoke-direct {p1, p0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    return-object p1
.end method

.method heights()Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/Float;",
            ">;"
        }
    .end annotation

    iget-object v0, p0, Lcom/k4/dressroom/StretchHold;->mHeights:Ljava/util/List;

    if-nez v0, :cond_0

    const/4 p0, 0x0

    return-object p0

    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    iget-object p0, p0, Lcom/k4/dressroom/StretchHold;->mHeights:Ljava/util/List;

    invoke-direct {v0, p0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    return-object v0
.end method

.method held()Z
    .locals 0

    iget-object p0, p0, Lcom/k4/dressroom/StretchHold;->mHeights:Ljava/util/List;

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method hold(Ljava/util/List;IFLjava/lang/Float;Ljava/lang/Float;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "*>;IF",
            "Ljava/lang/Float;",
            "Ljava/lang/Float;",
            ")V"
        }
    .end annotation

    invoke-static {p1}, Lcom/k4/dressroom/StretchHold;->floats(Ljava/util/List;)Ljava/util/List;

    move-result-object p1

    iput-object p1, p0, Lcom/k4/dressroom/StretchHold;->mHeights:Ljava/util/List;

    iput p2, p0, Lcom/k4/dressroom/StretchHold;->mGravity:I

    iput p3, p0, Lcom/k4/dressroom/StretchHold;->mScale:F

    iput-object p4, p0, Lcom/k4/dressroom/StretchHold;->mHRatio:Ljava/lang/Float;

    iput-object p5, p0, Lcom/k4/dressroom/StretchHold;->mBRatio:Ljava/lang/Float;

    const/4 p1, 0x0

    iput-object p1, p0, Lcom/k4/dressroom/StretchHold;->released:Ljava/lang/String;

    return-void
.end method

.method release()V
    .locals 1

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/k4/dressroom/StretchHold;->mHeights:Ljava/util/List;

    return-void
.end method
