# Linux-Monitoring

## Usage
First, get the files

```bash
sudo wget https://github.com/repo9k/Linux-Monitoring/blob/main/prometheus.service
sudo wget https://github.com/repo9k/Linux-Monitoring/blob/main/node_exporter.service
sudo wget https://github.com/repo9k/Linux-Monitoring/blob/main/prometheus.yml
Sudo wget https://github.com/prometheus/prometheus/releases/download/v3.2.0-rc.1/prometheus-3.2.0-rc.1.linux-amd64.tar.gz
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
```
## Step 2

```bash
tar xzf prometheus-3.2.0-rc.1.linux-amd64.tar.gz
tar xzf node_exporter-1.8.2.linux-amd64.tar.gz
sudo mv prometheus-3.2.0-rc.1.linux-amd64 /etc/prometheus
sudo mv node_exporter-1.8.2.linux-amd64 /etc/node_exporter
sudo rm -r /etc/prometheus/prometheus.yml
sudo mv prometheus.yml /etc/prometheus
sudo mv node_exporter.service /etc/systemd/system/
sudo mv prometheus.service /etc/systemd/system/
```
## step 3 Enable and start the services
```bash
systemctl enable node_exporter.service
systemctl enable prometheus.service
systemctl restart node_exporter.service
systemctl restart prometheus.service
```
## step 4 Install required packages

```bash
apt-get install -y adduser libfontconfig1 musl
sudo wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.5.1_amd64.deb
sudo dpkg -i grafana-enterprise_11.5.1_amd64.deb
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```
