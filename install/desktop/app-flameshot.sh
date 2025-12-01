#!/bin/bash

# Flameshot is a nice step-up over the default Gnome screenshot tool
omak_cache() {
    sudo apt-get --download-only install -y flameshot
}

omak_install() {
    sudo apt-get install -y flameshot

    if [ -f /usr/share/applications/org.flameshot.Flameshot.desktop ]; then
        cp /usr/share/applications/org.flameshot.Flameshot.desktop ~/.local/share/applications/org.flameshot.Flameshot.desktop
        if ! grep -q "NoDisplay=true" ~/.local/share/applications/org.flameshot.Flameshot.desktop; then
            echo "[Desktop Entry] NoDisplay=true" >>~/.local/share/applications/org.flameshot.Flameshot.desktop
        fi
    fi
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
