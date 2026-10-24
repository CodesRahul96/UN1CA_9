#!/usr/bin/env bash
# Host test of k4-gpu-driver (the boot-time part of the GPU driver selector for user drivers): every scenario runs
# the real script against a fake root (K4GPU_ROOT: /data/k4gpu, /data/adb, /vendor), properties in a file
# (K4GPU_PROPFILE) and recorded instead of real bind mounts (K4GPU_FAKEMOUNT). The driver files are tiny fake ELF
# files that carry a version string like the real libraries. Nothing here is shipped.
# Usage: run.sh [-v]   (-v: print the script's log of every boot)
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$HERE/../k4-gpu-driver"
SH="${K4GPU_TEST_SH:-bash}"
VERBOSE=false
[ "${1:-}" = -v ] && VERBOSE=true
T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT
PASS=0
FAIL=0

ok() { PASS=$((PASS + 1)); }
bad() { FAIL=$((FAIL + 1)); echo "FAIL [$CASE]: $*"; }
eq() { [ "$2" = "$3" ] && ok || bad "$1: expected '$3', got '$2'"; }
has() { grep -q -F -- "$2" "$3" && ok || bad "$1: '$2' not in $(basename "$3")"; }
hasnt() { grep -q -F -- "$2" "$3" && bad "$1: '$2' unexpectedly in $(basename "$3")" || ok; }

# the store/incoming slot name the script derives for a module id (slot_name in k4-gpu-driver)
mslot() { printf 'm_%s_%s' "$(printf '%s' "$1" | tr -c 'A-Za-z0-9._+-' '_' | cut -c 1-30)" "$(printf '%s' "$1" | sha1sum | cut -c 1-8)"; }

# fake_lib <file> <version or -> [32]: 20-byte ELF header (aarch64 or 32-bit ARM), a version string, padding
fake_lib() {
    mkdir -p "$(dirname "$1")"
    if [ "${3:-}" = 32 ]; then
        printf '\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x28\x00' > "$1"
    else
        printf '\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\xb7\x00' > "$1"
    fi
    [ "$2" = - ] || printf 'Qualcomm build %s (GIT@0000000000, I0000000000, 1700000000)\n' "$2" >> "$1"
    printf '%s\n' "$(basename "$1")" >> "$1"
}

# fake_set <vendor-like root> <version> [32]: a complete set like the shipped ones
fake_set() {
    local r="$1" v="$2" b="${3:-}" d=lib64
    [ "$b" = 32 ] && d=lib
    for n in libGLESv2_adreno.so libEGL_adreno.so libGLESv1_CM_adreno.so eglSubDriverAndroid.so libq3dtools_esx.so \
        libVkLayer_ADRENO_qprofiler.so; do
        if [ "$n" = libGLESv2_adreno.so ]; then fake_lib "$r/$d/egl/$n" "$v" $b; else fake_lib "$r/$d/egl/$n" - $b; fi
    done
    fake_lib "$r/$d/hw/vulkan.adreno.so" - $b
    for n in libgsl.so libllvm-glnext.so libCB.so libkcl.so libadreno_app_profiles.so libllvm-qgl.so; do
        fake_lib "$r/$d/$n" - $b
    done
    mkdir -p "$r/firmware"
    printf 'sqe %s\n' "$v" > "$r/firmware/a660_sqe.fw"
}

# a fresh device: stock V@0530.0 in /vendor, KernelSU, nothing else
device() {
    rm -rf "$T/root" "$T/props"
    R="$T/root"
    mkdir -p "$R/data/adb/modules" "$R/data/adb/modules_update" "$R/data/adb/ksu" "$R/data/k4gpu/store" \
        "$R/data/k4gpu/incoming" "$R/vendor/etc/permissions" "$R/vendor/k4gpu" "$R/vendor/firmware"
    for n in libGLESv2_adreno.so libEGL_adreno.so libGLESv1_CM_adreno.so eglSubDriverAndroid.so libq3dtools_adreno.so \
        libq3dtools_esx.so; do
        if [ "$n" = libGLESv2_adreno.so ]; then fake_lib "$R/vendor/lib64/egl/$n" V@0530.0; else fake_lib "$R/vendor/lib64/egl/$n" -; fi
    done
    fake_lib "$R/vendor/lib64/hw/vulkan.adreno.so" -
    for n in libgsl.so libllvm-glnext.so libCB.so libkcl.so libOpenCL.so; do fake_lib "$R/vendor/lib64/$n" -; done
    printf 'stock sqe\n' > "$R/vendor/firmware/a660_sqe.fw"
    echo '<feature name="android.hardware.vulkan.version" version="4198400" />' > "$R/vendor/etc/permissions/android.hardware.vulkan.version-1_1.xml"
    echo '<feature name="android.hardware.vulkan.version" version="4206592" />' > "$R/vendor/k4gpu/vulkan.version-1_3.xml"
    echo "ro.k4.gpu_drivers=530 849 863" > "$T/props"
    echo "persist.sys.k4.gpu_driver=530" >> "$T/props"
    echo "persist.sys.k4.gpu_trial=ok" >> "$T/props"
}

