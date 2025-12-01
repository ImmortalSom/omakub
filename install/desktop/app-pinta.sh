#!/bin/bash

# Pinta is a simple drawing and image editing program. See https://www.pinta-project.com/
omak_install() {
    flatpak install -y flathub com.github.PintaProject.Pinta
}

case $1 in
init | cache) true ;;
*) omak_install ;;
esac
