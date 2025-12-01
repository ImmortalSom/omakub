#!/bin/bash

# Check if a file contains valid JSON
# Usage: is_valid_json "/path/to/file"
is_valid_json() {
    local file="$1"
    [ -s "$file" ] && jq empty "$file" >/dev/null 2>&1
}
