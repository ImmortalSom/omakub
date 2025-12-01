#!/bin/bash

omak_cache() {
    gh_download "starship/starship" "starship-${ARCH}-unknown-linux-musl.tar.gz"
}

omak_install() {
    local releases_file
    releases_file=$(gh_download "starship/starship" "starship-${ARCH}-unknown-linux-musl.tar.gz")

    rm -rf "$OMAKUB_CACHE/starship"
    mkdir -p "$OMAKUB_CACHE/starship"
    tar -xf "$releases_file" -C "$OMAKUB_CACHE/starship"
    install -m 755 "$OMAKUB_CACHE/starship/starship" ~/.local/bin/starship
    rm -rf "$OMAKUB_CACHE/starship"

    cp "$OMAKUB_PATH/configs/starship.toml" ~/.config/starship.toml
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
