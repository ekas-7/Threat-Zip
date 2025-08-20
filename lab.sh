#!/bin/bash

# Lab Management Script
# Provides easy management of the IDS lab environment

show_help() {
    echo "🛠️  IDS Lab Management Script"
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start         Start the basic IDS lab"
    echo "  start-snort   Start the lab with Snort IDS"
    echo "  start-full    Start the full lab with monitoring"
    echo "  stop          Stop the lab"
    echo "  restart       Restart the lab"
    echo "  logs          Show IDS logs"
    echo "  attack        Launch attack shell"
    echo "  status        Show container status"
    echo "  clean         Stop and remove all containers"
    echo "  monitor       Monitor IDS alerts in real-time"
    echo "  web           Open DVWA in browser"
    echo "  grafana       Open Grafana dashboard"
    echo "  help          Show this help message"
}

start_basic() {
    echo "🚀 Starting basic IDS lab with Suricata..."
    docker-compose up -d attacker victim db ids
    echo "✅ Lab started!"
    show_access_info
}

start_snort() {
    echo "🚀 Starting IDS lab with Snort..."
    docker-compose --profile snort up -d attacker victim db snort-ids
    echo "✅ Lab started with Snort!"
    show_access_info
}

start_full() {
    echo "🚀 Starting full lab with monitoring..."
    docker-compose --profile monitoring up -d
    echo "✅ Full lab started!"
    show_access_info
    echo "📊 Grafana: http://localhost:3000 (admin/admin)"
}

stop_lab() {
    echo "🛑 Stopping lab..."
    docker-compose down
    echo "✅ Lab stopped!"
}

restart_lab() {
    echo "🔄 Restarting lab..."
    docker-compose restart
    echo "✅ Lab restarted!"
}

show_logs() {
    echo "📋 Showing IDS logs..."
    if docker ps | grep -q "ids"; then
        docker logs -f ids
    elif docker ps | grep -q "snort-ids"; then
        docker logs -f snort-ids
    else
        echo "❌ No IDS container running"
    fi
}

launch_attack() {
    echo "⚔️  Launching attack shell..."
    if docker ps | grep -q "attacker"; then
        docker exec -it attacker bash
    else
        echo "❌ Attacker container not running. Start the lab first."
    fi
}

show_status() {
    echo "📊 Container Status:"
    docker-compose ps
}

clean_lab() {
    echo "🧹 Cleaning up lab..."
    docker-compose down -v --remove-orphans
    docker system prune -f
    echo "✅ Lab cleaned!"
}

monitor_alerts() {
    echo "🔍 Monitoring IDS alerts..."
    if [ -f "logs/fast.log" ]; then
        tail -f logs/fast.log
    elif [ -f "logs/eve.json" ]; then
        tail -f logs/eve.json | jq 'select(.event_type=="alert")'
    else
        echo "❌ No log files found. Make sure the lab is running."
    fi
}

open_web() {
    echo "🌐 Opening DVWA..."
    if command -v open &> /dev/null; then
        open http://localhost:8080
    elif command -v xdg-open &> /dev/null; then
        xdg-open http://localhost:8080
    else
        echo "📎 Open http://localhost:8080 in your browser"
    fi
}

open_grafana() {
    echo "📊 Opening Grafana..."
    if command -v open &> /dev/null; then
        open http://localhost:3000
    elif command -v xdg-open &> /dev/null; then
        xdg-open http://localhost:3000
    else
        echo "📎 Open http://localhost:3000 in your browser (admin/admin)"
    fi
}

show_access_info() {
    echo ""
    echo "🎯 Access Information:"
    echo "- DVWA Web App: http://localhost:8080"
    echo "- Attack Shell: docker exec -it attacker bash"
    echo "- IDS Logs: docker logs -f ids"
    echo ""
    echo "🔧 Quick Commands:"
    echo "- Run attacks: ./lab.sh attack"
    echo "- View logs: ./lab.sh logs"
    echo "- Monitor alerts: ./lab.sh monitor"
}

case "$1" in
    start)
        start_basic
        ;;
    start-snort)
        start_snort
        ;;
    start-full)
        start_full
        ;;
    stop)
        stop_lab
        ;;
    restart)
        restart_lab
        ;;
    logs)
        show_logs
        ;;
    attack)
        launch_attack
        ;;
    status)
        show_status
        ;;
    clean)
        clean_lab
        ;;
    monitor)
        monitor_alerts
        ;;
    web)
        open_web
        ;;
    grafana)
        open_grafana
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        if [ -z "$1" ]; then
            show_help
        else
            echo "❌ Unknown command: $1"
            show_help
            exit 1
        fi
        ;;
esac
