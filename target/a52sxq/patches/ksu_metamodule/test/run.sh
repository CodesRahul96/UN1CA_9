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
REALZIP="$HERE/../meta-overlayfs-13100-1.3.1.zip"
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

# a fresh device: KernelSU (ksud), no modules, no metamodule
device() {
    rm -rf "$T/root" "$T/props" "$T/ksud.calls" "$T/kmsg"
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
    env K4KSU_ROOT="$R" K4KSU_PROPFILE="$T/props" K4KSU_KMSG="$T/kmsg" K4KSU_ZIP="${ZIP:-$REALZIP}" \
        K4KSU_NOMAGISK="${NOMAGISK-1}" KT="$T" PATH="${XPATH:-$PATH}" "$SH" "$SCRIPT" "$@"
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

CASE="gate: turned off"
device
echo "persist.sys.k4.ksu_metamodule=0" >> "$T/props"
run gate
eq gate "$(prop sys.k4.ksu_meta_gate)" off

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
yes_ staged "$ADB/modules_update/meta-overlayfs/metamount.sh"
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

CASE="usage"
device
run bogus 2> /dev/null
eq "exit" "$?" 2

echo "k4-ksu-metamodule host test ($SH): $PASS passed, $FAIL failed"
[ "$FAIL" = 0 ]
