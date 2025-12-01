#!/bin/bash

omak_install() {
    envsubst <"$OMAKUB_PATH/configs/xcompose" >~/.XCompose
    ibus restart
    gsettings set org.gnome.desktop.input-sources xkb-options "['compose:caps']"
}

case $1 in
init |  cache) true ;;
*) omak_install ;;
esac
