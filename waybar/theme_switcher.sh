#!/bin/bash

# Directory where themes are stored
THEME_DIR="$HOME/.config/waybar/themes"
# Get a list of theme directories
THEMES=$(ls "$THEME_DIR")

# Use wofi to pick a theme
CHOICE=$(echo -e "$THEMES" | wofi --dmenu --prompt "Select Waybar Theme:")

if [ -n "$CHOICE" ]; then
    # We use temporary files to switch to avoid breaking the original files in theme folders
    # But here we are symlinking the active config/style to the selected theme
    
    # Remove existing files/links if they exist
    rm -f "$HOME/.config/waybar/config.jsonc"
    rm -f "$HOME/.config/waybar/style.css"

    # Symlink the new theme files
    ln -s "$THEME_DIR/$CHOICE/config.jsonc" "$HOME/.config/waybar/config.jsonc"
    ln -s "$THEME_DIR/$CHOICE/style.css" "$HOME/.config/waybar/style.css"
    
    # Handle colors.css
    if [ -f "$THEME_DIR/$CHOICE/colors.css" ]; then
        rm -f "$HOME/.config/waybar/colors.css"
        ln -s "$THEME_DIR/$CHOICE/colors.css" "$HOME/.config/waybar/colors.css"
    elif [ -f "$THEME_DIR/$CHOICE/colors/colors.css" ]; then
        # If the theme has a colors/colors.css, it likely imports the root colors.css
        # so we ensure the root one exists. If it's already a file (from wallust), keep it.
        # If it's a symlink, we might want to reset it or leave it.
        # For 'alternate', we want the wallust one to stay or be restored.
        if [ ! -f "$HOME/.config/waybar/colors.css" ]; then
             # Try to restore from default if missing
             cp "$THEME_DIR/default/colors.css" "$HOME/.config/waybar/colors.css"
        fi
    fi

    # Handle Hyprland blur rule based on theme
    if [ "$CHOICE" == "default" ]; then
        hyprctl keyword "layerrule" "blur on, match:namespace waybar"
    else
        hyprctl keyword "layerrule" "blur off, match:namespace waybar"
    fi

    # Restart Waybar
    killall -9 waybar
    sleep 0.5
    waybar > /dev/null 2>&1 &
fi
