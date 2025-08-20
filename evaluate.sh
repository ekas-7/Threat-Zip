#!/bin/bash

# IDS Evaluation Script
# Systematically tests different attack scenarios and evaluates IDS performance

echo "🔬 IDS Evaluation Framework"
echo "=========================="

VICTIM_IP="172.20.0.20"
RESULTS_DIR="./evaluation_results"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Create results directory
mkdir -p $RESULTS_DIR

# Test scenarios
declare -a scenarios=(
    "icmp_flood:ICMP Flood Attack"
    "syn_flood:TCP SYN Flood Attack"
    "http_flood:HTTP Flood Attack"
    "port_scan:Port Scanning"
    "web_attacks:Web Application Attacks"
    "brute_force:Brute Force Attack"
)

# Performance metrics
declare -A metrics=(
    ["detection_rate"]="Percentage of attacks detected"
    ["false_positives"]="Number of false positive alerts"
    ["response_time"]="Time to first alert"
    ["cpu_usage"]="IDS CPU utilization"
    ["memory_usage"]="IDS memory utilization"
)

run_evaluation() {
    echo "🚀 Starting IDS Evaluation - $TIMESTAMP"
    
    # Check if lab is running
    if ! docker ps | grep -q "ids"; then
        echo "❌ IDS container not running. Please start the lab first."
        exit 1
    fi
    
    # Clear previous logs
    echo "🧹 Clearing previous logs..."
    docker exec ids rm -f /var/log/snort/* 2>/dev/null || true
    
    # Wait for IDS to stabilize
    echo "⏳ Waiting for IDS to stabilize..."
    sleep 10
    
    # Run each test scenario
    for scenario in "${scenarios[@]}"; do
        IFS=':' read -r test_name test_desc <<< "$scenario"
        echo ""
        echo "🎯 Running: $test_desc"
        echo "=========================="
        
        # Record start time
        start_time=$(date +%s)
        
        # Clear alerts before test
        docker exec ids truncate -s 0 /var/log/snort/alerts.txt 2>/dev/null || true
        
        # Run the specific test
        case $test_name in
            "icmp_flood")
                docker exec -d attacker hping3 -1 -c 50 $VICTIM_IP
                ;;
            "syn_flood")
                docker exec -d attacker hping3 -S -p 80 -c 100 $VICTIM_IP
                ;;
            "http_flood")
                docker exec -d attacker /scripts/http_flood.sh
                ;;
            "port_scan")
                docker exec -d attacker /scripts/port_scan.sh
                ;;
            "web_attacks")
                docker exec -d attacker /scripts/web_attacks.sh
                ;;
            "brute_force")
                docker exec -d attacker bash -c "for i in {1..10}; do curl -d 'username=admin&password=test' http://$VICTIM_IP/login.php; done"
                ;;
        esac
        
        # Wait for attack to complete and IDS to process
        sleep 30
        
        # Record end time
        end_time=$(date +%s)
        duration=$((end_time - start_time))
        
        # Collect results
        collect_test_results "$test_name" "$test_desc" "$duration"
        
        # Wait between tests
        echo "⏳ Cooling down..."
        sleep 15
    done
    
    # Generate final report
    generate_report
    
    echo "✅ Evaluation completed! Results saved in $RESULTS_DIR"
}

collect_test_results() {
    local test_name="$1"
    local test_desc="$2"
    local duration="$3"
    
    echo "📊 Collecting results for $test_name..."
    
    # Count alerts generated
    local alert_count=0
    if docker exec ids test -f /var/log/snort/alerts.txt; then
        alert_count=$(docker exec ids wc -l /var/log/snort/alerts.txt | cut -d' ' -f1)
    fi
    
    # Get CPU and memory usage
    local cpu_usage=$(docker stats --no-stream --format "table {{.CPUPerc}}" ids | tail -n 1 | sed 's/%//')
    local mem_usage=$(docker stats --no-stream --format "table {{.MemUsage}}" ids | tail -n 1)
    
    # Save results
    cat >> "$RESULTS_DIR/evaluation_${TIMESTAMP}.txt" << EOF

TEST: $test_desc
================
Duration: ${duration}s
Alerts Generated: $alert_count
CPU Usage: ${cpu_usage}%
Memory Usage: $mem_usage
Timestamp: $(date)

EOF
    
    # Save detailed logs if available
    if [ $alert_count -gt 0 ]; then
        docker exec ids cat /var/log/snort/alerts.txt > "$RESULTS_DIR/${test_name}_alerts_${TIMESTAMP}.log" 2>/dev/null || true
    fi
    
    echo "📝 Results: $alert_count alerts, ${cpu_usage}% CPU, Duration: ${duration}s"
}

generate_report() {
    local report_file="$RESULTS_DIR/summary_report_${TIMESTAMP}.md"
    
    cat > "$report_file" << EOF
# IDS Evaluation Report

**Date:** $(date)
**Lab Configuration:** $(docker-compose ps --services | tr '\n' ', ')

## Executive Summary

This report contains the results of systematic IDS evaluation across multiple attack scenarios.

## Test Results

EOF
    
    # Add detailed results
    cat "$RESULTS_DIR/evaluation_${TIMESTAMP}.txt" >> "$report_file"
    
    cat >> "$report_file" << EOF

## Performance Analysis

### Detection Effectiveness
- Total attack scenarios tested: ${#scenarios[@]}
- Average response time: [Calculate from logs]
- Detection rate: [Calculate from results]

### Resource Utilization
- Peak CPU usage: [Extract from logs]
- Peak memory usage: [Extract from logs]
- Log volume generated: $(du -sh $RESULTS_DIR | cut -f1)

## Recommendations

1. **Rule Tuning:** Review false positives and adjust detection thresholds
2. **Performance:** Monitor resource usage during high-traffic periods
3. **Coverage:** Consider additional rule sets for emerging threats

## Files Generated
EOF
    
    # List all generated files
    ls -la "$RESULTS_DIR"/*"$TIMESTAMP"* | awk '{print "- " $NF}' >> "$report_file"
    
    echo "📋 Report generated: $report_file"
}

# Check command line arguments
case "$1" in
    "run")
        run_evaluation
        ;;
    "report")
        if [ -z "$2" ]; then
            echo "📊 Available evaluation results:"
            ls -la "$RESULTS_DIR"/ 2>/dev/null || echo "No results found"
        else
            cat "$RESULTS_DIR/$2" 2>/dev/null || echo "File not found: $2"
        fi
        ;;
    "clean")
        echo "🧹 Cleaning evaluation results..."
        rm -rf "$RESULTS_DIR"
        echo "✅ Results cleaned"
        ;;
    *)
        echo "Usage: $0 {run|report|clean}"
        echo ""
        echo "Commands:"
        echo "  run     - Start comprehensive IDS evaluation"
        echo "  report  - View evaluation reports"
        echo "  clean   - Clean evaluation results"
        echo ""
        echo "Example: $0 run"
        ;;
esac
