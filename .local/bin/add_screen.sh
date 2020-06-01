#!/usr/bin/env bash

# Reminder of xrandr syntax to add new 2k screen right of current laptop one.

set -o errexit
set -o nounset

xrandr --output HDMI-2 --mode 2560x1440 --right-of eDP-1
