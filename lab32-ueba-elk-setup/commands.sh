#!/bin/bash
# Lab 32 - Setting Up User and Entity Behavior Analytics (UEBA) with ELK
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Environment Check
# =========================
cat /etc/os-release

# =========================
# Create Working Directory
# =========================
mkdir -p Lab32_UEBA_ELK
cd Lab32_UEBA_ELK

# =========================
# Update Packages
# =========================
sudo apt-get update

# =========================
# Verify Java (per lab prerequisite)
# =========================
java -version

# =========================
# Download + Install Elasticsearch 7.15.2
# =========================
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-amd64.deb
sudo dpkg -i elasticsearch-7.15.2-amd64.deb

# =========================
# Start + Enable Elasticsearch
# =========================
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
systemctl status elasticsearch --no-pager | head -n 14

# =========================
# Verify Elasticsearch Port + API
# =========================
sudo ss -lntp | grep 9200
curl -s http://localhost:9200 | head

# =========================
# Download + Install Kibana 7.15.2
# =========================
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.15.2-amd64.deb
sudo dpkg -i kibana-7.15.2-amd64.deb

# =========================
# Start + Enable Kibana
# =========================
sudo systemctl start kibana
sudo systemctl enable kibana
systemctl status kibana --no-pager | head -n 14

# =========================
# Verify Kibana Port + HTTP
# =========================
sudo ss -lntp | grep 5601
curl -I http://localhost:5601 | head

# =========================
# Download + Install Filebeat 7.15.2
# =========================
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.15.2-amd64.deb
sudo dpkg -i filebeat-7.15.2-amd64.deb

# =========================
# Download + Install Auditbeat 7.15.2
# =========================
wget https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-7.15.2-amd64.deb
sudo dpkg -i auditbeat-7.15.2-amd64.deb

# =========================
# Configure Filebeat Output to Elasticsearch
# =========================
sudo nano /etc/filebeat/filebeat.yml

# Enable system module (practical step)
sudo filebeat modules enable system

# Setup index template + dashboards
sudo filebeat setup -e

# Start + Enable Filebeat
sudo systemctl start filebeat
sudo systemctl enable filebeat
systemctl status filebeat --no-pager | head -n 14

# =========================
# Configure Auditbeat Output to Elasticsearch
# =========================
sudo nano /etc/auditbeat/auditbeat.yml

# Setup Auditbeat assets
sudo auditbeat setup -e

# Start + Enable Auditbeat
sudo systemctl start auditbeat
sudo systemctl enable auditbeat
systemctl status auditbeat --no-pager | head -n 14

# =========================
# Ingestion Verification (indices)
# =========================
curl -s "http://localhost:9200/_cat/indices?v" | head -n 20

# =========================
# UI Steps (Kibana) - performed manually
# =========================
# Open: http://localhost:5601
# Stack Management -> Index Patterns / Data Views:
#   - filebeat-*
#   - auditbeat-*
# Discover:
#   - Explore auth/system logs (filebeat)
#   - Explore host/audit activity (auditbeat)
# Example Discover filters:
#   - event.module:system AND (message:*Failed* OR message:*authentication failure*)
#   - event.action:* AND user.name:* AND host.name:*
# Machine Learning:
#   - Explore anomaly detection job templates related to auth spikes / unusual behavior
