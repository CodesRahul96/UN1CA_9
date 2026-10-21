SKIPUNZIP=1

# GPU driver selector (Settings > K4_UN1CA > UI > GPU driver). The stock A52s Adreno V@0530 stays in /vendor untouched
# and is the default. V@0849 (09/19/25) and V@0863.1 (12/24/25) are installed as complete sets under /vendor/k4gpu/v<ver>/
# and /system/etc/init/k4_gpu_driver.rc puts the selected one in place at early-boot:
#   - a read-only overlay of /vendor/k4gpu/v<ver>/lib64 over /vendor/lib64 (overlay, not per-file binds: the stock V@0530
#     GL/Vulkan libraries dlopen libadreno_app_profiles.so when it exists, so the sets' extra libraries must not be
#     visible while V@0530 is active),
#   - its a660 SQE microcode bound over /vendor/firmware/a660_sqe.fw (kgsl reads it on the first /dev/kgsl-3d0 open,
#     by the camera provider / SurfaceFlinger at boot, i.e. after early-boot),
#   - android.hardware.vulkan.version 1.3 bound over the vendor's 1.1 feature file (the flag must match the driver).
# Selection: persist.sys.k4.gpu_driver = 530 | 849 | 863. Failsafe: Settings sets persist.sys.k4.gpu_trial=pending; the
# rc turns it into "testing" for that boot and "ok" at boot_completed; "testing" at the next early-boot means that boot
# never finished, so the rc falls back to V@0530, records persist.sys.k4.gpu_failed and sets the trial to "failed".
# sys.k4.gpu_active reports what this boot actually mounted.
GPU_DEFAULT="530"
GPU_SETS="849 863"
VK13=4206592

# The stock driver must still be the one in /vendor (an older build of this patch replaced it in place).
grep -q -a -F "V@0530." "$WORK_DIR/vendor/lib64/egl/libGLESv2_adreno.so" || \
    ABORT "adreno_driver: /vendor/lib64/egl/libGLESv2_adreno.so is not the stock V@0530"

