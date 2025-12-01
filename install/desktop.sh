#!/bin/bash

for phase in "init" "pre-update" "cache" "install"; do
    case "$phase" in
    "pre-update")
        oprint_message "info" "Running phase: $phase"
        sudo apt-get update
        sudo apt-get upgrade -y
        ;;
    *)
        oprint_message "info" "Running phase: $phase"
        for category in "terminal" "desktop"; do
            omak_bootstrap "$HOME/.local/share/omakub/install/$category" "$phase" || {
                oprint_message "error" "Bootstrap phase '$phase' failed"
                return 1
            }
        done
        ;;
    esac
    oprint_message "success" "Successfully completed $phase phase."
    echo
done
