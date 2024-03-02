#!/bin/sh

# Specify the directory where the mkimage profile script will be created
APORTS_SCRIPTS_DIR="/home/build/aports/scripts"
echo $PROFILE_NAME
# Ensure the directory exists
mkdir -p "$APORTS_SCRIPTS_DIR"

# Create the mkimage profile script based on the configuration
cat << EOF > "$APORTS_SCRIPTS_DIR/mkimg.$PROFILE_NAME.sh"
profile_$PROFILE_NAME() {
    "$PROFILE_TYPE"
    title="$DESC"
    arch="$ARCH"
    kernel_flavors="$KERNEL_FLAVORS"
    kernel_addons="$KERNEL_ADDONS"
    apks="\$apks $ADDITIONAL_APKS"
    for _k in \$kernel_flavors; do
        apks="\$apks linux-\$_k"
        for _a in \$kernel_addons; do
            apks="\$apks \$_a-\$_k"
        done
    done
}
EOF

cat "$APORTS_SCRIPTS_DIR/mkimg.$PROFILE_NAME.sh"

# Make the profile script executable
chmod +x "$APORTS_SCRIPTS_DIR/mkimg.$PROFILE_NAME.sh"
echo "Profile script created successfully for profile: $PROFILE_NAME"
