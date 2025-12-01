#!/bin/bash
echo "" # Add spacing
oprint_message "info" "Enter identification for git and autocomplete..." ""

GIT_USER_NAME=$(git config --global --get user.name 2>/dev/null) || true
if [ -z "$GIT_USER_NAME" ]; then
    GIT_USER_NAME=$(getent passwd "$USER" | awk -F'[:,]' '{print $5}')
fi
GIT_USER_EMAIL=$(git config --global --get user.email 2>/dev/null) || true

OMAKUB_USER_NAME=$(gum input --placeholder "Enter full name" --value "$GIT_USER_NAME" --prompt "Name: ")
export OMAKUB_USER_NAME

OMAKUB_USER_EMAIL=$(gum input --placeholder "Enter email address" --value "$GIT_USER_EMAIL" --prompt "Email: ")
export OMAKUB_USER_EMAIL
