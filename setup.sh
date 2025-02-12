#!/bin/bash

# Function to print messages in a stylish way
print_message() {
    local message=$1
    local color=$2
    echo -e "\033[${color}m${message}\033[0m"
}

# Function to download a file if it doesn't exist
download_file() {
    local url=$1
    local dest=$2
    if [ ! -f "$dest" ]; then
        print_message "Downloading $dest..." "32"  # Green text for success
        sudo wget -v "$url" -O "$dest"
    else
        print_message "$dest already exists." "33"  # Yellow text for warning
    fi
}

# Function to extract a tarball if the directory doesn't exist
extract_tarball() {
    local tarball=$1
    local dest_dir=$2
    if [ ! -d "$dest_dir" ]; then
        print_message "Extracting $tarball..." "32"  # Green text for success
        tar xzf "$tarball" -C /tmp
        sudo mv /tmp/$(basename "$tarball" .tar.gz) "$dest_dir"
    else
        print_message "$dest_dir already exists." "33"  # Yellow text for warning
    fi
}

# Function to move a service file if it doesn't already exist
move_service_file() {
    local src=$1
    local dest=$2
    if [ ! -f "$dest" ]; then
        sudo mv "$src" "$dest"
    else
        print_message "$(basename "$src") already exists." "33"  # Yellow text for warning
    fi
}

# Step 1: Check if necessary files exist, and download if not
print_message "Checking for necessary files..." "34"  # Blue text for info
download_file "https://github.com/prometheus/prometheus/releases/download/v3.2.0-rc.1/prometheus-3.2.0-rc.1.linux-amd64.tar.gz" "/tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz"
download_file "https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.yml" "/tmp/prometheus.yml"
download_file "https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.service" "/tmp/prometheus.service"
download_file "https://github.com/repo9k/Linux-Monitoring/raw/main/node_exporter.service" "/tmp/node_exporter.service"
download_file "https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz" "/tmp/node_exporter-1.8.2.linux-amd64.tar.gz"

# Step 2: Extract Prometheus tarball and move it to /etc/prometheus
print_message "Extracting Prometheus tarball..." "34"  # Blue text for info
extract_tarball "/tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz" "/etc/prometheus"

# Step 3: Move the prometheus.yml file to /etc/prometheus
print_message "Moving prometheus.yml to /etc/prometheus..." "34"  # Blue text for info
sudo mv /tmp/prometheus.yml /etc/prometheus

# Step 4: Extract Node Exporter tarball and move it to /etc/node_exporter
print_message "Extracting Node Exporter tarball..." "34"  # Blue text for info
extract_tarball "/tmp/node_exporter-1.8.2.linux-amd64.tar.gz" "/etc/node_exporter"

# Step 5: Move the service files if they don't already exist
print_message "Moving Prometheus and Node Exporter service files..." "34"  # Blue text for info
move_service_file "/tmp/prometheus.service" "/etc/systemd/system/prometheus.service"
move_service_file "/tmp/node_exporter.service" "/etc/systemd/system/node_exporter.service"

# Step 6: Enable and start the services only if they aren't already running
print_message "Enabling and starting Prometheus and Node Exporter services..." "34"  # Blue text for info
if ! systemctl is-active --quiet node_exporter.service; then
    sudo systemctl enable node_exporter.service
    sudo systemctl start node_exporter.service
else
    print_message "Node Exporter service is already running." "33"  # Yellow text for warning
fi

if ! systemctl is-active --quiet prometheus.service; then
    sudo systemctl enable prometheus.service
    sudo systemctl start prometheus.service
else
    print_message "Prometheus service is already running." "33"  # Yellow text for warning
fi

# Step 7: Install Grafana only if it's not installed
print_message "Checking if Grafana is installed..." "34"  # Blue text for info
if ! dpkg -l | grep -q grafana; then
    print_message "Installing Grafana..." "32"  # Green text for success
    sudo apt-get update
    sudo apt-get install -y adduser libfontconfig1 musl
    download_file "https://dl.grafana.com/enterprise/release/grafana-enterprise_11.5.1_amd64.deb" "/tmp/grafana-enterprise_11.5.1_amd64.deb"
    sudo dpkg -i /tmp/grafana-enterprise_11.5.1_amd64.deb
else
    print_message "Grafana is already installed." "33"  # Yellow text for warning
fi

# Step 8: Enable and start Grafana server only if it's not already running
print_message "Enabling and starting Grafana server..." "34"  # Blue text for info
if ! systemctl is-active --quiet grafana-server; then
    sudo systemctl enable grafana-server
    sudo systemctl start grafana-server
else
    print_message "Grafana server is already running." "33"  # Yellow text for warning
fi

# Final Step: Confirm services are running
print_message "Setup complete!" "32"  # Green text for success
