#!/bin/bash

# IDS Lab Setup Script
# This script sets up the complete IDS evaluation lab

echo "🛠️  IDS Lab Setup Script"
echo "========================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"

# Create necessary directories if they don't exist
echo "📁 Creating necessary directories..."
mkdir -p logs
mkdir -p snort/rules
mkdir -p snort/config

echo "🔧 Setting up permissions..."
chmod +x scripts/*.sh

# Pull required Docker images
echo "🐳 Pulling Docker images..."
docker-compose pull

echo "🏗️  Building custom images..."
docker-compose build

echo "✅ Setup completed!"
echo ""
echo "📋 Available lab configurations:"
echo ""
echo "1. Basic IDS Lab (Snort):"
echo "   docker-compose up -d"
echo ""
echo "2. Full Lab with Monitoring:"
echo "   docker-compose --profile monitoring up -d"
echo ""
echo "📚 Usage:"
echo "- Access DVWA: http://localhost:8080"
echo "- Access Grafana: http://localhost:3000 (admin/admin)"
echo "- Run attacks: docker exec -it attacker bash"
echo "- Monitor IDS: docker logs -f ids"
echo ""
echo "🎯 Quick start:"
echo "1. Start lab: docker-compose up -d"
echo "2. Open attacker: docker exec -it attacker bash"
echo "3. Run attacks: /scripts/attack_menu.sh"
echo "4. Monitor logs: docker logs -f ids"
