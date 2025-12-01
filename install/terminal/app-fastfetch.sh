#!/bin/bash

# Display system information in the terminal
omak_init() {
    if [ ! -f /etc/apt/sources.list.d/fastfetch.sources ] || [ ! -f /etc/apt/keyrings/fastfetch-archive-keyring.gpg ]; then
        gpg --keyserver keyserver.ubuntu.com --recv 0x7e2e5cb4d4865f21
        gpg --export 0x7e2e5cb4d4865f21 | sudo tee /etc/apt/keyrings/fastfetch-archive-keyring.gpg >/dev/null
        local codaname
        codaname=$VERSION_CODENAME
        if [ "$ID" != "ubuntu" ]; then
            codaname="noble"
        fi
        printf "%s\n" \
            "Types: deb" \
            "URIs: https://ppa.launchpadcontent.net/zhangsongcui3371/fastfetch/ubuntu" \
            "Suites: $codaname" \
            "Components: main" \
            "Signed-By: /etc/apt/keyrings/fastfetch-archive-keyring.gpg" |
            sudo tee /etc/apt/sources.list.d/fastfetch.sources >/dev/null
    fi
}

omak_update() {
    sudo apt-get update
}

omak_cache() {
    sudo apt-get --download-only install -y fastfetch
}

omak_install() {
    sudo apt-get install -y fastfetch
    # Only attempt to set configuration if fastfetch is not already set
    if [ ! -f "$HOME/.config/fastfetch/config.jsonc" ]; then
        # Use Omakub fastfetch config
        install -D "$OMAKUB_PATH/configs/fastfetch.jsonc" ~/.config/fastfetch/config.jsonc
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
