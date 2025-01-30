# Use the official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    ubuntu-desktop \
    tightvncserver \
    xfce4 \
    xfce4-goodies \
    x11vnc \
    xvfb \
    firefox \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the VNC password to '1234'
RUN mkdir -p /home/iazp/.vnc
RUN echo "1234" | vncpasswd -f > /home/iazp/.vnc/passwd
RUN chmod 600 /home/iazp/.vnc/passwd

# Create a custom xstartup file for xfce4
RUN echo "#!/bin/bash\nxrdb \$HOME/.Xresources\nstartxfce4 &" > /home/iazp/.vnc/xstartup
RUN chmod +x /home/iazp/.vnc/xstartup

# Set the resolution to 1080x768
ENV RESOLUTION=1080x768

# Expose the VNC port
EXPOSE 5901

# Create a script to send server details to Discord webhook
RUN echo '#!/bin/bash\n\
IP=$(curl -s ifconfig.me)\n\
USERNAME="iazp"\n\
PASSWORD="1234"\n\
WEBHOOK_URL="https://discord.com/api/webhooks/1259140182653796455/9ccO4rNqNzAiFKS6xZDURwVjbagKE1MylitZUfr5nRGPvXWcaGlmD1ElU8mpG-36KgSu"\n\
PAYLOAD="{\\"content\\": \\"VNC Server is ready!\\nIP: $IP\\nUsername: $USERNAME\\nPassword: $PASSWORD\\"}"\n\
curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK_URL"\n\
' > /startup.sh
RUN chmod +x /startup.sh

# Start the VNC server and send details to Discord
CMD vncserver :1 -geometry $RESOLUTION -depth 24 && /startup.sh && tail -F /home/iazp/.vnc/*.log
