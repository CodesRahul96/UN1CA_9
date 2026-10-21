.class public Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;
.super Lcom/android/settings/core/BasePreferenceController;
.source "GpuDriverPreferenceController.java"

# interfaces
.implements Landroidx/preference/Preference$OnPreferenceChangeListener;


# static fields
.field private static final COLOR_PENDING:I

.field private static final KEY_ACTIVE:Ljava/lang/String; = "k4_gpu_driver_active"

.field private static final KEY_BANNER:Ljava/lang/String; = "k4_gpu_driver_restart"

.field private static final PROP_ACTIVE:Ljava/lang/String; = "sys.k4.gpu_active"

.field private static final PROP_DRIVERS:Ljava/lang/String; = "ro.k4.gpu_drivers"

.field private static final PROP_FAILED:Ljava/lang/String; = "persist.sys.k4.gpu_failed"

.field private static final PROP_SELECTED:Ljava/lang/String; = "persist.sys.k4.gpu_driver"

.field private static final PROP_TRIAL:Ljava/lang/String; = "persist.sys.k4.gpu_trial"


# instance fields
.field private mActive:Landroidx/preference/Preference;

.field private mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

.field private mPref:Landroidx/preference/DropDownPreference;

.field private mRebootDialog:Landroidx/appcompat/app/AlertDialog;


