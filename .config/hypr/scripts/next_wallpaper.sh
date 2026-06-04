#!/bin/bash

WALLPAPER_DIR="$HOME/wallpaper_desktop"
STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper_index"

mkdir -p "$(dirname "$STATE_FILE")"
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    exit 1
fi

CURRENT_INDEX=0
if [ -f "$STATE_FILE" ]; then
    CURRENT_INDEX=$(cat "$STATE_FILE" 2>/dev/null || echo 0)
    if ! [[ "$CURRENT_INDEX" =~ ^[0-9]+$ ]] || [ "$CURRENT_INDEX" -ge "${#WALLPAPERS[@]}" ]; then
        CURRENT_INDEX=0
    fi
fi

# ИСПРАВЛЕНО: Следующее изображение
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))
WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

echo "$NEXT_INDEX" > "$STATE_FILE"
awww img "$WALLPAPER" --transition-fps 60 --transition-type grow --transition-duration 2







