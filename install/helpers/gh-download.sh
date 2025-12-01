#!/bin/bash

# Download a specific binary asset from a GitHub release.
# Usage: gh_download <owner/repo> <filename> [tag]
#   - If <tag> is provided, downloads from the release tagged as <tag>.
#   - If <tag> is omitted, downloads from the latest release.
#   - Verifies file integrity using the SHA256 digest from the release metadata (if available).
#   - If GitHub does not provide a digest (e.g. .digest is null), verification is skipped
#     and the file may be re-downloaded on subsequent runs.
#   - Uses caching: skips download if a valid file already exists and passes verification.
# Returns: absolute path to the downloaded file on success.
#
# Examples:
#   gh_download "jesseduffield/lazygit" "lazygit_0.45.2_Linux_x86_64.tar.gz"
#   gh_download "neovim/neovim" "nvim-linux-x86_64.tar.gz" "stable"
gh_download() {
    local repo="$1"
    local file="$2"
    local tag="$3"

    if [ -z "$repo" ]; then
        oprint_message "error" "Missing repo argument (e.g. 'owner/repo')"
        return 1
    fi

    if [ -z "$file" ]; then
        oprint_message "error" "Missing filename argument (e.g. 'file.tar.gz')" \
        "Repo: $repo"
        return 1
    fi

    if [ ! -d "$OMAKUB_CACHE" ]; then
        oprint_message "error" "Cache directory not found: $OMAKUB_CACHE"
        return 1
    fi

    local meta
    meta=$(ogh_api "$repo" "$tag")

    local expected_sha256
    expected_sha256=$(jq -r ".assets[] | select(.name == \"$file\" and .digest != null) | .digest | sub(\"^sha256:\"; \"\")" "$meta" 2>/dev/null)

    local local_file="$OMAKUB_CACHE/$file"

    if [ -f "$local_file" ] && [ -n "$expected_sha256" ]; then
        local actual_sha256
        actual_sha256=$(sha256sum "$local_file" | cut -d' ' -f1)
        if [ "$actual_sha256" = "$expected_sha256" ]; then
            echo "$local_file"
            return 0
        fi

    elif [ -f "$local_file" ]; then
        echo "$local_file"
        return 0
    fi

    local download_url="https://github.com/$repo/releases/latest/download/$file"
    if [ -n "$tag" ]; then
        download_url="https://github.com/$repo/releases/download/$tag/$file"
    fi

    if aria2c -s 1 -x 1 \
        --retry-wait=10 \
        --max-tries=5 \
        --timeout=60 \
        --connect-timeout=60 \
        --auto-file-renaming=false \
        --allow-overwrite \
        --console-log-level=warn \
        --summary-interval=0 \
        --dir "$OMAKUB_CACHE" \
        -o "$file" "$download_url" 1>&2; then
        echo "$local_file"
        return 0
    else
        oprint_message "error" "Failed to download $file from $repo"
        return 1
    fi
}
