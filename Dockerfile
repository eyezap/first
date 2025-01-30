# Use a proper Windows-based image
FROM dockurr/windows:latest

# Set environment variables
ENV VERSION="10" `
    RAM_SIZE="4G" `
    CPU_CORES="2" `
    DISK_SIZE="64G" `
    USERNAME="admin" `
    PASSWORD="password" `
    MANUAL="N" `
    DHCP="N" `
    KVM="N"

# Set execution policy for PowerShell scripts (if needed)
SHELL ["powershell", "-Command"]

# Ensure QEMU is installed (use the proper installer for Windows)
RUN Invoke-WebRequest -Uri "https://qemu.weilnetz.de/w64/qemu-w64-setup-20230822.exe" -OutFile "qemu-setup.exe"; `
    Start-Process -FilePath ".\qemu-setup.exe" -ArgumentList "/S" -Wait; `
    Remove-Item -Path ".\qemu-setup.exe"

# Create a storage directory
RUN New-Item -ItemType Directory -Path "C:\storage" -Force

# Expose necessary ports (Remote Desktop & QEMU)
EXPOSE 8006 3389

# Define storage volume
VOLUME C:\storage

# Run QEMU without KVM
CMD qemu-system-x86_64.exe `
    -m $env:RAM_SIZE `
    -smp $env:CPU_CORES `
    -drive file=C:\storage\windows.img,format=raw `
    -netdev user,id=net0 `
    -device e1000,netdev=net0
