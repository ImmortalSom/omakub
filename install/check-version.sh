#!/bin/bash

# Check if /etc/os-release exists
if [ ! -f /etc/os-release ]; then
    oprint_message "error" "[Unable to determine OS]" \
        "/etc/os-release file not found." \
        "Installation stopped."
    return 1
fi

# Load OS release information
. /etc/os-release

# Check if running on Ubuntu 24.04 or higher, or Debian 13 or higher, using bc for version comparison
if ! [ -d /etc/apt ]; then
    oprint_message "error" "[OS requirement not met]" \
        "Omakub only supports operating systems" \
        "based on the APT package manager." \
        "You are currently running: ${ID^} $VERSION_ID" \
        "Installation stopped." \
        ""
    return 1
fi
if ([ "$ID" = "ubuntu" ] && ! dpkg --compare-versions "$VERSION_ID" ge "24.04") ||
   ([ "$ID" = "debian" ] && ! dpkg --compare-versions "$DEBIAN_VERSION_FULL" ge "13"); then
    oprint_message "warning" "[OS requirement not met]" \
        "You are currently running: ${ID^} $VERSION_ID" \
        "OS required: Ubuntu 24.04 or higher, or Debian 13 or higher." \
        ""
fi

# Check system architecture
ARCH=$(uname -m)
if [ "$ARCH" != "x86_64" ] && [ "$ARCH" != "aarch64" ]; then
    oprint_message "error" "[Unsupported architecture detected]" \
        "Current architecture: $ARCH" \
        "This installation is only supported on x86_64 and aarch64 architectures." \
        "Installation stopped." \
        ""
    return 1
fi
