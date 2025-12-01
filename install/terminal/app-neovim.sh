#!/bin/bash

omak_cache() {
    sudo apt-get --download-only install -y luarocks tree-sitter-cli

    local ARCH
    ARCH=$(uname -m | sed 's/aarch64/arm64/')

    gh_download "neovim/neovim" "nvim-linux-${ARCH}.tar.gz" "stable"

    if [ ! -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]; then
        git clone https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim
    fi
    if [ ! -d "$HOME/.config/nvim" ]; then
        git clone https://github.com/LazyVim/starter ~/.config/nvim
    fi
}

omak_install() {
    # Install luarocks and tree-sitter-cli to resolve lazyvim :checkhealth warnings
    sudo apt-get install -y luarocks tree-sitter-cli

    local ARCH
    ARCH=$(uname -m | sed 's/aarch64/arm64/')
    local releases_file
    releases_file=$(gh_download "neovim/neovim" "nvim-linux-${ARCH}.tar.gz" "stable")

    rm -rf "$OMAKUB_CACHE/nvim-linux-${ARCH}"
    tar -xf "$releases_file" -C "$OMAKUB_CACHE"
    install -m 755 "$OMAKUB_CACHE/nvim-linux-${ARCH}/bin/nvim" ~/.local/bin/nvim
    cp -R "$OMAKUB_CACHE/nvim-linux-${ARCH}/lib" ~/.local/
    cp -R "$OMAKUB_CACHE/nvim-linux-${ARCH}/share" ~/.local/
    rm -rf "$OMAKUB_CACHE/nvim-linux-${ARCH}"

    # Only attempt to set configuration if Neovim has never been run
    if [ -d "$HOME/.config/nvim/.git" ]; then
        # Remove the .git folder, so you can add it to your own repo later
        rm -rf ~/.config/nvim/.git
        # Make everything match the terminal transparency
        mkdir -p ~/.config/nvim/plugin/after
        cp "$OMAKUB_PATH/configs/neovim/transparency.lua" ~/.config/nvim/plugin/after/

        # Default to Tokyo Night theme
        cp "$OMAKUB_PATH/themes/tokyo-night/neovim.lua" ~/.config/nvim/lua/plugins/theme.lua

        # Turn off animated scrolling
        cp "$OMAKUB_PATH/configs/neovim/snacks-animated-scrolling-off.lua" ~/.config/nvim/lua/plugins/

        # Turn off relative line numbers
        echo "vim.opt.relativenumber = false" >>~/.config/nvim/lua/config/options.lua

        # Ensure editor.neo-tree is used by default
        cp "$OMAKUB_PATH/configs/neovim/lazyvim.json" ~/.config/nvim/
    fi
    printf "%s\n" \
        'n() { if [ "$#" -eq 0 ]; then nvim .; else nvim "$@"; fi; }' |
        tee ~/.config/aliases/neovim.sh >/dev/null

    if [ ! -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]; then
        git clone https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim
    fi
    if [ ! -d "$HOME/.config/nvim" ]; then
        git clone https://github.com/LazyVim/starter ~/.config/nvim
    fi
}

case $1 in
init) true ;;
cache) omak_cache ;;
*) omak_install ;;
esac
