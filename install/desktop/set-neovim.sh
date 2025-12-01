#!/bin/bash

omak_install() {
    # Install NeoVim if not present
    if ! command -v nvim >/dev/null 2>&1; then
        source "$OMAKUB_PATH/install/terminal/app-neovim.sh"
    fi
    # Install Alacritty if not present
    if ! command -v alacritty >/dev/null 2>&1; then
        source "$OMAKUB_PATH/install/desktop/app-alacritty.sh"
    fi

    # Hide system nvim.desktop by copying to user dir and marking NoDisplay
    if [ -f /usr/share/applications/nvim.desktop ]; then
        cp /usr/share/applications/nvim.desktop ~/.local/share/applications/nvim.desktop
        if ! grep -q "NoDisplay=true" ~/.local/share/applications/nvim.desktop; then
            echo "[Desktop Entry] NoDisplay=true" >>~/.local/share/applications/nvim.desktop
        fi
    fi
    printf "%s\n" \
        "[Desktop Entry]" \
        "Version=1.0" \
        "Name=Neovim" \
        "Comment=Edit text files" \
        "Exec=alacritty --config-file /home/$USER/.config/alacritty/pane.toml --class=Neovim --title=Neovim -e nvim %F" \
        "Terminal=false" \
        "Type=Application" \
        "Icon=nvim" \
        "Categories=Utilities;TextEditor;" \
        "StartupNotify=false" |
        tee ~/.local/share/applications/Neovim.desktop >/dev/null
}

case $1 in
init | cache) true ;;
*) omak_install ;;
esac
