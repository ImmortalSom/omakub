#!/bin/bash

omak_cache() {
    sudo apt-get --download-only install -y flatpak
}

omak_install() {
    sudo apt-get install -y flatpak
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
