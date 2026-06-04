#!/bin/sh
# Получаем раскладку со всех клавиатур, берём первую не-us
LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[] | .active_keymap' | grep -v "English" | head -n1 | tr '[:upper:]' '[:lower:]')

# Определяем короткое имя раскладки
case "$LAYOUT" in
  *ru*) echo "   RU" ;;
  *us*) echo "   EN" ;;
  *en*) echo "   EN" ;;
  *) 
    # Если ничего не нашли — проверяем напрямую через раскладку
    DEFAULT=$(hyprctl devices -j | jq -r '.keyboards[0].active_keymap' | tr '[:upper:]' '[:lower:]')
    [[ "$DEFAULT" == *"ru"* ]] && echo " RU" || echo "   EN"
    ;;
esac






