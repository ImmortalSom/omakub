#!/bin/bash

sudo apt-get -f install -y
sudo apt-get update
sudo apt-get upgrade -y
# Needed for all installers
sudo apt-get install -y curl git unzip aria2 gpg gnupg wget jq gum apt-transport-https
