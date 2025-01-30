# Use the dockurr/windows base image
FROM dockurr/windows:latest

# Set environment variables for Windows 10
ENV VERSION="10" \
    RAM_SIZE="4G" \
    CPU_CORES="2" \
    DISK_SIZE="64G" \
    USERNAME="admin" \
    PASSWORD="password" \
    MANUAL="N" \
    DHCP="N"

# Expose ports for web viewer and RDP
EXPOSE 8006 3389/tcp 3389/udp

# Set up storage volume
VOLUME /storage

# Use the default command from the base image
# Do not override CMD or ENTRYPOINT unless necessary
