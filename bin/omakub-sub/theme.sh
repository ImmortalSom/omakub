#!/bin/bash

THEME_NAMES=("Tokyo Night" "Catppuccin" "Nord" "Everforest" "Gruvbox" "Kanagawa" "Ristretto" "Rose Pine" "Matte Black" "Osaka Jade")
THEME=$(gum choose "${THEME_NAMES[@]}" "<< Back" --header "Choose your theme" --height 12 | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')

# shellcheck source=/dev/null
if [ -n "$THEME" ] && [ "$THEME" != "<<-back" ]; then
  install "$OMAKUB_PATH/themes/$THEME/alacritty.toml" ~/.config/alacritty/theme.toml
  mkdir -p  "$HOME/.config/zellij/themes"
  install "$OMAKUB_PATH/themes/$THEME/zellij.kdl" "$HOME/.config/zellij/themes/$THEME.kdl"
  sed -i "s/theme \".*\"/theme \"$THEME\"/g" ~/.config/zellij/config.kdl
  if [ -d "$HOME/.config/nvim" ]; then
    install "$OMAKUB_PATH/themes/$THEME/neovim.lua" ~/.config/nvim/lua/plugins/theme.lua
  fi

  if [ -f "$OMAKUB_PATH/themes/$THEME/btop.theme" ]; then
    install "$OMAKUB_PATH/themes/$THEME/btop.theme" "$HOME/.config/btop/themes/$THEME.theme"
    sed -i "s/color_theme = \".*\"/color_theme = \"$THEME\"/g" ~/.config/btop/btop.conf
  else
    sed -i "s/color_theme = \".*\"/color_theme = \"Default\"/g" ~/.config/btop/btop.conf
  fi

  source "$OMAKUB_PATH/themes/$THEME/gnome.sh"
  echo "Downloading VS Code appearance theme..."
  source "$OMAKUB_PATH/themes/$THEME/vscode.sh"

  # Forgo setting the Chrome theme until we might find a less disruptive way of doing it.
  # Having to quit Chrome, and all Chrome-based apps, is too much of an inposition.
  # source $OMAKUB_PATH/themes/$THEME/chrome.sh
fi
clear
source "$OMAKUB_PATH/bin/omakub-sub/header.sh"
source "$OMAKUB_PATH/bin/omakub-sub/menu.sh"
