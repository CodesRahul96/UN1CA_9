#!/usr/bin/env bash
# Host test of k4-ksu-metamodule (the KernelSU metamodule boot hook): every scenario runs the real script against a
# fake root (K4KSU_ROOT: /data/adb), properties in a file (K4KSU_PROPFILE) and a fake ksud that behaves like ksud
# 4.2's `module install` (modules_update/<id>, modules/<id>/module.prop + update, /data/adb/metamodule link for a
# metamodule) or fails half-way. Nothing here is shipped.
# Usage: run.sh [-v]   (-v: print the script's log of every run). K4KSU_TEST_SH=<shell> runs it with another
# shell (the phone runs /system/bin/sh = mksh).
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$HERE/../k4-ksu-metamodule"
REALZIP="$HERE/../meta-overlayfs-13101-1.3.1-k4.1.zip"
SH="${K4KSU_TEST_SH:-bash}"
VERBOSE=false
[ "${1:-}" = -v ] && VERBOSE=true
T="$(mktemp -d)"
trap 'rm -rf "$T"' EXIT
PASS=0
FAIL=0

ok() { PASS=$((PASS + 1)); }
bad() { FAIL=$((FAIL + 1)); echo "FAIL [$CASE]: $*"; }
eq() { [ "$2" = "$3" ] && ok || bad "$1: expected '$3', got '$2'"; }
yes_() { [ -e "$2" ] || [ -L "$2" ] && ok || bad "$1: $2 missing"; }
no_() { [ -e "$2" ] || [ -L "$2" ] && bad "$1: $2 exists" || ok; }
prop() { awk -v k="$1" 'index($0, k "=") == 1 { v = substr($0, length(k) + 2) } END { print v }' "$T/props"; }
calls() { [ -f "$T/ksud.calls" ] && wc -l < "$T/ksud.calls" | tr -d ' ' || echo 0; }
umountadds() { [ -f "$T/umountadd.calls" ] && wc -l < "$T/umountadd.calls" | tr -d ' ' || echo 0; }
notifies() { [ -f "$T/notify.calls" ] && wc -l < "$T/notify.calls" | tr -d ' ' || echo 0; }

# fake ksud: `module install <zip>` like ksud 4.2 (install_module_to_system). FAKE_KSUD_FAIL=1: dies after the
# extraction, before module.prop / the link (an installer script that aborted).
cat > "$T/ksud" << 'EOF'
#!/usr/bin/env bash
echo "$*" >> "$KT/ksud.calls"
[ "$1 $2" = "module install" ] || exit 2
ADB="$K4KSU_ROOT/data/adb"
id="$(unzip -p "$3" module.prop | sed -n 's/^id=//p')"
mkdir -p "$ADB/modules_update/$id" || exit 1
(cd "$ADB/modules_update/$id" && unzip -q -o "$3") || exit 1
[ -n "${FAKE_KSUD_FAIL:-}" ] && { echo "! Failed to install module script"; exit 1; }
# FAKE_KSUD_IMG=1: the metamodule's customize.sh made its modules image (here a directory, K4KSU_FAKEIMG)
[ -n "${FAKE_KSUD_IMG:-}" ] && { : > "$ADB/modules_update/$id/modules.img"; mkdir -p "$ADB/modules_update/$id/mnt"; }
mkdir -p "$ADB/modules/$id"
cp "$ADB/modules_update/$id/module.prop" "$ADB/modules/$id/module.prop"
touch "$ADB/modules/$id/update"
if grep -q -x 'metamodule=1' "$ADB/modules_update/$id/module.prop"; then
    rm -rf "$ADB/metamodule"
    ln -s "$ADB/modules/$id" "$ADB/metamodule"
fi
echo "- Module installed successfully!"
EOF
chmod 755 "$T/ksud"

# recorders for register_module_umounts' two kernel actions (K4KSU_UMOUNT_ADD / K4KSU_NOTIFY_MOUNTED): each appends,
# so the test can see which mount points went on the per-app umount list and that the kernel was notified
cat > "$T/umountadd-rec" << 'EOF'
#!/usr/bin/env bash
echo "$*" >> "$KT/umountadd.calls"
EOF
cat > "$T/notify-rec" << 'EOF'
#!/usr/bin/env bash
echo notified >> "$KT/notify.calls"
EOF
chmod 755 "$T/umountadd-rec" "$T/notify-rec"

# a fresh device: KernelSU (ksud), no modules, no metamodule
device() {
    rm -rf "$T/root" "$T/props" "$T/ksud.calls" "$T/kmsg" "$T/mountinfo"
    R="$T/root"
    ADB="$R/data/adb"
    mkdir -p "$ADB/modules" "$ADB/modules_update" "$ADB/ksu/bin"
    cp "$T/ksud" "$ADB/ksud"
    : > "$T/props"
}

# a module: <dir modules|modules_update> <id> [metamodule value]
module() {
    mkdir -p "$ADB/$1/$2/system/etc"
    printf 'id=%s\nname=%s\nversion=1\nversionCode=1\n' "$2" "$2" > "$ADB/$1/$2/module.prop"
    [ -n "${3:-}" ] && echo "metamodule=$3" >> "$ADB/$1/$2/module.prop"
    echo "file of $2" > "$ADB/$1/$2/system/etc/$2.txt"
}

