#!/usr/bin/env bash
#
# Runs ART's class verifier (host dex2oat, --compiler-filter=verify) on every APK/JAR apktool rebuilt, against the
# ROM's own boot class path, and fails the build on hard verification failures that the same file does not already
# have in stock firmware: those throw VerifyError on device (in system_server: a bootloop, 9.3.74). apktool
# assembles such code without complaint. See verify_dex.py for how class loaders and the stock baseline are built.
#
# dex2oat is not built by build_dependencies.sh: set DEX2OAT, or it is looked up in PATH and in an AOSP out dir
# (~/git/android/out/host/linux-x86/bin/dex2oat64 or dex2oatd64). Without it the check is skipped with a warning.
# DEX_VERIFY=false skips the check. Results and unpacked APEX jars are cached in DEX_VERIFY_CACHE
# (default: out/dex_verify).

# shellcheck disable=SC1091

set -eu

source "$SRC_DIR/scripts/utils/build_utils.sh" || exit 1

if [[ "${DEX_VERIFY:-true}" == "false" ]]; then
    LOGW "DEX_VERIFY=false, the rebuilt dex files are not verified"
    exit 0
fi

DEX2OAT="${DEX2OAT:-}"
if [ -z "$DEX2OAT" ]; then
    for t in dex2oat64 dex2oat dex2oatd64 dex2oatd; do
        DEX2OAT="$(command -v "$t" 2> /dev/null || true)"
        [ -n "$DEX2OAT" ] && break
    done
fi
if [ -z "$DEX2OAT" ]; then
    for t in dex2oat64 dex2oatd64; do
        if [ -x "$HOME/git/android/out/host/linux-x86/bin/$t" ]; then
            DEX2OAT="$HOME/git/android/out/host/linux-x86/bin/$t"
            break
        fi
    done
fi
if [ -z "$DEX2OAT" ] || [ ! -x "$DEX2OAT" ]; then
    LOGW "dex2oat not found (set DEX2OAT), the rebuilt dex files are not verified"
    exit 0
fi

SOURCE_FIRMWARE_PATH="$(cut -d "/" -f 1 -s <<< "$SOURCE_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$SOURCE_FIRMWARE")"
TARGET_FIRMWARE_PATH="$(cut -d "/" -f 1 -s <<< "$TARGET_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$TARGET_FIRMWARE")"

python3 "$SRC_DIR/scripts/internal/verify_dex.py" \
    --dex2oat "$DEX2OAT" \
    --rom "$WORK_DIR" \
    --stock "$FW_DIR/$SOURCE_FIRMWARE_PATH" \
    --stock "$FW_DIR/$TARGET_FIRMWARE_PATH" \
    --apktool-dir "$APKTOOL_DIR" \
    --cache "${DEX_VERIFY_CACHE:-$OUT_DIR/dex_verify}" \
    --report "${DEX_VERIFY_CACHE:-$OUT_DIR/dex_verify}/last_report.json"
