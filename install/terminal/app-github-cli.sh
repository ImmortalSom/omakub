#!/bin/bash

# Display system information in the terminal
omak_init() {
    if [ ! -f /etc/apt/sources.list.d/github-cli.sources ] || [ ! -f /etc/apt/keyrings/githubcli-archive-keyring.gpg ]; then
        omak_gpg https://cli.github.com/packages/githubcli-archive-keyring.gpg githubcli-archive-keyring.gpg
        printf "%s\n" \
            "Types: deb" \
            "URIs: https://cli.github.com/packages" \
            "Suites: stable" \
            "Components: main" \
            "Signed-By: /etc/apt/keyrings/githubcli-archive-keyring.gpg" |
            sudo tee /etc/apt/sources.list.d/github-cli.sources >/dev/null
    fi
}

omak_update() {
    sudo apt-get update
}

omak_cache() {
    sudo apt-get --download-only install -y gh
}

omak_install() {
    sudo apt-get install -y gh
}

case $1 in
init | cache | install) "omak_${1}" ;;
*)
    omak_init
    omak_update
    omak_install
    ;;
esac
