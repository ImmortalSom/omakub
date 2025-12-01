#!/bin/bash

set_font() {
    local font_name=$1
    local file_name=$2
    local file_type=$3

    if ! fc-list | grep -i "$font_name" >/dev/null; then
        gh_download "ryanoasis/nerd-fonts" "${file_name}.zip"
        mkdir -p ~/.local/share/fonts
        rm -rf "${OMAKUB_CACHE:?}/${file_name}"
        unzip "$OMAKUB_CACHE/${file_name}.zip" -d "$OMAKUB_CACHE/${file_name}"
        cp "$OMAKUB_CACHE/${file_name}/"*."$file_type" ~/.local/share/fonts/ 2>/dev/null || true
        rm -rf "${OMAKUB_CACHE:?}/${file_name}"
        fc-cache
    fi
    clear
    source "$OMAKUB_PATH/ascii.sh"

    OMAKUB_CURRENT_FONT_SIZE=$(gsettings get org.gnome.desktop.interface font-name | tr -d "'" | awk '{print $NF}')
    gsettings set org.gnome.desktop.interface font-name "$font_name $OMAKUB_CURRENT_FONT_SIZE"
    gsettings set org.gnome.desktop.interface monospace-font-name "$font_name Mono $OMAKUB_CURRENT_FONT_SIZE"

    mkdir -p ~/.config/alacritty
    cp "$OMAKUB_PATH/configs/alacritty/fonts/${file_name}.toml" ~/.config/alacritty/font.toml
    sed -i "s/\"editor.fontFamily\": \".*\"/\"editor.fontFamily\": \"$font_name\"/g" ~/.config/Code/User/settings.json
}

if [ "$#" -gt 1 ]; then
    choice=${!#}
else
    choice=$(gum choose "Caskaydia Mono" "Fira Mono" "JetBrains Mono" "Meslo" "> Change size" "<< Back" --height 8 --header "Choose your programming font")
fi

case $choice in
"Caskaydia Mono")
    # The author himself made a mistake in the name of the archive and, for the sake of backward compatibility, left it as a typo forever.
    set_font "CaskaydiaMono Nerd Font" "CascadiaMono" "ttf"
    ;;
"Fira Mono")
    set_font "FiraMono Nerd Font" "FiraMono" "otf"
    ;;
"JetBrains Mono")
    set_font "JetBrainsMono Nerd Font" "JetBrainsMono" "ttf"
    ;;
"Meslo")
    set_font "MesloLGS Nerd Font" "Meslo" "ttf"
    ;;
"> Change size")
    source "$OMAKUB_PATH/bin/omakub-sub/font-size.sh"
    exit
    ;;
esac

source "$OMAKUB_PATH/themes/set-qt6-theme.sh"
source "$OMAKUB_PATH/bin/omakub-sub/menu.sh"
