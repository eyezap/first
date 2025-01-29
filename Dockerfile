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
EXPOSE 8006 3389 5700 5900

# Mount points for shared folders or volumes
VOLUME ["/storage", "/oem"]

# Create directories for /storage and /oem
RUN mkdir -p /oem /storage

# Set the entrypoint and command to use environment variables
ENTRYPOINT ["qemu-system-x86_64"]
CMD ["-m", "${RAM_SIZE}", "-smp", "${CPU_CORES}", "-drive", "file=/storage/windows_disk.img,format=raw,if=virtio", "-cdrom", "/storage/windows.iso", "-boot", "order=d", "-netdev", "user,id=mynet0,hostfwd=tcp::8006-:8006", "-device", "virtio-net,netdev=mynet0", "-vnc", ":0", "-display", "vnc=0.0.0.0:0", "-drive", "file=/oem/win11x64.xml,format=raw", "-enable-kvm", "-device", "virtio-serial"]
