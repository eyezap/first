# Use the official dockurr/windows image as the base image
FROM dockurr/windows

# Set environment variables for Windows Server 2025
ENV VERSION="2025" \          # Windows Server 2025
    DISK_SIZE="100G" \        # Disk size for the virtual machine
    RAM_SIZE="8G" \           # RAM allocated to the VM
    CPU_CORES="4" \           # Number of CPU cores
    USERNAME="admin" \        # Default username
    PASSWORD="P@ssw0rd" \     # Default password
    LANGUAGE="English" \      # Language for the installation
    REGION="en-US" \          # Region settings
    KEYBOARD="en-US" \        # Keyboard layout
    KVM="Y"                   # Enable KVM acceleration (if supported)

# Expose the ports for RDP and web-based viewer
EXPOSE 8006 3389/tcp 3389/udp

# Mount points for shared folders or volumes
VOLUME ["/storage", "/oem"]

# Create directories for /storage and /oem
RUN mkdir -p /oem /storage

# Set the default command to start the Windows VM
CMD ["start-windows"]
