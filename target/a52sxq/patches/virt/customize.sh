VIRT_APEX="$WORK_DIR/system/system/apex/com.android.virt.apex"

# The source virt APEX has an erofs payload (magic e2e1f5e0 at 1024) the 5.4 kernel can't mount. Rebuild it; an ext4
# payload (magic 53ef at 1080) signed with our test key is the output of an earlier run. Anything else (compressed
# .capex, other payload, other key) would ship an APEX that fails to mount or still carries the VM runtime: ABORT.
VIRT_STATE="none"
if [ -f "$VIRT_APEX" ]; then
    VIRT_HDR="$(unzip -p "$VIRT_APEX" apex_payload.img 2> /dev/null | head -c 1082 | xxd -p | tr -d "\n" || true)"
    VIRT_PUBKEY="$(mktemp)"
    EVAL "avbtool extract_public_key --key \"$SRC_DIR/security/avb/testkey_rsa4096.pem\" --output \"$VIRT_PUBKEY\"" || ABORT "virt: avbtool failed"
    if [[ "${VIRT_HDR:2048:8}" == "e2e1f5e0" ]]; then
        VIRT_STATE="erofs"
    elif [[ "${VIRT_HDR:2160:4}" == "53ef" ]] && unzip -p "$VIRT_APEX" apex_pubkey 2> /dev/null | cmp -s - "$VIRT_PUBKEY"; then
        VIRT_STATE="rebuilt"
    else
        VIRT_STATE="unknown"
    fi
    rm -f "$VIRT_PUBKEY"
fi
if [ "$VIRT_STATE" == "unknown" ]; then
    ABORT "virt: com.android.virt.apex payload is neither the source erofs image nor our ext4 rebuild"
fi
if [ -e "$WORK_DIR/system/system/apex/com.android.virt.capex" ]; then
    ABORT "virt: the source ships a compressed com.android.virt.capex, which this patch does not handle"
fi
if [ "$VIRT_STATE" == "none" ]; then
    LOG "- No com.android.virt.apex in this source, nothing to rebuild"
elif [ "$VIRT_STATE" == "rebuilt" ]; then
    LOG "- com.android.virt.apex already has the framework-only ext4 payload"
