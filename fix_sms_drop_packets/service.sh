#!/system/bin/sh

while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
done

# Just for safe
sleep 5

cmd connectivity airplane-mode disable
settings put global airplane_mode_on 0
# Manual toggle on airplane mode to ahead race condition on boot

# watchdog
while true; do
    SHUTDOWN_STATE=$(getprop sys.shutdown.requested)
    if [ -n "$SHUTDOWN_STATE" ]; then
        # If we going "sleep" -> we need to turn on airplane mode again.
        cmd connectivity airplane-mode enable
        settings put global airplane_mode_on 1
        exit 0
    fi
    sleep 1
done