# KernelSU 4.x layout: <id>/vendor/... + system/vendor -> ../vendor
ksu_module() {
    local dir="$1" id="$2" v="$3"
    mkdir -p "$R/data/adb/$dir/$id/system"
    printf 'id=%s\nname=%s driver\nversion=1\nversionCode=1\n' "$id" "$id" > "$R/data/adb/$dir/$id/module.prop"
    fake_set "$R/data/adb/$dir/$id/vendor" "$v" "${4:-}"
    ln -s ../vendor "$R/data/adb/$dir/$id/system/vendor"
}

# Magisk layout: <id>/system/vendor/...
magisk_module() {
    mkdir -p "$R/data/adb/modules/$1/system/vendor" "$R/data/adb/magisk"
    printf 'id=%s\n' "$1" > "$R/data/adb/modules/$1/module.prop"
    fake_set "$R/data/adb/modules/$1/system/vendor" "$2"
}

# what Settings stages for "Add driver"
staged() {
    local d="$R/data/k4gpu/incoming/$1"
    fake_set "$d" "$2"
    printf 'version=%s\nname=%s\n' "$2" "$3" > "$d/info"
    [ "${4:-}" = noready ] || : > "$d/ready"
}

prop() {
    awk -v k="$1" 'index($0, k "=") == 1 { v = substr($0, length(k) + 2) } END { print v }' "$T/props"
}

setp() { echo "$1=$2" >> "$T/props"; }

# boot: a new boot (sys.* properties are gone, persist.* stay), then the script as init runs it
boot() {
    grep -v '^sys\.' "$T/props" > "$T/props.n"; mv "$T/props.n" "$T/props"
    : > "$T/mounts"
    K4GPU_ROOT="$R" K4GPU_PROPFILE="$T/props" K4GPU_FAKEMOUNT="$T/mounts" K4GPU_NOLABEL=1 K4GPU_KMSG=/dev/null \
        "$SH" "$SCRIPT" boot V@0530.0 > "$T/out" 2>&1
    eq "exit status" "$?" 0
    $VERBOSE && { echo "--- [$CASE] boot.log"; cat "$R/data/k4gpu/boot.log"; }
    [ -s "$T/out" ] && bad "script printed: $(head -c 300 "$T/out")"
    eq "scan" "$(prop sys.k4.gpu_scan)" 1
}

# what the early-boot rc and boot_completed then do
rc_early_boot() {
    [ "$(prop persist.sys.k4.gpu_trial)" = testing ] && { setp persist.sys.k4.gpu_failed "$(prop persist.sys.k4.gpu_driver)"; setp persist.sys.k4.gpu_driver 530; setp persist.sys.k4.gpu_trial failed; }
    [ "$(prop persist.sys.k4.gpu_trial)" = pending ] && setp persist.sys.k4.gpu_trial testing
    a="$(prop sys.k4.gpu_user_active)"; setp sys.k4.gpu_active "${a:-530}"
}
boot_completed() {
    [ "$(prop persist.sys.k4.gpu_trial)" = testing ] && setp persist.sys.k4.gpu_trial ok
}

M="$T/mounts"
L() { echo "$R/data/k4gpu/drivers"; }

CASE="nothing installed"
device; boot
eq driver "$(prop persist.sys.k4.gpu_driver)" 530
eq "no mounts" "$(wc -l < "$M")" 0
eq "empty list" "$(wc -c < "$(L)")" 0
eq root "$(prop sys.k4.gpu_root)" KernelSU
eq vendor "$(prop sys.k4.gpu_vendor)" ""

CASE="second run on the same boot"
K4GPU_ROOT="$R" K4GPU_PROPFILE="$T/props" K4GPU_FAKEMOUNT="$T/mounts" K4GPU_NOLABEL=1 "$SH" "$SCRIPT" boot V@0530.0
has log "already ran on this boot" "$R/data/k4gpu/boot.log"

