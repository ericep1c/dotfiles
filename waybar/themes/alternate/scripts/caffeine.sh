#!/usr/bin/env bash

if pgrep -f "systemd-inhibit.*caffeine" > /dev/null; then
    echo "{\"text\": \"\", \"tooltip\": \"Caffeine: Active\", \"class\": \"active\"}"
else
    echo "{\"text\": \"\", \"tooltip\": \"Caffeine: Inactive\", \"class\": \"inactive\"}"
fi
