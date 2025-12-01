#!/bin/bash

# Gum is used for the Omakub commands for tailoring Omakub after the initial install
if [ ! -f /etc/apt/sources.list.d/charm.sources ] || [ ! -f /etc/apt/keyrings/charm.gpg ]; then
    omak_gpg https://repo.charm.sh/apt/gpg.key charm.gpg
    printf '%s\n' \
        "Types: deb" \
        "URIs: https://repo.charm.sh/apt" \
        "Suites: *" \
        "Components: *" \
        "Signed-By: /etc/apt/keyrings/charm.gpg" |
        sudo tee /etc/apt/sources.list.d/charm.sources >/dev/null
fi
