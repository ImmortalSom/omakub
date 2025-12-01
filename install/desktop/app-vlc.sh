#!/bin/bash

omak_cache() {
    sudo apt-get --download-only install -y vlc
}

omak_install() {
    sudo apt-get install -y vlc
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
