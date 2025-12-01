#!/bin/bash

omak_cache() {
    sudo apt-get --download-only install -y fzf ripgrep bat eza zoxide plocate apache2-utils fd-find zsh
}

omak_install() {
    sudo apt-get install -y fzf ripgrep bat eza zoxide plocate apache2-utils fd-find zsh

    # Configure the bash shell using Omakub defaults
    if [ -f ~/.bashrc ] && [ ! -f ~/.bashrc.omakub.bak ]; then
        mv ~/.bashrc ~/.bashrc.omakub.bak
    fi
    cp "$OMAKUB_PATH/configs/bashrc" ~/.bashrc

    # Load the PATH for use later in the installers
    source "$OMAKUB_PATH/defaults/bash/shell"

    # Configure the inputrc using Omakub defaults
    if [ -f ~/.inputrc ] && [ ! -f ~/.inputrc.omakub.bak ]; then
        mv ~/.inputrc ~/.inputrc.omakub.bak
    fi
    cp "$OMAKUB_PATH/configs/inputrc" ~/.inputrc
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
