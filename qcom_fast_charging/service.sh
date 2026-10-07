#!/system/bin/sh

# Idle
sleep 30

# echo <limit> > device
echo 9 > /sys/class/power_supply/battery/charge_control_limit