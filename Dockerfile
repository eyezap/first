# Use the official dockurr/windows image as the base image
FROM dockurr/windows

# Set environment variables (Windows version, language, storage path, etc.)
ENV VERSION="11" \
    DISK_SIZE="64G" \
    RAM_SIZE="28G" \
    CPU_CORES="6" \
    USERNAME="iazp" \
    PASSWORD="1234" \
    LANGUAGE="English" \
    REGION="en-US" \
    KEYBOARD="en-US"

# Expose the ports for RDP and web-based viewer
EXPOSE 8006 3389

# Mount points for shared folders or volumes
VOLUME ["/storage", "/oem"]

# Additional software installation steps or customizations
# You can also add a script to run after installation like install.bat
COPY ./path/to/custom/files /oem/

# Command to run when the container starts
CMD ["start", "/bin/bash"]
