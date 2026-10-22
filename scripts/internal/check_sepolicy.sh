#!/usr/bin/env bash
#
# Compiles the split SELinux policy of the work dir the way init does at boot (secilc on plat + mapping + system_ext
# + product + vendor + odm CIL), so a patch that adds a rule naming a missing type, duplicating a declaration or
# breaking the syntax fails the build here instead of bootlooping the phone. init compiles with -N (neverallows are not
# enforced), so this does too.
#
# secilc is not built by build_dependencies.sh: set SECILC, or it is looked up in PATH and in an AOSP out dir
# (~/git/android/out/host/linux-x86/bin/secilc). Without it the check is skipped with a warning.

# shellcheck disable=SC1091

set -eu

source "$SRC_DIR/scripts/utils/build_utils.sh" || exit 1

SECILC="${SECILC:-}"
if [ -z "$SECILC" ]; then
    SECILC="$(command -v secilc 2> /dev/null || true)"
fi
if [ -z "$SECILC" ] && [ -x "$HOME/git/android/out/host/linux-x86/bin/secilc" ]; then
    SECILC="$HOME/git/android/out/host/linux-x86/bin/secilc"
fi
if [ -z "$SECILC" ] || [ ! -x "$SECILC" ]; then
    LOGW "secilc not found (set SECILC), the SELinux policy is not checked"
    exit 0
fi

SYS="$WORK_DIR/system/system"
VERS_FILE="$WORK_DIR/vendor/etc/selinux/plat_sepolicy_vers.txt"
[ -f "$VERS_FILE" ] || { LOGE "No vendor plat_sepolicy_vers.txt"; exit 1; }
VER="$(head -n 1 "$VERS_FILE" | tr -d "[:space:]")"

# FIND_PART <path under the partition root> for system_ext/product: their own partition or inside /system
FIND_PART()
{
    local p
    for p in "$WORK_DIR/$1" "$SYS/$1"; do
        [ -f "$p" ] && echo "$p" && return 0
    done
    return 0
}

ARGS=("$SYS/etc/selinux/plat_sepolicy.cil" "$SYS/etc/selinux/mapping/$VER.cil")
[ -f "$SYS/etc/selinux/mapping/$VER.compat.cil" ] && ARGS+=("$SYS/etc/selinux/mapping/$VER.compat.cil")
for f in system_ext/etc/selinux/system_ext_sepolicy.cil "system_ext/etc/selinux/mapping/$VER.cil" \
    product/etc/selinux/product_sepolicy.cil "product/etc/selinux/mapping/$VER.cil"; do
    p="$(FIND_PART "$f")"
    [ -n "$p" ] && ARGS+=("$p")
done
for f in vendor/etc/selinux/plat_pub_versioned.cil vendor/etc/selinux/vendor_sepolicy.cil odm/etc/selinux/odm_sepolicy.cil; do
    [ -f "$WORK_DIR/$f" ] && ARGS+=("$WORK_DIR/$f")
done
for f in "${ARGS[@]:0:2}"; do
    [ -f "$f" ] || { LOGE "Missing ${f//$WORK_DIR\//}"; exit 1; }
done

OUT="$(mktemp -d)"
trap 'rm -rf "$OUT"' EXIT
if ! "$SECILC" -m -M true -G -N -c 30 "${ARGS[@]}" -o "$OUT/policy" -f /dev/null > "$OUT/log" 2>&1; then
    LOGE "The SELinux policy does not compile (init would fail at boot):"
    tail -n 20 "$OUT/log" >&2
    exit 1
fi
LOG "- SELinux policy compiles (${#ARGS[@]} CIL files, vendor $VER, $(stat -c %s "$OUT/policy") bytes)"

exit 0
