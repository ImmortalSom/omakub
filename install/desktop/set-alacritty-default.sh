#!/bin/bash

omak_install() {
    # Install Alacritty if not present
    if ! command -v alacritty >/dev/null 2>&1; then
        source "$OMAKUB_PATH/install/desktop/app-alacritty.sh" install
    fi
    # Make alacritty default terminal emulator
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/alacritty ~/.local/bin/x-terminal-emulator
}

case $1 in
init | cache) true ;;
*) omak_install ;;
esac
