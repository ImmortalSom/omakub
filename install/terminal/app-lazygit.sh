#!/bin/bash

omak_cache() {
    local ARCH
    ARCH=$(uname -m | sed 's/aarch64/arm64/')
    local tag
    tag=$(ogh_tag "jesseduffield/lazygit")

    gh_download "jesseduffield/lazygit" "lazygit_${tag#v}_Linux_${ARCH}.tar.gz"
}

omak_install() {
    local ARCH
    ARCH=$(uname -m | sed 's/aarch64/arm64/')
    local tag
    tag=$(ogh_tag "jesseduffield/lazygit")

    releases_file=$(gh_download "jesseduffield/lazygit" "lazygit_${tag#v}_Linux_${ARCH}.tar.gz")

    rm -rf "$OMAKUB_CACHE/lazygit"
    mkdir -p "$OMAKUB_CACHE/lazygit"
    tar -xf "$releases_file" -C "$OMAKUB_CACHE/lazygit"
    install -m 755 "$OMAKUB_CACHE/lazygit/lazygit" ~/.local/bin/lazygit
    rm -rf "$OMAKUB_CACHE/lazygit"
    mkdir -p ~/.config/lazygit/
    touch ~/.config/lazygit/config.yml

    mkdir -p ~/.config/aliases
    printf "%s\n" \
        'alias lzg="lazygit"' |
        tee ~/.config/aliases/lazygit.sh >/dev/null
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