CASE="built-in selected, no user driver"
device; setp persist.sys.k4.gpu_driver 849; boot
eq driver "$(prop persist.sys.k4.gpu_driver)" 849
eq "no mounts" "$(wc -l < "$M")" 0

CASE="KernelSU module, first boot (still in modules_update)"
device; setp persist.sys.k4.gpu_driver 863
ksu_module modules_update adreno_test V@0744.0
boot
S="$R/data/k4gpu/store/$(mslot adreno_test)"
eq driver "$(prop persist.sys.k4.gpu_driver)" $(mslot adreno_test)
eq trial "$(prop persist.sys.k4.gpu_trial)" pending
eq prev "$(prop persist.sys.k4.gpu_prev)" 863
eq user_active "$(prop sys.k4.gpu_user_active)" $(mslot adreno_test)
has list "$(mslot adreno_test)	module	-	V@0744.0 (module adreno_test)" "$(L)"
has egl "bind $S/egl $R/vendor/lib64/egl" "$M"
has gsl "bind $S/lib64/libgsl.so $R/vendor/lib64/libgsl.so" "$M"
has kcl "bind $S/lib64/libkcl.so $R/vendor/lib64/libkcl.so" "$M"
has vulkan "bind $S/lib64/hw/vulkan.adreno.so $R/vendor/lib64/hw/vulkan.adreno.so" "$M"
has sqe "bind $S/firmware/a660_sqe.fw $R/vendor/firmware/a660_sqe.fw" "$M"
has vk13 "bind $R/vendor/k4gpu/vulkan.version-1_3.xml" "$M"
[ -f "$S/egl/libadreno_app_profiles.so" ] && ok || bad "a library with no stock counterpart goes to egl/"
[ -f "$S/egl/libllvm-qgl.so" ] && ok || bad "libllvm-qgl.so goes to egl/"
[ -f "$S/egl/libq3dtools_adreno.so" ] && ok || bad "the stock egl library the set lacks is kept"
grep -q "V@0530" "$S/egl/libGLESv2_adreno.so" && bad "stock GLES copied over the set's" || ok
hasnt "no 530 libs bound" "libOpenCL" "$M"
rc_early_boot; boot_completed
eq "trial after boot" "$(prop persist.sys.k4.gpu_trial)" ok
eq active "$(prop sys.k4.gpu_active)" $(mslot adreno_test)

CASE="next boot: module moved to modules/, unchanged files"
mv "$R/data/adb/modules_update/adreno_test" "$R/data/adb/modules/"
boot
hasnt "no re-import" "imported" "$R/data/k4gpu/boot.log"
eq driver "$(prop persist.sys.k4.gpu_driver)" $(mslot adreno_test)
eq trial "$(prop persist.sys.k4.gpu_trial)" ok
has "mounted again" "bind $S/egl" "$M"

CASE="module updated (new files)"
fake_set "$R/data/adb/modules/adreno_test/vendor" V@0762.0
touch -d '2026-01-01' "$R/data/adb/modules/adreno_test/vendor/lib64/egl/libGLESv2_adreno.so"
setp persist.sys.k4.gpu_driver 849
boot
has "re-import" "imported V@0762.0" "$R/data/k4gpu/boot.log"
eq driver "$(prop persist.sys.k4.gpu_driver)" $(mslot adreno_test)
eq trial "$(prop persist.sys.k4.gpu_trial)" pending
eq prev "$(prop persist.sys.k4.gpu_prev)" 849
has list "V@0762.0 (module adreno_test)" "$(L)"

CASE="trial boot never completed"
rc_early_boot   # pending -> testing, then the phone hangs: no boot_completed
boot
eq driver "$(prop persist.sys.k4.gpu_driver)" 530
eq failed "$(prop persist.sys.k4.gpu_failed)" $(mslot adreno_test)
eq trial "$(prop persist.sys.k4.gpu_trial)" failed
eq "no mounts" "$(wc -l < "$M")" 0
rc_early_boot
eq "rc leaves it" "$(prop persist.sys.k4.gpu_failed)" $(mslot adreno_test)
boot
eq "not selected again" "$(prop persist.sys.k4.gpu_driver)" 530
has "still listed" "$(mslot adreno_test)" "$(L)"

CASE="user selects the module again, then uninstalls it"
setp persist.sys.k4.gpu_driver $(mslot adreno_test); setp persist.sys.k4.gpu_trial ok; setp persist.sys.k4.gpu_prev 863
boot
has mounted "bind $S/egl" "$M"
rm -rf "$R/data/adb/modules/adreno_test"
boot
eq "back to previous" "$(prop persist.sys.k4.gpu_driver)" 863
[ -d "$S" ] && bad "stored copy deleted" || ok
eq "empty list" "$(wc -c < "$(L)")" 0
eq "no mounts" "$(wc -l < "$M")" 0

