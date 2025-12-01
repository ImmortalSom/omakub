#!/bin/bash

# Install mise for managing multiple versions of languages. See https://mise.jdx.dev/
omak_init() {
    if [ ! -f /etc/apt/sources.list.d/mise.sources ] || [ ! -f /etc/apt/keyrings/mise-archive-keyring.gpg ]; then
        omak_gpg https://mise.jdx.dev/gpg-key.pub mise-archive-keyring.gpg
        printf "%s\n" \
            "Types: deb" \
            "URIs: https://mise.jdx.dev/deb" \
            "Suites: stable" \
            "Components: main" \
            "Signed-By: /etc/apt/keyrings/mise-archive-keyring.gpg" |
            sudo tee /etc/apt/sources.list.d/mise.sources >/dev/null
    fi
}

omak_update() {
    sudo apt-get update
}

omak_cache() {
    sudo apt-get --download-only install -y mise
}

omak_install() {
    sudo apt-get install -y mise
}

case $1 in
init | cache | install) "omak_${1}" ;;
*)
    omak_init
    omak_update
    omak_install
    ;;
esac
