#!/usr/bin/env bash

MON1="eDP-1"
MON2="HDMI-A-1"
STATE_FILE="/tmp/hypr_monitor_mode"

# Default to extend
if [ ! -f "$STATE_FILE" ]; then
    echo "extend" > "$STATE_FILE"
fi

MODE=$(cat "$STATE_FILE")

# Get resolutions and scales
read MON1_WIDTH MON1_SCALE <<< $(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MON1\") | [.width, .scale] | @tsv")
read MON2_WIDTH MON2_SCALE <<< $(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MON2\") | [.width, .scale] | @tsv")

# Calculate logical widths
LOG1=$(echo "$MON1_WIDTH / $MON1_SCALE" | bc -l)
LOG2=$(echo "$MON2_WIDTH / $MON2_SCALE" | bc -l)

if [ "$MODE" = "extend" ]; then
    # MIRROR: scale both to the smaller logical width
    MIN_LOG=$(echo "$LOG1 $LOG2" | awk '{if ($1<$2) print $1; else print $2}')
    
    # New scales
    SCALE1=$(echo "$MON1_WIDTH / $MIN_LOG" | bc -l)
    SCALE2=$(echo "$MON2_WIDTH / $MIN_LOG" | bc -l)
    
    hyprctl keyword monitor "$MON1,${MON1_WIDTH}x$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MON1\") | .height")@$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MON1\") | .refreshRate"),0x0,$SCALE1"
    hyprctl keyword monitor "$MON2,${MON2_WIDTH}x$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MON2\") | .height")@$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MON2\") | .refreshRate"),0x0,$SCALE2"
    
    echo "Switched to MIRROR mode"
    echo "mirror" > "$STATE_FILE"
else
    # EXTEND: keep original scales, projector to the right
    hyprctl keyword monitor "$MON1,${MON1_WIDTH}x$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MON1\") | .height")@$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MON1\") | .refreshRate"),0x0,$MON1_SCALE"
    hyprctl keyword monitor "$MON2,${MON2_WIDTH}x$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MON2\") | .height")@$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MON2\") | .refreshRate"),${MON1_WIDTH}x0,$MON2_SCALE"
    
    echo "Switched to EXTEND mode"
    echo "extend" > "$STATE_FILE"
fi
