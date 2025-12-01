#!/bin/bash

omak_install() {
    local COMPUTER_MAKER
    COMPUTER_MAKER=$(sudo dmidecode -t system | grep 'Manufacturer:' | awk '{print $2}')
    local SCREEN_RESOLUTION
    SCREEN_RESOLUTION=$(xrandr | grep -F '*+' | awk '{print $1}')

    if [ "$COMPUTER_MAKER" == "Framework" ] && [ "$SCREEN_RESOLUTION" == "2256x1504" ]; then
        gsettings set org.gnome.desktop.interface text-scaling-factor 0.8
        gsettings set org.gnome.desktop.interface cursor-size 16
        sed -i "s/size = 9/size = 7/g" ~/.config/alacritty/alacritty.toml
    fi
}

case $1 in
init |  cache) true ;;
*) omak_install ;;
esac
