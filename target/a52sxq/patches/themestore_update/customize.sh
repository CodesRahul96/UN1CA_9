# See module.prop. ThemeStore_6.0.14.4.apk provenance (fetched 2026-10-24 for SM-S948B, mcc 248, csc SEB, sdkVer 37):
# vas.samsungapps.com/stub/stubUpdateCheck.as -> productId 000009169935, versionCode 601404100; uk-odc.samsungapps.com/ods.as
# (request 2303) -> downLoadURI aka-dn.gw.samsungapps.com/astore_bin/atom/2026/0826/prePost_20260826072858673.apk.
# APK signature v2+v3, signer CN=SamsungApps (cert sha256 fba3af4e7757d9016e953fb3ee4671ca2bd9af725f9a53d52ed4a38eaaa08901),
# the same signer as the S26 Ultra system copy. A later forced upgrade works from the app's own [Update] button (Galaxy Store).
THEMESTORE="system/priv-app/ThemeStore/ThemeStore.apk"
THEMESTORE_APK="$SRC_DIR/prebuilts/samsung_store_apps/ThemeStore_6.0.14.4.apk"
THEMESTORE_SHA="4e2cd64dd6ed09fe3b85da38215e2dbabacbe3d23d573ac8b22238b2ea0b156f"
# S26 Ultra S948BXXS4BZIG ThemeStore 6.0.13.2: a base with any other ThemeStore needs a new look at the store's minimum
THEMESTORE_BASE_SHA="c8b34c08caa0dc4af2c36291970f3522afd44627705ec82a752edd0e23385a89"
[ -f "$THEMESTORE_APK" ] || ABORT "themestore_update: $THEMESTORE_APK not found"
[ "$(sha256sum "$THEMESTORE_APK" | cut -d " " -f 1)" = "$THEMESTORE_SHA" ] || ABORT "themestore_update: sha256 mismatch for $THEMESTORE_APK"
[ -f "$WORK_DIR/system/$THEMESTORE" ] || ABORT "themestore_update: no $THEMESTORE in this base"
THEMESTORE_CUR_SHA="$(sha256sum "$WORK_DIR/system/$THEMESTORE" | cut -d " " -f 1)"
if [ "$THEMESTORE_CUR_SHA" = "$THEMESTORE_SHA" ]; then
    LOG "- Galaxy Themes is already 6.0.14.4"
else
    [ "$THEMESTORE_CUR_SHA" = "$THEMESTORE_BASE_SHA" ] \
        || ABORT "themestore_update: $THEMESTORE is not the S26 Ultra 6.0.13.2 build (sha256 $THEMESTORE_CUR_SHA)"
    EVAL "cp -f \"$THEMESTORE_APK\" \"$WORK_DIR/system/$THEMESTORE\""
    LOG "- Galaxy Themes 6.0.13.2 -> 6.0.14.4 (the store forces this update)"
fi
unset THEMESTORE THEMESTORE_APK THEMESTORE_SHA THEMESTORE_BASE_SHA THEMESTORE_CUR_SHA
