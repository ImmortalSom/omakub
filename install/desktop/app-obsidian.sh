#!/bin/bash

# Obsidian is a multi-platform note taking application. See https://obsidian.md
omak_cache() {
    local ARCH
    ARCH=$(uname -m | sed -e 's/aarch64/arm64/' -e 's/x86_64/amd64/')
    local tag
    tag=$(ogh_tag "obsidianmd/obsidian-releases")

    if [ "$ARCH" == "amd64" ]; then
        gh_download "obsidianmd/obsidian-releases" "obsidian_${tag#v}_${ARCH}.deb"
    else
        gh_download "obsidianmd/obsidian-releases" "obsidian-${tag#v}-${ARCH}.tar.gz"
    fi
}

omak_install() {
    local ARCH
    ARCH=$(uname -m | sed -e 's/aarch64/arm64/' -e 's/x86_64/amd64/')
    local tag
    tag=$(ogh_tag "obsidianmd/obsidian-releases")

    local releases_file
    if [ "$ARCH" == "amd64" ]; then
        releases_file=$(gh_download "obsidianmd/obsidian-releases" "obsidian_${tag#v}_${ARCH}.deb")
        sudo apt-get install -y "$releases_file"
    else
        releases_file=$(gh_download "obsidianmd/obsidian-releases" "obsidian-${tag#v}-${ARCH}.tar.gz")
        rm -rf "$OMAKUB_CACHE/obsidian-${tag#v}-${ARCH}"
        tar -xf "$releases_file" -C "$OMAKUB_CACHE"
        mkdir -p ~/.local/lib/obsidian
        cp -R "$OMAKUB_CACHE/obsidian-${tag#v}-${ARCH}/" ~/.local/lib/obsidian/
        rm -rf "$OMAKUB_CACHE/obsidian-${tag#v}-${ARCH}"

        rm -f ~/.local/bin/obsidian
        ln -s ~/.local/lib/obsidian/obsidian ~/.local/bin/obsidian
        printf "%s\n" \
            "[Desktop Entry]" \
            "Name=Obsidian" \
            "Exec=obsidian %U" \
            "Terminal=false" \
            "Type=Application" \
            "Icon=/home/$USER/.local/share/omakub/applications/icons/Obsidian.png" \
            "StartupWMClass=obsidian" \
            "Comment=Obsidian" \
            "MimeType=x-scheme-handler/obsidian;" \
            "Categories=Office;" |
            tee ~/.local/share/applications/obsidian.desktop >/dev/null
    fi
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
