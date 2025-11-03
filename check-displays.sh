#!/usr/bin/env bash

echo "=== Connected Display Ports ==="
for port in /sys/class/drm/card1-DP-*/status; do
    name=$(basename $(dirname $port))
    status=$(cat $port)
    echo "$name: $status"
done

echo -e "\n=== Niri Detected Outputs ==="
niri msg outputs 2>/dev/null || echo "Niri not running"

echo -e "\n=== DRM Info ==="
ls -l /sys/class/drm/card1-DP-*/drm_dp_aux* 2>/dev/null | head -20

echo -e "\n=== To force re-detection, run ==="
echo "echo detect | sudo tee /sys/class/drm/card1-DP-*/status"
