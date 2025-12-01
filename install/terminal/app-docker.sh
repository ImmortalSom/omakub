#!/bin/bash

omak_init() {
    # Add the official Docker repo
    local codaname
    codaname=$VERSION_CODENAME
    local id_dist
    id_dist=$ID
    if [ "$id_dist" != "ubuntu" ]; then
        codaname="trixie"
        id_dist="debian"
    fi

    if [ ! -f /etc/apt/sources.list.d/docker.sources ] || [ ! -f /etc/apt/keyrings/docker.gpg ]; then
        omak_gpg "https://download.docker.com/linux/$id_dist/gpg" docker.gpg
        printf "%s\n" \
            "Types: deb" \
            "URIs: https://download.docker.com/linux/$id_dist" \
            "Suites: $codaname" \
            "Components: stable" \
            "Signed-By: /etc/apt/keyrings/docker.gpg" |
            sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null
    fi
}

omak_update() {
    sudo apt-get update
}

omak_cache() {
    sudo apt-get --download-only install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
}

omak_install() {
    # Install Docker engine and standard plugins
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

    # Give this user privileged Docker access
    sudo usermod -aG docker "$USER"

    # Limit log size to avoid running out of disk
    echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json
}

case $1 in
init | cache | install) "omak_${1}" ;;
*)
    omak_init
    omak_update
    omak_install
    ;;
esac
