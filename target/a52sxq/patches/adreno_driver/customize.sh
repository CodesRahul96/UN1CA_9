SKIPUNZIP=1

# GPU driver selector (Settings > K4_UN1CA > UI > GPU driver). The stock A52s Adreno V@0530 stays in /vendor untouched
# and is the default. The built-in sets are every v<id>/ directory of this patch (v849 = V@0849, v863 = V@0863.1,
# v530_55 = V@0530.55: the id is the version with "." as "_"), pinned by v<id>/SHA256SUMS, installed as complete sets
# under /vendor/k4gpu/v<id>/; /system/etc/init/k4_gpu_driver.rc puts the selected one in place at early-boot:
#   - its egl directory bound over /vendor/lib64/egl (the stock one holds only the six Adreno libraries; the set's
#     libraries that stock has no counterpart for, e.g. libadreno_app_profiles.so, live in that egl directory, which is
#     on the sphal and vendor linker search paths, so they are never visible while V@0530 is active: the stock GL/Vulkan
#     libraries dlopen libadreno_app_profiles.so when it exists),
#   - its other libraries bound one by one over their stock counterparts in /vendor/lib64 and /vendor/lib64/hw (an
#     overlay of all of /vendor/lib64 does not work: overlayfs checks every lower file with init's credentials, so
#     SurfaceFlinger could no longer load the gralloc mapper - 9.3.64 test),
#   - its a660 SQE microcode, if the set has one, bound over /vendor/firmware/a660_sqe.fw (kgsl reads it on the first
#     /dev/kgsl-3d0 open, by the camera provider / SurfaceFlinger at boot, i.e. after early-boot),
#   - for V@07xx and newer builds, android.hardware.vulkan.version 1.3 bound over the vendor's 1.1 feature file (the flag
#     must match the driver: V@0530 builds report Vulkan 1.1, V@0849 / V@0863 1.3).
# Selection: persist.sys.k4.gpu_driver = 530 | <id>. Failsafe: Settings sets
# persist.sys.k4.gpu_trial=pending; the rc turns it into "testing" for that boot and "ok" at boot_completed; "testing" at
# the next boot means that boot never finished, so the stock V@0530 is used, persist.sys.k4.gpu_failed records the
# driver and the trial is set to "failed". sys.k4.gpu_active reports what this boot actually uses.
GPU_DEFAULT="530"
VK13=4206592

# The stock driver must still be the one in /vendor (an older build of this patch replaced it in place). Exact
# version: "V@0530." alone would also match the V@0530.55 set.
GPU_STOCK_VER="V@0530.0"
GPU_STOCK="$(grep -a -o -m 1 -E 'V@[0-9]{3,4}\.[0-9]+(\.[0-9]+)?' "$WORK_DIR/vendor/lib64/egl/libGLESv2_adreno.so" | head -n 1)"
[ "$GPU_STOCK" = "$GPU_STOCK_VER" ] || \
    ABORT "adreno_driver: /vendor/lib64/egl/libGLESv2_adreno.so is not the stock $GPU_STOCK_VER ($GPU_STOCK)"

GPU_SETS=""
for d in "$MODPATH"/v*/; do
    v="${d%/}"
    v="${v##*/v}"
    [[ "$v" =~ ^[0-9]+(_[0-9]+)*$ ]] || ABORT "adreno_driver: unexpected set directory v$v (v<version with _ for .>)"
    [ "$v" != "$GPU_DEFAULT" ] || ABORT "adreno_driver: v$GPU_DEFAULT would shadow the stock driver"
    GPU_SETS+="${GPU_SETS:+ }$v"
done
[ -n "$GPU_SETS" ] || ABORT "adreno_driver: no driver set"

