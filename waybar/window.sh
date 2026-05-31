#!/bin/bash
while true; do
    hyprctl activewindow -j | jq --compact-output '
      if .title == null then
        {"text": "Desktop", "class": "desktop"}
      else
        {"text": .title, "class": .class}
      end'
    sleep 1
done