# an installed meta-overlayfs metamodule with versionCode <vc> (the unmodified 1.3.1 is 13100)
meta_installed() {
    mkdir -p "$ADB/modules/meta-overlayfs"
    printf 'id=meta-overlayfs\nmetamodule=1\nname=OverlayFS MetaModule\nversion=x\nversionCode=%s\n' "$1" \
        > "$ADB/modules/meta-overlayfs/module.prop"
    echo "old metamount" > "$ADB/modules/meta-overlayfs/metamount.sh"
    ln -s "$ADB/modules/meta-overlayfs" "$ADB/metamodule"
}

# the phone's next boot: ksud's post-fs-data moves modules_update/<id> over modules/<id> and prunes "remove"
next_boot() {
    for u in "$ADB"/modules_update/*; do
        [ -d "$u" ] || continue
        rm -rf "$ADB/modules/${u##*/}"
        mv "$u" "$ADB/modules/${u##*/}"
    done
    for m in "$ADB"/modules/*; do
        [ -f "$m/remove" ] || continue
        if grep -q -x 'metamodule=1' "$m/module.prop" && [ -L "$ADB/metamodule" ]; then rm -f "$ADB/metamodule"; fi
        rm -rf "$m"
    done
    rm -f "$ADB/modules/"*/update 2> /dev/null
    sed -i '/^sys\./d' "$T/props"
}

run() {
    : > "$T/kmsg"
    rm -f "$T/umountadd.calls" "$T/notify.calls"
    [ -f "$T/mountinfo" ] || : > "$T/mountinfo"
    env K4KSU_ROOT="$R" K4KSU_PROPFILE="$T/props" K4KSU_KMSG="$T/kmsg" K4KSU_ZIP="${ZIP:-$REALZIP}" \
        K4KSU_NOMAGISK="${NOMAGISK-1}" K4KSU_BUSYBOX="${BBOX-}" K4KSU_FAKEIMG=1 \
        K4KSU_GPU_DRIVER="${GPU:-$T/none/k4-gpu-driver}" KT="$T" PATH="${XPATH:-$PATH}" \
        K4KSU_UMOUNT_ADD="$T/umountadd-rec" K4KSU_NOTIFY_MOUNTED="$T/notify-rec" \
        K4KSU_MOUNTINFO="$T/mountinfo" \
        "$SH" "$SCRIPT" "$@"
    local rc=$?
    if $VERBOSE; then sed "s/^/    [$CASE] /" "$T/kmsg"; fi
    return $rc
}

tree_sum() { (cd "$1" && find . -type f -exec sha1sum {} + | LC_ALL=C sort | sha1sum); }

# ---------------------------------------------------------------------------------------------------------------
CASE="gate: KernelSU"
device
run gate
eq gate "$(prop sys.k4.ksu_meta_gate)" ksu

CASE="gate: no ksud (Magisk / stock)"
device
rm -f "$ADB/ksud"
run gate
eq gate "$(prop sys.k4.ksu_meta_gate)" none

CASE="gate: turned off (apply still runs: the metamodule part is off, the GPU driver guard script is not)"
device
echo "persist.sys.k4.ksu_metamodule=0" >> "$T/props"
run gate
eq gate "$(prop sys.k4.ksu_meta_gate)" ksu

CASE="fresh KernelSU: installs, mounted from the next boot"
device
module modules plain_mod
before="$(tree_sum "$ADB/modules/plain_mod")"
run apply
eq status "$(prop sys.k4.ksu_meta)" installed
eq "ksud calls" "$(calls)" 1
eq "ksud args" "$(cat "$T/ksud.calls")" "module install $REALZIP"
yes_ link "$ADB/metamodule"
eq "link target" "$(readlink "$ADB/metamodule")" "$ADB/modules/meta-overlayfs"
# completed at once (nothing pending: ksud would block every other module install until a reboot)
yes_ "in place" "$ADB/modules/meta-overlayfs/metamount.sh"
no_ "nothing staged" "$ADB/modules_update/meta-overlayfs"
no_ "no update marker" "$ADB/modules/meta-overlayfs/update"
eq seen "$(cat "$ADB/.k4_metamodule_seen")" meta-overlayfs
no_ tries "$ADB/.k4_metamodule_tries"
no_ optout "$ADB/.k4_metamodule_optout"
eq "other module untouched" "$(tree_sum "$ADB/modules/plain_mod")" "$before"
grep -q "installed" "$ADB/.k4_metamodule.log" && ok || bad "log"
# same boot again (property retrigger): nothing new
run apply
eq "status again" "$(prop sys.k4.ksu_meta)" active
eq "no second install" "$(calls)" 1
next_boot
run apply
eq "next boot" "$(prop sys.k4.ksu_meta)" active
eq "still one install" "$(calls)" 1
yes_ moved "$ADB/modules/meta-overlayfs/metamount.sh"