# direct methods
.method static constructor <clinit>()V
    .registers 3

    const/16 v0, 0x7c

    const/4 v1, 0x0

    const/16 v2, 0xf5

    .line 37
    invoke-static {v2, v0, v1}, Landroid/graphics/Color;->rgb(III)I

    move-result v0

    sput v0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->COLOR_PENDING:I

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 45
    invoke-direct {p0, p1, p2}, Lcom/android/settings/core/BasePreferenceController;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method private static active()Ljava/lang/String;
    .registers 2

    .line 156
    const-string v0, "sys.k4.gpu_active"

    const-string v1, ""

    invoke-static {v0, v1}, Landroid/os/SemSystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 157
    invoke-static {v0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->isKnown(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_f

    return-object v0

    :cond_f
    invoke-static {}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->defaultDriver()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static defaultDriver()Ljava/lang/String;
    .registers 2

    .line 141
    invoke-static {}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->drivers()[Ljava/lang/String;

    move-result-object v0

    .line 142
    array-length v1, v0

    if-lez v1, :cond_b

    const/4 v1, 0x0

    aget-object v0, v0, v1

    return-object v0

    :cond_b
    const-string v0, ""

    return-object v0
.end method

.method private static drivers()[Ljava/lang/String;
    .registers 2

    .line 136
    const-string v0, "ro.k4.gpu_drivers"

    const-string v1, ""

    invoke-static {v0, v1}, Landroid/os/SemSystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    .line 137
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_16

    const/4 v0, 0x0

    new-array v0, v0, [Ljava/lang/String;

    return-object v0

    :cond_16
    const-string v1, "\\s+"

    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static failed()Ljava/lang/String;
    .registers 3

    .line 161
    const-string v0, "persist.sys.k4.gpu_failed"

    const-string v1, ""

    invoke-static {v0, v1}, Landroid/os/SemSystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 162
    invoke-static {v0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->isKnown(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_f

    return-object v0

    :cond_f
    return-object v1
.end method

.method private static isKnown(Ljava/lang/String;)Z
    .registers 6

    .line 146
    invoke-static {}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->drivers()[Ljava/lang/String;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_7
    if-ge v3, v1, :cond_16

    aget-object v4, v0, v3

    invoke-virtual {v4, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_13

    const/4 p0, 0x1

    return p0

    :cond_13
    add-int/lit8 v3, v3, 0x1

    goto :goto_7

    :cond_16
    return v2
.end method

.method private label(Ljava/lang/String;)Ljava/lang/String;
    .registers 5

    .line 168
    const-string v0, "array"

    :try_start_2
    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mContext:Landroid/content/Context;

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    .line 169
    const-string v1, "k4_gpu_driver_values"

    invoke-static {v0, v1}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    invoke-virtual {p0, v1}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object v1

    .line 170
    const-string v2, "k4_gpu_driver_entries"

    invoke-static {v0, v2}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getStringArray(I)[Ljava/lang/String;

    move-result-object p0

    const/4 v0, 0x0

    .line 171
    :goto_1d
    array-length v2, v1

    if-ge v0, v2, :cond_31

    array-length v2, p0

    if-ge v0, v2, :cond_31

    .line 172
    aget-object v2, v1, v0

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2e

    aget-object p0, p0, v0
    :try_end_2d
    .catch Landroid/content/res/Resources$NotFoundException; {:try_start_2 .. :try_end_2d} :catch_31

    return-object p0

    :cond_2e
    add-int/lit8 v0, v0, 0x1

    goto :goto_1d

    .line 176
    :catch_31
    :cond_31
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "V@0"

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private onBannerButton()V
    .registers 3

    .line 88
    invoke-static {}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->failed()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_2a

    invoke-static {}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->selected()Ljava/lang/String;

    move-result-object v0

    invoke-static {}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->active()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2a

    .line 90
    const-string v0, "persist.sys.k4.gpu_failed"

    const-string v1, ""

    invoke-static {v0, v1}, Landroid/os/SemSystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 91
    const-string v0, "persist.sys.k4.gpu_trial"

    const-string v1, "ok"

    invoke-static {v0, v1}, Landroid/os/SemSystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 92
    invoke-direct {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->refresh()V

    return-void

    .line 95
    :cond_2a
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mRebootDialog:Landroidx/appcompat/app/AlertDialog;

    if-nez v0, :cond_36

    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mContext:Landroid/content/Context;

    invoke-static {v0}, Lio/mesalabs/unica/utils/Utils;->createRebootDialog(Landroid/content/Context;)Landroidx/appcompat/app/AlertDialog;

    move-result-object v0

    iput-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mRebootDialog:Landroidx/appcompat/app/AlertDialog;

    .line 96
    :cond_36
    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mRebootDialog:Landroidx/appcompat/app/AlertDialog;

    invoke-virtual {p0}, Landroidx/appcompat/app/AlertDialog;->show()V

    return-void
.end method

.method private refresh()V
    .registers 8

    .line 100
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mPref:Landroidx/preference/DropDownPreference;

    if-eqz v0, :cond_f1

    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->getAvailabilityStatus()I

    move-result v0

    if-eqz v0, :cond_c

    goto/16 :goto_f1

    .line 101
    :cond_c
    invoke-static {}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->selected()Ljava/lang/String;

    move-result-object v0

    .line 102
    invoke-static {}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->active()Ljava/lang/String;

    move-result-object v1

    .line 103
    invoke-static {}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->failed()Ljava/lang/String;

    move-result-object v2

    .line 104
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    .line 106
    iget-object v4, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mPref:Landroidx/preference/DropDownPreference;

    invoke-virtual {v4, v0}, Landroidx/preference/DropDownPreference;->setValue(Ljava/lang/String;)V

    .line 111
    iget-object v4, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mPref:Landroidx/preference/DropDownPreference;

    if-nez v3, :cond_3e

    .line 108
    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->label(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    filled-new-array {v5}, [Ljava/lang/Object;

    move-result-object v5

    const-string v6, "k4_gpu_driver_selected_pending"

    invoke-direct {p0, v6, v5}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->string(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Landroidx/preference/DropDownPreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 109
    iget-object v4, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mPref:Landroidx/preference/DropDownPreference;

    sget v5, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->COLOR_PENDING:I

    invoke-virtual {v4, v5}, Landroidx/preference/DropDownPreference;->seslSetSummaryColor(I)V

    goto :goto_4f

    .line 111
    :cond_3e
    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->label(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    filled-new-array {v5}, [Ljava/lang/Object;

    move-result-object v5

    const-string v6, "k4_gpu_driver_selected_active"

    invoke-direct {p0, v6, v5}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->string(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Landroidx/preference/DropDownPreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 113
    :goto_4f
    iget-object v4, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mActive:Landroidx/preference/Preference;

    if-eqz v4, :cond_5a

    invoke-direct {p0, v1}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->label(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Landroidx/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 115
    :cond_5a
    iget-object v4, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    if-nez v4, :cond_60

    goto/16 :goto_f1

    :cond_60
    const/4 v5, 0x1

    const/4 v6, 0x0

    if-nez v3, :cond_a5

    .line 117
    const-string v2, "k4_gpu_driver_restart_title"

    new-array v3, v6, [Ljava/lang/Object;

    invoke-direct {p0, v2, v3}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->string(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v4, v2}, Lcom/android/settingslib/widget/BannerMessagePreference;->setTitle(Ljava/lang/CharSequence;)V

    .line 118
    iget-object v2, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    invoke-direct {p0, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->label(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v1}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->label(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    filled-new-array {v0, v1}, [Ljava/lang/Object;

    move-result-object v0

    const-string v1, "k4_gpu_driver_restart_summary"

    invoke-direct {p0, v1, v0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->string(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Lcom/android/settingslib/widget/BannerMessagePreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 119
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    sget-object v1, Lcom/android/settingslib/widget/BannerMessagePreference$AttentionLevel;->HIGH:Lcom/android/settingslib/widget/BannerMessagePreference$AttentionLevel;

    invoke-virtual {v0, v1}, Lcom/android/settingslib/widget/BannerMessagePreference;->setAttentionLevel(Lcom/android/settingslib/widget/BannerMessagePreference$AttentionLevel;)V

    .line 120
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    const-string v1, "k4_gpu_driver_restart_button"

    new-array v2, v6, [Ljava/lang/Object;

    invoke-direct {p0, v1, v2}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->string(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/settingslib/widget/BannerMessagePreference;->setPositiveButtonText(Ljava/lang/CharSequence;)V

    .line 121
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    invoke-virtual {v0, v5}, Lcom/android/settingslib/widget/BannerMessagePreference;->setPositiveButtonVisible(Z)V

    .line 122
    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    invoke-virtual {p0, v5}, Lcom/android/settingslib/widget/BannerMessagePreference;->setVisible(Z)V

    return-void

    .line 123
    :cond_a5
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    .line 131
    iget-object v3, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    if-nez v0, :cond_ee

    .line 124
    const-string v0, "k4_gpu_driver_failed_title"

    new-array v4, v6, [Ljava/lang/Object;

    invoke-direct {p0, v0, v4}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->string(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Lcom/android/settingslib/widget/BannerMessagePreference;->setTitle(Ljava/lang/CharSequence;)V

    .line 125
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    invoke-direct {p0, v2}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->label(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v1}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->label(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    filled-new-array {v2, v1}, [Ljava/lang/Object;

    move-result-object v1

    const-string v2, "k4_gpu_driver_failed_summary"

    invoke-direct {p0, v2, v1}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->string(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/settingslib/widget/BannerMessagePreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 126
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    sget-object v1, Lcom/android/settingslib/widget/BannerMessagePreference$AttentionLevel;->MEDIUM:Lcom/android/settingslib/widget/BannerMessagePreference$AttentionLevel;

    invoke-virtual {v0, v1}, Lcom/android/settingslib/widget/BannerMessagePreference;->setAttentionLevel(Lcom/android/settingslib/widget/BannerMessagePreference$AttentionLevel;)V

    .line 127
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    const-string v1, "k4_gpu_driver_failed_button"

    new-array v2, v6, [Ljava/lang/Object;

    invoke-direct {p0, v1, v2}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->string(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Lcom/android/settingslib/widget/BannerMessagePreference;->setPositiveButtonText(Ljava/lang/CharSequence;)V

    .line 128
    iget-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    invoke-virtual {v0, v5}, Lcom/android/settingslib/widget/BannerMessagePreference;->setPositiveButtonVisible(Z)V

    .line 129
    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    invoke-virtual {p0, v5}, Lcom/android/settingslib/widget/BannerMessagePreference;->setVisible(Z)V

    return-void

    .line 131
    :cond_ee
    invoke-virtual {v3, v6}, Lcom/android/settingslib/widget/BannerMessagePreference;->setVisible(Z)V

    :cond_f1
    :goto_f1
    return-void
.end method

.method private static selected()Ljava/lang/String;
    .registers 2

    .line 151
    const-string v0, "persist.sys.k4.gpu_driver"

    const-string v1, ""

    invoke-static {v0, v1}, Landroid/os/SemSystemProperties;->get(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 152
    invoke-static {v0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->isKnown(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_f

    return-object v0

    :cond_f
    invoke-static {}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->defaultDriver()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private varargs string(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;
    .registers 4

    .line 180
    iget-object p0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mContext:Landroid/content/Context;

    const-string v0, "string"

    invoke-static {v0, p1}, Lio/mesalabs/unica/utils/Utils;->getResourceId(Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    invoke-virtual {p0, p1, p2}, Landroid/content/Context;->getString(I[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method


# virtual methods
.method public displayPreference(Landroidx/preference/PreferenceScreen;)V
    .registers 4

    .line 55
    invoke-super {p0, p1}, Lcom/android/settings/core/BasePreferenceController;->displayPreference(Landroidx/preference/PreferenceScreen;)V

    .line 56
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->getPreferenceKey()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroidx/preference/PreferenceScreen;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object v0

    check-cast v0, Landroidx/preference/DropDownPreference;

    iput-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mPref:Landroidx/preference/DropDownPreference;

    .line 57
    const-string v0, "k4_gpu_driver_active"

    invoke-virtual {p1, v0}, Landroidx/preference/PreferenceScreen;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mActive:Landroidx/preference/Preference;

    .line 58
    const-string v0, "k4_gpu_driver_restart"

    invoke-virtual {p1, v0}, Landroidx/preference/PreferenceScreen;->findPreference(Ljava/lang/CharSequence;)Landroidx/preference/Preference;

    move-result-object p1

    check-cast p1, Lcom/android/settingslib/widget/BannerMessagePreference;

    iput-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    .line 59
    iget-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mPref:Landroidx/preference/DropDownPreference;

    if-eqz p1, :cond_28

    invoke-virtual {p1, p0}, Landroidx/preference/DropDownPreference;->setOnPreferenceChangeListener(Landroidx/preference/Preference$OnPreferenceChangeListener;)V

    .line 60
    :cond_28
    iget-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    const/4 v0, 0x0

    if-eqz p1, :cond_3a

    .line 61
    invoke-virtual {p1, v0}, Lcom/android/settingslib/widget/BannerMessagePreference;->setNegativeButtonVisible(Z)V

    .line 62
    iget-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    new-instance v1, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController$$0;

    invoke-direct {v1, p0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController$$0;-><init>(Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;)V

    invoke-virtual {p1, v1}, Lcom/android/settingslib/widget/BannerMessagePreference;->setPositiveButtonOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 64
    :cond_3a
    invoke-virtual {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->getAvailabilityStatus()I

    move-result p1

    if-nez p1, :cond_42

    const/4 p1, 0x1

    goto :goto_43

    :cond_42
    move p1, v0

    .line 65
    :goto_43
    iget-object v1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mActive:Landroidx/preference/Preference;

    if-eqz v1, :cond_4a

    invoke-virtual {v1, p1}, Landroidx/preference/Preference;->setVisible(Z)V

    .line 66
    :cond_4a
    iget-object p1, p0, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->mBanner:Lcom/android/settingslib/widget/BannerMessagePreference;

    if-eqz p1, :cond_51

    invoke-virtual {p1, v0}, Lcom/android/settingslib/widget/BannerMessagePreference;->setVisible(Z)V

    .line 67
    :cond_51
    invoke-direct {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->refresh()V

    return-void
.end method

.method public getAvailabilityStatus()I
    .registers 2

    .line 50
    invoke-static {}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->drivers()[Ljava/lang/String;

    move-result-object p0

    array-length p0, p0

    const/4 v0, 0x1

    if-le p0, v0, :cond_a

    const/4 p0, 0x0

    return p0

    :cond_a
    const/4 p0, 0x3

    return p0
.end method

.method synthetic lambda$displayPreference$0$io-mesalabs-unica-settings-ui-GpuDriverPreferenceController(Landroid/view/View;)V
    .registers 2

    .line 62
    invoke-direct {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->onBannerButton()V

    return-void
.end method

.method public onPreferenceChange(Landroidx/preference/Preference;Ljava/lang/Object;)Z
    .registers 3

    .line 78
    invoke-static {p2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    .line 79
    invoke-static {p1}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->isKnown(Ljava/lang/String;)Z

    move-result p2

    if-nez p2, :cond_c

    const/4 p0, 0x0

    return p0

    .line 80
    :cond_c
    const-string p2, "persist.sys.k4.gpu_driver"

    invoke-static {p2, p1}, Landroid/os/SemSystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 81
    invoke-static {}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->active()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1e

    const-string p1, "ok"

    goto :goto_20

    :cond_1e
    const-string p1, "pending"

    :goto_20
    const-string p2, "persist.sys.k4.gpu_trial"

    invoke-static {p2, p1}, Landroid/os/SemSystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 82
    const-string p1, "persist.sys.k4.gpu_failed"

    const-string p2, ""

    invoke-static {p1, p2}, Landroid/os/SemSystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    .line 83
    invoke-direct {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->refresh()V

    const/4 p0, 0x1

    return p0
.end method

.method public updateState(Landroidx/preference/Preference;)V
    .registers 2

    .line 72
    invoke-super {p0, p1}, Lcom/android/settings/core/BasePreferenceController;->updateState(Landroidx/preference/Preference;)V

    .line 73
    invoke-direct {p0}, Lio/mesalabs/unica/settings/ui/GpuDriverPreferenceController;->refresh()V

    return-void
.end method
