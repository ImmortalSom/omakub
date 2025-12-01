#!/bin/bash

omak_cache() {
    local ARCH
    ARCH=$(uname -m | sed -e 's/aarch64/arm-64/' -e 's/x86_64/x86-64/')
    local tag
    tag=$(ogh_tag "localsend/localsend")

    gh_download "localsend/localsend" "LocalSend-${tag#v}-linux-${ARCH}.deb"
}

omak_install() {
    local ARCH
    ARCH=$(uname -m | sed -e 's/aarch64/arm-64/' -e 's/x86_64/x86-64/')
    local tag
    tag=$(ogh_tag "localsend/localsend")

    releases_file=$(gh_download "localsend/localsend" "LocalSend-${tag#v}-linux-${ARCH}.deb")

    sudo apt-get install -y "$releases_file"
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
