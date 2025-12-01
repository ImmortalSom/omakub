# Fetch the tag name (e.g. "v0.24.2") of the latest GitHub release for a given repository.
# Usage: ogh_tag <owner/repo>
#   - Always fetches the latest release (ignores any symbolic tags like "stable").
#   - Returns only the raw tag name from the 'tag_name' field in the GitHub API response.
#
# Example:
#   ogh_tag "jesseduffield/lazydocker"
ogh_tag() {
    local repo="$1"
    local tag
    tag=$(ogh_api "$repo") || return 1
    jq -r '.tag_name' "$tag"
}
