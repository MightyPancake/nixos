WALLPAPER_DIR="$HOME/nixos/wallpapers"
QUEUE_FILE="/tmp/hyprpanel_wp_queue"

# 1. Check if the wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Directory $WALLPAPER_DIR does not exist."
    exit 1
fi

# 2. If the queue file is empty or doesn't exist, generate a new shuffled list
if [ ! -s "$QUEUE_FILE" ]; then
    # Find all images, shuffle them, and save to the queue file
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | shuf > "$QUEUE_FILE"
fi

# 3. Get the first wallpaper from the queue
NEXT_WP=$(head -n 1 "$QUEUE_FILE")

# 4. Check if we actually got a file (in case the directory was empty)
if [ -z "$NEXT_WP" ]; then
    echo "Error: No images found in $WALLPAPER_DIR"
    exit 1
fi

# 5. Remove the selected wallpaper from the queue file (pops it off the list)
sed -i '1d' "$QUEUE_FILE"

# 6. Apply the wallpaper using hyprpanel
hyprpanel sw "$NEXT_WP"

echo "Wallpaper changed to: $(basename "$NEXT_WP")"

# 7. pywalfox update
echo "Sending update request to pywalfox"
pywalfox update
