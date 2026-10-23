# Ensure /sys/class/power_supply/battery/batt_capacity_max is set to 1000
# so scaled capacity reflects true raw SoC instead of clamping to 100%.
RC="$WORK_DIR/system/system/etc/init/a52sxq_battery_scaling.rc"
cat > "$RC" << 'RCEOF'
# Galaxy A52s 5G battery capacity scaling fix
# Set batt_capacity_max to 1000 so scaled capacity reflects true raw battery percentage
on boot
    write /sys/class/power_supply/battery/batt_capacity_max 1000

on property:sys.boot_completed=1
    write /sys/class/power_supply/battery/batt_capacity_max 1000
RCEOF
SET_METADATA "system" "system/etc/init/a52sxq_battery_scaling.rc" 0 0 644 "u:object_r:system_file:s0"
LOG "- Installed battery capacity scaling fix init script"
unset RC
