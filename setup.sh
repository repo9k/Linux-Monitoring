#!/bin/bash

# Step 1: Check if Prometheus and Node Exporter files exist, download if not
echo "Checking if Prometheus and Node Exporter files are already downloaded..."
if [ ! -f /tmp/prometheus.service ]; then
    echo "Downloading prometheus.service..."
    sudo wget -v https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.service -O /tmp/prometheus.service
else
    echo "prometheus.service already exists."
fi

if [ ! -f /tmp/node_exporter.service ]; then
    echo "Downloading node_exporter.service..."
    sudo wget -v https://github.com/repo9k/Linux-Monitoring/raw/main/node_exporter.service -O /tmp/node_exporter.service
else
    echo "node_exporter.service already exists."
fi

if [ ! -f /tmp/prometheus.yml ]; then
    echo "Downloading prometheus.yml..."
    sudo wget -v https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.yml -O /tmp/prometheus.yml
else
    echo "prometheus.yml already exists."
fi

if [ ! -f /tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz ]; then
    echo "Downloading Prometheus tarball..."
    sudo wget -v https://github.com/prometheus/prometheus/releases/download/v3.2.0-rc.1/prometheus-3.2.0-rc.1.linux-amd64.tar.gz -O /tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz
else
    echo "Prometheus tarball already exists."
fi

if [ ! -f /tmp/node_exporter-1.8.2.linux-amd64.tar.gz ]; then
    echo "Downloading Node Exporter tarball..."
    sudo wget -v https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz -O /tmp/node_exporter-1.8.2.linux-amd64.tar.gz
else
    echo "Node Exporter tarball already exists."
fi

# Step 2: Extract tarballs only if they haven't been extracted
echo "Extracting Prometheus and Node Exporter tarballs..."
if [ ! -d /etc/prometheus ]; then
    echo "Extracting Prometheus..."
    tar xzf /tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz -C /tmp
    sudo mv /tmp/prometheus-3.2.0-rc.1.linux-amd64 /etc/prometheus
else
    echo "Prometheus directory already exists."
fi

if [ ! -d /etc/node_exporter ]; then
    echo "Extracting Node Exporter..."
    tar xzf /tmp/node_exporter-1.8.2.linux-amd64.tar.gz -C /tmp
    sudo mv /tmp/node_exporter-1.8.2.linux-amd64 /etc/node_exporter
else
    echo "Node Exporter directory already exists."
fi

# Step 3: Replace Prometheus configuration if it's missing or incorrect
echo "Replacing Prometheus configuration file..."
if [ ! -f /etc/prometheus/prometheus.yml ]; then
    sudo mv /tmp/prometheus.yml /etc/prometheus/prometheus.yml
else
    echo "Prometheus configuration file already exists."
fi

# Step 4: Move service files only if they aren't already present
echo "Moving Prometheus and Node Exporter service files..."
if [ ! -f /etc/systemd/system/node_exporter.service ]; then
    sudo mv /tmp/node_exporter.service /etc/systemd/system/
else
    echo "Node Exporter service file already exists."
fi

if [ ! -f /etc/systemd/system/prometheus.service ]; then
    sudo mv /tmp/prometheus.service /etc/systemd/system/
else
    echo "Prometheus service file already exists."
fi

# Step 5: Enable and start the services only if they aren't already running
echo "Enabling and starting Prometheus and Node Exporter services..."
if ! systemctl is-active --quiet node_exporter.service; then
    sudo systemctl enable node_exporter.service
    sudo systemctl start node_exporter.service
else
    echo "Node Exporter service is already running."
fi

if ! systemctl is-active --quiet prometheus.service; then
    sudo systemctl enable prometheus.service
    sudo systemctl start prometheus.service
else
    echo "Prometheus service is already running."
fi

# Step 6: Install Grafana only if it's not installed
echo "Checking if Grafana is installed..."
if ! dpkg -l | grep -q grafana; then
    echo "Installing Grafana..."
    sudo apt-get update
    sudo apt-get install -y adduser libfontconfig1 musl
    sudo wget -v https://dl.grafana.com/enterprise/release/grafana-enterprise_11.5.1_amd64.deb -O /tmp/grafana-enterprise_11.5.1_amd64.deb
    sudo dpkg -i /tmp/grafana-enterprise_11.5.1_amd64.deb
else
    echo "Grafana is already installed."
fi

# Step 7: Enable and start Grafana server only if it's not already running
echo "Enabling and starting Grafana server..."
if ! systemctl is-active --quiet grafana-server; then
    sudo systemctl enable grafana-server
    sudo systemctl start grafana-server
else
    echo "Grafana server is already running."
fi

# Final Step: Confirm services are running
echo "Done"
