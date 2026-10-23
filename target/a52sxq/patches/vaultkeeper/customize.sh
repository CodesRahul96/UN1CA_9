TFW="$(cut -d "/" -f 1 <<< "$TARGET_FIRMWARE")/$(cut -d "/" -f 2 <<< "$TARGET_FIRMWARE")"
# The 64-bit pair is mandatory: without it the source libvkmanager (AIDL client) stays and Bluetooth never turns on.
# The 32-bit pair only matters for 32-bit clients, so a target firmware without it is logged and skipped.
for d in lib lib64; do
    for f in libvkmanager.so vendor.samsung.hardware.security.vaultkeeper@2.0.so; do
        if [ ! -f "$FW_DIR/${TFW//\//_}/system/system/$d/$f" ]; then
            if [ "$d" == "lib64" ]; then
                ABORT "vaultkeeper: $d/$f not found in the target firmware ($TFW)"
            fi
            LOG "- No $d/$f in the target firmware, skipping the 32-bit copy"
            continue
        fi
        ADD_TO_WORK_DIR "$TFW" "system" "system/$d/$f" 0 0 644 "u:object_r:system_lib_file:s0" \
            || ABORT "vaultkeeper: failed to add $d/$f"
    done
done
unset TFW d f