CASE="module disabled"
device; ksu_module modules adreno_test V@0744.0; boot
eq driver "$(prop persist.sys.k4.gpu_driver)" $(mslot adreno_test)
: > "$R/data/adb/modules/adreno_test/disable"
boot
eq "back to previous" "$(prop persist.sys.k4.gpu_driver)" 530
eq "no mounts" "$(wc -l < "$M")" 0

CASE="module marked for removal"
device; ksu_module modules adreno_test V@0744.0; : > "$R/data/adb/modules/adreno_test/remove"; boot
eq driver "$(prop persist.sys.k4.gpu_driver)" 530
eq "empty list" "$(wc -c < "$(L)")" 0

CASE="module already mounted by a metamodule / magic mount"
device; setp persist.sys.k4.gpu_driver 849
ksu_module modules adreno_test V@0744.0
cp "$R/data/adb/modules/adreno_test/vendor/lib64/egl/libGLESv2_adreno.so" "$R/vendor/lib64/egl/libGLESv2_adreno.so"
boot
eq driver "$(prop persist.sys.k4.gpu_driver)" $(mslot adreno_test)
eq external "$(prop sys.k4.gpu_external)" $(mslot adreno_test)
eq trial "$(prop persist.sys.k4.gpu_trial)" ok
eq prev "$(prop persist.sys.k4.gpu_prev)" 849
eq "nothing mounted on top" "$(wc -l < "$M")" 0
eq user_active "$(prop sys.k4.gpu_user_active)" $(mslot adreno_test)
has list "$(mslot adreno_test)	module	external	V@0744.0 (module adreno_test)" "$(L)"
eq vendor "$(prop sys.k4.gpu_vendor)" ""
setp persist.sys.k4.gpu_driver 863   # Settings refuses this; even if it were set, the module's mount wins
boot
eq "locked" "$(prop persist.sys.k4.gpu_driver)" $(mslot adreno_test)

CASE="Magisk module"
device; magisk_module adreno_magisk V@0849.0; boot
eq root "$(prop sys.k4.gpu_root)" Magisk
eq driver "$(prop persist.sys.k4.gpu_driver)" $(mslot adreno_magisk)
has list "V@0849.0 (module adreno_magisk)" "$(L)"

CASE="module with only 32-bit libraries"
device; ksu_module modules adreno32 V@0744.0 32; boot
eq driver "$(prop persist.sys.k4.gpu_driver)" 530
eq rejected "$(prop sys.k4.gpu_rejected)" "module adreno32: only 32-bit libraries"

CASE="incomplete module"
device; ksu_module modules adreno_x V@0744.0; rm "$R/data/adb/modules/adreno_x/vendor/lib64/libgsl.so"; boot
eq driver "$(prop persist.sys.k4.gpu_driver)" 530
eq rejected "$(prop sys.k4.gpu_rejected)" "module adreno_x: missing libgsl.so"

CASE="module with a 32-bit library in lib64"
device; ksu_module modules adreno_x V@0744.0; fake_lib "$R/data/adb/modules/adreno_x/vendor/lib64/libgsl.so" - 32; boot
eq driver "$(prop persist.sys.k4.gpu_driver)" 530
eq rejected "$(prop sys.k4.gpu_rejected)" "module adreno_x: not a 64-bit ARM library: libgsl.so"

CASE="module without a version string"
device; ksu_module modules adreno_x V@0744.0; fake_lib "$R/data/adb/modules/adreno_x/vendor/lib64/egl/libGLESv2_adreno.so" -; boot
eq rejected "$(prop sys.k4.gpu_rejected)" "module adreno_x: no Adreno version string in libGLESv2_adreno.so"

CASE="not a GPU module"
device; mkdir -p "$R/data/adb/modules/other/system/bin"; boot
eq "empty list" "$(wc -c < "$(L)")" 0
eq rejected "$(prop sys.k4.gpu_rejected)" ""

CASE="driver added in Settings"
device; staged u_0849_0_abc V@0849.0 mydriver; boot
U="$R/data/k4gpu/store/u_0849_0_abc"
eq "not selected by itself" "$(prop persist.sys.k4.gpu_driver)" 530
[ -d "$R/data/k4gpu/incoming/u_0849_0_abc" ] && bad "staging dir removed" || ok
has list "u_0849_0_abc	added	-	V@0849.0 (added: mydriver)" "$(L)"
setp persist.sys.k4.gpu_driver u_0849_0_abc; setp persist.sys.k4.gpu_trial pending
boot
has mounted "bind $U/egl" "$M"
eq user_active "$(prop sys.k4.gpu_user_active)" u_0849_0_abc
rc_early_boot; boot_completed
eq trial "$(prop persist.sys.k4.gpu_trial)" ok

