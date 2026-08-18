#!/bin/bash

# --- CPU данные ---
read cpu a b c previdle rest < /proc/stat
prevtotal=$((a+b+c+previdle))
sleep 0.3
read cpu a b c idle rest < /proc/stat
total=$((a+b+c+idle))
cpu=$((100 * ( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))

# Динамический поиск hwmon для AMD (k10temp / zenpower)
CPU_TEMP_PATH=""
for sys in /sys/class/hwmon/hwmon*; do
    if [ -f "$sys/name" ]; then
        name=$(cat "$sys/name")
        if [ "$name" = "k10temp" ] || [ "$name" = "zenpower" ]; then
            CPU_TEMP_PATH="$sys/temp1_input"
            break
        fi
    fi
done

if [ -n "$CPU_TEMP_PATH" ] && [ -f "$CPU_TEMP_PATH" ]; then
    CPU_TEMP_RAW=$(cat "$CPU_TEMP_PATH" 2>/dev/null || echo 0)
    CPU_TEMP=$((CPU_TEMP_RAW / 1000))
else
    CPU_TEMP="N/A"
fi

# --- GPU данные (через nvidia-smi) ---
GPU_INFO=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
if [ $? -eq 0 ]; then
    GPU_UTIL=$(echo "$GPU_INFO" | awk -F, '{print $1}' | tr -d ' ')
    GPU_TEMP=$(echo "$GPU_INFO" | awk -F, '{print $2}' | tr -d ' ')
else
    GPU_UTIL="0"
    GPU_TEMP="0"
fi

# --- Вывод ---
if [ "$1" = "cpu" ]; then
    echo " CPU: ${cpu}%  ${CPU_TEMP}°C"
elif [ "$1" = "gpu" ]; then
    echo " GPU: ${GPU_UTIL}%  ${GPU_TEMP}°C"
fi