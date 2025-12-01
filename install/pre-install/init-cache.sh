#!/bin/bash

# Create and prepare directory cache
sudo mkdir -p /var/cache/omakub
if ! getent group omakub >/dev/null 2>&1; then
    sudo groupadd omakub
fi
sudo chown :omakub /var/cache/omakub
sudo chmod 775 /var/cache/omakub

# If user is not in group, add and re-exec in new group session
if ! groups | grep -qF omakub; then
    sudo usermod -aG omakub "$USER"
    chmod +x "$OMAKUB_PATH/install.sh"
    exec newgrp omakub <<<"$OMAKUB_PATH/install.sh"
fi

export OMAKUB_CACHE="/var/cache/omakub"
