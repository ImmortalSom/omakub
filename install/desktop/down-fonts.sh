#!/bin/bash

omak_cache() {
    # local fonts=("CascadiaMono" "JetBrainsMono" "FiraMono" "Meslo")
    local fonts=("CascadiaMono")
    local font
    for font in "${fonts[@]}"; do
        gh_download "ryanoasis/nerd-fonts" "${font}.zip"
    done
}

omak_install() {
    # local fonts=("CascadiaMono" "JetBrainsMono" "Meslo")
    local fonts=("CascadiaMono")
    mkdir -p ~/.local/share/fonts
    local font
    for font in "${fonts[@]}"; do
        rm -rf "${OMAKUB_CACHE:?}/${font}"
        unzip "$OMAKUB_CACHE/${font}.zip" -d "$OMAKUB_CACHE/${font}"
        cp "$OMAKUB_CACHE/${font}/"*.ttf ~/.local/share/fonts/ 2>/dev/null || true
        rm -rf "${OMAKUB_CACHE:?}/${font}"
    done

    # # FiraMono
    # rm -rf "${OMAKUB_CACHE:?}/FiraMono"
    # unzip "$OMAKUB_CACHE/FiraMono.zip" -d "$OMAKUB_CACHE/FiraMono"
    # cp "$OMAKUB_CACHE/FiraMono/"*.otf ~/.local/share/fonts/ 2>/dev/null || true
    # rm -rf "${OMAKUB_CACHE:?}/FiraMono"

    fc-cache -f
}

case $1 in
init) true ;;
cache) omak_cache ;;
*)
    omak_cache
    omak_install
    ;;
esac