SET_METADATA "vendor" "k4gpu" 0 2000 755 "u:object_r:vendor_file:s0"
for v in $GPU_SETS; do
    SRC="$MODPATH/v$v/vendor"
    VER="V@0${v//_/.}."  # v530_55 -> "V@0530.55."
    [ -f "$SRC/lib64/egl/libGLESv2_adreno.so" ] || ABORT "adreno_driver: no driver set v$v"
    # pinned: every file of the set exactly as reviewed (v$v/SHA256SUMS), and nothing else
    [ -f "$MODPATH/v$v/SHA256SUMS" ] || ABORT "adreno_driver: v$v has no SHA256SUMS"
    (cd "$MODPATH/v$v" && sha256sum --quiet --strict -c SHA256SUMS) || ABORT "adreno_driver: v$v does not match v$v/SHA256SUMS"
    [ "$(cd "$MODPATH/v$v" && find vendor -type f | LC_ALL=C sort)" = "$(sed 's/^[0-9a-f]*  //' "$MODPATH/v$v/SHA256SUMS" | LC_ALL=C sort)" ] || \
        ABORT "adreno_driver: v$v has files that are not in v$v/SHA256SUMS"
    grep -q -a -F "$VER" "$SRC/lib64/egl/libGLESv2_adreno.so" || ABORT "adreno_driver: v$v/libGLESv2_adreno.so is not $VER*"
    for f in lib64/egl/libEGL_adreno.so lib64/egl/libGLESv1_CM_adreno.so lib64/hw/vulkan.adreno.so; do
        [ -f "$SRC/$f" ] || ABORT "adreno_driver: v$v has no $f"
    done
    DST="$WORK_DIR/vendor/k4gpu/v$v"
    EVAL "rm -rf \"$DST\" && mkdir -p \"$DST/egl\""
    BINDS=""
    while IFS= read -r f; do
        case "$f" in
            lib64/egl/*) t="egl/${f#lib64/egl/}" ;;
            firmware/*) t="$f" ;;
            *) if [ -f "$WORK_DIR/vendor/$f" ]; then t="$f"; BINDS+=" $f"; else t="egl/$(basename "$f")"; fi ;;
        esac
        EVAL "mkdir -p \"$(dirname "$DST/$t")\" && cp -a \"$SRC/$f\" \"$DST/$t\""
        # same label as the stock file it covers (libkcl, libkernelmanager, libgpu_tonemapper are vendor_file on stock)
        case "$t" in
            firmware/*) LABEL="u:object_r:vendor_firmware_file:s0" ;;
            egl/*) LABEL="u:object_r:same_process_hal_file:s0" ;;
            *) LABEL="$(K="/vendor/$(_HANDLE_SPECIAL_CHARS "$f")" awk '$1 == ENVIRON["K"] { print $2; exit }' "$WORK_DIR/configs/file_context-vendor")"
               [ -n "$LABEL" ] || LABEL="u:object_r:same_process_hal_file:s0" ;;
        esac
        SET_METADATA "vendor" "k4gpu/v$v/$t" 0 0 644 "$LABEL"
    done < <(cd "$SRC" && find . -type f | sed "s|^\./||" | LC_ALL=C sort)
    while IFS= read -r d; do
        LABEL="u:object_r:vendor_file:s0"; [ "$d" = "egl" ] && LABEL="u:object_r:same_process_hal_file:s0"
        SET_METADATA "vendor" "k4gpu/v$v/$d" 0 2000 755 "$LABEL"
    done < <(cd "$DST" && find . -mindepth 1 -type d | sed "s|^\./||" | LC_ALL=C sort)
    eval "GPU_BINDS_$v=\"$BINDS\""
    # the microcode is optional (without one the stock a660 SQE stays); V@07xx+ report Vulkan 1.3, V@0530 builds
    # (stock and V@0530.55) Vulkan 1.1. Only a660_sqe.fw is ever bound: the unsigned command-processor microcode.
    # Signed firmware (zap shader, GMU) is never shipped or bound.
    [ -z "$(cd "$SRC" && find . -path "./firmware/*" ! -name a660_sqe.fw)" ] || ABORT "adreno_driver: v$v ships firmware other than a660_sqe.fw"
    if [ -f "$SRC/firmware/a660_sqe.fw" ]; then eval "GPU_SQE_$v=1"; else LOG "- adreno_driver: v$v has no a660_sqe.fw, the stock one stays"; fi
    [ "${v%%_*}" -ge 700 ] && eval "GPU_VK_$v=1"
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
            echo "    mount none /vendor/k4gpu/v$v/egl /vendor/lib64/egl bind"
            eval "B=\"\$GPU_BINDS_$v\""
            for f in $B; do
                echo "    mount none /vendor/k4gpu/v$v/$f /vendor/$f bind"
            done
            eval "[ -n \"\${GPU_SQE_$v:-}\" ]" && \
                echo "    mount none /vendor/k4gpu/v$v/firmware/a660_sqe.fw /vendor/firmware/a660_sqe.fw bind"
            eval "[ -n \"\${GPU_VK_$v:-}\" ]" && \
                echo "    mount none /vendor/k4gpu/vulkan.version-1_3.xml /vendor/etc/permissions/android.hardware.vulkan.version-1_1.xml bind"
            echo "    setprop sys.k4.gpu_active $v"
        done
    done
    echo
    echo "on property:sys.boot_completed=1 && property:persist.sys.k4.gpu_trial=testing"
    echo "    setprop persist.sys.k4.gpu_trial ok"
} > "$RC"
SET_METADATA "system" "system/etc/init/k4_gpu_driver.rc" 0 0 644 "u:object_r:system_file:s0"

# init mounts the sets (bind mounts only: the files keep their own labels, init only needs mounton on the targets).
PLAT_CIL="$WORK_DIR/system/system/etc/selinux/plat_sepolicy.cil"
if ! grep -q "^; k4 gpu driver selector" "$PLAT_CIL"; then
    {
        echo "; k4 gpu driver selector (target/a52sxq/patches/adreno_driver): init binds the selected set at early-boot"
        echo "(allow init same_process_hal_file (dir (mounton)))"
        echo "(allow init same_process_hal_file (file (mounton)))"
        echo "(allow init vendor_file (file (mounton)))"
        echo "(allow init vendor_firmware_file (file (mounton)))"
        echo "(allow init vendor_configs_file (file (mounton)))"
    } >> "$PLAT_CIL"
fi

# read by Settings (GpuDriverPreferenceController): a system prop; init does not load ro.k4.* from the vendor build.prop
SET_PROP "system" "ro.k4.gpu_drivers" "$GPU_DEFAULT $GPU_SETS"
LOG "- GPU driver selector: stock $GPU_STOCK default, $(sed "s/_/./g; s/^/V@0/; s/ /, V@0/g" <<< "$GPU_SETS") selectable"
for v in $GPU_SETS; do unset "GPU_BINDS_$v" "GPU_SQE_$v" "GPU_VK_$v"; done
unset GPU_DEFAULT GPU_SETS GPU_STOCK GPU_STOCK_VER VK13 SRC DST VER BINDS B LABEL VKXML RC PLAT_CIL v t d f
