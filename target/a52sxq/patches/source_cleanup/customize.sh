for f in bin/qccsyshal@1.2-service etc/init/vendor.qti.hardware.qccsyshal@1.2-service.rc lib64/vendor.qti.hardware.qccsyshal@1.2-halimpl.so; do
    # if/then, not `[ -e ] && ...`: a false test as the file's last command makes the sourced customize.sh return 1,
    # which ends the set -e build without any message
    if [ -e "$WORK_DIR/system/system/system_ext/$f" ]; then
        DELETE_FROM_WORK_DIR "system" "system/system_ext/$f"
    else
        LOG "- system_ext/$f is not in this source"
    fi
done
SET_PROP "product" "traced.relay_producer_port" --delete

# The source product build.prop sets remote_provisioning.tee.rkp_only=1 (the Fold8 KeyMint does remote key
# provisioning), which makes keystore2 refuse to fall back to the factory attestation keys: on the A52s keymaster 4.0
# there is no IRemotelyProvisionedComponent, so every attestation request died with "Failed to get rkpd key" /
# HARDWARE_TYPE_UNAVAILABLE (banking apps, Play Integrity, Knox attestation). The A52s stock product prop has no
# such line; drop it so keystore2 uses the factory (sakv2/gak) keys like stock.
SET_PROP "product" "remote_provisioning.tee.rkp_only" --delete

# The sm7325 platform patch swaps the Ex4HEXAGON hotword enrollment apps for the a73xqxx Ex3HEXAGON ones, but this
# source ships the Ex6_WIDEBAND_LARGE flavour instead, so both stay and PackageManager rejects the duplicates at
# every boot ("already installed. Skipping duplicate").
for d in HotwordEnrollmentXGoogleEx6_WIDEBAND_LARGE HotwordEnrollmentYGoogleEx6_WIDEBAND_LARGE; do
    if [ -d "$WORK_DIR/product/priv-app/$d" ] && [ -d "$WORK_DIR/product/priv-app/HotwordEnrollmentXGoogleEx3HEXAGON" ]; then
        DELETE_FROM_WORK_DIR "product" "priv-app/$d"
    fi
done

# loc_sys_service (source system_ext) is a client of the AIDL vendor.qti.gnss.ILocAidlGnss HAL that only the source
# vendor ships (vendor.qti.gnss-service). The A52s vendor is HIDL-only (android.hardware.gnss@2.1-service-qti), so it
# polls servicemanager -> init ctl.interface_start once a second for the whole uptime.
for f in bin/loc_sys_service etc/init/loc_sys_service.rc etc/permissions/com.qualcomm.qti.izattools.xml framework/com.qti.location.sdk.jar.fsv_meta; do
    if [ -e "$WORK_DIR/system/system/system_ext/$f" ]; then
        DELETE_FROM_WORK_DIR "system" "system/system_ext/$f"
    else
        LOG "- system_ext/$f is not in this source"
    fi
done
unset f d
