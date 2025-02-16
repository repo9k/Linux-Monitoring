#!/bin/bash
apt update
# Function to download files with progress bar
download_file() {
    local url=$1
    local output=$2
    if [ -f "$output" ]; then
        echo "$output already exists. Skipping download."
        return 0
    fi
    echo "Downloading: $output..."
    if ! curl -L -# -O "$url"; then
        echo "Error downloading $url"
        exit 1
    fi
}

# Function to extract tar.gz files
extract_file() {
    local file=$1
    local dir=$2
    if [ -d "$dir" ]; then
        echo "$dir already extracted. Skipping extraction."
        return 0
    fi
    echo "Extracting: $file..."
    if ! tar -xzf "$file"; then
        echo "Error extracting $file"
        exit 1
    fi
}

# Function to move files to appropriate locations
move_files() {
    echo "Moving files to appropriate locations..."
    if [ ! -d "/etc/node_exporter" ]; then
        mv node_exporter-1.8.2.linux-amd64 /etc/node_exporter || { echo "Failed to move node_exporter"; exit 1; }
    else
        echo "/etc/node_exporter already exists. Skipping move."
    fi

    if [ ! -d "/etc/prometheus" ]; then
        mv prometheus-3.2.0-rc.1.linux-amd64 /etc/prometheus || { echo "Failed to move prometheus"; exit 1; }
    else
        echo "/etc/prometheus already exists. Skipping move."
    fi

    if [ ! -f "/etc/prometheus/prometheus.yml" ]; then
        rm -r /etc/prometheus/prometheus.yml
        mv prometheus.yml /etc/prometheus || { echo "Failed to move prometheus.yml"; exit 1; }
    else
        echo "/etc/prometheus/prometheus.yml already exists. Skipping move."
    fi

    if [ ! -f "/etc/systemd/system/prometheus.service" ]; then
        mv prometheus.service /etc/systemd/system/prometheus.service || { echo "Failed to move prometheus.service"; exit 1; }
    else
        echo "prometheus.service already exists. Skipping move."
    fi

    if [ ! -f "/etc/systemd/system/node_exporter.service" ]; then
        mv node_exporter.service /etc/systemd/system/node_exporter.service || { echo "Failed to move node_exporter.service"; exit 1; }
    else
        echo "node_exporter.service already exists. Skipping move."
    fi
}
# Function to enable and start services
enable_start_services() {
    echo "Enabling and starting Prometheus and Node Exporter services..."
    systemctl enable node_exporter.service || { echo "Failed to enable node_exporter"; exit 1; }
    systemctl enable prometheus.service || { echo "Failed to enable prometheus"; exit 1; }
    systemctl start node_exporter.service || { echo "Failed to start node_exporter"; exit 1; }
    systemctl start prometheus.service || { echo "Failed to start prometheus"; exit 1; }

}

# Function to install dependencies
install_dependencies() {
    echo "Installing necessary dependencies..."
    apt-get install -y adduser libfontconfig1 musl || { echo "Failed to install dependencies"; exit 1; }
}

# Function to install Grafana
install_grafana() {
    if dpkg -l | grep -q grafana; then
        echo "Grafana is already installed. Skipping installation."
        return 0
    fi
    echo "Installing Grafana..."
    if ! dpkg -i grafana-enterprise_11.5.1_amd64.deb; then
        echo "Error installing Grafana"
        exit 1
    fi
}

# Function to start Grafana service
start_grafana_service() {
    echo "Starting Grafana server..."
    service grafana-server start || { echo "Failed to start Grafana service"; exit 1; }
    systemctl enable grafana-server.service || { echo "Failed to enable grafana"; exit 1; }
}

# Main script starts here

# Step 1: Download necessary files
echo "Starting download of Prometheus, Node Exporter, and Grafana files..."
download_file "https://github.com/prometheus/prometheus/releases/download/v3.2.0-rc.1/prometheus-3.2.0-rc.1.linux-amd64.tar.gz" "prometheus-3.2.0-rc.1.linux-amd64.tar.gz"
download_file "https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz" "node_exporter-1.8.2.linux-amd64.tar.gz"
download_file "https://github.com/repo9k/Linux-Monitoring/raw/main/node_exporter.service" "node_exporter.service"
download_file "https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.service" "prometheus.service"
download_file "https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.yml" "prometheus.yml"
download_file "https://dl.grafana.com/enterprise/release/grafana-enterprise_11.5.1_amd64.deb" "grafana-enterprise_11.5.1_amd64.deb"

# Step 2: Extract downloaded tar files
extract_file "node_exporter-1.8.2.linux-amd64.tar.gz" "node_exporter-1.8.2.linux-amd64"
extract_file "prometheus-3.2.0-rc.1.linux-amd64.tar.gz" "prometheus-3.2.0-rc.1.linux-amd64"

# Step 3: Move files to appropriate directories
move_files

# Step 4: Enable and start services
enable_start_services

# Step 5: Install required dependencies
install_dependencies

# Step 6: Install Grafana
install_grafana

# Step 7: Start Grafana service
start_grafana_service

echo "Setup complete!"
