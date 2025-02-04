# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Set environment variables
ENV USERNAME=newuser
ENV PASSWORD=root
ENV WEBHOOK_URL=https://discord.com/api/webhooks/your_webhook_url

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    curl \
    jq && \
    rm -rf /var/lib/apt/lists/*

# Create the user
RUN useradd -m -s /bin/bash $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    usermod -aG sudo $USERNAME

# Copy the webhook script into the container
COPY send_webhook.sh /usr/local/bin/send_webhook.sh

# Set the script to run on container startup
CMD ["/usr/local/bin/send_webhook.sh"]
