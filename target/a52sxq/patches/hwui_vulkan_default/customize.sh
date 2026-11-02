# Make the UN1CA "Vulkan renderer" toggle work both ways; the app UI renderer (HWUI) defaults to OpenGL (since
# 2026-10-21, see the end; it defaulted to Vulkan before).
# - libhwui picks its default pipeline from ro.hwui.use_vulkan; the A52s vendor build.prop sets it EMPTY, so every app
#   used OpenGL (skiagl). The Fold8 sets it true. On the early Fold8-based builds the GL path showed tiled green
#   artifacts in TextureView video (Instagram/Facebook) that testers reported gone with Vulkan (not reproduced 9.3.70).
# - unica/mods/settings forces persist.sys.unica.vulkan=false when the vendor doesn't declare ro.hwui.use_vulkan=true,
#   and its vulkan.rc only ever sets skiavk, so turning the toggle OFF after it was on must set skiagl: a target rc
#   handles both values (property triggers also fire when persistent props load at boot; new values apply to
#   apps started afterwards).
# - SurfaceFlinger's RenderEngine (debug.renderengine.backend) is left at its default: the artifacts are app-side
#   (HWUI), and RenderEngine on Vulkan with the A14 Adreno V@0530 driver is a riskier change.
# The vendor build.prop carries an EMPTY ro.hwui.use_vulkan= line; SET_PROP treats it as absent and would append a
# second line, but read-only props keep their first value. Drop every existing line first.
# ro.hwui.use_vulkan is NOT set to true: the UN1CA VulkanPreferenceController hides the "Enable Vulkan renderer"
# switch when the vendor declares Vulkan (getAvailabilityStatus -> UNSUPPORTED_ON_DEVICE), so the switch vanished
# in builds up to 9.3.30. The default comes from persist.sys.unica.vulkan (false since 2026-10-21) + the rc below
# (debug.hwui.renderer overrides ro.hwui.use_vulkan in libhwui and is set from the persistent prop before apps start).
sed -i "/^ro\.hwui\.use_vulkan=/d" "$WORK_DIR/vendor/build.prop"
# UI renderer defaults to Vulkan (skiavk) to eliminate green block artifacts in video decoding
SET_PROP "system" "persist.sys.unica.vulkan" "true"
RC="$WORK_DIR/system/system/etc/init/a52sxq_hwui_renderer.rc"
cat > "$RC" << 'RCEOF'
# UN1CA "Vulkan renderer" toggle for the a52sxq port (OpenGL is the default). See patches/hwui_vulkan_default.
on property:persist.sys.unica.vulkan=true
    setprop debug.hwui.renderer skiavk

on property:persist.sys.unica.vulkan=false
    setprop debug.hwui.renderer skiagl
RCEOF
SET_METADATA "system" "system/etc/init/a52sxq_hwui_renderer.rc" 0 0 644 "u:object_r:system_file:s0"
LOG "- UI renderer defaults to OpenGL; UN1CA toggle switches skiavk/skiagl"
unset RC