SET_METADATA "vendor" "k4gpu" 0 2000 755 "u:object_r:vendor_file:s0"
for v in $GPU_SETS; do
    SRC="$MODPATH/v$v/vendor"
    [ -f "$SRC/lib64/egl/libGLESv2_adreno.so" ] || ABORT "adreno_driver: no driver set v$v"
    grep -q -a -F "V@0$v." "$SRC/lib64/egl/libGLESv2_adreno.so" || ABORT "adreno_driver: v$v/libGLESv2_adreno.so is not V@0$v"
    [ -f "$SRC/firmware/a660_sqe.fw" ] || ABORT "adreno_driver: v$v has no a660_sqe.fw"
    EVAL "mkdir -p \"$WORK_DIR/vendor/k4gpu/v$v\" && cp -a \"$SRC/.\" \"$WORK_DIR/vendor/k4gpu/v$v/\""
    while IFS= read -r d; do
        SET_METADATA "vendor" "k4gpu/v$v/$d" 0 2000 755 "u:object_r:vendor_file:s0"
    done < <(cd "$SRC" && find . -mindepth 1 -type d | sed "s|^\./||" | LC_ALL=C sort)
    while IFS= read -r f; do
        case "$f" in
            firmware/*) LABEL="u:object_r:vendor_firmware_file:s0" ;;
            *) LABEL="u:object_r:same_process_hal_file:s0" ;;
        esac
        SET_METADATA "vendor" "k4gpu/v$v/$f" 0 0 644 "$LABEL"
    done < <(cd "$SRC" && find . -type f | sed "s|^\./||" | LC_ALL=C sort)
    SET_METADATA "vendor" "k4gpu/v$v" 0 2000 755 "u:object_r:vendor_file:s0"
done

VKXML="$WORK_DIR/vendor/etc/permissions/android.hardware.vulkan.version-1_1.xml"
grep -q 'name="android.hardware.vulkan.version" version="4198400"' "$VKXML" || \
    ABORT "adreno_driver: ${VKXML//$WORK_DIR/} is not the stock Vulkan 1.1 feature file"
EVAL "sed 's|version=\"4198400\"|version=\"$VK13\"|' \"$VKXML\" > \"$WORK_DIR/vendor/k4gpu/vulkan.version-1_3.xml\""
grep -q "version=\"$VK13\"" "$WORK_DIR/vendor/k4gpu/vulkan.version-1_3.xml" || ABORT "adreno_driver: Vulkan 1.3 feature file"
SET_METADATA "vendor" "k4gpu/vulkan.version-1_3.xml" 0 0 644 "u:object_r:vendor_configs_file:s0"

RC="$WORK_DIR/system/system/etc/init/k4_gpu_driver.rc"
{
    echo "# GPU driver selector (target/a52sxq/patches/adreno_driver). V@0$GPU_DEFAULT = stock, nothing to mount."
    echo "on early-boot"
    echo "    setprop sys.k4.gpu_active $GPU_DEFAULT"
    echo
    echo "# The previous boot with a newly selected driver never reached boot_completed: back to the stock driver."
    echo "on early-boot && property:persist.sys.k4.gpu_trial=testing"
    echo "    setprop persist.sys.k4.gpu_failed \${persist.sys.k4.gpu_driver}"
    echo "    setprop persist.sys.k4.gpu_driver $GPU_DEFAULT"
    echo "    setprop persist.sys.k4.gpu_trial failed"
    echo
    echo "on early-boot && property:persist.sys.k4.gpu_trial=pending"
    echo "    setprop persist.sys.k4.gpu_trial testing"
    for v in $GPU_SETS; do
        for t in pending ok; do
            echo
            echo "on early-boot && property:persist.sys.k4.gpu_driver=$v && property:persist.sys.k4.gpu_trial=$t"
            echo "    mount overlay k4gpu /vendor/lib64 ro lowerdir=/vendor/k4gpu/v$v/lib64:/vendor/lib64"
            echo "    mount none /vendor/k4gpu/v$v/firmware/a660_sqe.fw /vendor/firmware/a660_sqe.fw bind"
            echo "    mount none /vendor/k4gpu/vulkan.version-1_3.xml /vendor/etc/permissions/android.hardware.vulkan.version-1_1.xml bind"
            echo "    setprop sys.k4.gpu_active $v"
        done
    done
    echo
    echo "on property:sys.boot_completed=1 && property:persist.sys.k4.gpu_trial=testing"
    echo "    setprop persist.sys.k4.gpu_trial ok"
} > "$RC"
SET_METADATA "system" "system/etc/init/k4_gpu_driver.rc" 0 0 644 "u:object_r:system_file:s0"

# init mounts the sets: overlayfs opens the lower files with the mounter's (init's) credentials when an app maps a library.
PLAT_CIL="$WORK_DIR/system/system/etc/selinux/plat_sepolicy.cil"
if ! grep -q "^; k4 gpu driver selector" "$PLAT_CIL"; then
    {
        echo "; k4 gpu driver selector (target/a52sxq/patches/adreno_driver)"
        echo "(allow init same_process_hal_file (file (read open getattr map execute)))"
        echo "(allow init vendor_firmware_file (file (mounton)))"
        echo "(allow init vendor_configs_file (file (mounton)))"
    } >> "$PLAT_CIL"
fi

# read by Settings (GpuDriverPreferenceController): a system prop; init does not load ro.k4.* from the vendor build.prop
SET_PROP "system" "ro.k4.gpu_drivers" "$GPU_DEFAULT $GPU_SETS"
LOG "- GPU driver selector: stock V@0$GPU_DEFAULT default, V@0${GPU_SETS// /, V@0} selectable"
unset GPU_DEFAULT GPU_SETS VK13 SRC LABEL VKXML RC PLAT_CIL v t d f
