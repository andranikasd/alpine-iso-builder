#!/bin/sh

# Exit on errors
set -e

# Parse the configuration file and set environment variables
eval "$(python parse-config.py /home/build/image-settings.yaml)"

# Ensure PROFILE_NAME is valid and set
PROFILE_NAME=${PROFILE_NAME:-custom}
echo "$PROFILE_NAME"
abuild-keygen -a -n
# Clone the aports repository if necessary

# Generate the overlay file from the YAML configuration
python /home/build/generate_overlay_from_yaml.py /home/build/image-settings.yaml > /home/build/aports/scripts/genapkovl-mkimgoverlay.sh
chmod +x /home/build/aports/scripts/genapkovl-mkimgoverlay.sh

# Call the script to create the mkimg.$PROFILE_NAME.sh script
./create-mkimg-profile.sh "$PROFILE_NAME" "$ADDITIONAL_APKS"

# Prepare temporary directory
mkdir -pv ~/tmp
export TMPDIR=~/tmp

echo "Attempting to source mkimg.$PROFILE_NAME.sh manually..."
source /home/build/aports/scripts/mkimg.$PROFILE_NAME.sh

echo "Running mkimage.sh with profile $PROFILE_NAME..."

export PACKAGER_PRIVKEY="/home/build/.abuild/*.rsa"

# Create ISO
mkdir -p ~/iso
sh /home/build/aports/scripts/mkimage.sh --tag edge \
    --outdir ~/iso \
    --arch "$ARCH" \
    --repository https://dl-cdn.alpinelinux.org/alpine/edge/main \
    --profile "$PROFILE_NAME"

echo "ISO creation complete."
