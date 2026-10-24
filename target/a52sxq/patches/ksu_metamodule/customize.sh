SKIPUNZIP=1

# KernelSU metamodule by default (see module.prop and k4-ksu-metamodule). Ships the ROM's meta-overlayfs build in
# /system/etc/k4/ksu/, the boot hook /system/bin/k4-ksu-metamodule and /system/etc/init/k4_ksu_metamodule.rc:
#   sys.boot_completed=1      -> k4_ksu_meta_gate (domain k4ksumeta, root uid, no capabilities used): is KernelSU
#                                active? (sets sys.k4.ksu_meta_gate)
#   sys.k4.ksu_meta_gate=ksu  -> k4_ksu_meta (KernelSU's own domain u:r:ksu:s0, the domain ksud's boot stages run
#                                in; it only exists while KernelSU is loaded, which the gate checked): installs the
#                                metamodule with `ksud module install` when there is none and the user did not opt
#                                out; it is mounted from the next boot on.
# Without KernelSU nothing but the gate runs (Magisk mounts modules itself).
# meta-overlayfs 1.3.1-k4.1: the official v1.3.1 release zip with the files of meta-overlayfs-k4/ changed or added
# (meta-overlayfs-k4/make_zip.sh, PROVENANCE.txt)
META_ZIP="meta-overlayfs-13101-1.3.1-k4.1.zip"
META_SHA256="73695f19fd362620738955069306963ef9dde119ce509c3ce90aa27a76ff0669"
# the files the K4 build leaves as they are: sha256 of each in the official v1.3.1 release zip
META_UPSTREAM="f8d62ca9523bb73216fa7d812f3bc07f4444f39f33bcb3c2b1bf00d65ef980ad uninstall.sh
9524097461a391997df79b699c14afbcac4be6ce73bcfe6f27e6532d4cc1f147 customize.sh
833e1299a4ff3ae2f2c629e0f8cebf9f54026c2efe8d9614e51a4fe64c472e3a metauninstall.sh
d27f99f18f674f8f3d6ccaf3806321ac18264318d5b20e53397fb9103dce2773 post-mount.sh
4ff9a64aaff1095ee172bd16189b8ffb37cacf522523edebadd191547ef125b6 meta-overlayfs-x86_64
04ef286eb33dd6650be08c368cc16d06e369aeae2c582f8df520d0a7dcc2fa95 meta-overlayfs-aarch64"
META_K4="metainstall.sh metamount.sh module.prop K4_CHANGES.txt"

[ "$(sha256sum "$MODPATH/$META_ZIP" | cut -d " " -f 1)" = "$META_SHA256" ] || \
    ABORT "ksu_metamodule: $META_ZIP does not match the pinned sha256 (PROVENANCE.txt)"
[ "$(unzip -Z1 "$MODPATH/$META_ZIP" | LC_ALL=C sort | tr '\n' ' ')" = \
    "$( (echo "$META_UPSTREAM" | cut -d " " -f 2; echo "$META_K4" | tr ' ' '\n') | LC_ALL=C sort | tr '\n' ' ')" ] || \
    ABORT "ksu_metamodule: $META_ZIP does not hold exactly the expected files"
while read -r h f; do
    [ "$(unzip -p "$MODPATH/$META_ZIP" "$f" | sha256sum | cut -d " " -f 1)" = "$h" ] || \
        ABORT "ksu_metamodule: $f in $META_ZIP is not the official v1.3.1 file"
done <<< "$META_UPSTREAM"
for f in $META_K4; do
    unzip -p "$MODPATH/$META_ZIP" "$f" | cmp -s - "$MODPATH/meta-overlayfs-k4/$f" || \
        ABORT "ksu_metamodule: $f in $META_ZIP differs from meta-overlayfs-k4/$f (rebuild it with make_zip.sh)"
done
grep -q -x -F "ZIP_VC=$(sed -n 's/^versionCode=//p' "$MODPATH/meta-overlayfs-k4/module.prop")" "$MODPATH/k4-ksu-metamodule" || \
    ABORT "ksu_metamodule: ZIP_VC in k4-ksu-metamodule is not the versionCode of meta-overlayfs-k4/module.prop"
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

LOG "- KernelSU metamodule by default: meta-overlayfs 1.3.1-k4.1 in /system/etc/k4/ksu, installed by k4-ksu-metamodule"
unset META_ZIP META_SHA256 META_UPSTREAM META_K4 RC PLAT_CIL PLAT_PC t a n h f
