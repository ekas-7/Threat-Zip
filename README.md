# 🛠️ IDS Lab: Evaluation of Open Source Intrusion Detection Systems using Docker

A comprehensive Docker-based laboratory environment for evaluating and comparing different Intrusion Detection Systems (IDS) including Suricata and Snort.

## 🎯 Lab Overview

This lab provides a controlled environment to test and evaluate IDS capabilities through systematic attack simulations. The environment includes:

- **Attacker Container**: Kali Linux with penetration testing tools
- **Victim Container**: DVWA (Damn Vulnerable Web Application) 
- **IDS Containers**: Suricata (default) and Snort (alternative)
- **Monitoring Stack**: Grafana + Loki + Promtail for log visualization

## 🏗️ Architecture

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Attacker  │────│   Victim    │    │     IDS     │
│ (Kali Linux)│    │   (DVWA)    │    │ (Suricata/  │
│             │    │             │    │  Snort)     │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       └───────────────────┼───────────────────┘
                           │
                    ┌─────────────┐
                    │ Monitoring  │
                    │ (Grafana)   │
                    └─────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- At least 4GB RAM available
- Linux/macOS recommended (Windows with WSL2)

### 1. Setup
```bash
# Clone and setup
git clone <repository>
cd Threat-Zip
./setup.sh
```

### 2. Start the Lab
```bash
# Basic lab with Suricata
./lab.sh start

# Or with Snort IDS
./lab.sh start-snort

# Or full lab with monitoring
./lab.sh start-full
```

### 3. Launch Attacks
```bash
# Open attacker shell
./lab.sh attack

# Run attack menu
/scripts/attack_menu.sh
```

### 4. Monitor Results
```bash
# View IDS logs
./lab.sh logs

# Monitor alerts in real-time
./lab.sh monitor

# Access Grafana dashboard
./lab.sh grafana
```

## 🎯 Attack Scenarios

The lab includes the following attack scenarios:

### Network-Level Attacks
- **ICMP Flood**: Overwhelming target with ICMP packets
- **TCP SYN Flood**: TCP connection exhaustion attack
- **Port Scanning**: Network reconnaissance using hping3/nmap

### Application-Level Attacks
- **HTTP Flood**: Web server overwhelming with HTTP requests
- **SQL Injection**: Database attack via web application
- **XSS (Cross-Site Scripting)**: Client-side code injection
- **Directory Traversal**: File system access attempts
- **Brute Force**: Login credential guessing

### Advanced Scenarios
- **Command Injection**: OS command execution via web app
- **File Upload Attacks**: Malicious file upload attempts
- **Session Hijacking**: Authentication bypass attempts

## 🔧 Configuration

### IDS Rules
- **Suricata**: `suricata/rules/custom.rules`
- **Snort**: `snort/rules/lab.rules`

### Network Configuration
- **Lab Network**: 172.20.0.0/16
- **Attacker**: 172.20.0.10
- **Victim**: 172.20.0.20
- **IDS**: 172.20.0.30

### Log Locations
- **Suricata**: `logs/eve.json`, `logs/fast.log`
- **Snort**: `logs/snort.log`, `logs/alerts.txt`

## 📊 Evaluation Framework

### Automated Evaluation
```bash
# Run comprehensive evaluation
./evaluate.sh run

# View results
./evaluate.sh report

# Clean results
./evaluate.sh clean
```

### Manual Testing
```bash
# Individual attack scripts
./scripts/icmp_flood.sh
./scripts/syn_flood.sh
./scripts/http_flood.sh
./scripts/port_scan.sh
./scripts/web_attacks.sh
```

### Performance Metrics
- **Detection Rate**: % of attacks detected
- **False Positives**: Benign traffic flagged as malicious
- **Response Time**: Time to first alert
- **Resource Usage**: CPU and memory consumption
- **Log Volume**: Amount of data generated

## 🎛️ Lab Management

