#!/bin/bash

omak_cache() {
    sudo apt-get --download-only install -y gnome-software-plugin-flatpak
}

omak_install() {
    sudo apt-get install -y gnome-software-plugin-flatpak
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
