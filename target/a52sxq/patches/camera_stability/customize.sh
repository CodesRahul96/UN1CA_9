# See module.prop. Nothing is patched at this stage: device patches run BEFORE unica/patches (scripts/make_rom.sh),
# and the camera these fixes are for (the r9qxxx SamsungCamera 16.0.00.74 "hal3_mass" prebuilt) is only copied over
# the source firmware's camera and decoded by unica/patches/camera. Decoding /system/priv-app/SamsungCamera here would
# decode the S26U camera, and unica/patches/camera's DECODE_APK would then reuse that stale decode dir. apply.sh does
# the work from target/a52sxq/post_mods.sh (unica/mods/zz_target), after every unica patch and mod, before the APK build.
# This step only fails early, before the long ROM patch stage, if the prebuilt the fixes expect is gone.
if $TARGET_CAMERA_SUPPORT_MASS_APP_FLAVOR && ! $SOURCE_CAMERA_SUPPORT_MASS_APP_FLAVOR; then
    [ -f "$SRC_DIR/prebuilts/samsung/r9qxxx/system/priv-app/SamsungCamera/SamsungCamera.apk.00" ] || \
        ABORT "camera_stability: prebuilts/samsung/r9qxxx SamsungCamera not found"
else
    LOG "- camera_stability: this build does not use the hal3_mass camera, nothing to patch"
fi
