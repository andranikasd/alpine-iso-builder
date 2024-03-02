#!/bin/sh

# Source the logger script
. /logger.sh

# Function to handle errors
error_handler() {
    ERROR_MSG="$?"
    log_error "An error occurred with profile: $PROFILE_NAME. Error code: $ERROR_MSG"
    exit 1
}

# Trap any error with error_handler
trap 'error_handler' ERR

# Set script to exit on errors
set -e

# Parse the configuration file and set environment variables
CONFIG_OUTPUT=$(python parse-config.py /image-settings.yaml 2>&1)
if [ $? -ne 0 ]; then
    log_error "$CONFIG_OUTPUT"
    exit 1
else
    eval "$CONFIG_OUTPUT"
fi

# Ensure PROFILE_NAME is valid and set
PROFILE_NAME=${PROFILE_NAME:-custom}
log_info "Profile name set to ${PROFILE_NAME}"
ABUILD_KEYGEN_OUTPUT=$(abuild-keygen -a -n 2>&1)
log_info "$ABUILD_KEYGEN_OUTPUT"

# Generate the overlay file from the YAML configuration
python /generate_overlay_from_yaml.py /image-settings.yaml /aports/scripts/genapkovl-mkimgoverlay.sh >/dev/null 2>&1
chmod +x /aports/scripts/genapkovl-mkimgoverlay.sh
log_info "Overlay file generated and permissions set."

# Call the script to create the mkimg.$PROFILE_NAME.sh script
CREATE_PROFILE_SCRIPT_OUTPUT=$(./create-mkimg-profile.sh "$PROFILE_NAME" "$ADDITIONAL_APKS" 2>&1)
log_info "$CREATE_PROFILE_SCRIPT_OUTPUT"

# Prepare temporary directory
mkdir -pv /tmp >/dev/null 2>&1

log_info "Attempting to source mkimg.$PROFILE_NAME.sh manually..."
source /aports/scripts/mkimg.$PROFILE_NAME.sh 

log_info "Running mkimage.sh with profile $PROFILE_NAME..."

export PACKAGER_PRIVKEY="/.abuild/*.rsa"

# Create ISO
MKIMAGE_OUTPUT=$(sh /aports/scripts/mkimage.sh --tag edge \
    --outdir /iso \
    --arch "$ARCH" \
    --repository https://dl-cdn.alpinelinux.org/alpine/edge/main \
    --profile "$PROFILE_NAME" 2>&1)
if [ $? -ne 0 ]; then
    log_error "$MKIMAGE_OUTPUT"
    exit 1
else
    log_info "$MKIMAGE_OUTPUT"
fi

log_info "ISO creation complete."
