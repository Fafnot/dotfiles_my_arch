#!/bin/bash
TERMINAL="kitty"
UPDATE_CMD="sudo pacman -Syu"

# Nord цвета
FG="#ECEFF4"       # foreground - Snow
SELECTED="#88C0D0" # selected - Ice blue
ACTIVE="#A3BE8C"   # active - Sage green
URGENT="#BF616A"   # urgent - Red
BG_ALT="#3B4252"   # background-alt

UPDATES=$(checkupdates 2>/dev/null)
COUNT=$(echo "$UPDATES" | grep -c .)

send_notify() {
    notify-send "Обновление системы" "$1" -u normal
}

if [ -z "$UPDATES" ]; then
    send_notify "Система актуальна" "Нет доступных обновлений 🎉"
    exit 0
fi

if [ "$1" == "--run-in-term" ]; then
    clear
    gum style \
        --foreground "$SELECTED" --border-foreground "$SELECTED" --border rounded \
        --align center --width 35 --margin "1 2" \
        "  ОБНОВЛЕНИЕ СИСТЕМЫ  "

    gum style --foreground "$FG" "  Доступно обновлений: $(gum style --foreground "$SELECTED" "$COUNT")"
    echo ""

    echo "$UPDATES" | awk '{print $1}' | while read pkg; do
        gum style --foreground "$ACTIVE" "  • $pkg"
        sleep 0.01
    done

    echo ""
    if gum confirm --selected.foreground="$BG_ALT" --selected.background="$SELECTED" \
                   --unselected.foreground="$FG" "  Обновить всё?"; then
        echo ""
        gum spin --spinner dot --spinner.foreground="$SELECTED" \
                 --title.foreground="$FG" --title "Обновление..." -- sleep 1
        eval $UPDATE_CMD
        echo ""
        gum style --foreground "$ACTIVE" "✓ Готово! Нажми Enter чтобы закрыть."
        read
        send_notify "Обновление завершено" "Система обновлена успешно ✓"
    else
        gum style --foreground "$URGENT" "  Отменено."
        sleep 2
    fi
else
    $TERMINAL --title "SystemUpdate" -e "$0" --run-in-term &
fi





