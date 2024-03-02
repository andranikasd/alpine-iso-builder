import yaml
import sys

def main(config_path, output_script_path):
    try:
        with open(config_path, 'r') as stream:
            config = yaml.safe_load(stream)
    except Exception as e:
        print(f"Error reading YAML file: {e}", file=sys.stderr)
        sys.exit(1)

    additional_apks = config.get('additional_apks', [])
    
    # Prepare the content for the overlay script
    overlay_script_content = """#!/bin/sh
tmp=$(mktemp -d)
mkdir -p "$tmp"/etc/apk
cat <<EOF > "$tmp"/etc/apk/world
alpine-base
""" + '\n'.join(additional_apks) + """
EOF

# Example of adding services to start on boot, adjust as necessary
# rc_add sshd boot
# rc_add networking boot

tar -czf "$1" -C "$tmp" .
rm -rf "$tmp"
"""

    # Write the script content to a file
    with open(output_script_path, 'w') as script_file:
        script_file.write(overlay_script_content)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python generate_overlay_from_yaml.py image-settings.yaml output_script.sh", file=sys.stderr)
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])