### Available Commands
```bash
./lab.sh start         # Start basic lab
./lab.sh start-snort   # Start with Snort IDS
./lab.sh start-full    # Start with monitoring
./lab.sh stop          # Stop lab
./lab.sh restart       # Restart lab
./lab.sh status        # Show container status
./lab.sh clean         # Clean up everything
./lab.sh attack        # Launch attack shell
./lab.sh logs          # View IDS logs
./lab.sh monitor       # Monitor alerts
./lab.sh web           # Open DVWA
./lab.sh grafana       # Open Grafana
```

## 🔍 Monitoring and Visualization

### Grafana Dashboard
- **URL**: http://localhost:3000
- **Credentials**: admin/admin
- **Features**: Real-time log analysis, alert visualization, performance metrics

### Direct Log Analysis
```bash
# View Suricata alerts
tail -f logs/eve.json | jq 'select(.event_type=="alert")'

# View Snort alerts  
tail -f logs/fast.log

# Search for specific attacks
grep "ICMP Flood" logs/fast.log
```

## 📈 Extensions and Customization

### Adding New Attack Scenarios
1. Create script in `scripts/` directory
2. Add to attack menu in `scripts/attack_menu.sh`
3. Create corresponding IDS rules

### Custom IDS Rules
```bash
# Suricata
echo 'alert tcp any any -> any 80 (msg:"Custom Rule"; sid:2000001;)' >> suricata/rules/custom.rules

# Snort
echo 'alert tcp any any -> any 80 (msg:"Custom Rule"; sid:2000001;)' >> snort/rules/local.rules
```

### Multiple IDS Comparison
```bash
# Run both Suricata and Snort
docker-compose up -d ids
docker-compose --profile snort up -d snort-ids
```

## 🔧 Troubleshooting

### Common Issues
1. **Port conflicts**: Ensure ports 8080, 3000, 3100 are available
2. **Permission errors**: Run `chmod +x *.sh scripts/*.sh`
3. **Memory issues**: Increase Docker memory limit to 4GB+
4. **Container startup**: Check `docker-compose logs [service]`

### Debug Commands
```bash
# Check container status
docker-compose ps

# View container logs
docker-compose logs ids

# Shell into containers
docker exec -it attacker bash
docker exec -it victim bash
docker exec -it ids bash
```

## 📚 Learning Objectives

After completing this lab, you will understand:

1. **IDS Deployment**: How to deploy and configure different IDS solutions
2. **Attack Detection**: How various attacks appear in IDS logs
3. **Rule Writing**: How to create custom detection rules
4. **Performance Tuning**: How to optimize IDS performance
5. **False Positive Management**: How to reduce false positives
6. **Log Analysis**: How to analyze and correlate security events

## 🔬 Research Applications

This lab is suitable for:

- **Academic Research**: IDS comparison studies
- **Security Training**: Hands-on cybersecurity education  
- **Product Evaluation**: Testing commercial IDS products
- **Rule Development**: Creating and testing custom rules
- **Performance Benchmarking**: Comparing IDS performance

## 📝 Lab Report Template

### Evaluation Metrics
- Detection accuracy per attack type
- Resource utilization during attacks
- Alert quality and false positive rate
- Rule effectiveness analysis

### Comparative Analysis
- Suricata vs Snort performance
- Different rule sets effectiveness
- Impact of configuration changes

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/new-attack`)
3. Add new attack scenarios or IDS configurations
4. Test thoroughly in lab environment
5. Submit pull request with documentation

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⚠️ Disclaimer

This lab is for educational and research purposes only. The included attack tools and techniques should only be used in controlled environments. Do not use against systems without explicit permission.

## 🔗 Resources

- [Suricata Documentation](https://suricata.readthedocs.io/)
- [Snort Documentation](https://www.snort.org/documents)
- [DVWA Documentation](http://www.dvwa.co.uk/)
- [Docker Compose Reference](https://docs.docker.com/compose/)

---

**Happy Learning! 🚀**
./setup.sh