CASE="user uninstalls our metamodule: opt-out, never again"
touch "$ADB/modules/meta-overlayfs/remove"
run apply
eq "pending removal still counts" "$(prop sys.k4.ksu_meta)" active
next_boot
no_ gone "$ADB/modules/meta-overlayfs"
run apply
eq status "$(prop sys.k4.ksu_meta)" optout
yes_ optout "$ADB/.k4_metamodule_optout"
eq "optout reason" "$(cat "$ADB/.k4_metamodule_optout")" "removed meta-overlayfs"
eq "no reinstall" "$(calls)" 1
next_boot
run apply
eq "later boot" "$(prop sys.k4.ksu_meta)" optout
eq "still no reinstall" "$(calls)" 1

CASE="re-arm with persist.sys.k4.ksu_metamodule=1"
echo "persist.sys.k4.ksu_metamodule=1" >> "$T/props"
run apply
eq status "$(prop sys.k4.ksu_meta)" installed
eq "installed again" "$(calls)" 2
eq "prop back to automatic" "$(prop persist.sys.k4.ksu_metamodule)" ""
no_ optout "$ADB/.k4_metamodule_optout"

CASE="user's own metamodule (link): never touched"
device
module modules mountify 1
ln -s "$ADB/modules/mountify" "$ADB/metamodule"
before="$(tree_sum "$ADB/modules/mountify")"
run apply
eq status "$(prop sys.k4.ksu_meta)" other:mountify
eq "no install" "$(calls)" 0
eq seen "$(cat "$ADB/.k4_metamodule_seen")" mountify
eq "untouched" "$(tree_sum "$ADB/modules/mountify")" "$before"
eq "link untouched" "$(readlink "$ADB/metamodule")" "$ADB/modules/mountify"

CASE="switching metamodules: the boot in between stands down"
touch "$ADB/modules/mountify/remove"
next_boot
run apply
eq status "$(prop sys.k4.ksu_meta)" optout
eq "optout reason" "$(cat "$ADB/.k4_metamodule_optout")" "removed mountify"
eq "no install" "$(calls)" 0
module modules_update meta-hybrid 1
ln -s "$ADB/modules/meta-hybrid" "$ADB/metamodule"
mkdir -p "$ADB/modules/meta-hybrid" && cp "$ADB/modules_update/meta-hybrid/module.prop" "$ADB/modules/meta-hybrid/"
run apply
eq "new one" "$(prop sys.k4.ksu_meta)" other:meta-hybrid
eq "no install" "$(calls)" 0

CASE="metamodule without the link (metamodule=TRUE in modules_update)"
device
module modules_update meta-x " TRUE"
run apply
eq status "$(prop sys.k4.ksu_meta)" other:meta-x
eq "no install" "$(calls)" 0

CASE="disabled metamodule still counts"
device
module modules meta-mm 1
touch "$ADB/modules/meta-mm/disable"
run apply
eq status "$(prop sys.k4.ksu_meta)" other:meta-mm
eq "no install" "$(calls)" 0

CASE="metamodule=0 is a regular module"
device
module modules notmeta 0
run apply
eq status "$(prop sys.k4.ksu_meta)" installed
eq "installed" "$(calls)" 1

CASE="dangling /data/adb/metamodule link (like ksud: no metamodule)"
device
ln -s "$ADB/modules/vanished" "$ADB/metamodule"
run apply
eq status "$(prop sys.k4.ksu_meta)" installed
eq "link replaced by ksud" "$(readlink "$ADB/metamodule")" "$ADB/modules/meta-overlayfs"

CASE="plain directory at /data/adb/metamodule"
device
mkdir -p "$ADB/metamodule"
run apply
eq status "$(prop sys.k4.ksu_meta)" other:metamodule
eq "no install" "$(calls)" 0

CASE="turned off"
device
echo "persist.sys.k4.ksu_metamodule=0" >> "$T/props"
run apply
eq status "$(prop sys.k4.ksu_meta)" off
eq "no install" "$(calls)" 0
no_ seen "$ADB/.k4_metamodule_seen"

CASE="no KernelSU"
device
rm -f "$ADB/ksud"
run apply
eq status "$(prop sys.k4.ksu_meta)" none
eq "no install" "$(calls)" 0

CASE="unmodified meta-overlayfs 1.3.1 installed: updated in place to the K4 build, nothing pending"
device
meta_installed 13100
m="$ADB/modules/meta-overlayfs"
echo image > "$m/modules.img"; mkdir -p "$m/mnt/plain_mod"; echo f > "$m/mnt/plain_mod/f"
echo oldbin > "$m/meta-overlayfs"; chmod 755 "$m/meta-overlayfs" "$m/metamount.sh"
module modules plain_mod
before="$(tree_sum "$ADB/modules/plain_mod")"
run apply
eq status "$(prop sys.k4.ksu_meta)" updated
eq "no ksud install" "$(calls)" 0
for f in metainstall.sh metamount.sh module.prop K4_CHANGES.txt metauninstall.sh post-mount.sh uninstall.sh; do
    unzip -p "$REALZIP" "$f" | cmp -s - "$m/$f" && ok || bad "$f is not the zip's"
