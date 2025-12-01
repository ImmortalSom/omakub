#!/bin/bash

# Typora is a markdown editor and reader. See https://typora.io/
omak_init() {
    if [ ! -f /etc/apt/sources.list.d/typora.list ] || [ ! -f /etc/apt/keyrings/typora.gpg ]; then
        omak_gpg "https://downloads.typora.io/typora.gpg" typora.gpg
        printf "%s\n" \
            "deb [signed-by=/etc/apt/keyrings/typora.gpg] https://downloads.typora.io/linux ./" |
            sudo tee /etc/apt/sources.list.d/typora.list >/dev/null
    fi
}

omak_update() {
    sudo apt-get update
}

omak_cache() {
    sudo apt-get --download-only install -y typora

    if [ -d "$OMAKUB_CACHE/iA-Fonts/.git" ]; then
        (cd "$OMAKUB_CACHE/iA-Fonts" && git pull --ff-only)
    else
        rm -rf "$OMAKUB_CACHE/iA-Fonts"
        git clone https://github.com/iaolo/iA-Fonts.git "$OMAKUB_CACHE/iA-Fonts"
    fi
}

omak_install() {
    sudo apt-get install -y typora

    cp "$OMAKUB_CACHE/iA-Fonts/iA Writer Mono/Static/"iAWriterMonoS-*.ttf ~/.local/share/fonts/ 2>/dev/null || true

    # Add iA Typora theme
    mkdir -p ~/.config/Typora/themes
    cp "$OMAKUB_PATH/configs/typora/ia_typora.css" ~/.config/Typora/themes/
    cp "$OMAKUB_PATH/configs/typora/ia_typora_night.css" ~/.config/Typora/themes/
}

case $1 in
init | cache | install) "omak_${1}" ;;
*)
    omak_init
    omak_update
    omak_install
    ;;
esac