CASE="stored driver damaged"
f="$(ls "$U"/lib64/*.so | head -n 1)"; printf 'x' >> "$f"
boot
eq driver "$(prop persist.sys.k4.gpu_driver)" 530
eq missing "$(prop sys.k4.gpu_missing)" u_0849_0_abc
eq "no mounts" "$(wc -l < "$M")" 0

CASE="added driver selected before the restart (staged), incomplete"
device; staged u_bad V@0849.0 broken; rm "$R/data/k4gpu/incoming/u_bad/lib64/libllvm-glnext.so"
setp persist.sys.k4.gpu_driver u_bad; setp persist.sys.k4.gpu_trial pending
boot
eq driver "$(prop persist.sys.k4.gpu_driver)" 530
eq missing "$(prop sys.k4.gpu_missing)" u_bad
eq rejected "$(prop sys.k4.gpu_rejected)" "broken: missing libllvm-glnext.so"
[ -e "$R/data/k4gpu/store/u_bad" ] && bad "nothing stored" || ok

CASE="staging never finished (no ready)"
device; staged u_half V@0849.0 half noready; boot
[ -e "$R/data/k4gpu/incoming/u_half" ] && bad "half-staged dir removed" || ok
eq "empty list" "$(wc -c < "$(L)")" 0

CASE="remove an added driver"
device; staged u_a V@0849.0 a; boot
: > "$R/data/k4gpu/incoming/u_a.remove"
boot
[ -e "$R/data/k4gpu/store/u_a" ] && bad "stored files deleted" || ok
[ -e "$R/data/k4gpu/incoming/u_a.remove" ] && bad "request consumed" || ok
eq "empty list" "$(wc -c < "$(L)")" 0

CASE="hide a module"
device; ksu_module modules adreno_test V@0744.0; boot
setp persist.sys.k4.gpu_driver 530   # Settings moves the selection away when it hides the selected entry
: > "$R/data/k4gpu/incoming/$(mslot adreno_test).hide"
boot
eq "empty list" "$(wc -c < "$(L)")" 0
[ -e "$R/data/k4gpu/store/$(mslot adreno_test)" ] && bad "stored copy deleted" || ok
boot
hasnt "not imported again" "imported" "$R/data/k4gpu/boot.log"
eq driver "$(prop persist.sys.k4.gpu_driver)" 530
rm -rf "$R/data/adb/modules/adreno_test"; boot
eq "forgotten when uninstalled" "$(wc -c < "$R/data/k4gpu/hidden")" 0
ksu_module modules adreno_test V@0744.0; boot
eq "listed again after a new install" "$(prop persist.sys.k4.gpu_driver)" $(mslot adreno_test)

CASE="driver flashed into /vendor (TWRP)"
device; setp persist.sys.k4.gpu_driver 849
fake_lib "$R/vendor/lib64/egl/libGLESv2_adreno.so" V@0744.0
boot
eq vendor "$(prop sys.k4.gpu_vendor)" V@0744.0
eq driver "$(prop persist.sys.k4.gpu_driver)" 530
eq prev "$(prop persist.sys.k4.gpu_prev)" 849
setp persist.sys.k4.gpu_driver 849   # the user picks a built-in on purpose: allowed, not reset again
boot
eq driver "$(prop persist.sys.k4.gpu_driver)" 849
fake_lib "$R/vendor/lib64/egl/libGLESv2_adreno.so" V@0530.0
boot
eq "stock again" "$(prop sys.k4.gpu_vendor)" ""
eq "seen cleared" "$(prop persist.sys.k4.gpu_vendor_seen)" ""

CASE="mount fails half way"
device; ksu_module modules adreno_test V@0744.0
setp persist.sys.k4.gpu_driver $(mslot adreno_test); setp persist.sys.k4.gpu_trial ok
cat > "$T/failmount" << 'EOF'
EOF
K4GPU_FAKEMOUNT_FAIL=libgsl.so
export K4GPU_FAKEMOUNT_FAIL
boot
unset K4GPU_FAKEMOUNT_FAIL
eq driver "$(prop persist.sys.k4.gpu_driver)" 530
eq missing "$(prop sys.k4.gpu_missing)" $(mslot adreno_test)
has "undone" "umount $R/vendor/lib64/egl" "$M"
eq user_active "$(prop sys.k4.gpu_user_active)" ""

