omak_gpg() {
    local gpg_url="$1"
    local gpg_name="$2"
    local cache_path="$OMAKUB_CACHE/$gpg_name"
    local keyring_path="/etc/apt/keyrings/$gpg_name"

    # Download key
    if ! aria2c -s 1 -x 1 \
        --retry-wait=10 \
        --max-tries=5 \
        --timeout=60 \
        --connect-timeout=60 \
        --auto-file-renaming=false \
        --allow-overwrite \
        --console-log-level=warn \
        --summary-interval=0 \
        --dir "$OMAKUB_CACHE" \
        -o "$gpg_name" "$gpg_url" 1>&2; then
        oprint_message "error" "Failed to download GPG key from $gpg_url"
        return 1
    fi

    # Verify download
    if [ ! -s "$cache_path" ]; then
        oprint_message "error" "Downloaded GPG file is empty"
        rm -f "$cache_path"
        return 1
    fi

    # Verify it's a valid ASCII-armored GPG key
    if ! gpg --list-packets "$cache_path" >/dev/null 2>&1; then
        oprint_message "error" "Downloaded file is not a valid GPG key"
        rm -f "$cache_path"
        return 1
    fi

    # Atomically replace the keyring file
    if ! sudo gpg --dearmor -o "$keyring_path.new" "$cache_path" 2>/dev/null; then
        oprint_message "error" "Failed to dearmor GPG key"
        rm -f "$cache_path" "$keyring_path.new"
        return 1
    fi

    # Only now remove old and replace with new
    sudo mv "$keyring_path.new" "$keyring_path"
    rm -f "$cache_path"

    # Optional: verify binary key is readable
    if ! gpg --keyring "$keyring_path" --list-keys >/dev/null 2>&1; then
        oprint_message "warning" "Imported keyring may be corrupted, but saved: $keyring_path"
    fi
}
