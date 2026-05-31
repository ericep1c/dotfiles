#!/bin/bash

entries="Shutdown\nReboot\nSleep"

selected=$(echo -e $entries | wofi --dmenu --cache-file /dev/null --width 250 --height 210 --hide-search | tr '[:upper:]' '[:lower:]')

case $selected in
  shutdown)
    systemctl poweroff;;
  reboot)
    systemctl reboot;;
  sleep)
    systemctl suspend;;
esac
