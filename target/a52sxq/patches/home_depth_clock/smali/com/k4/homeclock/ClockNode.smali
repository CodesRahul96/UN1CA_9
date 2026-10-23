.class final Lcom/k4/homeclock/ClockNode;
.super Lcom/k4/homeclock/DepthClock;
.source "ClockNode.java"


# instance fields
.field private final accent:Z

.field private final baseline:F

.field private final centerX:F

.field private final fixedColor:Ljava/lang/Integer;

.field private final lightBackground:Z

.field private final paint:Landroid/graphics/Paint;


# direct methods
.method constructor <init>(Landroid/content/Context;IIFLandroid/graphics/Bitmap;Li3/c;Lh3/a;Z)V
    .registers 16

    .line 34
    const-string v3, "K4DepthClockNode"

    move-object v1, p0

    move-object v2, p1

    move-object v4, p6

    move-object v5, p7

    move v6, p8

    invoke-direct/range {v1 .. v6}, Lcom/k4/homeclock/DepthClock;-><init>(Landroid/content/Context;Ljava/lang/String;Li3/c;Lh3/a;Z)V

    .line 25
    new-instance p1, Landroid/graphics/Paint;

    const/16 p6, 0x81

    invoke-direct {p1, p6}, Landroid/graphics/Paint;-><init>(I)V

    iput-object p1, v1, Lcom/k4/homeclock/ClockNode;->paint:Landroid/graphics/Paint;

    .line 35
    iget-object p1, v1, Lcom/k4/homeclock/ClockNode;->paint:Landroid/graphics/Paint;

    sget-object p6, Landroid/graphics/Typeface;->DEFAULT:Landroid/graphics/Typeface;

    const/16 p7, 0x1f4

    const/4 p8, 0x0

    invoke-static {p6, p7, p8}, Landroid/graphics/Typeface;->create(Landroid/graphics/Typeface;IZ)Landroid/graphics/Typeface;

    move-result-object p6

    invoke-virtual {p1, p6}, Landroid/graphics/Paint;->setTypeface(Landroid/graphics/Typeface;)Landroid/graphics/Typeface;

    .line 36
    iget-object p1, v1, Lcom/k4/homeclock/ClockNode;->paint:Landroid/graphics/Paint;

    sget-object p6, Landroid/graphics/Paint$Align;->CENTER:Landroid/graphics/Paint$Align;

    invoke-virtual {p1, p6}, Landroid/graphics/Paint;->setTextAlign(Landroid/graphics/Paint$Align;)V

    .line 37
    iget-object p1, v1, Lcom/k4/homeclock/ClockNode;->paint:Landroid/graphics/Paint;

    const-string p6, "tnum"

    invoke-virtual {p1, p6}, Landroid/graphics/Paint;->setFontFeatureSettings(Ljava/lang/String;)V

    .line 38
    iget-object p1, v1, Lcom/k4/homeclock/ClockNode;->paint:Landroid/graphics/Paint;

    const/high16 p6, 0x42c80000    # 100.0f

    invoke-virtual {p1, p6}, Landroid/graphics/Paint;->setTextSize(F)V

    .line 39
    if-gt p2, p3, :cond_3c

    const p1, 0x3f570a3d    # 0.84f

    goto :goto_3f

    :cond_3c
    const p1, 0x3ed70a3d    # 0.42f

    :goto_3f
    int-to-float p2, p2

    mul-float/2addr p1, p2

    .line 40
    iget-object p7, v1, Lcom/k4/homeclock/ClockNode;->paint:Landroid/graphics/Paint;

    mul-float v0, p1, p6

    iget-object v2, v1, Lcom/k4/homeclock/ClockNode;->paint:Landroid/graphics/Paint;

    const-string v3, "00:00"

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->measureText(Ljava/lang/String;)F

    move-result v2

    div-float/2addr v0, v2

    invoke-virtual {p7, v0}, Landroid/graphics/Paint;->setTextSize(F)V

    .line 41
    new-instance p7, Landroid/graphics/Rect;

    invoke-direct {p7}, Landroid/graphics/Rect;-><init>()V

    .line 42
    iget-object v0, v1, Lcom/k4/homeclock/ClockNode;->paint:Landroid/graphics/Paint;

    const-string v2, "0123456789"

    const/16 v3, 0xa

    invoke-virtual {v0, v2, p8, v3, p7}, Landroid/graphics/Paint;->getTextBounds(Ljava/lang/String;IILandroid/graphics/Rect;)V

    .line 43
    iget p7, p7, Landroid/graphics/Rect;->top:I

    neg-int p7, p7

    int-to-float p7, p7

    .line 45
    const-string v0, "persist.sys.k4.home_depth_clock_y"

    invoke-static {v0}, Lcom/k4/homeclock/HomeDepthClock;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/k4/homeclock/ClockNode;->parse(Ljava/lang/String;)F

    move-result v0

    .line 46
    invoke-static {v0}, Ljava/lang/Float;->isNaN(F)Z

    move-result v2

    const/high16 v3, 0x40000000    # 2.0f

    if-nez v2, :cond_86

    .line 47
    int-to-float p3, p3

    mul-float/2addr v0, p3

    div-float/2addr v0, p6

    div-float p6, p7, v3

    add-float/2addr v0, p6

    invoke-static {p7, v0}, Ljava/lang/Math;->max(FF)F

    move-result p6

    invoke-static {p3, p6}, Ljava/lang/Math;->min(FF)F

    move-result p3

    iput p3, v1, Lcom/k4/homeclock/ClockNode;->baseline:F

    goto :goto_b1

    .line 49
    :cond_86
    const/4 p6, 0x0

    cmpl-float p6, p4, p6

    if-ltz p6, :cond_91

    const p6, 0x3eb33333    # 0.35f

    mul-float/2addr p6, p7

    add-float/2addr p6, p4

    goto :goto_99

    :cond_91
    const p6, 0x3e99999a    # 0.3f

    int-to-float v0, p3

    mul-float/2addr v0, p6

    div-float p6, p7, v3

    add-float/2addr p6, v0

    .line 50
    :goto_99
    int-to-float p3, p3

    const v0, 0x3dcccccd    # 0.1f

    mul-float/2addr v0, p3

    add-float/2addr v0, p7

    .line 51
    const v2, 0x3ee66666    # 0.45f

    mul-float/2addr p3, v2

    invoke-static {v0, p3}, Ljava/lang/Math;->max(FF)F

    move-result p3

    .line 52
    invoke-static {v0, p6}, Ljava/lang/Math;->max(FF)F

    move-result p6

    invoke-static {p3, p6}, Ljava/lang/Math;->min(FF)F

    move-result p3

    iput p3, v1, Lcom/k4/homeclock/ClockNode;->baseline:F

    .line 54
    :goto_b1
    div-float/2addr p2, v3

    iput p2, v1, Lcom/k4/homeclock/ClockNode;->centerX:F

    .line 56
    const-string p2, "persist.sys.k4.home_depth_clock_color"

    invoke-static {p2}, Lcom/k4/homeclock/HomeDepthClock;->prop(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    .line 57
    const/4 p3, -0x1

    invoke-static {p3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p3

    .line 58
    nop

    .line 59
    const-string p6, "accent"

    invoke-virtual {p6, p2}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    const/4 v2, 0x1

    if-eqz v0, :cond_cb

    .line 60
    move p2, v2

    goto :goto_df

    .line 61
    :cond_cb
    const-string v0, "#"

    invoke-virtual {p2, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_de

    .line 63
    :try_start_d3
    invoke-static {p2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p2

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p3
    :try_end_db
    .catch Ljava/lang/IllegalArgumentException; {:try_start_d3 .. :try_end_db} :catch_dd

    .line 65
    move p2, p8

    goto :goto_df

    .line 64
    :catch_dd
    move-exception v0

    .line 67
    :cond_de
    move p2, p8

    :goto_df
    iput-boolean p2, v1, Lcom/k4/homeclock/ClockNode;->accent:Z

    .line 68
    iput-object p3, v1, Lcom/k4/homeclock/ClockNode;->fixedColor:Ljava/lang/Integer;

    .line 69
    if-eqz p2, :cond_103

    if-eqz p5, :cond_103

    iget p2, v1, Lcom/k4/homeclock/ClockNode;->centerX:F

    div-float/2addr p1, v3

    sub-float/2addr p2, p1

    float-to-int p2, p2

    iget v0, v1, Lcom/k4/homeclock/ClockNode;->baseline:F

    sub-float/2addr v0, p7

    float-to-int v0, v0

    iget v3, v1, Lcom/k4/homeclock/ClockNode;->centerX:F

    add-float/2addr v3, p1

    float-to-int p1, v3

    iget v3, v1, Lcom/k4/homeclock/ClockNode;->baseline:F

    float-to-int v3, v3

    invoke-static {p5, p2, v0, p1, v3}, Lcom/k4/homeclock/ClockNode;->luminance(Landroid/graphics/Bitmap;IIII)F

    move-result p1

    const p2, 0x3f19999a    # 0.6f

    cmpl-float p1, p1, p2

    if-lez p1, :cond_103

    move p8, v2

    :cond_103
    iput-boolean p8, v1, Lcom/k4/homeclock/ClockNode;->lightBackground:Z

    .line 71
    iget-object p1, v1, Lcom/k4/homeclock/ClockNode;->paint:Landroid/graphics/Paint;

    invoke-virtual {p1}, Landroid/graphics/Paint;->getTextSize()F

    move-result p1

    iget p2, v1, Lcom/k4/homeclock/ClockNode;->baseline:F

    .line 72
    iget-boolean p5, v1, Lcom/k4/homeclock/ClockNode;->accent:Z

    if-eqz p5, :cond_112

    goto :goto_11a

    :cond_112
    invoke-virtual {p3}, Ljava/lang/Integer;->intValue()I

    move-result p3

    invoke-static {p3}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object p6

    .line 73
    :goto_11a
    if-eqz v6, :cond_11f

    const-string p3, ", gated"

    goto :goto_121

    :cond_11f
    const-string p3, ""

    :goto_121
    new-instance p5, Ljava/lang/StringBuilder;

    invoke-direct {p5}, Ljava/lang/StringBuilder;-><init>()V

    const-string p8, "layout: textSize="

    invoke-virtual {p5, p8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p5

    invoke-virtual {p5, p1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p5, ", digitH="

    invoke-virtual {p1, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p7}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p5, ", baseline="

    invoke-virtual {p1, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, " (subjectTop="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, "), color="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 71
    const-string p2, "K4HomeClock"

    invoke-static {p2, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 74
    return-void
.end method

.method private static parse(Ljava/lang/String;)F
    .registers 3

    .line 98
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    const/high16 v1, 0x7fc00000    # Float.NaN

    if-eqz v0, :cond_9

    .line 99
    return v1

    .line 102
    :cond_9
    :try_start_9
    invoke-static {p0}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result p0
    :try_end_d
    .catch Ljava/lang/NumberFormatException; {:try_start_9 .. :try_end_d} :catch_1a

    .line 103
    const/4 v0, 0x0

    cmpl-float v0, p0, v0

    if-ltz v0, :cond_19

    const/high16 v0, 0x42c80000    # 100.0f

    cmpg-float v0, p0, v0

    if-gtz v0, :cond_19

    move v1, p0

    :cond_19
    return v1

    .line 104
    :catch_1a
    move-exception p0

    .line 105
    return v1
.end method


# virtual methods
.method public a(Landroid/graphics/Canvas;)V
    .registers 8

    .line 78
    invoke-virtual {p0}, Lcom/k4/homeclock/ClockNode;->showing()Z

    move-result v0

    if-nez v0, :cond_b

    .line 79
    const-string p1, ""

    iput-object p1, p0, Lcom/k4/homeclock/ClockNode;->lastDrawn:Ljava/lang/String;

    .line 80
    return-void

    .line 82
    :cond_b
    invoke-virtual {p0}, Lcom/k4/homeclock/ClockNode;->text()Ljava/lang/String;

    move-result-object v0

    .line 83
    iget-boolean v1, p0, Lcom/k4/homeclock/ClockNode;->accent:Z

    if-eqz v1, :cond_25

    .line 84
    iget-object v1, p0, Lcom/k4/homeclock/ClockNode;->a:Landroid/content/Context;

    iget-boolean v2, p0, Lcom/k4/homeclock/ClockNode;->lightBackground:Z

    if-eqz v2, :cond_1d

    const v2, 0x1060041

    goto :goto_20

    :cond_1d
    const v2, 0x1060039

    :goto_20
    invoke-virtual {v1, v2}, Landroid/content/Context;->getColor(I)I

    move-result v1

    goto :goto_2b

    .line 85
    :cond_25
    iget-object v1, p0, Lcom/k4/homeclock/ClockNode;->fixedColor:Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    .line 86
    :goto_2b
    iget-object v2, p0, Lcom/k4/homeclock/ClockNode;->paint:Landroid/graphics/Paint;

    invoke-virtual {v2, v1}, Landroid/graphics/Paint;->setColor(I)V

    .line 87
    invoke-virtual {p0}, Lcom/k4/homeclock/ClockNode;->zoom()F

    move-result v1

    .line 88
    invoke-virtual {p1}, Landroid/graphics/Canvas;->save()I

    move-result v2

    .line 89
    const/high16 v3, 0x3f800000    # 1.0f

    cmpl-float v3, v1, v3

    if-eqz v3, :cond_4f

    .line 90
    invoke-virtual {p1}, Landroid/graphics/Canvas;->getWidth()I

    move-result v3

    int-to-float v3, v3

    const/high16 v4, 0x40000000    # 2.0f

    div-float/2addr v3, v4

    invoke-virtual {p1}, Landroid/graphics/Canvas;->getHeight()I

    move-result v5

    int-to-float v5, v5

    div-float/2addr v5, v4

    invoke-virtual {p1, v1, v1, v3, v5}, Landroid/graphics/Canvas;->scale(FFFF)V

    .line 92
    :cond_4f
    iget v1, p0, Lcom/k4/homeclock/ClockNode;->centerX:F

    iget v3, p0, Lcom/k4/homeclock/ClockNode;->baseline:F

    iget-object v4, p0, Lcom/k4/homeclock/ClockNode;->paint:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v1, v3, v4}, Landroid/graphics/Canvas;->drawText(Ljava/lang/String;FFLandroid/graphics/Paint;)V

    .line 93
    invoke-virtual {p1, v2}, Landroid/graphics/Canvas;->restoreToCount(I)V

    .line 94
    iput-object v0, p0, Lcom/k4/homeclock/ClockNode;->lastDrawn:Ljava/lang/String;

    .line 95
    return-void
.end method
