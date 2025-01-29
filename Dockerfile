# Use the official dockurr/windows image as the base image
FROM dockurr/windows

# Set environment variables (Windows version, language, storage path, etc.)
ENV VERSION="7e" \
    DISK_SIZE="120G" \
    RAM_SIZE="28G" \
    CPU_CORES="6" \
    USERNAME="iazp" \
    PASSWORD="1234" \
    LANGUAGE="English" \
    REGION="en-US" \
    KEYBOARD="en-US" \
    KVM="N"

# Expose the ports for RDP and web-based viewer
EXPOSE 8006 3389/tcp 3389/udp 5700 5900

# Mount points for shared folders or volumes
VOLUME ["/storage", "/oem"]

# Create directories for /storage and /oem
RUN mkdir -p /oem /storage

# Add any additional setup commands if needed
# RUN some-command

# Set the default command to run when the container starts
CMD ["start-windows"]
