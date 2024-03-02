#!/bin/sh

# Source the logger script
. /logger.sh

# Specify the directory where the mkimage profile script will be created
APORTS_SCRIPTS_DIR="/aports/scripts"

# Ensure the directory exists
mkdir -p "$APORTS_SCRIPTS_DIR" >/dev/null 2>&1

# Create the mkimage profile script based on the configuration
PROFILE_SCRIPT_CONTENT=$(cat << EOF
profile_$PROFILE_NAME() {
    profile_standard
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
)

echo "$PROFILE_SCRIPT_CONTENT" > "$APORTS_SCRIPTS_DIR/mkimg.$PROFILE_NAME.sh"
chmod +x "$APORTS_SCRIPTS_DIR/mkimg.$PROFILE_NAME.sh"
log_info "Profile script created successfully for profile: $PROFILE_NAME"
