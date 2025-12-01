if ! { [ "$ID" = "debian" ] && [ "$VERSION_CODENAME" = "trixie" ]; } ; then
    if [ ! -f /etc/apt/sources.list.d/debian-trixie.sources ] || [ ! -f /etc/apt/keyrings/debian-trixie.gpg ]; then
        omak_gpg https://ftp-master.debian.org/keys/archive-key-13.asc debian-trixie.gpg
        printf "%s\n" \
            "Types: deb" \
            "URIs: https://deb.debian.org/debian" \
            "Suites: trixie" \
            "Components: main" \
            "Signed-By: /etc/apt/keyrings/debian-trixie.gpg" |
            sudo tee /etc/apt/sources.list.d/debian-trixie.sources >/dev/null
        printf "%s\n" \
            "Package: *" \
            "Pin: release o=Debian,n=trixie" \
            "Pin-Priority: -10" |
            sudo tee /etc/apt/preferences.d/debian-trixie.pref >/dev/null
    fi
fi
