FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

# Configure dpkg to skip problematic packages
RUN mkdir -p /etc/apt/preferences.d && \
    echo 'Package: libfprint-2-2\nPin: release *\nPin-Priority: -1' > /etc/apt/preferences.d/libfprint-2-2

# Install only the necessary packages
RUN apt-get update && apt-get install -y \
    tightvncserver \
    xfce4 \
    xfce4-goodies \
    x11vnc \
    xvfb \
    curl \
    git \
    python3 \
    websockify \
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

# Clone noVNC (web-based VNC client)
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC
RUN git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify
RUN ln -s /opt/noVNC/utils/launch.sh /usr/local/bin/novnc

# Expose the noVNC port (HTTP)
EXPOSE 8080

# Create a script to send server details to Discord webhook
RUN echo '#!/bin/bash\n\
URL="https://first-pbbd.onrender.com"\n\
USERNAME="iazp"\n\
PASSWORD="1234"\n\
WEBHOOK_URL="https://discord.com/api/webhooks/1259140182653796455/9ccO4rNqNzAiFKS6xZDURwVjbagKE1MylitZUfr5nRGPvXWcaGlmD1ElU8mpG-36KgSu"\n\
PAYLOAD="{\\"content\\": \\"VNC Server is ready!\\nURL: $URL\\nUsername: $USERNAME\\nPassword: $PASSWORD\\"}"\n\
curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK_URL"\n\
' > /startup.sh
RUN chmod +x /startup.sh

# Start the VNC server, noVNC, and send details to Discord
CMD vncserver :1 -geometry $RESOLUTION -depth 24 && /startup.sh && /opt/noVNC/utils/launch.sh --vnc localhost:5901 --listen 8080
