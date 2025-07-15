#!/etc/profiles/per-user/vivek/bin/bash

# Kill previous instance (except this one)
SCRIPT_NAME=$(basename "$0")
CURRENT_PID=$$
pgrep -f "$SCRIPT_NAME" | grep -v "$CURRENT_PID" | xargs -r kill

# Use argument as wallpaper dir or default
WALLPAPER_DIR="${1:-$HOME/Pictures/wallpapers}"
INTERVAL=60

# Check if directory exists
[[ ! -d "$WALLPAPER_DIR" ]] && echo "Directory not found: $WALLPAPER_DIR" && exit 1

# Get monitor names
MONITOR="HDMI-A-1"

# Load wallpapers
mapfile -t WALLPAPERS < <(fd -e png -e jpg -d 1 . $WALLPAPER_DIR | sort)

printf '%s\n' "${WALLPAPERS[@]}"


[[ ${#WALLPAPERS[@]} -eq 0 ]] && echo "No wallpapers found." && exit 1

# Cycle wallpapers
while true; do
  for wp in "${WALLPAPERS[@]}"; do
    hyprctl hyprpaper reload "$MONITOR,$wp"
    sleep "$INTERVAL"
  done
done
