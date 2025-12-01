#!/bin/bash

omak_install() {

    # Install Alacritty if not present
    if ! command -v alacritty >/dev/null 2>&1; then
        source "$OMAKUB_PATH/install/desktop/app-alacritty.sh" install
    fi
    if [ -f ~/.local/bin/lazydocker ]; then
        source "$OMAKUB_PATH/install/terminal/app-lazydocker.sh" install
    fi

    printf "%s\n" \
        "[Desktop Entry]" \
        "Version=1.0" \
        "Name=Docker" \
        "Comment=Manage Docker containers with LazyDocker" \
        "Exec=alacritty --config-file /home/$USER/.config/alacritty/pane.toml --class=Docker --title=Docker -e lazydocker" \
        "Terminal=false" \
        "Type=Application" \
        "Icon=$OMAKUB_PATH/applications/icons/Docker.png" \
        "Categories=GTK;" \
        "StartupNotify=false" |
        tee ~/.local/share/applications/Docker.desktop >/dev/null
}

case $1 in
init | cache) true ;;
*) omak_install ;;
esac
