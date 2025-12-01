#!/bin/bash

omak_init() {
    if [ ! -f /etc/apt/sources.list.d/ulauncher.sources ] || [ ! -f /etc/apt/keyrings/ulauncher-archive-keyring.gpg ]; then
        gpg --keyserver keyserver.ubuntu.com --recv 0xfaf1020699503176
        gpg --export 0xfaf1020699503176 | sudo tee /etc/apt/keyrings/ulauncher-archive-keyring.gpg >/dev/null
        local codaname
        codaname=$VERSION_CODENAME
        if [ "$ID" != "ubuntu" ]; then
            codaname="noble"
        fi
        printf "%s\n" \
            "Types: deb" \
            "URIs: https://ppa.launchpadcontent.net/agornostal/ulauncher/ubuntu" \
            "Suites: $codaname" \
            "Components: main" \
            "Signed-By: /etc/apt/keyrings/ulauncher-archive-keyring.gpg" |
            sudo tee /etc/apt/sources.list.d/ulauncher.sources >/dev/null
    fi
}

omak_update() {
    sudo apt-get update
}

omak_cache() {
    sudo apt-get --download-only install -y ulauncher
}

omak_install() {
    sudo apt-get install -y ulauncher
    # Start ulauncher to have it populate config before we overwrite
    mkdir -p ~/.config/autostart/
    install -D "$OMAKUB_PATH/configs/ulauncher.desktop" ~/.config/autostart/ulauncher.desktop
    gtk-launch ulauncher.desktop >/dev/null 2>&1
    sleep 5 # ensure enough time for ulauncher to set defaults
    install -D "$OMAKUB_PATH/configs/ulauncher.json" ~/.config/ulauncher/settings.json
}

case $1 in
init | cache | install) "omak_${1}" ;;
*)
    omak_init
    omak_update
    omak_install
    ;;
esac