fi
if [ "$VIRT_STATE" == "erofs" ]; then
    LOG_STEP_IN "- Rebuilding com.android.virt with a framework-only ext4 payload"
    [ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"
    EVAL "apktool d -j \"$(nproc)\" -o \"$TMP_DIR\" -r \"$VIRT_APEX\""

    MNT="$TMP_DIR/tmp_out"
    PAY="$TMP_DIR/unknown/apex_payload"
    mkdir -p "$MNT" "$PAY"
    EVAL "fuse.erofs \"$TMP_DIR/unknown/apex_payload.img\" \"$MNT\""
    EVAL "cp -a -T \"$MNT\" \"$PAY\""

    # VirtualizationSystemService (apex-system-service in this APEX's manifest, so SystemServer always starts it)
    # calls ServiceManager.waitForService("android.system.virtualizationmaintenance") on system_server's shared
    # android.bg (BackgroundThread) for every full app uninstall / user removal, and from the daily SecretkeeperJob.
    # virtualizationservice is dropped below, so that wait never returns and android.bg is wedged until reboot.
    # checkService() returns null instead -> IllegalStateException, which both callers already catch and log.
    SVJ="$PAY/javalib/service-virtualization.jar"
    EVAL "apktool d -f -o \"$TMP_DIR/svj\" \"$SVJ\""
    sed -i "s|Landroid/os/ServiceManager;->waitForService(Ljava/lang/String;)Landroid/os/IBinder;|Landroid/os/ServiceManager;->checkService(Ljava/lang/String;)Landroid/os/IBinder;|" \
        "$TMP_DIR/svj/smali/com/android/system/virtualmachine/VirtualizationSystemService.smali"
    grep -q "waitForService" -r "$TMP_DIR/svj/smali" && ABORT "service-virtualization.jar still calls waitForService"
    EVAL "apktool b -o \"$SVJ\" \"$TMP_DIR/svj\""
    rm -rf "$TMP_DIR/svj"
    EVAL "find \"$MNT\" | xargs -I \"{}\" -P \"$(nproc)\" stat -c \"%n %u %g %a capabilities=0x0\" \"{}\" > \"$TMP_DIR/unknown/fs_config-apex_payload\""
    EVAL "find \"$MNT\" | xargs -I \"{}\" -P \"$(nproc)\" sh -c 'echo \"\$1 \$(getfattr -n security.selinux --only-values -h --absolute-names \"\$1\")\"' \"sh\" \"{}\" > \"$TMP_DIR/unknown/file_context-apex_payload\""
    EVAL "fusermount3 -u \"$MNT\""
    rmdir "$MNT"
    rm -f "$TMP_DIR/unknown/apex_payload.img"
    sed -i -e "s|$MNT |/ |g" -e "s|$MNT||g" "$TMP_DIR/unknown/file_context-apex_payload"
    sed -i -e "s|\.|\\\.|g" -e "s|\+|\\\+|g" -e "s|\[|\\\[|g" -e "s|\]|\\\]|g" -e "s|\*|\\\*|g" "$TMP_DIR/unknown/file_context-apex_payload"
    sed -i -e "s|$MNT | |g" -e "s|$MNT/||g" "$TMP_DIR/unknown/fs_config-apex_payload"

    # Drop the VM runtime (crosvm, microdroid images, services); keep jars, JNI libs, classpath/aconfig/sysconfig, res app
    for p in bin priv-app app/EmptyPayloadApp etc/fs etc/vintf etc/microdroid.json etc/microdroid_initrd_debuggable.img \
            etc/microdroid_initrd_normal.img etc/service_vm.bin etc/u-boot.bin etc/vfio_handler.rc \
            etc/virtualizationservice.rc etc/vmnic.rc; do
        rm -rf "${PAY:?}/$p"
        P_RE="$(sed -e "s|\.|\\\\\\\\.|g" <<< "$p")"
        sed -i -e "\|^$p\( \|/\)|d" "$TMP_DIR/unknown/fs_config-apex_payload"
        sed -i -e "\|^/$P_RE\( \|/\)|d" "$TMP_DIR/unknown/file_context-apex_payload"
    done
    find "$PAY" -name "EmptyPayloadApp*" -exec rm -rf {} + 2> /dev/null
    sed -i "/EmptyPayloadApp/d" "$TMP_DIR/unknown/fs_config-apex_payload" "$TMP_DIR/unknown/file_context-apex_payload"

    sort -o "$TMP_DIR/unknown/fs_config-apex_payload" "$TMP_DIR/unknown/fs_config-apex_payload"
    sort -o "$TMP_DIR/unknown/file_context-apex_payload" "$TMP_DIR/unknown/file_context-apex_payload"
    "$SRC_DIR/scripts/build_fs_image.sh" "ext4" --no-avb -o "$TMP_DIR/unknown/apex_payload.img" -p "system" \
        "$PAY" "$TMP_DIR/unknown/file_context-apex_payload" "$TMP_DIR/unknown/fs_config-apex_payload" \
        > /dev/null || ABORT "Failed to build com.android.virt apex_payload.img"
    rm -rf "$PAY" "$TMP_DIR/unknown/file_context-apex_payload" "$TMP_DIR/unknown/fs_config-apex_payload"

    SALT="$(sha256sum "$TMP_DIR/unknown/apex_manifest.pb" | cut -d " " -f 1)"
    EVAL "avbtool add_hashtree_footer --do_not_generate_fec --algorithm \"SHA256_RSA4096\" --hash_algorithm \"sha256\" --key \"$SRC_DIR/security/avb/testkey_rsa4096.pem\" --prop \"apex.key:com.android.virt\" --salt \"$SALT\" --image \"$TMP_DIR/unknown/apex_payload.img\""
    EVAL "avbtool extract_public_key --key \"$SRC_DIR/security/avb/testkey_rsa4096.pem\" --output \"$TMP_DIR/unknown/apex_pubkey\""

    mkdir -p "$TMP_DIR/build/apk"
    cp -a "$TMP_DIR/original/META-INF" "$TMP_DIR/build/apk/META-INF"
    EVAL "apktool b -j \"$(nproc)\" \"$TMP_DIR\""
    mv -f "$TMP_DIR/dist/$(basename "$VIRT_APEX")" "$VIRT_APEX"
    CERT_PREFIX="aosp"
    $ROM_IS_OFFICIAL && CERT_PREFIX="unica"
    EVAL "signapk -a 4096 --align-file-size \"$SRC_DIR/security/${CERT_PREFIX}_platform.x509.pem\" \"$SRC_DIR/security/${CERT_PREFIX}_platform.pk8\" \"$VIRT_APEX\" \"$VIRT_APEX.signed\""
    mv -f "$VIRT_APEX.signed" "$VIRT_APEX"
    rm -rf "$TMP_DIR"
    unset MNT PAY P_RE SALT CERT_PREFIX SVJ
    LOG_STEP_OUT
fi
unset VIRT_APEX VIRT_STATE VIRT_HDR VIRT_PUBKEY

# SystemServer starts IsolatedCompilationService (com.android.compos) when this is true -> ClassNotFoundException
# crash, since compos is debloated along with AVF
SET_PROP "system_ext" "ro.config.isolated_compilation_enabled" "false"
