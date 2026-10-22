SKIPUNZIP=1

# Sources that ship the engine themselves (S25: lib64 + public.libraries-arcsoft.txt entries) keep their own copy,
# which matches their DressRoom/deepsky SDK; only sources without it (Fold8) get the S22 one.
SOURCE_LIB64="$FW_DIR/$SOURCE_FIRMWARE_PATH/system/system/lib64"
if [ -f "$SOURCE_LIB64/libobjectcapture.arcsoft.so" ] && [ -f "$SOURCE_LIB64/libobjectcapture_jni.arcsoft.so" ]; then
    LOG "- Source already ships the ArcSoft object capture libraries, skipping"
# Libraries come from the S22 (SM-S901E) system image, compressed F2FS: extract with ~/s22_arcsoft_extract.sh
elif [ ! -f "$MODPATH/system/system/lib64/libobjectcapture.arcsoft.so" ] || \
        [ ! -f "$MODPATH/system/system/lib64/libobjectcapture_jni.arcsoft.so" ]; then
    LOG "- ArcSoft object capture libraries not present, skipping"
else
    # pinned: byte-identical to the SM-S901E (S22) system image files
    [ "$(sha256sum "$MODPATH/system/system/lib64/libobjectcapture.arcsoft.so" | cut -d " " -f 1)" = "9d7b5d3c729715a9e00c383e5de57e80adfcd1123086173af9130f3f84dac14d" ] && \
        [ "$(sha256sum "$MODPATH/system/system/lib64/libobjectcapture_jni.arcsoft.so" | cut -d " " -f 1)" = "61ef6f30c32a12b73b89fc0417b318955da906cbc6ba059333fd37d7a7fb10b5" ] || \
        ABORT "arcsoft_objectcapture: libraries are not the S22 SM-S901E ones"
    for f in libobjectcapture.arcsoft.so libobjectcapture_jni.arcsoft.so; do
        ADD_TO_WORK_DIR "$MODPATH" "system" "system/lib64/$f" 0 0 644 "u:object_r:system_lib_file:s0"
        grep -q "^$f$" "$WORK_DIR/system/system/etc/public.libraries-arcsoft.txt" || \
            echo "$f" >> "$WORK_DIR/system/system/etc/public.libraries-arcsoft.txt"
    done
fi
unset SOURCE_LIB64