done
unzip -p "$REALZIP" meta-overlayfs-aarch64 | cmp -s - "$m/meta-overlayfs" && ok || bad "binary not the zip's aarch64 one"
eq "binary mode" "$(stat -c %a "$m/meta-overlayfs")" 755
eq "script mode kept" "$(stat -c %a "$m/metamount.sh")" 755
no_ "no customize.sh" "$m/customize.sh"
no_ "no arch binaries" "$m/meta-overlayfs-aarch64"
eq "image untouched" "$(cat "$m/modules.img")" image
eq "image content untouched" "$(cat "$m/mnt/plain_mod/f")" f
no_ "nothing staged" "$ADB/modules_update/meta-overlayfs"
no_ "no update marker" "$m/update"
no_ "no temp" "$ADB/.k4_metamodule.tmp"
eq "link kept" "$(readlink "$ADB/metamodule")" "$m"
eq "other module untouched" "$(tree_sum "$ADB/modules/plain_mod")" "$before"
grep -q "updated from 13100 to 13101 in place" "$ADB/.k4_metamodule.log" && ok || bad "log"
run apply
eq "same boot again" "$(prop sys.k4.ksu_meta)" active
next_boot
run apply
eq "next boot" "$(prop sys.k4.ksu_meta)" active
eq "K4 build in place" "$(sed -n 's/^versionCode=//p' "$ADB/modules/meta-overlayfs/module.prop")" 13101
eq "never a ksud install" "$(calls)" 0

CASE="newer meta-overlayfs (the user's own update): left alone"
device
meta_installed 13200
run apply
eq status "$(prop sys.k4.ksu_meta)" active
eq "no install" "$(calls)" 0

CASE="old meta-overlayfs disabled / marked for removal / update pending: not updated"
for mark in disable remove pending; do
    device
    meta_installed 13100
    if [ $mark = pending ]; then mkdir -p "$ADB/modules_update/meta-overlayfs"; else touch "$ADB/modules/meta-overlayfs/$mark"; fi
    run apply
    eq "$mark status" "$(prop sys.k4.ksu_meta)" active
    eq "$mark no install" "$(calls)" 0
done

CASE="in-place update fails (module directory not writable): the installed one stays, at most 3 tries"
device
meta_installed 13100
chmod 555 "$ADB/modules/meta-overlayfs"
before="$(tree_sum "$ADB/modules/meta-overlayfs")"
for i in 1 2 3; do
    run apply
    eq "status $i" "$(prop sys.k4.ksu_meta)" active
    eq "tries $i" "$(cat "$ADB/.k4_metamodule_tries")" "$i"
    eq "installed untouched $i" "$(tree_sum "$ADB/modules/meta-overlayfs")" "$before"
    no_ "no temp $i" "$ADB/.k4_metamodule.tmp"
    next_boot
done
run apply
eq "4th boot" "$(prop sys.k4.ksu_meta)" active
grep -q "failed 3 times" "$ADB/.k4_metamodule.log" && ok || bad "not tried a 4th time"
chmod 755 "$ADB/modules/meta-overlayfs"

CASE="update: zip not the pinned build"
device
meta_installed 13100
cp "$REALZIP" "$T/other.zip" && printf 'x' >> "$T/other.zip"
ZIP="$T/other.zip" run apply
eq status "$(prop sys.k4.ksu_meta)" active
eq "no install" "$(calls)" 0

CASE="Magisk in PATH"
device
mkdir -p "$T/mbin" && printf '#!/bin/sh\n' > "$T/mbin/magisk" && chmod 755 "$T/mbin/magisk"
NOMAGISK="" XPATH="$T/mbin:$PATH" run apply
eq status "$(prop sys.k4.ksu_meta)" magisk
eq "no install" "$(calls)" 0

CASE="safe mode"
device
echo "persist.sys.safemode=1" >> "$T/props"
run apply
eq status "$(prop sys.k4.ksu_meta)" safemode
eq "no install" "$(calls)" 0

CASE="zip not the pinned build"
device
cp "$REALZIP" "$T/other.zip" && printf 'x' >> "$T/other.zip"
ZIP="$T/other.zip" run apply
eq status "$(prop sys.k4.ksu_meta)" failed
eq "no install" "$(calls)" 0
ZIP="$T/missing.zip" run apply
eq "missing zip" "$(prop sys.k4.ksu_meta)" failed
eq "no install" "$(calls)" 0

CASE="a non-metamodule module named meta-overlayfs"
device
module modules meta-overlayfs
run apply
eq status "$(prop sys.k4.ksu_meta)" conflict
eq "no install" "$(calls)" 0

CASE="ksud install fails: cleaned up, at most 3 tries"
device
module modules plain_mod
before="$(tree_sum "$ADB/modules")"
for i in 1 2 3; do
    FAKE_KSUD_FAIL=1 run apply
    eq "status $i" "$(prop sys.k4.ksu_meta)" failed
    eq "calls $i" "$(calls)" "$i"
    no_ "staged $i" "$ADB/modules_update/meta-overlayfs"
    no_ "link $i" "$ADB/metamodule"
    eq "tries $i" "$(cat "$ADB/.k4_metamodule_tries")" "$i"
    next_boot
