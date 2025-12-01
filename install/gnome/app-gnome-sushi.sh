#!/bin/bash

# Gives you previews in the file manager when pressing space
omak_cache() {
    sudo apt-get --download-only install -y gnome-sushi
}

omak_install() {
    sudo apt-get install -y gnome-sushi
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
