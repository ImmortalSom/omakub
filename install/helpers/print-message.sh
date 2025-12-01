#!/bin/bash

# Print a styled message with a header and optional body lines.
# Usage: oprint_message <type> <header> [message...]
#   type: error, warning, info, success (supports uppercase for bold)
# Example: oprint_message "info" "Starting setup..." "This may take a few seconds"
oprint_message() {
    local msg_type="$1"
    shift
    local header="$1"
    shift
    local msg_details=("$@")

    local red='\033[31m'
    local yellow='\033[93m'
    local green='\033[32m'
    local blue='\033[94m'
    local bold='\033[1m'
    local reset='\033[0m'

    local color=""

    case "${msg_type}" in
    error)
        color="$red" ;;
    "ERROR")
        color="${red}${bold}" ;;
    warning)
        color="$yellow" ;;
    "WARNING")
        color="${yellow}${bold}" ;;
    info)
        color="$blue" ;;
    "INFO")
        color="${blue}${bold}" ;;
    success)
        color="$green" ;;
    "SUCCESS")
        color="${green}${bold}" ;;
    *)
        color="$reset" ;;
    esac

    echo -e "${color}${header}${reset}" >&2

    if ((${#msg_details[@]} > 0)); then
        printf "%s\n" "${msg_details[@]}" >&2
    fi
}
