#!/bin/bash

# Function to run a specific phase across all modules in a directory
# Usage: omak_bootstrap <dir> [phase]
#   phase: init, sync, install
# Example: omak_bootstrap "$HOME/.local/share/omakub/install/terminal" install

omak_bootstrap() {
    local dir="$1"
    local phase="$2"

    if [[ -z "$dir" ]]; then
        oprint_message "error" "Usage: omak_bootstrap <dir>"
        return 1
    fi

    if [[ ! -d "$dir" ]]; then
        oprint_message "error" "Directory $dir does not exist."
        return 1
    fi

    for module in "$dir/"*.sh; do
        if [[ -f "$module" ]]; then
            # shellcheck source=/dev/null
            source "$module" "$phase" || return 1
        fi
    done
}
