#!/bin/bash

omak_cache() {
    sudo apt-get --download-only install -y qt6ct adwaita-qt
}

omak_install() {
    sudo apt-get install -y qt6ct adwaita-qt
    source "$OMAKUB_PATH/themes/tokyo-night/gnome.sh"
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
