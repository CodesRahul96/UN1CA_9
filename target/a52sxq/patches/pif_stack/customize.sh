SKIPUNZIP=1

# Play Integrity module stack by default (see module.prop and k4-gmscompat). Ships the exact module zips that pass
# BASIC+DEVICE+STRONG on this phone, the configs that passed and the boot hook /system/bin/k4-gmscompat with
# /system/etc/init/k4_gmscompat.rc:
#   init.svc.k4_metamod=stopped        -> k4_gmscompat (KernelSU's own domain u:r:ksu:s0): installs the stack with
#                                         `ksud module install` (k4_metamod only runs after its gate found KernelSU,
#                                         so the domain exists, and any metamodule install of this boot is done)
#   persist.sys.unica.pif changes      -> the same, at once (the Settings "Play Integrity Fix" switch)
# Without KernelSU nothing runs. Needs ksu_metamodule (its services, its status property type).
# zygisksu and playintegrityfix are the upstream releases, unmodified. teesim is the upstream canary 73 with ONE
# byte changed in arm64-v8a/libteesim_keymint.so (offset 0xe0206, 0x02->0x03: cmp x24,#0x80 -> #0xc0, raising the
# kmr MAX_ATTESTATION_CHALLENGE_SIZE 128->192) so GMS 26.42.31+'s 144-byte attestation challenge is accepted instead
# of rejected (INVALID_INPUT_LENGTH -> Play Integrity INTERNAL_ERROR/-100). 192 still rejects Duck Detector's >=256
# probes. See PROVENANCE.txt; unmodified upstream archived at pi_stack_ship/. The keybox is NOT in this repository
# (public): a keybox.xml at $K4_PIF_KEYBOX (default /mnt/B1/OneUi9/keybox/keybox.xml) is shipped when it exists.
PIF_ZIPS="ce50b13fecb9e4456db69ef17b715f7cfbc094004dd9f30f7d6348dfab619a96 zygisksu 864
39598955355cc94cb87110b6f1e648c541e079eb2266df3da23c442324c7205c teesim 73
bc7a9d92638a6bd90a41b70d3aaf86bc549dd8d3a1e5e901b315a6c425852697 playintegrityfix 490"
PIF_KEYBOX="${K4_PIF_KEYBOX:-/mnt/B1/OneUi9/keybox/keybox.xml}"
PIF_DIR="$WORK_DIR/system/system/etc/k4/gmscompat"

[ -f "$WORK_DIR/system/system/etc/init/k4_metamodule.rc" ] || \
    ABORT "pif_stack: needs ksu_metamodule (k4_metamodule.rc not in the work dir)"

EVAL "rm -rf \"$PIF_DIR\" && mkdir -p \"$PIF_DIR/seed\""
SET_METADATA "system" "system/etc/k4" 0 0 755 "u:object_r:system_file:s0"
# root only: apps cannot list what is in here
SET_METADATA "system" "system/etc/k4/gmscompat" 0 0 700 "u:object_r:system_file:s0"
SET_METADATA "system" "system/etc/k4/gmscompat/seed" 0 0 700 "u:object_r:system_file:s0"
: > "$PIF_DIR/manifest"
while read -r h id vc; do
    [ "$(sha256sum "$MODPATH/$id.zip" | cut -d " " -f 1)" = "$h" ] || \
        ABORT "pif_stack: $id.zip does not match the pinned sha256 (PROVENANCE.txt)"
    [ "$(unzip -p "$MODPATH/$id.zip" module.prop | sed -n 's/^id=//p' | tr -d '\r')" = "$id" ] || \
        ABORT "pif_stack: $id.zip is not module $id"
    [ "$(unzip -p "$MODPATH/$id.zip" module.prop | sed -n 's/^versionCode=//p' | tr -d '\r')" = "$vc" ] || \
        ABORT "pif_stack: $id.zip is not versionCode $vc"
    EVAL "cp -f \"$MODPATH/$id.zip\" \"$PIF_DIR/$id.zip\""
    SET_METADATA "system" "system/etc/k4/gmscompat/$id.zip" 0 0 600 "u:object_r:system_file:s0"
    echo "$id.zip $h $vc" >> "$PIF_DIR/manifest"
done <<< "$PIF_ZIPS"
SET_METADATA "system" "system/etc/k4/gmscompat/manifest" 0 0 600 "u:object_r:system_file:s0"

for f in teesim_config.json teesim_overrides.json pif.prop; do
    EVAL "cp -f \"$MODPATH/seed/$f\" \"$PIF_DIR/seed/$f\""
    SET_METADATA "system" "system/etc/k4/gmscompat/seed/$f" 0 0 600 "u:object_r:system_file:s0"
done
if [ -f "$PIF_KEYBOX" ]; then
    grep -q "<AndroidAttestation>" "$PIF_KEYBOX" || ABORT "pif_stack: $PIF_KEYBOX is not a keybox"
    EVAL "cp -f \"$PIF_KEYBOX\" \"$PIF_DIR/seed/keybox.xml\""
    SET_METADATA "system" "system/etc/k4/gmscompat/seed/keybox.xml" 0 0 600 "u:object_r:system_file:s0"
    LOG "- Play Integrity stack: keybox $(sha256sum "$PIF_KEYBOX" | cut -c 1-8) shipped"
else
    LOG "- Play Integrity stack: no keybox at $PIF_KEYBOX, shipping none (STRONG needs the user's own)"
fi

EVAL "cp -f \"$MODPATH/k4-gmscompat\" \"$WORK_DIR/system/system/bin/k4-gmscompat\""
SET_METADATA "system" "system/bin/k4-gmscompat" 0 2000 755 "u:object_r:system_file:s0"

cat > "$WORK_DIR/system/system/etc/init/k4_gmscompat.rc" << 'EOF'
# Play Integrity module stack by default (target/a52sxq/patches/pif_stack). k4_metamod (k4_metamodule.rc) only
# runs once its gate found KernelSU, so u:r:ksu:s0 exists when this starts; starting after it also means this
# boot's metamodule install is complete.
on property:init.svc.k4_metamod=stopped
    start k4_gmscompat

# the Settings "Play Integrity Fix" switch
on property:persist.sys.unica.pif=* && property:init.svc.k4_metamod=stopped
    start k4_gmscompat

service k4_gmscompat /system/bin/timeout 180 /system/bin/sh /system/bin/k4-gmscompat apply
    user root
    group root
    seclabel u:r:ksu:s0
    oneshot
    disabled
EOF
SET_METADATA "system" "system/etc/init/k4_gmscompat.rc" 0 0 644 "u:object_r:system_file:s0"

# result property: the status type of ksu_metamodule (set by the ksu domain, readable from adb shell)
PLAT_PC="$WORK_DIR/system/system/etc/selinux/plat_property_contexts"
grep -q "k4_metamod_status_prop" "$PLAT_PC" || ABORT "pif_stack: k4_metamod_status_prop not in plat_property_contexts"
if ! grep -q "^sys\.k4\.gmscompat " "$PLAT_PC"; then
    [ -z "$(tail -c 1 "$PLAT_PC")" ] || echo >> "$PLAT_PC"
    echo "sys.k4.gmscompat            u:object_r:k4_metamod_status_prop:s0" >> "$PLAT_PC"
fi

LOG "- Play Integrity stack (Zygisk Next 864, TEESimulator 73, PIF 490) in /system/etc/k4/gmscompat, installed by k4-gmscompat"
unset PIF_ZIPS PIF_KEYBOX PIF_DIR PLAT_PC h id vc f
