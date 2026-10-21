SKIPUNZIP=1

# See module.prop. Same two files and public.libraries entries as the stock A52s system.
TARGET_LIB64="$FW_DIR/$TARGET_FIRMWARE_PATH/system/system/lib64"
PUBLIC_LIBS="$WORK_DIR/system/system/etc/public.libraries-camera.samsung.txt"
[ -f "$PUBLIC_LIBS" ] || ABORT "camera_food_libs: ${PUBLIC_LIBS//$WORK_DIR/} not found"
for f in libFoodDetector.camera.samsung.so libFood.camera.samsung.so; do
    [ -f "$TARGET_LIB64/$f" ] || ABORT "camera_food_libs: target firmware has no system/lib64/$f"
    ADD_TO_WORK_DIR "$FW_DIR/$TARGET_FIRMWARE_PATH" "system" "system/lib64/$f" 0 0 644 "u:object_r:system_lib_file:s0"
    grep -q "^$f$" "$PUBLIC_LIBS" || echo "$f" >> "$PUBLIC_LIBS"
done
grep -q "^libOpenCv.camera.samsung.so$" "$PUBLIC_LIBS" || ABORT "camera_food_libs: libOpenCv.camera.samsung.so is not a public camera library"
LOG "- Camera Food mode: A52s libFoodDetector/libFood added (SecSaliencyFoodNode)"
unset TARGET_LIB64 PUBLIC_LIBS f
