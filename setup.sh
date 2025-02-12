#!/bin/bash

# Step 1: Check if Prometheus and Node Exporter files exist, download if not
echo "Checking if Prometheus and Node Exporter files are already downloaded..."
if [ ! -f /tmp/prometheus.service ]; then
    echo "Downloading prometheus.service..."
    sudo wget -v https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.service -O /tmp/prometheus.service
else
    echo "prometheus.service already exists."
fi
# Function to download a file if it doesn't exist
download_file() {
    local url=$1
    local dest=$2
    if [ ! -f "$dest" ]; then
        echo "Downloading $dest..."
        sudo wget -q "$url" -O "$dest"
    else
        echo "$dest already exists."
    fi
}

if [ ! -f /tmp/node_exporter.service ]; then
    echo "Downloading node_exporter.service..."
    sudo wget -v https://github.com/repo9k/Linux-Monitoring/raw/main/node_exporter.service -O /tmp/node_exporter.service
else
    echo "node_exporter.service already exists."
fi
# Function to extract a tarball if the destination directory doesn't exist
extract_tarball() {
    local tarball=$1
    local dest_dir=$2
    if [ ! -d "$dest_dir" ]; then
        echo "Extracting $tarball..."
        tar xzf "$tarball" -C /tmp
        sudo mv "/tmp/$(basename "$tarball" .tar.gz)" "$dest_dir"
    else
        echo "$dest_dir already exists."
    fi
}

if [ ! -f /tmp/prometheus.yml ]; then
    echo "Downloading prometheus.yml..."
    sudo wget -v https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.yml -O /tmp/prometheus.yml
else
    echo "prometheus.yml already exists."
fi
# Function to enable and start a service
start_service() {
    local service=$1
    if ! systemctl is-active --quiet "$service"; then
        sudo systemctl enable "$service"
        sudo systemctl start "$service"
        echo "$service started successfully."
    else
        echo "$service is already running."
    fi
}

if [ ! -f /tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz ]; then
    echo "Downloading Prometheus tarball..."
    sudo wget -v https://github.com/prometheus/prometheus/releases/download/v3.2.0-rc.1/prometheus-3.2.0-rc.1.linux-amd64.tar.gz -O /tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz
else
    echo "Prometheus tarball already exists."
fi
# Step 1: Setup Monitoring (Download, Extract, and Move Files)
setup_monitoring() {
    echo "===== Setting Up Monitoring ====="
    download_file "https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.service" "/tmp/prometheus.service"
    download_file "https://github.com/repo9k/Linux-Monitoring/raw/main/node_exporter.service" "/tmp/node_exporter.service"
    download_file "https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.yml" "/tmp/prometheus.yml"
    download_file "https://github.com/prometheus/prometheus/releases/download/v3.2.0-rc.1/prometheus-3.2.0-rc.1.linux-amd64.tar.gz" "/tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz"
    download_file "https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz" "/tmp/node_exporter-1.8.2.linux-amd64.tar.gz"

if [ ! -f /tmp/node_exporter-1.8.2.linux-amd64.tar.gz ]; then
    echo "Downloading Node Exporter tarball..."
    sudo wget -v https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz -O /tmp/node_exporter-1.8.2.linux-amd64.tar.gz
else
    echo "Node Exporter tarball already exists."
fi
    extract_tarball "/tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz" "/etc/prometheus"
    extract_tarball "/tmp/node_exporter-1.8.2.linux-amd64.tar.gz" "/etc/node_exporter"

# Step 2: Extract tarballs only if they haven't been extracted
echo "Extracting Prometheus and Node Exporter tarballs..."
if [ ! -d /etc/prometheus ]; then
    echo "Extracting Prometheus..."
    tar xzf /tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz -C /tmp
    sudo mv /tmp/prometheus-3.2.0-rc.1.linux-amd64 /etc/prometheus
else
    echo "Prometheus directory already exists."
fi
    sudo mv -f /tmp/prometheus.yml /etc/prometheus/
    sudo mv -f /tmp/node_exporter.service /etc/systemd/system/
    sudo mv -f /tmp/prometheus.service /etc/systemd/system/
}

if [ ! -d /etc/node_exporter ]; then
    echo "Extracting Node Exporter..."
    tar xzf /tmp/node_exporter-1.8.2.linux-amd64.tar.gz -C /tmp
    sudo mv /tmp/node_exporter-1.8.2.linux-amd64 /etc/node_exporter
else
    echo "Node Exporter directory already exists."
fi
# Step 2: Start Monitoring Services
start_services() {
    echo "===== Starting Monitoring Services ====="
    start_service "node_exporter.service"
    start_service "prometheus.service"
}

# Step 3: Replace Prometheus configuration file (overwrite if necessary)
echo "Replacing Prometheus configuration file..."
sudo mv /tmp/prometheus.yml /etc/prometheus
# Step 3: Install Grafana
install_grafana() {
    echo "===== Installing Grafana ====="
    if ! dpkg -l | grep -q grafana; then
        sudo apt-get update
        sudo apt-get install -y adduser libfontconfig1 musl
        download_file "https://dl.grafana.com/enterprise/release/grafana-enterprise_11.5.1_amd64.deb" "/tmp/grafana-enterprise_11.5.1_amd64.deb"
        sudo dpkg -i /tmp/grafana-enterprise_11.5.1_amd64.deb
    else
        echo "Grafana is already installed."
    fi
    start_service "grafana-server"
}

# Step 4: Move service files only if they aren't already present
echo "Moving Prometheus and Node Exporter service files..."
if [ ! -f /etc/systemd/system/node_exporter.service ]; then
    sudo mv /tmp/node_exporter.service /etc/systemd/system/
else
    echo "Node Exporter service file already exists."
fi
# Step 4: Check Service Status
check_status() {
    echo "===== Service Status ====="
    services=("node_exporter.service" "prometheus.service" "grafana-server")
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service"; then
            echo "$service is running."
        else
            echo "$service is not running."
        fi
    done
}

if [ ! -f /etc/systemd/system/prometheus.service ]; then
    sudo mv /tmp/prometheus.service /etc/systemd/system/
else
    echo "Prometheus service file already exists."
fi
# Main menu
main_menu() {
    echo "===== Monitoring Setup Menu ====="
    echo "1. Setup Monitoring (Download, Extract, and Move Files)"
    echo "2. Start Monitoring Services"
    echo "3. Install Grafana"
    echo "4. Check Service Status"
    echo "5. Exit"
    read -p "Choose an option (1-5): " choice

# Step 5: Enable and start the services only if they aren't already running
echo "Enabling and starting Prometheus and Node Exporter services..."
if ! systemctl is-active --quiet node_exporter.service; then
    sudo systemctl enable node_exporter.service
    sudo systemctl start node_exporter.service
else
    echo "Node Exporter service is already running."
fi
    case "$choice" in
        1) setup_monitoring ;;
        2) start_services ;;
        3) install_grafana ;;
        4) check_status ;;
        5) exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
}

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
# Run the main menu in a loop
while true; do
    main_menu
    read -p "Press Enter to continue..."
done