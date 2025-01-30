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

EXPOSE 8006 3389/tcp 3389/udp

VOLUME /storage
