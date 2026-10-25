# See module.prop and k4-leveldb-stale.
SRC="$SRC_DIR/target/a52sxq/patches/mediaprovider_leveldb_stale"
SYS="$WORK_DIR/system/system"
CIL="$SYS/etc/selinux/plat_sepolicy.cil"

EVAL "cp -f \"$SRC/k4-leveldb-stale\" \"$SYS/bin/k4-leveldb-stale\"" || ABORT "mediaprovider_leveldb_stale: script copy failed"
SET_METADATA "system" "system/bin/k4-leveldb-stale" 0 2000 755 "u:object_r:system_file:s0"
EVAL "cp -f \"$SRC/k4_leveldb_stale.rc\" \"$SYS/etc/init/k4_leveldb_stale.rc\"" || ABORT "mediaprovider_leveldb_stale: rc copy failed"
SET_METADATA "system" "system/etc/init/k4_leveldb_stale.rc" 0 0 644 "u:object_r:system_file:s0"

# The script only knows these two MediaProvider package names and the "<pkg> <uid> " packages.list layout; the seapp
# entry of the shipped one must still give it the mediaprovider_app domain with levelFrom=all (the categories the
# script expects) - if the source changes any of that, review the script before building.
SEAPP="$SYS/etc/selinux/plat_seapp_contexts"
[ -f "$SEAPP" ] || ABORT "mediaprovider_leveldb_stale: plat_seapp_contexts not found"
grep -q -E "name=com\.(google\.)?android\.providers\.media\.module domain=mediaprovider_app type=privapp_data_file levelFrom=all" "$SEAPP" \
    || ABORT "mediaprovider_leveldb_stale: MediaProvider seapp entry changed, review k4-leveldb-stale"

# SELinux: a small enforcing domain that may only read packages.list, list /data/media and unlink files / rmdir dirs
# of type media_rw_data_file. init compiles the split policy at boot, so a rule naming a type that does not exist
# would stop the boot.
[ -f "$CIL" ] || ABORT "mediaprovider_leveldb_stale: plat_sepolicy.cil not found"
if ! grep -q -x -F "(type k4leveldb)" "$CIL"; then
    for t in init shell_exec toolbox_exec system_file kmsg_device system_data_root_file system_data_file \
        packages_list_file media_userdir_file media_rw_data_file; do
        grep -q -x -F "(type $t)" "$CIL" || ABORT "mediaprovider_leveldb_stale: type $t not in plat_sepolicy.cil, review sepolicy.cil"
    done
    # the script relies on media_rw_data_file being an mlstrustedobject (MLS categories do not block access)
    grep -q -E "^\(typeattributeset mlstrustedobject \(.* media_rw_data_file[ )]" "$CIL" \
        || ABORT "mediaprovider_leveldb_stale: media_rw_data_file is no longer an mlstrustedobject, review k4-leveldb-stale"
    [ "$(grep -c "^(typeattributeset domain (" "$CIL")" = 1 ] || ABORT "mediaprovider_leveldb_stale: no single domain attribute set in plat_sepolicy.cil"
    sed -i "s/^(typeattributeset domain (/(typeattributeset domain (k4leveldb /" "$CIL"
    grep -q "^(typeattributeset domain (k4leveldb " "$CIL" || ABORT "mediaprovider_leveldb_stale: failed to add k4leveldb to domain"
    [ -z "$(tail -c 1 "$CIL")" ] || echo >> "$CIL"
    cat "$SRC/sepolicy.cil" >> "$CIL"
fi
grep -q -x -F "(allow k4leveldb media_rw_data_file (file (getattr unlink)))" "$CIL" || ABORT "mediaprovider_leveldb_stale: rules missing from plat_sepolicy.cil"

LOG "- Stale MediaProvider backup dirs (old uid after a dirty flash) are removed at boot, MediaProvider recreates them"
unset SRC SYS CIL SEAPP t
