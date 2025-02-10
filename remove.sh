#!/bin/bash

# Step 1: Stop the services first
echo "Stopping Prometheus and Node Exporter services..."
sudo systemctl stop prometheus.service
sudo systemctl stop node_exporter.service
sudo systemctl stop grafana-server

# Step 2: Disable the services
echo "Disabling Prometheus and Node Exporter services..."
sudo systemctl disable prometheus.service
sudo systemctl disable node_exporter.service
sudo systemctl disable grafana-server

# Step 3: Remove Prometheus and Node Exporter directories
echo "Removing Prometheus and Node Exporter directories..."
sudo rm -rf /etc/prometheus
sudo rm -rf /etc/node_exporter

# Step 4: Remove Prometheus and Node Exporter service files
echo "Removing Prometheus and Node Exporter service files..."
sudo rm -f /etc/systemd/system/prometheus.service
sudo rm -f /etc/systemd/system/node_exporter.service

# Step 5: Remove Grafana package
echo "Removing Grafana..."
sudo apt-get remove --purge -y grafana

# Step 6: Remove any downloaded tarballs and configuration files
echo "Removing downloaded files..."
sudo rm -f /tmp/prometheus.yml
sudo rm -f /tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz
sudo rm -f /tmp/node_exporter-1.8.2.linux-amd64.tar.gz
sudo rm -f /tmp/prometheus.service
sudo rm -f /tmp/node_exporter.service
sudo rm -f /tmp/grafana-enterprise_11.5.1_amd64.deb

# Step 7: Reload systemd to apply changes
echo "Reloading systemd..."
sudo systemctl daemon-reload

echo "Cleanup completed. All components have been removed."
