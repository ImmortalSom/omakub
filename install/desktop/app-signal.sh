#!/bin/bash

omak_init() {
    if [ "$ARCH" == "x86_64" ]; then
        if [ ! -f /etc/apt/sources.list.d/signal-desktop.sources ] || [ ! -f /etc/apt/keyrings/signal-desktop-keyring.gpg ]; then
            omak_gpg "https://updates.signal.org/desktop/apt/keys.asc" signal-desktop-keyring.gpg
            printf "%s\n" \
                "Types: deb" \
                "URIs: https://updates.signal.org/desktop/apt" \
                "Suites: xenial" \
                "Components: main" \
                "Architectures: amd64" \
                "Signed-By: /etc/apt/keyrings/signal-desktop-keyring.gpg" |
                sudo tee /etc/apt/sources.list.d/signal-desktop.sources >/dev/null
        fi
    fi
}

omak_update() {
    if [ "$ARCH" == "x86_64" ]; then
        sudo apt-get update
    fi
}

omak_cache() {
    if [ "$ARCH" == "x86_64" ]; then
        sudo apt-get --download-only install -y signal-desktop
    else
        local tag
        tag=$(ogh_tag "dennisameling/Signal-Desktop")
        gh_download "dennisameling/Signal-Desktop" "signal-desktop-unofficial_${tag#v}_arm64.deb"
    fi
}

omak_install() {
    if [ "$ARCH" == "x86_64" ]; then
        sudo apt-get install -y signal-desktop
    else
        local tag
        tag=$(ogh_tag "dennisameling/Signal-Desktop")
        releases_file=$(gh_download "dennisameling/Signal-Desktop" "signal-desktop-unofficial_${tag#v}_arm64.deb")
        sudo apt-get install -y "$releases_file"
    fi
}

case $1 in
init | cache | install) "omak_${1}" ;;
*)
    omak_init
    omak_update
    omak_install
    ;;
esac
