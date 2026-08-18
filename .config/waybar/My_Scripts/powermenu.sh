#!/usr/bin/env bash

## Author  : Aditya Shakya (Modified for Fuzzel)

uptime=$(uptime -p | sed -e 's/up //g')

# Команда вызова Fuzzel в стиле dmenu (с кастомным промптом)
fuzzel_cmd() {
    fuzzel --dmenu --prompt "$1: " --minimal-lines
}

# Options (иконки можно оставить, Fuzzel их отлично отображает, если установлены шрифты)
shutdown=" Shutdown"
reboot=" Restart"
lock=" Lock"
suspend=" Sleep"
logout=" Logout"

# Подтверждение действия через Fuzzel
confirm_exit() {
    choosen_confirm=$(echo -e "no\nyes" | fuzzel_cmd "Are You Sure?")
    if [[ "$choosen_confirm" == "yes" ]]; then
        echo "y"
    else
        echo "n"
    fi
}

# Variable passed to fuzzel (передаем список вариантов)
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

# Вызываем главное меню
chosen="$(echo -e "$options" | fuzzel_cmd "Uptime: $uptime")"

case $chosen in
    $shutdown)
        ans=$(confirm_exit)
        if [[ $ans == "y" ]]; then
            systemctl poweroff
        fi
        ;;
    $reboot)
        ans=$(confirm_exit)
        if [[ $ans == "y" ]]; then
            systemctl reboot
        fi
        ;;
    $lock)
        # Подстрой под свой локальный локер, если используешь swaylock
        if command -v swaylock &> /dev/null; then
            swaylock -f -c 1a1b26
        elif command -v i3lock &> /dev/null; then
            i3lock
        fi
        ;;
    $suspend)
        ans=$(confirm_exit)
        if [[ $ans == "y" ]]; then
            # Для Wayland/Pipewire команды mpc/amixer можно заменить на системные или оставить, если стоят
            systemctl suspend
        fi
        ;;
    $logout)
        ans=$(confirm_exit)
        if [[ $ans == "y" ]]; then
            swaymsg exit
        fi
        ;;
esac