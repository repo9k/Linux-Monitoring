# Monitoring Setup Script

![Bash](https://img.shields.io/badge/Language-Bash-green)
![Prometheus](https://img.shields.io/badge/Tools-Prometheus-orange)
![Grafana](https://img.shields.io/badge/Tools-Grafana-blue)
![Node Exporter](https://img.shields.io/badge/Tools-Node_Exporter-yellow)

This Bash script automates the setup of a monitoring stack using **Prometheus**, **Node Exporter**, and **Grafana**. It simplifies the process of downloading, configuring, and starting these tools on a Linux system.

## 🚀 Features
- **Download and Install Prometheus & Node Exporter**: Automatically downloads and installs the required tarballs.
- **Move Service Files**: Ensures Prometheus and Node Exporter service files are placed in the correct directory for systemd.
- **Enable & Start Services**: Automatically enables and starts Prometheus and Node Exporter services.
- **Grafana Installation**: Installs Grafana if it is not already installed, and ensures the Grafana server is up and running.
- **Cool and Clean Terminal Output**: With beautiful colored output, the installation process is fun and engaging.

## 📦 Requirements
- A Linux-based system (Ubuntu/Debian).
- **sudo** privileges.
- **wget** (already available on most systems).
- **tar** for extracting the downloaded tarballs.

## 🛠️ Installation Instructions

### 1. Download the secript

```bash
wget https://github.com/repo9k/Linux-Monitoring/blob/main/setup.sh
```
### 2. Run the script:
```bash
sudo sh setup.sh
```
### 📖 Credits:
- Prometheus: https://prometheus.io/
- Node Exporter: https://github.com/prometheus/node_exporter
- Grafana: https://grafana.com/
