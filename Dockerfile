# Use Alpine Linux as the base image
FROM alpine:3.19.1

# Install necessary packages
RUN apk update && \
    apk add --update --no-cache \
    alpine-sdk git \
    alpine-conf \
    syslinux \
    xorriso \
    squashfs-tools \
    grub grub-efi \
    doas \
    mtools \
    dosfstools \
    python3 \
    py3-pip \
    abuild \
    apk-tools \
    busybox \
    fakeroot \
    syslinux \
    xorriso

# Making Python available
COPY requirements.txt /tmp/
RUN pip install --no-cache-dir --break-system-packages cython PyYAML
# Alternatively, if you have additional requirements: RUN pip install -r /tmp/requirements.txt --no-cache-dir

# Configure doas for non-interactive use
RUN echo "permit nopass as root" > /etc/doas.conf

# Copy the ISO and mkimg creation scripts into the container
COPY aports /aports
COPY generate_overlay_from_yaml.py /generate_overlay_from_yaml.py
COPY parse-config.py /parse-config.py
COPY create-custom-iso.sh /create-custom-iso.sh
COPY create-mkimg-profile.sh /create-mkimg-profile.sh
COPY logger.sh /logger.sh

# Ensure scripts are executable
RUN chmod +x /*.sh /*.py

# Set the working directory
WORKDIR /

# The entrypoint is the script to create the ISO
ENTRYPOINT ["/bin/sh", "/create-custom-iso.sh"]
