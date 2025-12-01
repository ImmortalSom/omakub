#!/bin/bash

omak_cache() {
    sudo apt-get --download-only install -y alacritty
}

omak_install() {
    # Alacritty is a GPU-powered and highly extensible terminal. See https://alacritty.org/
    sudo apt-get install -y alacritty
}
omak_config() {
    if ! command -v zellij >/dev/null 2>&1; then
        source "$OMAKUB_PATH/install/terminal/app-zellij.sh" install
    fi
    mkdir -p ~/.config/alacritty
    cp "$OMAKUB_PATH/configs/alacritty.toml" ~/.config/alacritty/alacritty.toml
    cp "$OMAKUB_PATH/configs/alacritty/shared.toml" ~/.config/alacritty/shared.toml
    cp "$OMAKUB_PATH/configs/alacritty/pane.toml" ~/.config/alacritty/pane.toml
    cp "$OMAKUB_PATH/configs/alacritty/btop.toml" ~/.config/alacritty/btop.toml
    cp "$OMAKUB_PATH/themes/tokyo-night/alacritty.toml" ~/.config/alacritty/theme.toml
    cp "$OMAKUB_PATH/configs/alacritty/fonts/CaskaydiaMono.toml" ~/.config/alacritty/font.toml
    cp "$OMAKUB_PATH/configs/alacritty/font-size.toml" ~/.config/alacritty/font-size.toml

    # Migrate config format if needed
    alacritty migrate 2>/dev/null || true
    alacritty migrate -c ~/.config/alacritty/pane.toml 2>/dev/null || true
    alacritty migrate -c ~/.config/alacritty/btop.toml 2>/dev/null || true

    if [ -f /usr/share/applications/vim.desktop ]; then
        cp /usr/share/applications/vim.desktop ~/.local/share/applications/vim.desktop
        if ! grep -q "NoDisplay=true" ~/.local/share/applications/vim.desktop; then
            echo "[Desktop Entry] NoDisplay=true" >>~/.local/share/applications/vim.desktop
        fi
    fi
}

omak_quest() {
    echo "Installing the application..."
    omak_install
    if gum confirm "Would you like to apply Omakub configuration for this application?"; then
        echo "Applying Omakub settings..."
        omak_config
        omak_install
    else
        echo "Skipping Omakub configuration."
        omak_install
    fi
}

case $1 in
init) true ;;
cache | config) "omak_${1}" ;;
full | install)
    omak_install
    omak_config
    ;;
*) omak_quest ;;
esac
