#!/bin/bash

omak_cache() {
    sudo apt-get --download-only install -y xournalpp
}

omak_install() {
    sudo apt-get install -y xournalpp
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
