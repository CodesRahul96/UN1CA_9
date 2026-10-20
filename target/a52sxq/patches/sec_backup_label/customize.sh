# See module.prop. Deep dive 2026-10-16 finding L6 (/mnt/B1/OneUi9/scratch/deepdive_1016/selinux_hal/DENIAL_GROUPS.txt)
PLAT_FC="$WORK_DIR/system/system/etc/selinux/plat_file_contexts"

if ! grep -q "^/metadata/sec_backup" "$PLAT_FC"; then
    LOG "- Labeling /metadata/sec_backup as vold_metadata_file in /system/etc/selinux/plat_file_contexts"
    EVAL "echo \"/metadata/sec_backup(/.*)?    u:object_r:vold_metadata_file:s0\" >> \"$PLAT_FC\""
fi

unset PLAT_FC
