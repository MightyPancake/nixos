STEP=5

# Get current volume (float like 0.42)
vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')

# Convert to percentage
# vol_pct=$(printf "%.0f" "$(echo "$vol * 100" | bc -l)")
vol_pct=$(LC_NUMERIC=C printf "%.0f" "$(echo "$vol * 100" | bc -l)")

# Round to nearest 5
rounded=$(( (vol_pct + 2) / 5 * 5 ))

case "$1" in
  up)
    new=$((rounded + STEP))
    ;;
  down)
    new=$((rounded - STEP))
    ;;
  *)
    exit 1
    ;;
esac

# Clamp between 0 and 100
if [ "$new" -gt 100 ]; then new=100; fi
if [ "$new" -lt 0 ]; then new=0; fi

# Convert back to 0–1 range
new_float=$(echo "$new / 100" | bc -l)

wpctl set-volume @DEFAULT_AUDIO_SINK@ "$new_float"