done
eq "modules untouched" "$(tree_sum "$ADB/modules")" "$before"
FAKE_KSUD_FAIL=1 run apply
eq "4th boot" "$(prop sys.k4.ksu_meta)" failed
eq "not tried a 4th time" "$(calls)" 3
echo "persist.sys.k4.ksu_metamodule=1" >> "$T/props"
run apply
eq "re-armed retry" "$(prop sys.k4.ksu_meta)" installed
eq "retried" "$(calls)" 4
no_ tries "$ADB/.k4_metamodule_tries"

# --- modules installed before the metamodule: imported into the image ------------------------------------------
# an installed K4 meta-overlayfs with its image (a directory here, K4KSU_FAKEIMG) and the mount script
meta_with_image() {
    meta_installed "${1:-13101}"
    if [ "${1:-13101}" = 13101 ]; then
        for f in metainstall.sh metamount.sh module.prop K4_CHANGES.txt metauninstall.sh post-mount.sh uninstall.sh; do
            unzip -p "$REALZIP" "$f" > "$ADB/modules/meta-overlayfs/$f"
        done
        unzip -p "$REALZIP" meta-overlayfs-aarch64 > "$ADB/modules/meta-overlayfs/meta-overlayfs"
    fi
    : > "$ADB/modules/meta-overlayfs/modules.img"
    mkdir -p "$ADB/modules/meta-overlayfs/mnt"
    MNT="$ADB/modules/meta-overlayfs/mnt"
}
# an Adreno driver module (<lib dir under the module>, e.g. vendor/lib64)
gpu_mod() {
    mkdir -p "$ADB/modules/$1/$2/egl"
    printf 'id=%s\nname=%s\nversionCode=1\n' "$1" "$1" > "$ADB/modules/$1/module.prop"
    echo gles > "$ADB/modules/$1/$2/egl/libGLESv2_adreno.so"
    mkdir -p "$ADB/modules/$1/system"
}

CASE="import: a module installed before the metamodule is copied into the image"
device
meta_with_image
module modules plain_mod
mkdir -p "$ADB/modules/plain_mod/vendor/etc" "$ADB/modules/plain_mod/product/app"
echo v > "$ADB/modules/plain_mod/vendor/etc/v.conf"; echo p > "$ADB/modules/plain_mod/product/app/p.apk"
ln -s ../vendor "$ADB/modules/plain_mod/system/vendor"
echo "#!/system/bin/sh" > "$ADB/modules/plain_mod/service.sh"
before="$(tree_sum "$ADB/modules/plain_mod")"
run apply
eq status "$(prop sys.k4.ksu_meta)" active
eq import "$(prop sys.k4.ksu_meta_import)" plain_mod
eq "system copied" "$(cat "$MNT/plain_mod/system/etc/plain_mod.txt")" "file of plain_mod"
eq "vendor copied" "$(cat "$MNT/plain_mod/vendor/etc/v.conf")" v
eq "product copied" "$(cat "$MNT/plain_mod/product/app/p.apk")" p
eq "system/vendor link kept" "$(readlink "$MNT/plain_mod/system/vendor")" ../vendor
no_ "only partition directories" "$MNT/plain_mod/service.sh"
no_ "no module.prop in the image" "$MNT/plain_mod/module.prop"
no_ "no temp" "$MNT/.k4import.plain_mod"
eq "module untouched" "$(tree_sum "$ADB/modules/plain_mod")" "$before"
eq "no ksud call" "$(calls)" 0
grep -q "import: plain_mod (installed before the metamodule) copied" "$ADB/.k4_metamodule.log" && ok || bad "log"
img="$(tree_sum "$MNT")"
run apply
eq "idempotent: nothing more" "$(prop sys.k4.ksu_meta_import)" none
eq "idempotent: image unchanged" "$(tree_sum "$MNT")" "$img"
next_boot
run apply
eq "next boot: nothing more" "$(prop sys.k4.ksu_meta_import)" none

CASE="import: a module already in the image is never touched"
device
meta_with_image
module modules plain_mod
mkdir -p "$MNT/plain_mod/system/etc" && echo "metainstall copy" > "$MNT/plain_mod/system/etc/plain_mod.txt"
run apply
eq import "$(prop sys.k4.ksu_meta_import)" none
eq "copy untouched" "$(cat "$MNT/plain_mod/system/etc/plain_mod.txt")" "metainstall copy"

CASE="import: modules metainstall.sh would not copy are skipped"
device
meta_with_image
for x in disabled removed skipmount pending; do module modules "m_$x"; done
touch "$ADB/modules/m_disabled/disable" "$ADB/modules/m_removed/remove" "$ADB/modules/m_skipmount/skip_mount"
touch "$ADB/modules/m_pending/update"; module modules_update m_pending
module modules nosys && rm -rf "$ADB/modules/nosys/system" && mkdir -p "$ADB/modules/nosys/vendor/etc"
module modules otherid && mv "$ADB/modules/otherid" "$ADB/modules/_bad"
module modules noprop && rm -f "$ADB/modules/noprop/module.prop"
gpu_mod gpu64 vendor/lib64
gpu_mod gpu32sys system/vendor/lib
module modules keep
run apply
eq "only the plain one" "$(prop sys.k4.ksu_meta_import)" keep
for x in m_disabled m_removed m_skipmount m_pending nosys _bad noprop gpu64 gpu32sys meta-overlayfs; do
    no_ "$x not imported" "$MNT/$x"
