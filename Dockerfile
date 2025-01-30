FROM dockurr/windows:latest

ENV VERSION="10" \
    RAM_SIZE="4G" \
    CPU_CORES="2" \
    DISK_SIZE="64G" \
    USERNAME="admin" \
    PASSWORD="password" \
    MANUAL="N" \
    DHCP="N" \
    KVM="N"

# Ensure /dev/net/tun exists for networking
RUN mkdir -p /dev/net && \
    mknod /dev/net/tun c 10 200 || true && \
    chmod 600 /dev/net/tun

# Install necessary networking utilities
RUN apt-get update && apt-get install -y iproute2 iputils-ping net-tools dnsutils

# Expose necessary ports
EXPOSE 8006 3389/tcp 3389/udp

# Define storage volume
VOLUME /storage

# Run QEMU without KVM
CMD ["qemu-system-x86_64", \
    "-m", "${RAM_SIZE}", \
    "-smp", "${CPU_CORES}", \
    "-drive", "file=/storage/windows.img,format=raw", \
    "-netdev", "user,id=net0", \
    "-device", "e1000,netdev=net0"]
