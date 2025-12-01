for phase in init "pre-update" cache install; do
    case "$phase" in
    "pre-update")
        oprint_message "info" "Running phase: $phase"
        sudo apt-get update
        sudo apt-get upgrade -y
        ;;
    *)
        oprint_message "info" "Running phase: $phase"
        omak_bootstrap "$HOME/.local/share/omakub/install/terminal" "$phase" || {
            oprint_message "error" "Bootstrap phase '$phase' failed"
            return 1
        }
        ;;
    esac
    oprint_message "success" "Successfully completed $phase phase."
    echo
done
