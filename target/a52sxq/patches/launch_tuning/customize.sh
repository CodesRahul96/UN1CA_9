# See module.prop.
SRC="$SRC_DIR/target/a52sxq/patches/launch_tuning"
EVAL "cp -f \"$SRC/a52sxq_launch_tuning.rc\" \"$WORK_DIR/system/system/etc/init/a52sxq_launch_tuning.rc\"" || ABORT "launch_tuning: failed to install the rc"
SET_METADATA "system" "system/etc/init/a52sxq_launch_tuning.rc" 0 0 644 "u:object_r:system_file:s0"
LOG "- lz4 zram; vendor sched_downmigrate/upmigrate (65 85 / 71 95) re-applied after post_boot, then the perf HAL restarted"
unset SRC
