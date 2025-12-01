#!/bin/bash

omak_cache() {
    local tag
    tag=$(ogh_tag "ajeetdsouza/zoxide")
    gh_download "ajeetdsouza/zoxide" "zoxide-${tag#v}-${ARCH}-unknown-linux-musl.tar.gz"
}

omak_install() {
    local tag
    tag=$(ogh_tag "ajeetdsouza/zoxide")
    local releases_file
    releases_file=$(gh_download "ajeetdsouza/zoxide" "zoxide-${tag#v}-${ARCH}-unknown-linux-musl.tar.gz")

    rm -rf "$OMAKUB_CACHE/zoxide"
    mkdir -p "$OMAKUB_CACHE/zoxide"
    tar -xf "$releases_file" -C "$OMAKUB_CACHE/zoxide"
    install -m 755 "$OMAKUB_CACHE/zoxide/zoxide" ~/.local/bin/zoxide
    rm -rf "$OMAKUB_CACHE/zoxide"
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
