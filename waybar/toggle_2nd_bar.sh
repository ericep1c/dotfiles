#!/bin/bash

CONFIG="$HOME/.config/waybar/config.jsonc"
TMP_CONFIG="$HOME/.config/waybar/config.jsonc.tmp"

# Check if HDMI-A-1 is currently an output in the config (checking for more than 1 object in array)
if [ "$(jq 'length' "$CONFIG")" -gt 1 ]; then
    # It's there, so remove the second monitor bar object.
    jq 'del(.[1])' "$CONFIG" > "$TMP_CONFIG" && mv "$TMP_CONFIG" "$CONFIG"
    echo '{"text": "<span size=\"11500\">󰶐</span>", "tooltip": "Enable 2nd Bar"}'
else
    # It's not there, so add it back. 
    jq '.[0] as $first | . + [$first | .output = "HDMI-A-1" | ."custom/active_window"."max-length" = 15]' "$CONFIG" > "$TMP_CONFIG" && mv "$TMP_CONFIG" "$CONFIG"
    echo '{"text": "<span size=\"11500\">󰶒</span>", "tooltip": "Disable 2nd Bar"}'
fi

# Restart Waybar
killall waybar
waybar &
