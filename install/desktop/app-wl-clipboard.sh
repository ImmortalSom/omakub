#!/bin/bash

# Provides a system clipboard interface for Neovim under Wayland
omak_cache() {
    sudo apt-get --download-only install -y wl-clipboard
}

omak_install() {
    sudo apt-get install -y wl-clipboard
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
