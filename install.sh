#!/bin/bash

# Step 1: Install unzip (if it's not already installed)
echo "Installing unzip..."
apt-get update
apt-get install -y unzip

# Step 2: Unzip the file xyz.zip
echo "Unzipping xyz.zip..."
unzip xyz.zip -d /tmp/xyz

# Step 3: Move node_exporter and prometheus folders to /etc
echo "Moving node_exporter and prometheus folders to /etc..."
mv /tmp/xyz/node_exporter /etc/
mv /tmp/xyz/prometheus /etc/

# Step 4: Move node_exporter.service and prometheus.service to /etc/systemd/system
echo "Moving service files to /etc/systemd/system..."
mv /tmp/xyz/node_exporter.service /etc/systemd/system/
mv /tmp/xyz/prometheus.service /etc/systemd/system/

# Step 5: Enable and start the services
echo "Enabling and starting node_exporter and prometheus services..."
systemctl enable node_exporter.service
systemctl enable prometheus.service
systemctl restart node_exporter.service
systemctl restart prometheus.service

# Step 6: Install required packages
echo "Installing required packages..."
apt-get install -y adduser libfontconfig1 musl

# Step 7: Download and install Grafana (using sudo for wget)
echo "Downloading and installing Grafana..."
sudo wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.5.1_amd64.deb

# Step 8: Install Grafana
echo "Installing Grafana..."
dpkg -i grafana-enterprise_11.5.1_amd64.deb

# Step 9: Start Grafana
echo "Starting Grafana..."
systemctl start grafana-server
systemctl enable grafana-server

echo "Setup complete!"