CASE="unknown selection value"
device; setp persist.sys.k4.gpu_driver 999; boot
eq driver "$(prop persist.sys.k4.gpu_driver)" 530

# ---- REVIEW1 fixes ----

CASE="M2 a module must not replace an unrelated /vendor library"
device; fake_lib "$R/vendor/lib64/libsec-ril.so" -; fake_lib "$R/vendor/lib64/libQSEEComAPI.so" -
ksu_module modules adreno_ril V@0744.0
fake_lib "$R/data/adb/modules/adreno_ril/vendor/lib64/libsec-ril.so" -
fake_lib "$R/data/adb/modules/adreno_ril/vendor/lib64/libQSEEComAPI.so" -
boot
hasnt "libsec-ril.so never bound" "/vendor/lib64/libsec-ril.so" "$M"
hasnt "libQSEEComAPI.so never bound" "/vendor/lib64/libQSEEComAPI.so" "$M"
eq "the set is rejected" "$(prop persist.sys.k4.gpu_driver)" 530
has "with an unexpected-file reason" "unexpected file:" "$R/data/k4gpu/boot.log"

CASE="M2 an unexpected library in lib64/egl is rejected too"
device; ksu_module modules adreno_e V@0744.0
fake_lib "$R/data/adb/modules/adreno_e/vendor/lib64/egl/libEGL_mali.so" -
boot
eq "rejected" "$(prop persist.sys.k4.gpu_driver)" 530
has reason "unexpected file: libEGL_mali.so" "$R/data/k4gpu/boot.log"

CASE="M2 a file in lib64/hw other than vulkan.adreno.so is rejected"
device; ksu_module modules adreno_hw V@0744.0
fake_lib "$R/data/adb/modules/adreno_hw/vendor/lib64/hw/gralloc.default.so" -
boot
eq "rejected" "$(prop persist.sys.k4.gpu_driver)" 530

CASE="M3 a library name with a space is rejected (device shell: must not break the run or re-import forever)"
device; ksu_module modules adreno_sp V@0744.0
fake_lib "$R/data/adb/modules/adreno_sp/vendor/lib64/lib extra.so" -
boot
eq "run still finishes" "$(prop sys.k4.gpu_scan)" 1
eq "rejected, stock stays" "$(prop persist.sys.k4.gpu_driver)" 530
[ -z "$(ls "$R/data/k4gpu/store" 2> /dev/null)" ] && ok || bad "a set with a whitespace name must not be stored"
boot
eq "no re-import loop (second boot clean)" "$(prop sys.k4.gpu_scan)" 1

CASE="M3 check_set fails closed (a glob character in a name is rejected, not accepted)"
device; ksu_module modules adreno_g V@0744.0
fake_lib "$R/data/adb/modules/adreno_g/vendor/lib64/lib*.so" -
boot
eq "rejected" "$(prop persist.sys.k4.gpu_driver)" 530

CASE="M3 the reviewer's bypass: a 32-bit libgsl with no version and a spaced name is NOT stored"
device; ksu_module modules adreno_bp V@0744.0
fake_lib "$R/data/adb/modules/adreno_bp/vendor/lib64/libgsl.so" - 32
fake_lib "$R/data/adb/modules/adreno_bp/vendor/lib64/egl/libGLESv2_adreno.so" -
fake_lib "$R/data/adb/modules/adreno_bp/vendor/lib64/lib x.so" -
boot
[ -z "$(ls "$R/data/k4gpu/store" 2> /dev/null)" ] && ok || bad "the poisoned set was stored"
eq "stock stays" "$(prop persist.sys.k4.gpu_driver)" 530

CASE="L7 a module that ships the stock driver (vendor symlinked to /vendor) is ignored, not auto-selected"
device; mkdir -p "$R/data/adb/modules/evil"; ln -s "$R/vendor" "$R/data/adb/modules/evil/vendor"
boot
eq "not auto-selected" "$(prop persist.sys.k4.gpu_driver)" 530
eq "nothing stored" "$(ls "$R/data/k4gpu/store" 2> /dev/null | wc -l)" 0
eq "empty list" "$(wc -c < "$(L)")" 0

