#!/usr/bin/env bash
sudo apt-get update

sudo apt-get install stress

# create downloads directory so that we can download all the packages
# which are required during provisioning process
mkdir /home/vagrant/Downloads
cd /home/vagrant/Downloads

# download prometheus installation files
wget https://github.com/prometheus/prometheus/releases/download/v2.21.0/prometheus-2.21.0.linux-amd64.tar.gz

# create directory for prometheus installation files
# so that we can extrac all the files into it
mkdir -p /home/vagrant/Prometheus/server
cd /home/vagrant/Prometheus/server

# Extract files
tar -xvzf /home/vagrant/Downloads/prometheus-2.21.0.linux-amd64.tar.gz

cd prometheus-2.21.0.linux-amd64

# check prometheus version
./prometheus -version

# create directory for node_exporter which can be used to send ubuntu metrics to the prometheus server
mkdir -p /home/vagrant/Prometheus/node_exporter
cd /home/vagrant/Prometheus/node_exporter

# download node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz -O /home/vagrant/Downloads/node_exporter-1.0.1.linux-amd64.tar.gz

# extract node_exporter
tar -xvzf /home/vagrant/Downloads/node_exporter-1.0.1.linux-amd64.tar.gz

sudo cp /home/vagrant/Prometheus/node_exporter/node_exporter-1.0.1.linux-amd64/node_exporter /usr/local/bin/
sudo useradd --no-create-home --shell /bin/false node_exporter
sudo chown -R node_exporter:node_exporter /usr/local/bin/node_exporter

# edit node_exporter configuration file and add configuration so that it will automatically start in next boot
sudo cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF

sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl status node_exporter
sudo systemctl enable node_exporter

# -------------------

sudo useradd --no-create-home --shell /bin/false prometheus


cd /home/vagrant/Prometheus/server/prometheus-2.21.0.linux-amd64/


sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/

sudo mkdir /etc/prometheus
sudo cp -r consoles/ \
  /etc/prometheus/consoles
sudo cp -r console_libraries/ \
  /etc/prometheus/console_libraries
#sudo cp prometheus.yml \
#  /etc/prometheus/
sudo chown -R prometheus:prometheus /etc/prometheus

sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus


sudo cat <<EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=default.target
EOF



# edit prometheus configuration file which will pull metrics from node_exporter
# every 15 seconds time interval
sudo cat <<EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval: 1s # Set the scrape interval to every 1 second.

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    monitor: 'codelab-monitor'

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'node-prometheus'

    static_configs:
      - targets: ['localhost:9090', 'localhost:9100']
EOF


sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl status prometheus
sudo systemctl enable prometheus

# -----------------

# download grafana
wget https://dl.grafana.com/oss/release/grafana_6.7.0_amd64.deb -O /home/vagrant/Downloads/grafana_6.7.0_amd64.deb

sudo apt-get install -y adduser libfontconfig

# install grafana 
sudo dpkg -i /home/vagrant/Downloads/grafana_6.7.0_amd64.deb

sudo systemctl start grafana-server
sudo systemctl status grafana-server
sudo systemctl enable grafana-server


#stress --cpu 2 --timeout 60
