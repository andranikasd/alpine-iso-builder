# Custom Alpine Linux ISO Builder

This project automates the creation of custom Alpine Linux ISO images using Docker. It allows users to specify their custom configurations through a YAML file, making it easy to generate tailored Alpine Linux distributions for various environments or applications.

## Getting Started

Follow these instructions to get your custom Alpine Linux ISO built and ready for use.

### Prerequisites

Ensure you have Docker installed on your system. Visit the [official Docker documentation](https://docs.docker.com/get-docker/) for installation instructions.

---
### Configuration

Your `image-settings.yaml` file should specify the configuration for the custom Alpine Linux ISO. Here is an example structure:

```yaml
profile_type: profile_standard
iso_name: "custom_alpine"
desc: "Custom Alpine Linux"
arch: "x86_64"
alpine_version: "3.14"
kernel_flavors: "lts"
bootloader: "grub"
profile_name: "custom_profile"
users:
  - username: "admin"
additional_apks:
  - "vim"
  - "htop"
```
Adjust the content according to your needs.

---
### Building the Docker Image

To build the Docker image for this project, navigate to the project directory and run:

```bash
docker build -t image_name .
```

Replace `image_name` with your preferred name for the Docker image.

### Running the Container

To generate your custom Alpine Linux ISO, run the following command:

```bash
docker run --privileged -v $(pwd)/image-settings.yaml:/image-settings.yaml -v $(pwd)/releases:/iso image_name
```

This command does the following:

- The `--privileged` flag is necessary for certain operations within the container that require elevated privileges.
- The first `-v` option mounts your local image-settings.yaml file into the container. This file should contain your custom configuration for the ISO.
- The second `-v` option mounts a local directory (releases) to the container's `/iso` directory, where the generated ISO will be saved..

Ensure you have an `image-settings.yaml` file and a releases directory in your current working directory.

---
### License

This project is licensed under the GPL License - see the [LICENSE](LICENSE) file for details.