CASE="L5 two ids sharing the first 30 characters get distinct slots (the hash disambiguates), no overwrite/churn"
id1="adreno.driver.very.long.name.aaa"; id2="adreno.driver.very.long.name.bbb"
device; ksu_module modules "$id1" V@0744.0; ksu_module modules "$id2" V@0762.0
boot
eq "two entries" "$(wc -l < "$(L)")" 2
n1="$(mslot "$id1")"; n2="$(mslot "$id2")"
[ "$n1" != "$n2" ] && ok || bad "slot collision"
has "slot for id1" "$n1" "$(L)"
has "slot for id2" "$n2" "$(L)"
boot
eq "no re-import on an unchanged second boot" "$(grep -c imported "$R/data/k4gpu/boot.log")" 0

CASE="L5 a hand-made module directory with an odd id (space) is skipped cleanly"
device; ksu_module modules 'drv a' V@0744.0; boot
eq "not listed" "$(wc -c < "$(L)")" 0
eq "nothing stored" "$(ls "$R/data/k4gpu/store" 2> /dev/null | wc -l)" 0

CASE="L6 a module id with a newline cannot inject lines into the drivers list (skipped, nothing stored)"
device; ksu_module modules "$(printf 'nl\nsig=x')" V@0744.0
boot
eq "run finishes" "$(prop sys.k4.gpu_scan)" 1
eq "nothing listed (no injection)" "$(wc -c < "$(L)")" 0
eq "nothing stored" "$(ls "$R/data/k4gpu/store" 2> /dev/null | wc -l)" 0

CASE="L3 a new module on a failsafe boot does not erase the undone record or auto-select"
device; setp persist.sys.k4.gpu_driver 863; setp persist.sys.k4.gpu_trial testing
ksu_module modules_update adreno_new V@0744.0
boot
eq "failed=863 kept" "$(prop persist.sys.k4.gpu_failed)" 863
eq "trial failed" "$(prop persist.sys.k4.gpu_trial)" failed
eq "stock, not the new module" "$(prop persist.sys.k4.gpu_driver)" 530
has "but the new module is listed" "$(mslot adreno_new)" "$(L)"

CASE="L4 a hidden module disabled for a boot stays hidden and does not override the user's choice when re-enabled"
device; ksu_module modules adreno_h V@0744.0; boot
setp persist.sys.k4.gpu_driver 849; : > "$R/data/k4gpu/incoming/$(mslot adreno_h).hide"; boot
eq "hidden now" "$(wc -c < "$(L)")" 0
: > "$R/data/adb/modules/adreno_h/disable"; boot
rm "$R/data/adb/modules/adreno_h/disable"; boot
eq "still hidden after re-enable" "$(wc -c < "$(L)")" 0
eq "user's choice (849) survives" "$(prop persist.sys.k4.gpu_driver)" 849

CASE="L2 an empty/unreadable ro.k4.gpu_drivers must not destroy a built-in choice"
device; grep -v '^ro.k4.gpu_drivers=' "$T/props" > "$T/p2"; mv "$T/p2" "$T/props"
setp persist.sys.k4.gpu_driver 849; boot
eq "849 kept" "$(prop persist.sys.k4.gpu_driver)" 849

CASE="M4 safe mode runs the stock driver this boot without changing the selection"
device; ksu_module modules adreno_sm V@0744.0; boot
eq "module selected" "$(prop persist.sys.k4.gpu_driver)" "$(mslot adreno_sm)"
setp persist.sys.safemode 1; boot
eq "selection unchanged" "$(prop persist.sys.k4.gpu_driver)" "$(mslot adreno_sm)"
eq "but nothing mounted this boot" "$(wc -l < "$M")" 0
eq "active reports stock" "$(prop sys.k4.gpu_user_active)" ""
device; ksu_module modules adreno_sm V@0744.0; setp persist.sys.safemode 0; boot
eq "normal boot mounts again" "$(prop sys.k4.gpu_user_active)" "$(mslot adreno_sm)"

CASE="M4 the reset prop (settable from adb shell) reverts to the stock driver on the next boot"
device; ksu_module modules adreno_rs V@0744.0; boot
setp persist.sys.k4.gpu_driver "$(mslot adreno_rs)"; setp persist.sys.k4.gpu_trial ok
setp persist.sys.k4.gpu_reset 1; boot
eq "back to stock" "$(prop persist.sys.k4.gpu_driver)" 530
eq "reset flag cleared" "$(prop persist.sys.k4.gpu_reset)" ""
eq "nothing mounted" "$(wc -l < "$M")" 0

