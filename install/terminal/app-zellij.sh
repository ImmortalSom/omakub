#!/bin/bash

omak_cache() {
    gh_download "zellij-org/zellij" "zellij-${ARCH}-unknown-linux-musl.tar.gz"
}

omak_install() {
    local releases_file
    releases_file=$(gh_download "zellij-org/zellij" "zellij-${ARCH}-unknown-linux-musl.tar.gz")

    rm -rf "$OMAKUB_CACHE/zellij"
    mkdir -p "$OMAKUB_CACHE/zellij"
    tar -xf "$releases_file" -C "$OMAKUB_CACHE/zellij"
    install -m 755 "$OMAKUB_CACHE/zellij/zellij" ~/.local/bin/zellij
    rm -rf "$OMAKUB_CACHE/zellij"
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
