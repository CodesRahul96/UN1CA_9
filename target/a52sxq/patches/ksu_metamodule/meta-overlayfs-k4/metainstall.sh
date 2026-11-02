#!/system/bin/sh
############################################
# meta-overlayfs metainstall.sh
# Module installation hook for ext4 image support
############################################
#
# Modified for the K4_UN1CA ROM (Galaxy A52s 5G), 2026-10-24, kusti420. Upstream: meta-overlayfs v1.3.1,
# github.com/KernelSU-Modules-Repo/meta-overlayfs commit 7143eb79 (metamodule/metainstall.sh), GPL-3.0; this
# modified file is under the same licence. Changes (marked "K4"):
#   1. set_perm was called with a mode in the SELinux-context argument (set_perm <path> 0 0 0755 0644), so its
#      chcon failed ("chcon: invalid context: 0644") and the image's mnt/ and mnt/<id> directories stayed
#      "unlabeled". They now get set_perm's default context.
#   2. Adreno GPU driver modules (lib64/egl/libGLESv2_adreno.so or lib/egl/libGLESv2_adreno.so under vendor/ or
#      system/vendor/) are not copied into the image on a ROM with the K4 GPU driver selector
#      (/system/bin/k4-gpu-driver): the selector imports them with the stock SELinux labels, an allowlist and a
#      trial boot that falls back to the stock driver. Mounted from here they kept KernelSU's default label
#      vendor_file, which SurfaceFlinger may not read (same_process_hal_file is needed): SurfaceFlinger aborted on
#      every start ("couldn't find an OpenGL ES implementation") and the phone looped into recovery.
#   3. A directory of the module that also exists on the partition gets the partition directory's label (an
#      overlayfs merged directory shows the label of the topmost layer: the module's lib64/hw, labeled vendor_file,
#      hid the stock vendor_hal_file directory). Files keep the labels the module gave them, as before.

# Constants
IMG_FILE="/data/adb/metamodule/modules.img"
MNT_DIR="/data/adb/metamodule/mnt"

# Ensure ext4 image is mounted
ensure_image_mounted() {
    if ! mountpoint -q "$MNT_DIR" 2>/dev/null; then
        ui_print "- Mounting modules image"
        mkdir -p "$MNT_DIR"
        chcon u:object_r:ksu_file:s0 "$IMG_FILE" 2>/dev/null
        mount -t ext4 -o loop,rw,noatime "$IMG_FILE" "$MNT_DIR" || {
            abort "! Failed to mount modules image"
        }
        ui_print "- Image mounted successfully"
    else
        ui_print "- Image already mounted"
    fi
}

# K4: a module that carries an Adreno GPU driver set, on a ROM whose GPU driver selector handles those (change 2)
k4_gpu_driver_module() {
    [ -f /system/bin/k4-gpu-driver ] || return 1
    for k4_v in "$1/vendor" "$1/system/vendor"; do
        for k4_l in lib64 lib; do
            [ -f "$k4_v/$k4_l/egl/libGLESv2_adreno.so" ] && return 0
        done
    done
    return 1
}

# K4: directories that exist on the partition take its label (change 3); $1 = image copy, $2 = partition root
k4_dir_labels() {
    command -v chcon >/dev/null 2>&1 || return 0
    [ -d "$1" ] && [ ! -L "$1" ] || return 0
    find "$1" -type d | while IFS= read -r K4_D; do
        K4_R="${K4_D#"$1"}"
        K4_P="$2$K4_R"
        if [ -d "$K4_P" ] && [ ! -L "$K4_P" ]; then
            chcon --reference="$K4_P" "$K4_D" 2>/dev/null || true
        fi
    done
}

# Determine whether this module should be moved into the ext4 image.
# We only relocate payloads that expose system/ overlays and do not opt out via skip_mount.
module_requires_overlay_move() {
    if [ -f "$MODPATH/skip_mount" ]; then
        ui_print "- skip_mount flag detected; keeping files under /data/adb/modules"
        return 1
    fi

    if k4_gpu_driver_module "$MODPATH"; then
        ui_print "- Adreno GPU driver module: not mounted by meta-overlayfs. The ROM's GPU driver selector"
        ui_print "  imports it on the next boot and tries it once (stock driver again if that boot fails):"
        ui_print "  Settings > UN1CA 9 > UI > GPU driver"
        return 1
    fi

    if [ ! -d "$MODPATH/system" ]; then
        ui_print "- No system/ directory detected; keeping files under /data/adb/modules"
        return 1
    fi

    return 0
}

# Copy SELinux contexts from src tree to destination by mirroring each entry.
copy_selinux_contexts() {
    command -v chcon >/dev/null 2>&1 || return 0

    SRC="$1"
    DST="$2"

    if [ -z "$SRC" ] || [ -z "$DST" ] || [ ! -e "$SRC" ] || [ ! -e "$DST" ]; then
        return 0
    fi

    CHCON_FLAG=""
    if [ -L "$SRC" ]; then
        CHCON_FLAG="-h"
    fi
    chcon $CHCON_FLAG --reference="$SRC" "$DST" 2>/dev/null || true

    find "$SRC" -print | while IFS= read -r PATH_SRC; do
        if [ "$PATH_SRC" = "$SRC" ]; then
            continue
        fi
        REL_PATH="${PATH_SRC#"${SRC}/"}"
        PATH_DST="$DST/$REL_PATH"
        if [ -e "$PATH_DST" ] || [ -L "$PATH_DST" ]; then
            CHCON_FLAG=""
            if [ -L "$PATH_SRC" ]; then
                CHCON_FLAG="-h"
            fi
            chcon $CHCON_FLAG --reference="$PATH_SRC" "$PATH_DST" 2>/dev/null || true
        fi
    done
}

# Post-installation: move partition directories to ext4 image
post_install_to_image() {
    ui_print "- Copying module content to image"

    # K4: no fifth argument, it is the SELinux context (change 1)
    set_perm "$MNT_DIR" 0 0 0755

    MOD_IMG_DIR="$MNT_DIR/$MODID"
    mkdir -p "$MOD_IMG_DIR"
    set_perm "$MOD_IMG_DIR" 0 0 0755

    # Move all partition directories
    for partition in system vendor product system_ext odm oem; do
        if [ -d "$MODPATH/$partition" ]; then
            ui_print "- Copying $partition/"
            cp -af "$MODPATH/$partition" "$MOD_IMG_DIR/" || {
                ui_print "! Warning: Failed to move $partition"
                continue
            }
            copy_selinux_contexts "$MODPATH/$partition" "$MOD_IMG_DIR/$partition"
            k4_dir_labels "$MOD_IMG_DIR/$partition" "/$partition"
        fi
    done
}

# REPLACE
mark_replace() {
	replace_target="$1"
	mkdir -p "$replace_target"
	setfattr -n trusted.overlay.opaque -v y "$replace_target"
}

ui_print "- Using meta-overlayfs metainstall"

install_module

if module_requires_overlay_move; then
    ensure_image_mounted
    post_install_to_image
else
    # K4: an earlier install of this id may have left a copy in the image, which would still be mounted
    if [ -n "$MODID" ] && mountpoint -q "$MNT_DIR" 2>/dev/null && [ -d "$MNT_DIR/$MODID" ]; then
        rm -rf "${MNT_DIR:?}/$MODID" && ui_print "- Removed the copy of an earlier install from the modules image"
    fi
    ui_print "- Skipping move to modules image"
fi

ui_print "- Installation complete"