CASE="M4 settle promotes a trial to ok only after the window with no system_server restart"
device
printf 'persist.sys.k4.gpu_trial=testing\nsys.boot_completed=1\nsys.system_server.start_count=1\n' > "$T/props"
K4GPU_ROOT="$R" K4GPU_PROPFILE="$T/props" K4GPU_KMSG=/dev/null K4GPU_SLEEP=0 "$SH" "$SCRIPT" settle 20 > /dev/null 2>&1
eq "stable -> ok" "$(prop persist.sys.k4.gpu_trial)" ok

CASE="M4 settle leaves the trial testing if system_server restarts in the window"
device
printf 'persist.sys.k4.gpu_trial=testing\nsys.boot_completed=1\nsys.system_server.start_count=1\n' > "$T/props"
( K4GPU_ROOT="$R" K4GPU_PROPFILE="$T/props" K4GPU_KMSG=/dev/null K4GPU_SLEEP=0.3 "$SH" "$SCRIPT" settle 500 > /dev/null 2>&1 ) &
SPID=$!
sleep 0.5; setp sys.system_server.start_count 2
wait $SPID
eq "crash -> still testing" "$(prop persist.sys.k4.gpu_trial)" testing

CASE="L1 best-effort: more than MAX_NEW new modules are not all imported in one boot"
device; for i in 1 2 3 4 5 6; do ksu_module modules "big$i" V@0744.0; done; boot
imp="$(grep -c imported "$R/data/k4gpu/boot.log")"
[ "$imp" -le 4 ] && ok || bad "imported $imp new modules in one boot (cap is 4)"

CASE="polish 3: the stock driver is never on trial (pending left by an older Settings)"
device; setp persist.sys.k4.gpu_driver 530; setp persist.sys.k4.gpu_trial pending; boot
eq "trial ok" "$(prop persist.sys.k4.gpu_trial)" ok
rc_early_boot
eq "rc does not turn it into testing" "$(prop persist.sys.k4.gpu_trial)" ok

CASE="polish 3: testing left on the stock driver records no failure"
device; setp persist.sys.k4.gpu_driver 530; setp persist.sys.k4.gpu_trial testing; boot
eq "trial ok" "$(prop persist.sys.k4.gpu_trial)" ok
eq "no gpu_failed=530" "$(prop persist.sys.k4.gpu_failed)" ""

CASE="polish 3: settle on the stock driver promotes at once (no 150 s window)"
device
printf 'persist.sys.k4.gpu_driver=530\npersist.sys.k4.gpu_trial=testing\nsys.boot_completed=1\n' > "$T/props"
K4GPU_ROOT="$R" K4GPU_PROPFILE="$T/props" K4GPU_KMSG=/dev/null K4GPU_SLEEP=5 timeout 4 "$SH" "$SCRIPT" settle 150 > /dev/null 2>&1
eq "ok without waiting" "$(prop persist.sys.k4.gpu_trial)" ok

CASE="polish 2: boot.log is group-writable so settle (user system) can append its result"
device; boot
eq "boot.log mode" "$(stat -c %a "$R/data/k4gpu/boot.log")" 660

CASE="polish 2: settle writes its result to boot.log and sys.k4.gpu_settle"
device; boot
printf 'persist.sys.k4.gpu_driver=u_x\npersist.sys.k4.gpu_trial=testing\nsys.boot_completed=1\nsys.system_server.start_count=1\n' > "$T/props"
K4GPU_ROOT="$R" K4GPU_PROPFILE="$T/props" K4GPU_KMSG=/dev/null K4GPU_SLEEP=0 "$SH" "$SCRIPT" settle 20 > /dev/null 2>&1
has "result in boot.log" "settle: 20s stable, trial ok" "$R/data/k4gpu/boot.log"
eq "status prop" "$(prop sys.k4.gpu_settle)" "ok: 20s stable"
printf 'persist.sys.k4.gpu_driver=u_x\npersist.sys.k4.gpu_trial=testing\nsys.boot_completed=1\nsys.system_server.start_count=1\n' > "$T/props"
( K4GPU_ROOT="$R" K4GPU_PROPFILE="$T/props" K4GPU_KMSG=/dev/null K4GPU_SLEEP=0.3 "$SH" "$SCRIPT" settle 500 > /dev/null 2>&1 ) &
SPID=$!
sleep 0.5; setp sys.system_server.start_count 2
wait $SPID
has "crash result in boot.log" "system_server restarted (1 -> 2)" "$R/data/k4gpu/boot.log"
eq "crash status prop" "$(prop sys.k4.gpu_settle)" "failed: system_server restarted (1 -> 2), trial stays testing"

echo "$PASS passed, $FAIL failed"
[ "$FAIL" = 0 ]
