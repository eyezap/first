# Use the latest Ubuntu base image
FROM ubuntu:20.04

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    ubuntu-desktop \
    xfce4 \
    xfce4-goodies \
    xorg \
    openbox \
    tightvncserver \
    novnc \
    websockify \
    xterm \
    && apt-get clean

# Set the environment variables
ENV USER=root
ENV DISPLAY=:1

# Set the VNC password (can be modified as needed)
RUN mkdir -p /root/.vnc \
    && echo "vncpassword" | vncpasswd -f > /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd

# Start the VNC server and the web interface
CMD /usr/bin/vncserver $DISPLAY && \
    websockify --web=/usr/share/novnc/ 6080 localhost:5901 && \
    tail -f /dev/null
