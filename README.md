# Monitoring Setup Script

![Bash](https://img.shields.io/badge/Language-Bash-green)
![Prometheus](https://img.shields.io/badge/Tools-Prometheus-orange)
![Grafana](https://img.shields.io/badge/Tools-Grafana-blue)
![Node Exporter](https://img.shields.io/badge/Tools-Node_Exporter-yellow)

This Bash script automates the setup of a monitoring stack using **Prometheus**, **Node Exporter**, and **Grafana**. It simplifies the process of downloading, configuring, and starting these tools on a Linux system.

---

## Features

- **Automated Setup**: Downloads and configures Prometheus, Node Exporter, and Grafana.
- **Interactive Menu**: Easy-to-use menu for step-by-step setup.
- **Error Handling**: Skips steps if files or services already exist.
- **Service Management**: Automatically starts and enables services.


## Tools Included

1. **Prometheus**: A powerful time-series database for monitoring metrics.
2. **Node Exporter**: Collects system-level metrics (CPU, memory, disk, etc.).
3. **Grafana**: A visualization tool for creating dashboards from Prometheus data.


## Prerequisites

- **Linux System**: Tested on Ubuntu/Debian-based systems.
- **sudo Access**: Required for installing packages and moving files.
- **Internet Connection**: Needed to download files.


## How to Use

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/monitoring-setup.git
cd monitoring-setup
```
### 2. Make the Script Executable
```bash
chmod +x setup_monitoring.sh
```

### 3. Run the Script
```bash
./setup_monitoring.sh
```

### 4. Follow the Menu

The script provides an interactive menu with the following options:

| Option | Description                                                                 |
|--------|-----------------------------------------------------------------------------|
| 1      | Setup Monitoring (Download, Extract, and Move Files)                       |
| 2      | Start Monitoring Services (Prometheus and Node Exporter)                    |
| 3      | Install Grafana                                                             |
| 4      | Check Service Status                                                        |
| 5      | Exit                                                                        |

## Example Workflow

1. Setup Monitoring (Option 1):
- **Downloads Prometheus, Node Exporter, and Grafana files.
- **Extracts and moves files to the correct directories.

2. Start Monitoring Services (Option 2):
- **Starts and enables Prometheus and Node Exporter services.

3. Install Grafana (Option 3):
- **Installs Grafana and starts the Grafana server.

4. Check Service Status (Option 4):
- **Verifies that all services are running.

---

## Screenshots

### Interactive Menu
![Menu](https://via.placeholder.com/600x300.png?text=Interactive+Menu)

### Service Status
![Status](https://via.placeholder.com/600x300.png?text=Service+Status)

---

## Contributing

Contributions are welcome! If you have suggestions or improvements, please:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Author

[CLAWE] 
📧 xoo9hr@gmail.com
---

### How to Use:
1. Copy the content above into a file named README.md.
2. Replace placeholders (e.g., your-username, `YourEmail@example.com`) with your actual details.
3. Add actual screenshots (if available) by replacing the placeholder image URLs.
4. Push the README.md to your GitHub repository.

---
This README.md is designed to be professional, informative, and visually appealing, making it easy for others to understand and use your script.