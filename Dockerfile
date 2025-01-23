# Use the latest Ubuntu image
FROM ubuntu:latest

# Set environment variables
ENV USER=root

# Install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    curl \
    gnupg2 \
    lsb-release \
    ca-certificates \
    unzip \
    python3 \
    python3-pip \
    xorg \
    openbox \
    tightvncserver \
    novnc \
    websockify \
    xfce4 \
    xfce4-goodies \
    && apt-get clean

# Install noVNC and Websockify
RUN wget https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz && \
    tar -xvzf v1.2.0.tar.gz && \
    mv noVNC-1.2.0 /usr/local/noVNC

# Expose ports for VNC and noVNC
EXPOSE 5901 6080

# Set up VNC server
RUN mkdir /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 0600 /root/.vnc/passwd

# Set up default window manager (Xfce)
RUN echo "startxfce4 &" > ~/.xinitrc

# Start VNC and noVNC
CMD /usr/bin/tightvncserver :1 && \
    /usr/local/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 6080
