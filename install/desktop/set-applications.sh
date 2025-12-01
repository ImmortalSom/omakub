#!/bin/bash

omak_install() {
    for script in "$OMAKUB_PATH/applications/"*.sh; do
        # shellcheck source=/dev/null
        source "$script"
    done
}

case $1 in
init | cache) true ;;
*) omak_install ;;
esac
