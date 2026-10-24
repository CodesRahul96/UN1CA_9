.class final enum Lcom/k4/homeclock/ReloadPolicy$Action;
.super Ljava/lang/Enum;
.source "ReloadPolicy.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/k4/homeclock/ReloadPolicy;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4018
    name = "Action"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/k4/homeclock/ReloadPolicy$Action;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/k4/homeclock/ReloadPolicy$Action;

.field public static final enum KEEP:Lcom/k4/homeclock/ReloadPolicy$Action;

.field public static final enum NONE:Lcom/k4/homeclock/ReloadPolicy$Action;

.field public static final enum REBUILD:Lcom/k4/homeclock/ReloadPolicy$Action;


# direct methods
.method private static synthetic $values()[Lcom/k4/homeclock/ReloadPolicy$Action;
    .registers 3

    .line 13
    sget-object v0, Lcom/k4/homeclock/ReloadPolicy$Action;->NONE:Lcom/k4/homeclock/ReloadPolicy$Action;

    sget-object v1, Lcom/k4/homeclock/ReloadPolicy$Action;->KEEP:Lcom/k4/homeclock/ReloadPolicy$Action;

    sget-object v2, Lcom/k4/homeclock/ReloadPolicy$Action;->REBUILD:Lcom/k4/homeclock/ReloadPolicy$Action;

    filled-new-array {v0, v1, v2}, [Lcom/k4/homeclock/ReloadPolicy$Action;

    move-result-object v0

    return-object v0
.end method

.method static constructor <clinit>()V
    .registers 3

    .line 15
    new-instance v0, Lcom/k4/homeclock/ReloadPolicy$Action;

    const-string v1, "NONE"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/k4/homeclock/ReloadPolicy$Action;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/k4/homeclock/ReloadPolicy$Action;->NONE:Lcom/k4/homeclock/ReloadPolicy$Action;

    .line 17
    new-instance v0, Lcom/k4/homeclock/ReloadPolicy$Action;

    const-string v1, "KEEP"

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Lcom/k4/homeclock/ReloadPolicy$Action;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/k4/homeclock/ReloadPolicy$Action;->KEEP:Lcom/k4/homeclock/ReloadPolicy$Action;

    .line 19
    new-instance v0, Lcom/k4/homeclock/ReloadPolicy$Action;

    const-string v1, "REBUILD"

    const/4 v2, 0x2

    invoke-direct {v0, v1, v2}, Lcom/k4/homeclock/ReloadPolicy$Action;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/k4/homeclock/ReloadPolicy$Action;->REBUILD:Lcom/k4/homeclock/ReloadPolicy$Action;

    .line 13
    invoke-static {}, Lcom/k4/homeclock/ReloadPolicy$Action;->$values()[Lcom/k4/homeclock/ReloadPolicy$Action;

    move-result-object v0

    sput-object v0, Lcom/k4/homeclock/ReloadPolicy$Action;->$VALUES:[Lcom/k4/homeclock/ReloadPolicy$Action;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .registers 3
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x1000,
            0x1000
        }
        names = {
            null,
            null
        }
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 13
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/k4/homeclock/ReloadPolicy$Action;
    .registers 2
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8000
        }
        names = {
            null
        }
    .end annotation

    .line 13
    const-class v0, Lcom/k4/homeclock/ReloadPolicy$Action;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/k4/homeclock/ReloadPolicy$Action;

    return-object p0
.end method

.method public static values()[Lcom/k4/homeclock/ReloadPolicy$Action;
    .registers 1

    .line 13
    sget-object v0, Lcom/k4/homeclock/ReloadPolicy$Action;->$VALUES:[Lcom/k4/homeclock/ReloadPolicy$Action;

    invoke-virtual {v0}, [Lcom/k4/homeclock/ReloadPolicy$Action;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/k4/homeclock/ReloadPolicy$Action;

    return-object v0
.end method
