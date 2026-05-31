#!/bin/bash
# Get the current wallpaper path from argument or awww cache
if [ -n "$1" ]; then
    WALLPAPER_PATH="$1"
else
    WALLPAPER_PATH=$(strings "$HOME/.cache/awww/0.12.0/DP-1" | tail -n 1)
fi

if [ -f "$WALLPAPER_PATH" ]; then
    # Check if the file is a video
    MIME_TYPE=$(file --mime-type -b "$WALLPAPER_PATH")
    
    if [[ "$MIME_TYPE" == video/* ]]; then
        # It's a video, extract the first frame
        STATIC_IMAGE="$HOME/.cache/wallpaper_frame.jpg"
        ffmpeg -y -i "$WALLPAPER_PATH" -frames:v 1 "$STATIC_IMAGE" > /dev/null 2>&1
        ln -sf "$STATIC_IMAGE" "$HOME/.cache/current_wallpaper.jpg"
        FINAL_PATH="$STATIC_IMAGE"
    else
        # It's a regular image
        ln -sf "$WALLPAPER_PATH" "$HOME/.cache/current_wallpaper.jpg"
        FINAL_PATH="$WALLPAPER_PATH"
    fi

    # Update SDDM background if writable
    if [ -w "/usr/share/sddm/themes/hyprlock-theme/background.jpg" ]; then
        cp "$FINAL_PATH" "/usr/share/sddm/themes/hyprlock-theme/background.jpg"
    fi
fi

exit 0
