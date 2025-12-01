#!/bin/bash

# Fetch release metadata from GitHub API and cache it for 2 hours.
# Usage: ogh_api <owner/repo> [tag]
#   - If <tag> is provided, fetches the release for that specific tag.
#   - If <tag> is omitted, fetches the latest release.
# Example: ogh_api "neovim/neovim"
# Example: ogh_api "neovim/neovim" "stable"
ogh_api() {
    local repo="$1"
    local tag="$2"

    if [ -z "$repo" ]; then
        oprint_message "error" "Missing repo argument (e.g. 'owner/repo')"
        return 1
    fi

    local prefix="${repo//\//_}"
    local now
    now=$(date +%s 2>/dev/null || echo 0)

    if [ ! -d "$OMAKUB_CACHE" ]; then
        oprint_message "error" "Cache directory not found: $OMAKUB_CACHE"
        return 1
    fi

    local latest_file
    latest_file=$(ls -1t "$OMAKUB_CACHE"/"${prefix}"_*.json 2>/dev/null | head -n1)

    if [ -n "$latest_file" ] && [ -f "$latest_file" ]; then
        if is_valid_json "$latest_file"; then
            local file_time
            file_time=$(stat -c %Y "$latest_file" 2>/dev/null || echo 0)
            if [ "$((now - file_time))" -lt 7200 ]; then
                echo "$latest_file"
                find "$OMAKUB_CACHE" -name "${prefix}_*.json" ! -path "$latest_file" -delete 2>/dev/null || true
                return 0
            fi
        else
            rm -f "$latest_file"
            find "$OMAKUB_CACHE" -name "${prefix}_*.json" -delete 2>/dev/null || true
        fi
    fi

    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S 2>/dev/null || echo "unknown")
    local new_file="${prefix}_${timestamp}.json"

    local download_url="https://api.github.com/repos/$repo/releases/latest"
    if [ -n "$tag" ]; then
        download_url="https://api.github.com/repos/$repo/releases/tags/$tag"
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
        -o "$new_file" "$download_url" 1>&2; then
        echo "${OMAKUB_CACHE}/${new_file}"
        return 0
    else
        oprint_message "error" "Failed to fetch release data for $repo"
        return 1
    fi
}
