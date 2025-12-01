#!/bin/bash

omak_init() {
    if [ ! -f /etc/apt/sources.list.d/vscode.sources ] || [ ! -f /etc/apt/keyrings/packages.microsoft.gpg ]; then
        omak_gpg https://packages.microsoft.com/keys/microsoft.asc packages.microsoft.gpg
        printf "%s\n" \
            "Types: deb" \
            "URIs: https://packages.microsoft.com/repos/code" \
            "Suites: stable" \
            "Components: main" \
            "Signed-By: /etc/apt/keyrings/packages.microsoft.gpg" |
            sudo tee /etc/apt/sources.list.d/vscode.sources >/dev/null
    fi
}

omak_update() {
    sudo apt-get update
}

omak_cache() {
    sudo apt-get --download-only install -y code
}

omak_install() {
    sudo apt-get install -y code

    mkdir -p ~/.config/Code/User
    cp "$OMAKUB_PATH/configs/vscode.json" ~/.config/Code/User/settings.json

    # Install default supported themes
    code --install-extension enkia.tokyo-night
}

case $1 in
init | cache | install) "omak_${1}" ;;
*)
    omak_init
    omak_update
    omak_install
    ;;
esac
