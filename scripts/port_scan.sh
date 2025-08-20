#!/bin/bash

# Port Scanning Attack Script
TARGET="172.20.0.20"

echo "Starting Port Scan on $TARGET"
echo "Scanning common ports..."

# TCP Connect Scan using hping3
echo "TCP SYN Scan on common ports..."
hping3 -S -p ++20-1000 -c 1 $TARGET

# Using nmap if available
if command -v nmap &> /dev/null; then
    echo "Running nmap scan..."
    nmap -sS -T4 $TARGET
    nmap -sU -T4 --top-ports 100 $TARGET
fi

echo "Port scan completed"
