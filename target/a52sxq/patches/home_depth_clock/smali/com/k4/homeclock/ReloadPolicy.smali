.class final Lcom/k4/homeclock/ReloadPolicy;
.super Ljava/lang/Object;
.source "ReloadPolicy.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/k4/homeclock/ReloadPolicy$Action;
    }
.end annotation


# static fields
.field private static final NULL:Ljava/lang/String; = "\u0000"

.field private static final SEP:C = '\u001f'

.field static final WALLPAPER_WAIT_MS:J = 0x1770L


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 25
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static checkDelay(Z)J
    .registers 3

    .line 60
    if-eqz p0, :cond_5

    const-wide/16 v0, 0x1770

    goto :goto_7

    :cond_5
    const-wide/16 v0, 0x12c

    :goto_7
    return-wide v0
.end method

.method static decide(ZZLjava/lang/String;Ljava/lang/String;)Lcom/k4/homeclock/ReloadPolicy$Action;
    .registers 4

    .line 44
    if-nez p0, :cond_7

    if-nez p1, :cond_7

    .line 45
    sget-object p0, Lcom/k4/homeclock/ReloadPolicy$Action;->NONE:Lcom/k4/homeclock/ReloadPolicy$Action;

    return-object p0

    .line 47
    :cond_7
    if-eq p0, p1, :cond_c

    .line 48
    sget-object p0, Lcom/k4/homeclock/ReloadPolicy$Action;->REBUILD:Lcom/k4/homeclock/ReloadPolicy$Action;

    return-object p0

    .line 50
    :cond_c
    if-eqz p2, :cond_19

    if-eqz p3, :cond_19

    invoke-virtual {p2, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_19

    sget-object p0, Lcom/k4/homeclock/ReloadPolicy$Action;->KEEP:Lcom/k4/homeclock/ReloadPolicy$Action;

    goto :goto_1b

    :cond_19
    sget-object p0, Lcom/k4/homeclock/ReloadPolicy$Action;->REBUILD:Lcom/k4/homeclock/ReloadPolicy$Action;

    :goto_1b
    return-object p0
.end method

.method static varargs fingerprint([Ljava/lang/String;)Ljava/lang/String;
    .registers 4

    .line 29
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 30
    const/4 v1, 0x0

    :goto_6
    array-length v2, p0

    if-ge v1, v2, :cond_1f

    .line 31
    if-lez v1, :cond_10

    .line 32
    const/16 v2, 0x1f

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 34
    :cond_10
    aget-object v2, p0, v1

    if-nez v2, :cond_17

    const-string v2, "\u0000"

    goto :goto_19

    :cond_17
    aget-object v2, p0, v1

    :goto_19
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 30
    add-int/lit8 v1, v1, 0x1

    goto :goto_6

    .line 36
    :cond_1f
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
