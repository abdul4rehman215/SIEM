#!/bin/bash
# Lab 38 - Reviewing System Health & Performance
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Step 0: Create working directory
# =========================
mkdir -p Lab38_System_Health
cd Lab38_System_Health

# =========================
# Task 1.1: Install Prometheus + Node Exporter
# =========================
sudo apt-get update
sudo apt-get install prometheus

# Start and enable services
sudo systemctl enable --now prometheus
sudo systemctl enable --now prometheus-node-exporter

# Verify services
systemctl status prometheus --no-pager | head -n 12
systemctl status prometheus-node-exporter --no-pager | head -n 12

# Confirm ports (9090 Prometheus, 9100 Node Exporter)
sudo ss -lntp | egrep '9090|9100'

# Quick HTTP check
curl -I http://localhost:9090 | head

# =========================
# Task 1.2: Monitor CPU Usage (Prometheus HTTP API)
# =========================
curl -sG "http://localhost:9090/api/v1/query" \
  --data-urlencode 'query=100 - (avg by(instance)(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)' | head -n 40

# =========================
# Task 1.3: Monitor Memory Usage (Prometheus HTTP API)
# =========================
curl -sG "http://localhost:9090/api/v1/query" \
  --data-urlencode 'query=node_memory_Active_bytes / node_memory_MemTotal_bytes * 100' | head -n 40

# =========================
# Task 2: Review ingestion/indexing (Elasticsearch APIs)
# =========================
curl -s "http://localhost:9200/_cat/indices?v" | head -n 20
curl -s "http://localhost:9200/_stats/indexing?pretty" | head -n 60
curl -s "http://localhost:9200/_cat/thread_pool/write?v"

# =========================
# Task 3: Check system logs for errors
# =========================
grep -i "error" /var/log/syslog | head -n 30

# =========================
# Fix applied: permissions on Prometheus config
# =========================
ls -l /etc/prometheus/prometheus.yml
sudo chown root:prometheus /etc/prometheus/prometheus.yml
sudo chmod 640 /etc/prometheus/prometheus.yml

# Restart and confirm healthy
sudo systemctl restart prometheus
systemctl status prometheus --no-pager | head -n 12
