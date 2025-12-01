#!/bin/bash

omak_cache() {
    sudo apt-get --download-only install -y plasma-discover-backend-flatpak
    sudo apt-get --download-only install -y kde-config-flatpak
}

omak_install() {
    sudo apt-get install -y plasma-discover-backend-flatpak
    sudo apt-get install -y kde-config-flatpak
}

case $1 in
cache) omak_cache ;;
install | all | full) omak_install ;;
*) true ;;
esac
