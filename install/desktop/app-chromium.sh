#!/bin/bash
true
# omak_init() {
#     if ! { [ "$ID" = "debian" ] && [ "$VERSION_CODENAME" = "trixie" ]; }; then

#         if [ ! -f /etc/apt/sources.list.d/debian-trixie.sources ] || [ ! -f /etc/apt/keyrings/debian-trixie.gpg ]; then
#             omak_gpg https://ftp-master.debian.org/keys/archive-key-13.asc debian-trixie.gpg
#             printf "%s\n" \
#                 "Types: deb" \
#                 "URIs: https://deb.debian.org/debian" \
#                 "Suites: trixie" \
#                 "Components: main" \
#                 "Signed-By: /etc/apt/keyrings/debian-trixie.gpg" |
#                 sudo tee /etc/apt/sources.list.d/debian-trixie.sources >/dev/null
#             printf "%s\n" \
#                 "Package: *" \
#                 "Pin: release o=Debian,n=trixie" \
#                 "Pin-Priority: -10" |
#                 sudo tee /etc/apt/preferences.d/debian-trixie.pref >/dev/null
#         fi

#         if [ ! -f /etc/apt/preferences.d/chromium.pref ] &&
#             [ -f /etc/apt/sources.list.d/debian-sid.sources ] &&
#             ! apt-cache show chromium >/dev/null 2>&1; then
#             printf "%s\n" \
#                 "Package: chromium chromium-common chromium-driver chromium-headless-shell" \
#                 "Pin: release a=unstable" \
#                 "Pin-Priority: 100" \
#                 "#" \
#                 "#" \
#                 "Package: chromium-l10n chromium-lwn4chrome chromium-sandbox chromium-shell" \
#                 "Pin: release o=Debian,n=trixie" \
#                 "Pin-Priority: 100" |
#                 sudo tee /etc/apt/preferences.d/chromium.pref >/dev/null
#         fi
#     fi
# }

# omak_update() {
#     sudo apt-get update
# }

# omak_cache() {
#     sudo apt-get --download-only install -y chromium
# }

# omak_install() {
#     sudo apt-get install -y chromium
#     xdg-settings set default-web-browser chromium.desktop
# }

# case $1 in
# init | cache | install) "omak_${1}" ;;
# *)
#     omak_init
#     omak_update
#     omak_install
#     ;;
# esac
