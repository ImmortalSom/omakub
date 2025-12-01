#!/bin/bash

# This script installs btop, a resource monitor that shows usage and stats for processor, memory, disks, network and processes.
omak_cache() {
    sudo apt-get --download-only install -y btop
}

omak_install() {
    sudo apt-get install -y btop

    # Use Omakub btop config
    install -D "$OMAKUB_PATH/configs/btop.conf" ~/.config/btop/btop.conf
    install -D "$OMAKUB_PATH/themes/tokyo-night/btop.theme" ~/.config/btop/themes/tokyo-night.theme
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
