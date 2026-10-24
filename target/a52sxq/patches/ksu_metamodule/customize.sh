SKIPUNZIP=1

# KernelSU metamodule by default (see module.prop and k4-ksu-metamodule). Ships the official meta-overlayfs zip in
# /system/etc/k4/ksu/, the boot hook /system/bin/k4-ksu-metamodule and /system/etc/init/k4_ksu_metamodule.rc:
#   sys.boot_completed=1      -> k4_ksu_meta_gate (domain k4ksumeta, root uid, no capabilities used): is KernelSU
#                                active? (sets sys.k4.ksu_meta_gate)
#   sys.k4.ksu_meta_gate=ksu  -> k4_ksu_meta (KernelSU's own domain u:r:ksu:s0, the domain ksud's boot stages run
#                                in; it only exists while KernelSU is loaded, which the gate checked): installs the
#                                metamodule with `ksud module install` when there is none and the user did not opt
#                                out; it is mounted from the next boot on.
# Without KernelSU nothing but the gate runs (Magisk mounts modules itself).
META_ZIP="meta-overlayfs-13100-1.3.1.zip"
META_SHA256="279d85a6a35724dfcf8aa1137a9630c7e989e154b94543517c539ee70f9b8811"
META_PROP="$(printf 'id=meta-overlayfs\nmetamodule=1\nname=OverlayFS MetaModule\nversion=1.3.1\nversionCode=13100\nauthor=KernelSU Developers\ndescription=An implementation of a metamodule using OverlayFS for KernelSU')"

[ "$(sha256sum "$MODPATH/$META_ZIP" | cut -d " " -f 1)" = "$META_SHA256" ] || \
    ABORT "ksu_metamodule: $META_ZIP does not match the pinned sha256 (PROVENANCE.txt)"
[ "$(unzip -p "$MODPATH/$META_ZIP" module.prop)" = "$META_PROP" ] || ABORT "ksu_metamodule: unexpected module.prop in $META_ZIP"
grep -q -x -F "ZIP_SHA256=\"\${K4KSU_ZIP_SHA256:-$META_SHA256}\"" "$MODPATH/k4-ksu-metamodule" || \
    ABORT "ksu_metamodule: k4-ksu-metamodule pins another zip"

EVAL "mkdir -p \"$WORK_DIR/system/system/etc/k4/ksu\""
SET_METADATA "system" "system/etc/k4" 0 0 755 "u:object_r:system_file:s0"
SET_METADATA "system" "system/etc/k4/ksu" 0 0 755 "u:object_r:system_file:s0"
EVAL "cp -f \"$MODPATH/$META_ZIP\" \"$WORK_DIR/system/system/etc/k4/ksu/meta-overlayfs.zip\""
SET_METADATA "system" "system/etc/k4/ksu/meta-overlayfs.zip" 0 0 644 "u:object_r:system_file:s0"
EVAL "cp -f \"$MODPATH/k4-ksu-metamodule\" \"$WORK_DIR/system/system/bin/k4-ksu-metamodule\""
SET_METADATA "system" "system/bin/k4-ksu-metamodule" 0 2000 755 "u:object_r:system_file:s0"

RC="$WORK_DIR/system/system/etc/init/k4_ksu_metamodule.rc"
cat > "$RC" << 'EOF'
# KernelSU metamodule by default (target/a52sxq/patches/ksu_metamodule). ksud refuses to install modules before
# boot_completed; its own boot-completed stage (init.rc, KernelSU) runs before this file's actions.
on property:sys.boot_completed=1
    start k4_ksu_meta_gate

# Is KernelSU active? Confined domain, it can only stat /data/adb/ksud (see /system/bin/k4-ksu-metamodule).
service k4_ksu_meta_gate /system/bin/sh /system/bin/k4-ksu-metamodule gate
    user root
    group root
    seclabel u:r:k4ksumeta:s0
    oneshot
    disabled

on property:sys.k4.ksu_meta_gate=ksu
    start k4_ksu_meta

# Installs the metamodule through ksud, in KernelSU's own domain (ksud's boot stages run there too). Started only
# after the gate found KernelSU, so the domain exists. Bounded: ksud module install takes a few seconds.
service k4_ksu_meta /system/bin/timeout 120 /system/bin/sh /system/bin/k4-ksu-metamodule apply
    user root
    group root
    seclabel u:r:ksu:s0
    oneshot
    disabled
EOF
SET_METADATA "system" "system/etc/init/k4_ksu_metamodule.rc" 0 0 644 "u:object_r:system_file:s0"

# k4ksumeta (the gate) and the two property types: persist.sys.k4.ksu_metamodule (0 = off, 1 = re-arm once;
# settable from adb shell) and sys.k4.ksu_meta* (the result, set by the gate and by the ksu domain). init compiles
# the split policy at boot, so a rule naming a type that does not exist would stop the boot: check every type first.
PLAT_CIL="$WORK_DIR/system/system/etc/selinux/plat_sepolicy.cil"
PLAT_PC="$WORK_DIR/system/system/etc/selinux/plat_property_contexts"
if ! grep -q -x -F "(type k4ksumeta)" "$PLAT_CIL"; then
    for t in init shell_exec toolbox_exec system_file kmsg_device system_data_root_file adb_data_file property_socket shell; do
        grep -q -x -F "(type $t)" "$PLAT_CIL" || ABORT "ksu_metamodule: type $t not in plat_sepolicy.cil, review sepolicy.cil"
    done
    # secilc rejects a second typeattributeset for an attribute, so extend the existing ones
    for a in "domain k4ksumeta" "property_type k4_ksu_meta_prop k4_ksu_meta_status_prop" \
        "system_property_type k4_ksu_meta_prop k4_ksu_meta_status_prop"; do
        n="${a%% *}"
        [ "$(grep -c "^(typeattributeset $n (" "$PLAT_CIL")" = 1 ] || ABORT "ksu_metamodule: no single $n attribute set in plat_sepolicy.cil"
        sed -i "s/^(typeattributeset $n (/(typeattributeset $n (${a#* } /" "$PLAT_CIL"
        grep -q "^(typeattributeset $n (${a#* } " "$PLAT_CIL" || ABORT "ksu_metamodule: failed to extend $n"
    done
    [ -z "$(tail -c 1 "$PLAT_CIL")" ] || echo >> "$PLAT_CIL"
    echo "; k4 KernelSU metamodule gate (target/a52sxq/patches/ksu_metamodule/sepolicy.cil)" >> "$PLAT_CIL"
    cat "$MODPATH/sepolicy.cil" >> "$PLAT_CIL"

    grep -q -E "^(persist\.)?sys\.k4\.ksu_meta" "$PLAT_PC" && ABORT "ksu_metamodule: sys.k4.ksu_meta already in plat_property_contexts"
    [ -z "$(tail -c 1 "$PLAT_PC")" ] || echo >> "$PLAT_PC"
    {
        echo "persist.sys.k4.ksu_metamodule u:object_r:k4_ksu_meta_prop:s0 exact string"
        echo "sys.k4.ksu_meta              u:object_r:k4_ksu_meta_status_prop:s0"
    } >> "$PLAT_PC"
fi
grep -q -x -F "(allow k4ksumeta k4_ksu_meta_status_prop (property_service (set)))" "$PLAT_CIL" || \
    ABORT "ksu_metamodule: k4ksumeta rules missing from plat_sepolicy.cil"

LOG "- KernelSU metamodule by default: meta-overlayfs 1.3.1 in /system/etc/k4/ksu, installed by k4-ksu-metamodule"
unset META_ZIP META_SHA256 META_PROP RC PLAT_CIL PLAT_PC t a n
