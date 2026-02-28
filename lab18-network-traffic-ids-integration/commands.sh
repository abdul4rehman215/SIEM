#!/usr/bin/env bash
# Lab 18 - Network Traffic & IDS Integration (Optional)
# Commands Executed During Lab (sequential, copy/paste-ready)

# -------------------------------
# Task 1: Install Snort IDS
# -------------------------------
sudo apt update
sudo apt install snort

# Note: During install prompts
# - Interface(s): ens5
# - Home network (CIDR): 172.31.0.0/16

# -------------------------------
# Task 1.2: Configure Snort (enable community rules include)
# -------------------------------
sudo nano /etc/snort/snort.conf

# -------------------------------
# Task 1.3: Test Snort installation / configuration
# -------------------------------
sudo snort -T -c /etc/snort/snort.conf

# -------------------------------
# Task 2: Forward IDS Alerts to SIEM (ELK)
# -------------------------------

# Attempt installs (expected failures before adding Elastic repo)
sudo apt install elasticsearch
sudo apt install logstash
sudo apt install kibana

# Install prerequisites for Elastic APT repo
sudo apt install apt-transport-https ca-certificates curl gnupg -y

# Add Elastic GPG key + repository
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

# Update and install ELK components
sudo apt update
sudo apt install elasticsearch
sudo apt install logstash
sudo apt install kibana

# -------------------------------
# Task 2.2: Configure Logstash pipeline for Snort alerts
# -------------------------------
sudo nano /etc/logstash/conf.d/snort.conf

# -------------------------------
# Task 2.3: Start services
# -------------------------------
sudo service elasticsearch start
sudo service logstash start
sudo service kibana start

# Quick Elasticsearch health check
curl -s http://localhost:9200 | head

# -------------------------------
# Task 3: Generate test traffic
# -------------------------------
curl http://example.com
ping -c 4 example.com

# -------------------------------
# Verify Snort alert logging + Kibana access basics
# -------------------------------
sudo ls -l /var/log/snort/alert
sudo tail -n 5 /var/log/snort/alert

# Get interface IP for Kibana URL
ip a show ens5 | sed -n '1,6p'

# Confirm Kibana port listening
sudo ss -lntp | grep 5601
