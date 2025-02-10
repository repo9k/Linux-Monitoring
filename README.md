# Linux-Monitoring

## Usage
First, get the files

```bash
Sudo wget https://github.com/prometheus/prometheus/releases/download/v3.2.0-rc.1/prometheus-3.2.0-rc.1.linux-amd64.tar.gz
tar xzf prometheus-3.2.0-rc.1.linux-amd64
sudo mv prometheus-3.2.0-rc.1.linux-amd64 /etc/prometheus
sudo rm -r /etc/prometheus/prometheus.yml
sudo mv prometheus.yml /etc/prometheus
```
