#!/bin/bash

# Work with Word, Excel, Powerpoint files
omak_cache() {
    sudo apt-get --download-only install -y libreoffice
}

omak_install() {
    sudo apt-get install -y libreoffice
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