done
yes_ "keep imported" "$MNT/keep/system/etc/keep.txt"
# enabled later: imported on that boot, mounted from the next
rm -f "$ADB/modules/m_disabled/disable"
run apply
eq "re-enabled module" "$(prop sys.k4.ksu_meta_import)" m_disabled

CASE="import: system/vendor left inside system/ (Mountify / Magic Mount layout) is moved out like KernelSU's installer"
device
meta_with_image
mkdir -p "$R/vendor/etc" "$R/system"
ln -s ../product "$R/system_ext"   # a partition that is a link: left inside system/
module modules mfy_mod
mkdir -p "$ADB/modules/mfy_mod/system/vendor/etc" "$ADB/modules/mfy_mod/system/system_ext/etc"
ln -s ./system/vendor "$ADB/modules/mfy_mod/vendor"   # what Mountify's metainstall.sh adds
echo x > "$ADB/modules/mfy_mod/system/vendor/etc/x.conf"
echo y > "$ADB/modules/mfy_mod/system/system_ext/etc/y.conf"
before="$(tree_sum "$ADB/modules/mfy_mod")"
run apply
eq import "$(prop sys.k4.ksu_meta_import)" mfy_mod
eq "moved to vendor/" "$(cat "$MNT/mfy_mod/vendor/etc/x.conf")" x
eq "link left in system/" "$(readlink "$MNT/mfy_mod/system/vendor")" ../vendor
[ -d "$MNT/mfy_mod/vendor" ] && [ ! -L "$MNT/mfy_mod/vendor" ] && ok || bad "Mountify's vendor link not replaced by the directory"
eq "system_ext (a link on the device) stays" "$(cat "$MNT/mfy_mod/system/system_ext/etc/y.conf")" y
eq "module untouched" "$(tree_sum "$ADB/modules/mfy_mod")" "$before"

CASE="import: failed copy - nothing half-done, not retried until reinstalled"
device
meta_with_image
mkdir -p "$R/vendor"
module modules both_mod
mkdir -p "$ADB/modules/both_mod/system/vendor/etc" "$ADB/modules/both_mod/vendor/etc"
module modules ok_mod
run apply
eq import "$(prop sys.k4.ksu_meta_import)" "ok_mod; failed: both_mod"
no_ "not imported" "$MNT/both_mod"
no_ "no temp" "$MNT/.k4import.both_mod"
yes_ "the other one is" "$MNT/ok_mod/system"
run apply
eq "not retried" "$(prop sys.k4.ksu_meta_import)" "failed: both_mod"
grep -c "both_mod" "$ADB/.k4_metamodule_import_failed" | grep -q -x 1 && ok || bad "recorded once"
rm -rf "$ADB/modules/both_mod/vendor"
cp -a "$ADB/modules/both_mod" "$ADB/modules/both_mod.new" && rm -rf "$ADB/modules/both_mod" && mv "$ADB/modules/both_mod.new" "$ADB/modules/both_mod"
run apply
eq "reinstalled: retried" "$(prop sys.k4.ksu_meta_import)" both_mod
if [ "$(id -u)" != 0 ]; then
    module modules unreadable && chmod 000 "$ADB/modules/unreadable/system/etc/unreadable.txt"
    run apply 2> /dev/null
    eq "unreadable file" "$(prop sys.k4.ksu_meta_import)" "failed: unreadable"
    no_ "no temp" "$MNT/.k4import.unreadable"
    no_ "not imported" "$MNT/unreadable"
    chmod 644 "$ADB/modules/unreadable/system/etc/unreadable.txt"
fi

CASE="import: a leftover temp copy of an interrupted run is removed and redone"
device
meta_with_image
module modules plain_mod
mkdir -p "$MNT/.k4import.plain_mod/system" && echo half > "$MNT/.k4import.plain_mod/system/half"
run apply
eq import "$(prop sys.k4.ksu_meta_import)" plain_mod
no_ "temp gone" "$MNT/.k4import.plain_mod"
no_ "half file not in the copy" "$MNT/plain_mod/system/half"

CASE="import: not while meta-overlayfs is disabled / marked for removal / pending, or without its image"
for mark in disable remove pending noimage; do
    device
    meta_with_image
    module modules plain_mod
    case $mark in
        pending) mkdir -p "$ADB/modules_update/meta-overlayfs" ;;
        noimage) rm -f "$ADB/modules/meta-overlayfs/modules.img" ;;
        *) touch "$ADB/modules/meta-overlayfs/$mark" ;;
    esac
    run apply
    no_ "$mark: not imported" "$MNT/plain_mod"
done

CASE="import: another metamodule (Mountify) - nothing imported"
device
module modules mountify 1
ln -s "$ADB/modules/mountify" "$ADB/metamodule"
module modules plain_mod
run apply
eq status "$(prop sys.k4.ksu_meta)" other:mountify
eq import "$(prop sys.k4.ksu_meta_import)" ""

