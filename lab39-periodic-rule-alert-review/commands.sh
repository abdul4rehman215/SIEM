#!/bin/bash
# Lab 39 - Periodic Rule & Alert Review (Prometheus)
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Step 0: Create working directory
# =========================
mkdir -p Lab39_Rule_Review
cd Lab39_Rule_Review

# =========================
# Task 1: Confirm Prometheus reachable
# =========================
curl -I http://localhost:9090 | head

# =========================
# Install jq (if missing)
# =========================
jq --version
sudo apt-get install -y jq

# =========================
# List active rules (Prometheus rules API)
# =========================
curl -X GET http://localhost:9090/api/v1/rules | jq '.data.groups[] | {name: .name, rules: [.rules[] | {name: .name, type: .type, health: .health, lastEvaluation: .lastEvaluation}]}' | head -n 80

# =========================
# Create a sample rule for review (if no rules exist)
# =========================
sudo mkdir -p /etc/prometheus/rules.d
sudo nano /etc/prometheus/rules.d/siem_alerts.yml

# Ensure Prometheus loads the rules directory
sudo grep -n "rule_files" -A3 /etc/prometheus/prometheus.yml | head -n 20

# Reload Prometheus to load new rules
sudo systemctl reload prometheus

# Confirm rule now appears
curl -s http://localhost:9090/api/v1/rules | jq '.data.groups[] | select(.name=="siem_health_rules")'

# =========================
# Task 2: Test rule metric (CPU % without threshold)
# =========================
curl -sG "http://localhost:9090/api/v1/query" \
  --data-urlencode 'query=100 - (avg by(instance)(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)' | jq

# =========================
# Task 3: Revise rule threshold (performed)
# =========================
sudo nano /etc/prometheus/rules.d/siem_alerts.yml
sudo systemctl reload prometheus

# =========================
# Task 4: Document outcome
# =========================
nano Rule_Review_Log.md
ls -lh
