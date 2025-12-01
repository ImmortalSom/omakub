#!/bin/bash

omak_init() {
    true
}

omak_update() {
    true
}

omak_cache() {
    true
}

omak_install() {
    true
}

case $1 in
init | cache | install) "omak_${1}" ;;
*)
    omak_init
    omak_update
    omak_cache
    omak_install
    ;;
esac