CASE="import: right after a fresh install of the metamodule (mounted from the next boot, its first)"
device
module modules plain_mod
FAKE_KSUD_IMG=1 run apply
eq status "$(prop sys.k4.ksu_meta)" installed
eq import "$(prop sys.k4.ksu_meta_import)" plain_mod
yes_ "in the new image" "$ADB/modules/meta-overlayfs/mnt/plain_mod/system/etc/plain_mod.txt"

CASE="import: after the in-place update of the unmodified 1.3.1"
device
meta_with_image 13100
echo "old metamount" > "$ADB/modules/meta-overlayfs/metamount.sh"
module modules plain_mod
run apply
eq status "$(prop sys.k4.ksu_meta)" updated
eq import "$(prop sys.k4.ksu_meta_import)" plain_mod

CASE="import: runs under ksud's busybox when there is one"
device
meta_with_image
module modules plain_mod
printf '#!/usr/bin/env bash\necho "$*" >> "%s/bb.calls"\n[ "$1" = sh ] && shift\nexec bash "$@"\n' "$T" > "$T/busybox"
chmod 755 "$T/busybox"
BBOX="$T/busybox" run apply
eq import "$(prop sys.k4.ksu_meta_import)" plain_mod
grep -q -x "sh $SCRIPT import" "$T/bb.calls" && ok || bad "busybox not used: $(cat "$T/bb.calls" 2> /dev/null)"
rm -f "$T/bb.calls"

CASE="import: label functions identical to meta-overlayfs-k4/metainstall.sh"
for fn in copy_selinux_contexts k4_dir_labels; do
    a="$(sed -n "/^$fn() {/,/^}/p" "$SCRIPT")"
    b="$(sed -n "/^$fn() {/,/^}/p" "$HERE/../meta-overlayfs-k4/metainstall.sh")"
    [ -n "$a" ] && [ "$a" = "$b" ] && ok || bad "$fn differs from metainstall.sh"
done

# --- hide the module mounts from apps (register_module_umounts, runs at the end of every apply) -------------------
CASE="hide: image mount + live KSU overlays go on the per-app umount list, kernel notified, after the import"
device
meta_with_image
module modules plain_mod
cat > "$T/mountinfo" << 'EOF'
38 37 253:0 / / ro,relatime shared:1 - erofs /dev/block/dm-0 ro,seclabel
287 38 0:38 / /system rw,relatime shared:48 - overlay KSU ro,seclabel,lowerdir=/data/adb/modules/meta-overlayfs/mnt/plain_mod/system:/system
290 38 0:40 / /vendor rw,relatime shared:49 - overlay KSU ro,seclabel,lowerdir=/data/adb/modules/meta-overlayfs/mnt/plain_mod/vendor:/vendor
301 38 0:41 / /data/x rw,relatime shared:50 - overlay other ro,seclabel,lowerdir=/foo
EOF
run apply
eq status "$(prop sys.k4.ksu_meta)" active
eq import "$(prop sys.k4.ksu_meta_import)" plain_mod
# the image mount and both KSU overlays, not the non-KSU overlay
eq "image + 2 overlays added" "$(umountadds)" 3
grep -q -x -F "$ADB/modules/meta-overlayfs/mnt" "$T/umountadd.calls" && ok || bad "image mount not added: $(cat "$T/umountadd.calls" 2> /dev/null)"
grep -q -x -F /system "$T/umountadd.calls" && ok || bad "/system not added"
grep -q -x -F /vendor "$T/umountadd.calls" && ok || bad "/vendor not added"
grep -q -x -F /data/x "$T/umountadd.calls" && bad "non-KSU overlay added" || ok
eq "kernel notified once" "$(notifies)" 1
grep -q "registered 3 module mount point" "$ADB/.k4_metamodule.log" && ok || bad "no register log line"
# the import must have run before the register (one superblock: the image is loop-mounted only once a boot)
awk '/import: plain_mod/ { i = NR } /registered 3 module mount point/ { d = NR } END { exit !(i && d && i < d) }' \
    "$ADB/.k4_metamodule.log" && ok || bad "register ran before the import"

CASE="hide: nothing registered when our image is not mounted"
device
meta_installed 13101
printf '287 38 0:38 / /system rw,relatime shared:48 - overlay KSU ro,seclabel,lowerdir=/x:/system\n' > "$T/mountinfo"
run apply
eq status "$(prop sys.k4.ksu_meta)" active
eq "no umount-add" "$(umountadds)" 0
eq "no notify" "$(notifies)" 0

CASE="hide: image mounted but no overlays yet - only the image is registered, kernel still notified"
device
meta_with_image
run apply
eq "only the image" "$(umountadds)" 1
grep -q -x -F "$ADB/modules/meta-overlayfs/mnt" "$T/umountadd.calls" && ok || bad "image mount not added"
eq "kernel notified" "$(notifies)" 1

CASE="hide: another metamodule (Mountify) - we register nothing (our image is not mounted)"
device
module modules mountify 1
ln -s "$ADB/modules/mountify" "$ADB/metamodule"
run apply
eq status "$(prop sys.k4.ksu_meta)" other:mountify
eq "no umount-add" "$(umountadds)" 0
eq "no notify" "$(notifies)" 0

