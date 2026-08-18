#!/bin/bash

# 1. Узнаем раскладку (пример для US/RU)
LAYOUT=$(swaymsg -t get_inputs | jq -r '.[] | select(.type=="keyboard") | .xkb_active_layout_name' | head -n 1)

if [[ "$LAYOUT" =~ "Russian" ]]; then
    LANG_STR="RU"
else
    LANG_STR="US"
fi

# 2. Проверяем Caps и Num через ядро
CAPS_FILE=$(ls /sys/class/leds/input*::capslock/brightness 2>/dev/null | head -n 1)
NUM_FILE=$(ls /sys/class/leds/input*::numlock/brightness 2>/dev/null | head -n 1)

MODS=""
[ -n "$CAPS_FILE" ] && [ "$(cat "$CAPS_FILE")" -eq 1 ] && MODS="CAPS"
[ -n "$NUM_FILE" ] && [ "$(cat "$NUM_FILE")" -eq 1 ] && MODS="${MODS:+$MODS }Num"

# 3. Собираем итоговую строку
if [ -n "$MODS" ]; then
    echo " $MODS $LANG_STR "
else
    echo " $LANG_STR "
fi