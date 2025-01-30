FROM ubuntu:latest

ENV VERSION="10" \
    RAM_SIZE="4G" \
    CPU_CORES="2" \
    DISK_SIZE="64G" \
    USERNAME="admin" \
    PASSWORD="password" \
    MANUAL="N" \
    DHCP="N" \
    KVM="N"

# Install necessary packages
RUN apt-get update && \
    apt-get install -y qemu-system-x86 qemu-utils iproute2 iputils-ping net-tools dnsutils && \
    rm -rf /var/lib/apt/lists/*

# Create /storage directory for Windows image
RUN mkdir -p /storage && chmod 777 /storage

# Expose necessary ports
EXPOSE 8006 3389/tcp 3389/udp

# Run QEMU without KVM
CMD ["qemu-system-x86_64", \
    "-m", "${RAM_SIZE}", \
    "-smp", "${CPU_CORES}", \
    "-drive", "file=/storage/windows.img,format=raw", \
    "-netdev", "user,id=net0", \
    "-device", "e1000,netdev=net0"]
