#!/sbin/sh
# UN1CA 9 Post-Install Permanent Fixes
# Runs inside recovery (TWRP/OrangeFox) after image flashing

# Mount /data if not mounted
if ! grep -q " /data " /proc/mounts; then
    mount /data 2>/dev/null || mount -t f2fs /dev/block/bootdevice/by-name/userdata /data 2>/dev/null || mount -t ext4 /dev/block/bootdevice/by-name/userdata /data 2>/dev/null
fi

if [ -d "/data" ]; then
    # 1. Create KernelSU / data directories
    mkdir -p /data/adb/post-fs-data.d
    mkdir -p /data/adb/service.d
    mkdir -p /data/adb/modules/unica_fixes/system/priv-app/SecSettings

    # 2. Install permanent SecSettings (UN1CA 9 logo & search crash fix)
    if [ -f "/tmp/SecSettings.apk" ]; then
        cp -f /tmp/SecSettings.apk /data/adb/SecSettings.apk
        cp -f /tmp/SecSettings.apk /data/adb/modules/unica_fixes/system/priv-app/SecSettings/SecSettings.apk
        chmod 644 /data/adb/SecSettings.apk /data/adb/modules/unica_fixes/system/priv-app/SecSettings/SecSettings.apk
    fi

    # 3. KernelSU Module metadata
    cat << 'EOF' > /data/adb/modules/unica_fixes/module.prop
id=unica_fixes
name=UN1CA 9 Fixes & Branding
version=1.0
versionCode=1
author=CodesRahul96
description=Permanent UN1CA 9 branding logo and Settings search fix
EOF
    touch /data/adb/modules/unica_fixes/auto_mount
    chmod 755 /data/adb/modules/unica_fixes

    # 4. Bind-mount boot scripts (guarantees persistence across reboots)
    cat << 'EOF' > /data/adb/post-fs-data.d/01_unica_fixes.sh
#!/system/bin/sh
if [ -f /data/adb/SecSettings.apk ]; then
    mount --bind /data/adb/SecSettings.apk /system/priv-app/SecSettings/SecSettings.apk
fi
EOF
    chmod 755 /data/adb/post-fs-data.d/01_unica_fixes.sh

    cat << 'EOF' > /data/adb/service.d/01_unica_fixes.sh
#!/system/bin/sh
if [ -f /data/adb/SecSettings.apk ]; then
    mount --bind /data/adb/SecSettings.apk /system/priv-app/SecSettings/SecSettings.apk
fi
EOF
    chmod 755 /data/adb/service.d/01_unica_fixes.sh

    # 5. Play Integrity certified Pixel 5 profile (no USB/adbd conflicts)
    if [ -f "/tmp/pif.prop" ]; then
        cp -f /tmp/pif.prop /data/adb/pif.prop
        chmod 644 /data/adb/pif.prop
    fi
    if [ -f "/tmp/pif.json" ]; then
        cp -f /tmp/pif.json /data/adb/pif.json
        chmod 644 /data/adb/pif.json
    fi

    # 6. Pre-add and install BakaSU root manager out-of-the-box
    if [ -f "/tmp/BakaSU.apk" ]; then
        cp -f /tmp/BakaSU.apk /data/adb/BakaSU.apk
        chmod 644 /data/adb/BakaSU.apk

        cat << 'EOF' > /data/adb/service.d/00_install_bakasu.sh
#!/system/bin/sh
# Wait for Android Package Manager service on boot
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 2
done
sleep 3
if ! pm list packages | grep -q com.resukisu.resukisu; then
    pm install -r -g /data/adb/BakaSU.apk
fi
EOF
        chmod 755 /data/adb/service.d/00_install_bakasu.sh
    fi

    sync
fi

exit 0
