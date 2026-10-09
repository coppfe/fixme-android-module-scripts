#!/system/bin/sh
MODDIR=${0%/*}

while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
done

EVENT_NODE=""
for dev in /sys/class/input/event*/device/name; do
    if grep -qi "gpio-keys" "$dev" 2>/dev/null; then
        EVENT_NAME=$(echo "$dev" | cut -d'/' -f5)
        EVENT_NODE="/dev/input/$EVENT_NAME"
        break
    fi
done
[ -z "$EVENT_NODE" ] && EVENT_NODE="/dev/input/event1"

pkill -f "getevent -l $EVENT_NODE" 2>/dev/null

getevent -l "$EVENT_NODE" | while read -r line; do
    [ -f "$MODDIR/config.sh" ] && . "$MODDIR/config.sh"
    
    case "$line" in
        *SW_PEN_INSERTED*00000001*)
            eval "$ACTION_ON"
            ;;
        *SW_PEN_INSERTED*00000000*)
            eval "$ACTION_OFF"
            ;;
    esac
done