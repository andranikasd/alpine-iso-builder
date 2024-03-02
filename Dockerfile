# Use Alpine Linux as the base image
FROM alpine:3.19.1

# Install necessary packages
RUN apk update &&     \
    apk add --update --no-cache \
    alpine-sdk git        \
    alpine-conf        \
    syslinux           \
    xorriso            \
    squashfs-tools     \
    grub grub-efi doas \
    mtools dosfstools  \
    python3 py3-pip

# Making Python availabe

# Configure doas for non-interactive use by the build user
RUN echo "permit nopass build as root" > /etc/doas.conf

COPY requirements.txt /tmp/
RUN pip install cython PyYAML --break-system-packages 
# RUN pip install -r /tmp/requirements.txt --break-system-packages

# Add your build user and add to the abuild group
RUN adduser --disabled-password --gecos "" build && \
    addgroup build abuild && \
    echo "permit :abuild" > /etc/doas.d/doas.conf && \
    echo "permit persist :abuild" >> /etc/doas.d/doas.conf

COPY --chown=build:build aports /home/build/aports

# Copy the ISO and mkimg creation scripts into the container
COPY generate_overlay_from_yaml.py /home/build/generate_overlay_from_yaml.py
COPY parse-config.py /home/build/
COPY create-custom-iso.sh /home/build/
COPY create-mkimg-profile.sh /home/build/
RUN chmod +x /home/build/create-custom-iso.sh /home/build/create-mkimg-profile.sh && \
    chown build:build /home/build/create-custom-iso.sh /home/build/create-mkimg-profile.sh
RUN chmod +x /home/build/*.sh /home/build/*.py

# Switch to the build user for subsequent commands
USER build
WORKDIR /home/build

# The entrypoint is the script to create the ISO
ENTRYPOINT ["/bin/sh", "/home/build/create-custom-iso.sh"]
