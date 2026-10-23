# The Fold8 system (the first source) shipped without HIDL; the S26 Ultra has a system_ext hwservicemanager again,
# which the AOSP copy below replaces. On the Fold8: /system/bin/hwservicemanager is a dangling
# symlink and the framework manifest lacks android.hidl.*. The A52s vendor (FCM 5) is
# almost entirely HIDL, so bring back the AOSP CP2A.260605.016 pieces from ichthys32.
ICHTHYS32="$SRC_DIR/prebuilts/ichthys32"
SYS_EXT="$WORK_DIR/system/system/system_ext"
$TARGET_OS_BUILD_SYSTEM_EXT_PARTITION && SYS_EXT="$WORK_DIR/system_ext"
# pinned: every file and symlink exactly as reviewed (prebuilts/ichthys32/SHA256SUMS + SYMLINKS), nothing else
(cd "$ICHTHYS32" && sha256sum --quiet --strict -c SHA256SUMS) || ABORT "ichthys32 does not match prebuilts/ichthys32/SHA256SUMS"
[ "$(cd "$ICHTHYS32" && find . -type f ! -name SOURCE.txt ! -name SHA256SUMS ! -name SYMLINKS | sed 's|^\./||' | LC_ALL=C sort)" = \
    "$(sed 's/^[0-9a-f]*  //' "$ICHTHYS32/SHA256SUMS" | LC_ALL=C sort)" ] || ABORT "ichthys32 has files that are not in SHA256SUMS"
[ "$(cd "$ICHTHYS32" && find . -type l -printf "%P -> %l\n" | LC_ALL=C sort)" = "$(LC_ALL=C sort "$ICHTHYS32/SYMLINKS")" ] || \
    ABORT "ichthys32 symlinks differ from prebuilts/ichthys32/SYMLINKS"

ADD_TO_WORK_DIR "$ICHTHYS32" "system_ext" "bin/hwservicemanager" 0 2000 755 "u:object_r:hwservicemanager_exec:s0"
ADD_TO_WORK_DIR "$ICHTHYS32" "system_ext" "etc/init/hwservicemanager.rc" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$ICHTHYS32" "system_ext" "bin/hw/android.hidl.allocator@1.0-service" 0 2000 755 "u:object_r:hal_allocator_default_exec:s0"
ADD_TO_WORK_DIR "$ICHTHYS32" "system_ext" "etc/init/android.hidl.allocator@1.0-service.rc" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$ICHTHYS32" "system_ext" "etc/vintf/manifest/android.hidl.allocator@1.0-service.xml" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$ICHTHYS32" "system_ext" "lib64/hw/android.hidl.memory@1.0-impl.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$ICHTHYS32" "system_ext" "lib/hw/android.hidl.memory@1.0-impl.so" 0 0 644 "u:object_r:system_lib_file:s0"

# ADD_FRAMEWORK_HAL <manifest> <name> <hal xml>
ADD_FRAMEWORK_HAL()
{
    if grep -q "<name>$2</name>" "$1"; then
        return 0
    fi
    LOG "- Declaring $2 in ${1//$WORK_DIR/}"
    python3 - "$1" "$3" <<'PYEOF' || ABORT "Failed to patch ${1//$WORK_DIR/}"
import sys
path, hal = sys.argv[1:]
s = open(path).read()
i = s.rindex("</manifest>")
open(path, "w").write(s[:i] + hal + "\n" + s[i:])
PYEOF
}

ADD_FRAMEWORK_HAL "$SYS_EXT/etc/vintf/manifest.xml" "android.hidl.manager" '    <hal format="hidl" max-level="8">
        <name>android.hidl.manager</name>
        <transport>hwbinder</transport>
        <fqname>@1.2::IServiceManager/default</fqname>
    </hal>'
ADD_FRAMEWORK_HAL "$SYS_EXT/etc/vintf/manifest.xml" "android.hidl.token" '    <hal format="hidl" max-level="8">
        <name>android.hidl.token</name>
        <transport>hwbinder</transport>
        <fqname>@1.0::ITokenManager/default</fqname>
    </hal>'
ADD_FRAMEWORK_HAL "$WORK_DIR/system/system/etc/vintf/manifest.xml" "android.hidl.memory" '    <hal format="hidl" max-level="8">
        <name>android.hidl.memory</name>
        <transport arch="32+64">passthrough</transport>
        <fqname>@1.0::IMapper/ashmem</fqname>
    </hal>'

unset ICHTHYS32 SYS_EXT
unset -f ADD_FRAMEWORK_HAL
