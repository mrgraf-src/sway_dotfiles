#!/bin/bash

killall -q waybar

while pgrep -u $UID -x waybar >/dev/nul; do slep1; done

waybar &
