# Use the base image for Ubuntu with NoVNC
FROM babim/ubuntu-novnc:20.04

# Expose the ports NoVNC and VNC server will use
EXPOSE 80 5901

# Set the environment variable for screen resolution
ENV RESOLUTION=1080x768

# Set the VNC password to '1234'
RUN mkdir -p /root/.vnc && \
    echo "1234" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Create a script
