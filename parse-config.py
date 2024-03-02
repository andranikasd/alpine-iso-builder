import yaml
import sys

def print_usage():
    print("Usage: python parse-config.py <path_to_yaml>")
    print("\nExample of a config file (image-settings.yaml):")
    print("""
profile_type: "standard" # Options: "standard (for normal usage)", "extended (Running on RAM For servers etc ..)"
iso_name: "gambit_custom"
desc: "Minimal Alpine Linux for Gambit"
arch: "x86_64"
alpine_version: "3.14"  # Specify custom Alpine version
kernel_flavors: "lts"
kernel_addons: ""
bootloader: "grub"  # Choose bootloader: grub, syslinux, etc.
partitioning_scheme:
- name: "root"
    size: "10G"
    type: "ext4"
- name: "swap"
    size: "1G"
profile_name: "gambit_custom"
additional_apks:
- linux-firmware
- nfs-utils
- python3
- htop
- curl
- openrc
- iptables
- sudo
""")

def main(config_path):
    try:
        with open(config_path, 'r') as stream:
            config = yaml.safe_load(stream)
    except FileNotFoundError:
        print(f"Error: The file '{config_path}' was not found.")
        sys.exit(1)
    except yaml.YAMLError as exc:
        print(f"Error parsing YAML file: {exc}")
        sys.exit(1)

    for key, value in config.items():
        if isinstance(value, list):
            value = ' '.join(value)
        print(f'export {key.upper()}="{value}"')

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print_usage()
        sys.exit(1)
    main(sys.argv[1])
