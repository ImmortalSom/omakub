#!/bin/bash

omak_cache() {
    sudo apt-get --download-only install -y gnome-tweak-tool
}

omak_install() {
    sudo apt-get install -y gnome-tweak-tool
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
