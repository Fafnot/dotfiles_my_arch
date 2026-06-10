#!/bin/bash

WALLPAPER_DIR="$HOME/wallpaper_desktop"
STATE_FILE="$HOME/.cache/current_wallpaper_index"
TOTAL=$(ls -1 "$WALLPAPER_DIR"/*.{png,jpg,jpeg,webp,bmp} 2>/dev/null | wc -l)

# Если нет обоев — выходим
[[ $TOTAL -eq 0 ]] && echo "Нет обоев в $WALLPAPER_DIR" >&2 && exit 1

# Инициализируем счётчик или читаем текущий
if [[ ! -f "$STATE_FILE" ]]; then
    echo "0" > "$STATE_FILE"
    CURRENT=0
else
    CURRENT=$(cat "$STATE_FILE")
fi

# Получаем список файлов (массив)
mapfile -t WALLPAPERS < <(ls -1 "$WALLPAPER_DIR"/*.{png,jpg,jpeg,webp,bmp} 2>/dev/null | sort)

# Выбираем следующее изображение (циклически)
NEXT=$(( (CURRENT + 1) % TOTAL ))
echo "$NEXT" > "$STATE_FILE"

# Устанавливаем обои
swww img "${WALLPAPERS[$NEXT]}" --transition-type grow --transition-pos 1,1 --transition-duration 2

# Опционально: выводим имя файла в уведомление
notify-send "🖼 Обои" "$(basename "${WALLPAPERS[$NEXT]}")" -t 1500













