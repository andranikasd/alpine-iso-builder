#!/bin/sh

# Define colors for pretty output (optional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Log an informational message
log_info() {
    printf "%b[INFO]%b %s\n" "$GREEN" "$NC" "$1"
}

# Log a warning message
log_warning() {
    printf "%b[WARNING]%b %s\n" "$YELLOW" "$NC" "$1"
}

# Log an error message
log_error() {
    printf "%b[ERROR]%b %s\n" "$RED" "$NC" "$1"
}

