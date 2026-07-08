#!/usr/bin/env bash
# Wayle watchdog — if the panel layer disappears for 3 consecutive
# checks (90s), kill the zombie and restart. A brief disappearance
# (menu transitions, bar animations) won't trigger a restart.

STALE_FILE="/tmp/wayle_watchdog_stale"
MAX_STALE=3

PANEL_LAYER=$(hyprctl layers 2>/dev/null | grep -c "wayle")

if [ "$PANEL_LAYER" -lt 1 ]; then
    if [ -f "$STALE_FILE" ]; then
        COUNT=$(cat "$STALE_FILE")
        COUNT=$((COUNT + 1))
    else
        COUNT=1
    fi
    echo "$COUNT" > "$STALE_FILE"

    if [ "$COUNT" -ge "$MAX_STALE" ]; then
        echo "[watchdog] Wayle layer missing for ${COUNT} checks, restarting at $(date)"
        pkill -f "wayle" 2>/dev/null
        sleep 1
        wayle shell &
        echo "[watchdog] Wayle restarted"
        rm -f "$STALE_FILE"
    fi
else
    rm -f "$STALE_FILE"
fi
