#!/system/bin/sh
# meta-overlayfs Module Mount Handler
# This script is the entry point for dual-directory module mounting
#
# Modified for the K4_UN1CA ROM (Galaxy A52s 5G), 2026-10-24, kusti420. Upstream: meta-overlayfs v1.3.1,
# github.com/KernelSU-Modules-Repo/meta-overlayfs commit 7143eb79 (metamodule/metamount.sh), GPL-3.0; this
# modified file is under the same licence. Changes (marked "K4"):
#   1. On a ROM with the K4 GPU driver selector (/system/bin/k4-gpu-driver), an Adreno GPU driver module's copy in
#      the image (put there by an earlier install through the unmodified metainstall.sh) is deleted before mounting,
#      so it is never mounted: the selector imports the module from /data/adb/modules/<id> with the right SELinux
#      labels and a trial boot (see metainstall.sh). Mounted from here with KernelSU's default label vendor_file,
#      SurfaceFlinger could not load the driver and the phone bootlooped. The module itself is not touched.
#   2. The copy of a module that is gone (no /data/adb/modules/<id> any more) is deleted: metauninstall.sh runs
#      before this script mounts the image, finds it unmounted and skips its cleanup, so the copy stayed - and a
#      later install of the same id copied over it, mounting the old version's leftover files with the new one.

MODDIR="${0%/*}"
IMG_FILE="$MODDIR/modules.img"
MNT_DIR="$MODDIR/mnt"
RW_ROOT="/data/adb/modules/.rw"
# K4: the module metadata directory (the same one MODULE_METADATA_DIR names below)
MODULE_DIR_K4="/data/adb/modules"
PARTITIONS="system vendor product system_ext odm oem"

# Log function
log() {
    echo "[meta-overlayfs] $1"
}

log "Starting module mount process"

# Ensure ext4 image is mounted
if ! mountpoint -q "$MNT_DIR" 2>/dev/null; then
    log "Image not mounted, mounting now..."

    # Check if image file exists
    if [ ! -f "$IMG_FILE" ]; then
        log "ERROR: Image file not found at $IMG_FILE"
        exit 1
    fi

    # Create mount point
    mkdir -p "$MNT_DIR"

    # Mount the ext4 image
    chcon u:object_r:ksu_file:s0 "$IMG_FILE" 2>/dev/null
    mount -t ext4 -o loop,rw,noatime "$IMG_FILE" "$MNT_DIR" || {
        log "ERROR: Failed to mount image"
        exit 1
    }
    log "Image mounted successfully at $MNT_DIR"
else
    log "Image already mounted at $MNT_DIR"
fi

# K4: copies of removed modules (change 2) and Adreno GPU driver modules (change 1) are not mounted
for K4_C in "$MNT_DIR"/*; do
    [ -d "$K4_C" ] && [ ! -L "$K4_C" ] || continue
    K4_ID="${K4_C##*/}"
    [ "$K4_ID" = lost+found ] && continue
    if [ -d "$MODULE_DIR_K4" ] && [ ! -d "$MODULE_DIR_K4/$K4_ID" ]; then
        rm -rf "$K4_C"
        log "$K4_ID: module removed, its copy in the image deleted"
        continue
    fi
    if [ -f /system/bin/k4-gpu-driver ]; then
        K4_GPU=""
        for K4_B in "$K4_C" "$MODULE_DIR_K4/$K4_ID"; do
            for K4_V in "$K4_B/vendor" "$K4_B/system/vendor"; do
                for K4_L in lib64 lib; do
                    [ -f "$K4_V/$K4_L/egl/libGLESv2_adreno.so" ] && K4_GPU=1
                done
            done
        done
        if [ -n "$K4_GPU" ]; then
            rm -rf "$K4_C"
            log "$K4_ID: Adreno GPU driver module, left to the ROM's GPU driver selector (image copy removed)"
            echo "meta-overlayfs: $K4_ID: Adreno GPU driver module, left to the ROM's GPU driver selector" > /dev/kmsg 2>/dev/null
        fi
    fi
done

# Binary path (architecture-specific binary selected during installation)
BINARY="$MODDIR/meta-overlayfs"

if [ ! -f "$BINARY" ]; then
    log "ERROR: Binary not found: $BINARY"
    exit 1
fi

# Special .rw handling
if [ -d "$RW_ROOT" ]; then
    log "Applying SELinux contexts for RW partition structures"

    for part in $PARTITIONS; do
        PART_DIR="$RW_ROOT/$part"
        REFERENCE_PATH="/$part"
        if [ -d "$PART_DIR" ] && [ -e "$REFERENCE_PATH" ]; then
            chcon --reference="$REFERENCE_PATH" "$PART_DIR" 2>/dev/null
            UPPER_DIR="$PART_DIR/upperdir"
            if [ -d "$UPPER_DIR" ]; then
                chcon --reference="$PART_DIR" "$UPPER_DIR" 2>/dev/null
            fi
            WORK_DIR="$PART_DIR/workdir"
            if [ -d "$WORK_DIR" ]; then
                chcon --reference="$PART_DIR" "$WORK_DIR" 2>/dev/null
            fi
        fi
    done
fi

# Set dual-directory environment variables
export MODULE_METADATA_DIR="/data/adb/modules"
export MODULE_CONTENT_DIR="$MNT_DIR"

log "Metadata directory: $MODULE_METADATA_DIR"
log "Content directory: $MODULE_CONTENT_DIR"
log "Executing $BINARY"

# Execute the mount binary
"$BINARY"
EXIT_CODE=$?

if [ $EXIT_CODE -ne 0 ]; then
    log "Mount failed with exit code $EXIT_CODE"
    exit $EXIT_CODE
fi

log "Mount completed successfully"
exit 0
