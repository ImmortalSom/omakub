#!/bin/bash

omak_install() {
    if ! command -v btop >/dev/null 2>&1; then
        # shellcheck source=/dev/null
        source "$OMAKUB_PATH/install/desktop/app-btop.sh"
    fi

    local desktop
    local src
    local dst
    for desktop in "btop" "org.gnome.SystemMonitor"; do
        src="/usr/share/applications/${desktop}.desktop"
        dst="$HOME/.local/share/applications/${desktop}.desktop"
        if [ -f "$src" ]; then
            cp "$src" "$dst"
            if ! grep -q "NoDisplay=true" "$dst"; then
                echo "[Desktop Entry] NoDisplay=true" >>"$dst"
            fi
        fi
    done
}

case $1 in
init | cache) true ;;
*) omak_install ;;
esac
