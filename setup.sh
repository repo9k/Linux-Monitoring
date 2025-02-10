#!/bin/bash

# Step 1: Download necessary files
echo "Downloading Prometheus and Node Exporter files..."
sudo wget -q https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.service -O /tmp/prometheus.service
sudo wget -q https://github.com/repo9k/Linux-Monitoring/raw/main/node_exporter.service -O /tmp/node_exporter.service
sudo wget -q https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.yml -O /tmp/prometheus.yml
sudo wget -q https://github.com/prometheus/prometheus/releases/download/v3.2.0-rc.1/prometheus-3.2.0-rc.1.linux-amd64.tar.gz -O /tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz
sudo wget -q https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz -O /tmp/node_exporter-1.8.2.linux-amd64.tar.gz

# Step 2: Extract downloaded tarballs
echo "Extracting Prometheus and Node Exporter tarballs..."
tar xzf /tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz -C /tmp
tar xzf /tmp/node_exporter-1.8.2.linux-amd64.tar.gz -C /tmp

# Step 3: Move extracted files to the appropriate directories
echo "Moving extracted files to /etc/prometheus and /etc/node_exporter..."
sudo mv /tmp/prometheus-3.2.0-rc.1.linux-amd64 /etc/prometheus
sudo mv /tmp/node_exporter-1.8.2.linux-amd64 /etc/node_exporter

# Step 4: Replace default Prometheus configuration with the downloaded one
echo "Replacing Prometheus configuration file..."
sudo rm -f /etc/prometheus/prometheus.yml
sudo mv /tmp/prometheus.yml /etc/prometheus/prometheus.yml

# Step 5: Move service files to systemd directory
echo "Moving Prometheus and Node Exporter service files..."
sudo mv /tmp/node_exporter.service /etc/systemd/system/
sudo mv /tmp/prometheus.service /etc/systemd/system/

# Step 6: Enable and start the services
echo "Enabling and starting Prometheus and Node Exporter services..."
sudo systemctl enable node_exporter.service
sudo systemctl enable prometheus.service
sudo systemctl restart node_exporter.service
sudo systemctl restart prometheus.service

# Step 7: Install Grafana and its dependencies
echo "Installing Grafana and dependencies..."
sudo apt-get update
sudo apt-get install -y adduser libfontconfig1 musl

# Step 8: Download and install Grafana
echo "Downloading and installing Grafana..."
sudo wget -q https://dl.grafana.com/enterprise/release/grafana-enterprise_11.5.1_amd64.deb -O /tmp/grafana-enterprise_11.5.1_amd64.deb
sudo dpkg -i /tmp/grafana-enterprise_11.5.1_amd64.deb

# Step 9: Enable and start Grafana server
echo "Enabling and starting Grafana server..."
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Final Step: Confirm services are running
echo "Verifying service status..."
sudo systemctl status node_exporter.service
sudo systemctl status prometheus.service
sudo systemctl status grafana-server