CASE="hide: also with persist.sys.k4.ksu_metamodule=0 (the module still mounts itself, so still hidden)"
device
meta_with_image
echo "persist.sys.k4.ksu_metamodule=0" >> "$T/props"
run apply
eq status "$(prop sys.k4.ksu_meta)" off
eq "image still registered" "$(umountadds)" 1
eq "kernel still notified" "$(notifies)" 1

# --- GPU driver guard script in ksud's post-fs-data.d -------------------------------------------------------------
GSH() { echo "$ADB/post-fs-data.d/k4_gpu_driver_guard.sh"; }
: > "$T/k4-gpu-driver"

CASE="guard script: written on a ROM with the GPU driver selector, runs its guard"
device
GPU="$T/k4-gpu-driver" run apply
eq status "$(prop sys.k4.ksu_meta)" installed
yes_ "written" "$(GSH)"
eq "mode" "$(stat -c %a "$(GSH)")" 755
eq "dir mode" "$(stat -c %a "$ADB/post-fs-data.d")" 755
eq "runs the guard" "$(tail -n 1 "$(GSH)")" "exec /system/bin/sh \"$T/k4-gpu-driver\" guard"
grep -q -x -F "[ -f \"$T/k4-gpu-driver\" ] || exit 0" "$(GSH)" && ok || bad "no ROM check"
head -n 1 "$(GSH)" | grep -q -x '#!/system/bin/sh' && ok || bad "shebang"
grep -q "GPU driver guard written" "$ADB/.k4_metamodule.log" && ok || bad "log"
no_ "no temp" "$(GSH).k4new"
touch -d @1000000000 "$(GSH)"
GPU="$T/k4-gpu-driver" run apply
eq "unchanged: not rewritten" "$(stat -c %Y "$(GSH)")" 1000000000
grep -q "GPU driver guard written" "$ADB/.k4_metamodule.log" && bad "rewritten" || ok
echo "# changed" >> "$(GSH)"
GPU="$T/k4-gpu-driver" run apply
grep -q "# changed" "$(GSH)" && bad "not restored" || ok
chmod 644 "$(GSH)"
GPU="$T/k4-gpu-driver" run apply
eq "not executable: restored" "$(stat -c %a "$(GSH)")" 755

CASE="guard script: other scripts in post-fs-data.d and the directory's mode are left alone"
device
mkdir -p "$ADB/post-fs-data.d" && chmod 700 "$ADB/post-fs-data.d" && echo mine > "$ADB/post-fs-data.d/user.sh"
GPU="$T/k4-gpu-driver" run apply
yes_ "written" "$(GSH)"
eq "dir mode kept" "$(stat -c %a "$ADB/post-fs-data.d")" 700
eq "user script kept" "$(cat "$ADB/post-fs-data.d/user.sh")" mine

CASE="guard script: never through a link"
device
mkdir -p "$T/elsewhere" && ln -s "$T/elsewhere" "$ADB/post-fs-data.d"
GPU="$T/k4-gpu-driver" run apply
no_ "nothing written through the link" "$T/elsewhere/k4_gpu_driver_guard.sh"
rm -f "$ADB/post-fs-data.d" && mkdir -p "$ADB/post-fs-data.d" && ln -s "$T/elsewhere/x" "$(GSH)"
GPU="$T/k4-gpu-driver" run apply
no_ "link target not created" "$T/elsewhere/x"

CASE="guard script: also with persist.sys.k4.ksu_metamodule=0 (metamodule part off) and an opt-out"
device
echo "persist.sys.k4.ksu_metamodule=0" >> "$T/props"
GPU="$T/k4-gpu-driver" run apply
eq status "$(prop sys.k4.ksu_meta)" off
yes_ "written" "$(GSH)"
eq "no install" "$(calls)" 0
device
echo "removed meta-overlayfs" > "$ADB/.k4_metamodule_optout"
GPU="$T/k4-gpu-driver" run apply
eq status "$(prop sys.k4.ksu_meta)" optout
yes_ "written" "$(GSH)"

CASE="guard script: not without the selector, KernelSU, in safe mode or with Magisk"
device
GPU="$T/no-such-k4-gpu-driver" run apply
no_ "no selector" "$(GSH)"
device; rm -f "$ADB/ksud"
GPU="$T/k4-gpu-driver" run apply
no_ "no KernelSU" "$(GSH)"
device; echo "persist.sys.safemode=1" >> "$T/props"
GPU="$T/k4-gpu-driver" run apply
no_ "safe mode" "$(GSH)"
device
mkdir -p "$T/mbin" && printf '#!/bin/sh\n' > "$T/mbin/magisk" && chmod 755 "$T/mbin/magisk"
GPU="$T/k4-gpu-driver" NOMAGISK="" XPATH="$T/mbin:$PATH" run apply
no_ "Magisk" "$(GSH)"

CASE="usage"
device
run bogus 2> /dev/null
eq "exit" "$?" 2

echo "k4-ksu-metamodule host test ($SH): $PASS passed, $FAIL failed"
[ "$FAIL" = 0 ]
