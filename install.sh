#!/bin/bash

# shellcheck source=/dev/null
cd ~/.local/share/omakub
clear
source "$HOME/.local/share/omakub/ascii.sh"
echo "" # Add spacing
echo "                                 $(cat "$HOME"/.local/share/omakub/version)"
echo "" # Add spacing
echo
# Exit immediately if a command exits with a non-zero status
set -eEo pipefail
# Give people a chance to retry running the installation
trap 'printf "%b\n" \
    "\033[31m[Omakub installation failed!]\033[0m" \
    "You can retry by running:" \
    "source ~/.local/share/omakub/install.sh" >&2' ERR
# Source utility functions
source "$HOME/.local/share/omakub/install/helpers/all.sh"

# Check the distribution name and version and abort if incompatible
source "$HOME/.local/share/omakub/install/check-version.sh"

# Inform user about upcoming choices
oprint_message "info" "Get ready to make a few choices..."

source "$HOME/.local/share/omakub/install/pre-install/all.sh"
source "$HOME/.local/share/omakub/install/identification.sh"

# Desktop software and tweaks will only be installed if we're running Gnome
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]]; then
    # Ensure computer doesn't go to sleep or lock while installing
    gsettings set org.gnome.desktop.screensaver lock-enabled false
    gsettings set org.gnome.desktop.session idle-delay 0

    oprint_message "info" "Installing terminal and desktop tools..."
    source "$HOME/.local/share/omakub/install/gnome.sh"

    # Revert to normal idle and lock settings
    gsettings set org.gnome.desktop.screensaver lock-enabled true
    gsettings set org.gnome.desktop.session idle-delay 300
elif [ -n "$XDG_CURRENT_DESKTOP" ] || [ -n "$XDG_SESSION_DESKTOP" ]; then
    oprint_message "info" "Installing terminal and desktop tools..."
    source "$HOME/.local/share/omakub/install/desktop.sh"
else
    oprint_message "info" "Only installing terminal tools..."
    source "$HOME/.local/share/omakub/install/terminal.sh"
fi
