#!/bin/bash

omak_cache() {
    local ARCH
    ARCH=$(uname -m | sed 's/aarch64/arm64/')
    local tag
    tag=$(ogh_tag "jesseduffield/lazydocker")

    gh_download "jesseduffield/lazydocker" "lazydocker_${tag#v}_Linux_${ARCH}.tar.gz"
}

omak_install() {
    local ARCH
    ARCH=$(uname -m | sed 's/aarch64/arm64/')
    local tag
    tag=$(ogh_tag "jesseduffield/lazydocker")
    local releases_file
    releases_file=$(gh_download "jesseduffield/lazydocker" "lazydocker_${tag#v}_Linux_${ARCH}.tar.gz")

    rm -rf "$OMAKUB_CACHE/lazydocker"
    mkdir -p "$OMAKUB_CACHE/lazydocker"
    tar -xf "$releases_file" -C "$OMAKUB_CACHE/lazydocker"
    install -m 755 "$OMAKUB_CACHE/lazydocker/lazydocker" ~/.local/bin/lazydocker
    rm -rf "$OMAKUB_CACHE/lazydocker"

    mkdir -p ~/.config/aliases
    printf "%s\n" \
        'alias lzd="lazydocker"' |
        tee ~/.config/aliases/lazydocker.sh >/dev/null
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
