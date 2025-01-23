# Use the official dockurr/windows image as the base image
FROM dockurr/windows

# Set environment variables (Windows version, language, storage path, etc.)
ENV VERSION="11" \
    DISK_SIZE="120G" \ 
    RAM_SIZE="28G" \
    CPU_CORES="6" \
    USERNAME="iazp" \
    PASSWORD="1234" \
    LANGUAGE="English" \
    REGION="en-US" \
    KEYBOARD="en-US"
    KVM="N" \


# Expose the ports for RDP and web-based viewer
EXPOSE 8006 3389

# Mount points for shared folders or volumes
VOLUME ["/storage", "/oem"]

# Ensure the correct folder exists before copying
RUN mkdir -p /oem
 
