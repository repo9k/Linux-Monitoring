#!/bin/bash

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

# Step 1: Setup Monitoring (Download, Extract, and Move Files)
setup_monitoring() {
    echo "===== Setting Up Monitoring ====="
    download_file "https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.service" "/tmp/prometheus.service"
    download_file "https://github.com/repo9k/Linux-Monitoring/raw/main/node_exporter.service" "/tmp/node_exporter.service"
    download_file "https://github.com/repo9k/Linux-Monitoring/raw/main/prometheus.yml" "/tmp/prometheus.yml"
    download_file "https://github.com/prometheus/prometheus/releases/download/v3.2.0-rc.1/prometheus-3.2.0-rc.1.linux-amd64.tar.gz" "/tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz"
    download_file "https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz" "/tmp/node_exporter-1.8.2.linux-amd64.tar.gz"

    extract_tarball "/tmp/prometheus-3.2.0-rc.1.linux-amd64.tar.gz" "/etc/prometheus"
    extract_tarball "/tmp/node_exporter-1.8.2.linux-amd64.tar.gz" "/etc/node_exporter"

    sudo mv -f /tmp/prometheus.yml /etc/prometheus/
    sudo mv -f /tmp/node_exporter.service /etc/systemd/system/
    sudo mv -f /tmp/prometheus.service /etc/systemd/system/
}

# Step 2: Start Monitoring Services
start_services() {
    echo "===== Starting Monitoring Services ====="
    start_service "node_exporter.service"
    start_service "prometheus.service"
}

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

# Main menu
main_menu() {
    echo "===== Monitoring Setup Menu ====="
    echo "1. Setup Monitoring (Download, Extract, and Move Files)"
    echo "2. Start Monitoring Services"
    echo "3. Install Grafana"
    echo "4. Check Service Status"
    echo "5. Exit"
    read -p "Choose an option (1-5): " choice

    case "$choice" in
        1) setup_monitoring ;;
        2) start_services ;;
        3) install_grafana ;;
        4) check_status ;;
        5) exit 0 ;;
        *) echo "Invalid option. Please try again." ;;
    esac
}

# Run the main menu in a loop
while true; do
    main_menu
    read -p "Press Enter to continue..."
done