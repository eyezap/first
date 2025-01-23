# Use the base image for Ubuntu with NoVNC
FROM fredblgr/ubuntu-novnc:20.04

# Expose the ports NoVNC and VNC server will use
EXPOSE 80 5901

# Set the environment variable for screen resolution (Optional)
ENV RESOLUTION 1707x1067

# If you want to customize VNC resolution, ensure it's set in the startup script
RUN echo "Xvnc -geometry ${RESOLUTION} -depth 24 :1 &" > /root/start_vnc.sh && chmod +x /root/start_vnc.sh

# Use supervisor to run the VNC server and NoVNC proxy
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
