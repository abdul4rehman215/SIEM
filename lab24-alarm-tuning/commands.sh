#!/usr/bin/env bash
# Lab 24 - Alarm Tuning (ElastAlert)
# Commands Executed During Lab (sequential, copy/paste-ready)

# -------------------------------
# Task 0: Setup - Install ElastAlert + Prepare Log Directory
# -------------------------------
sudo apt update

python3 --version

sudo apt install python3-pip python3-venv -y

python3 -m venv ~/elastalert-venv
source ~/elastalert-venv/bin/activate

pip install elastalert

sudo mkdir -p /etc/elastalert/rules /var/log/elastalert
sudo chown -R toor:toor /etc/elastalert /var/log/elastalert

# -------------------------------
# Task 1: Identify Frequent False Positive Alerts
# -------------------------------
cd /var/log/elastalert/

# Create sample alert log
nano alerts.log

# Lab-style filter example
grep -i "ALERT:" alerts.log | awk '{print $1, $2, $3, $4, $5, $6}'

# Practical alert frequency counting
grep -oP 'ALERT:\s+\K[^ ]+' alerts.log | sort | uniq -c | sort -nr

# -------------------------------
# Task 2: Add Exception Conditions (ElastAlert must_not tuning)
# -------------------------------

# Create base ElastAlert config
sudo nano /etc/elastalert/elastalert.yaml

# Create noisy rule (before tuning)
sudo nano /etc/elastalert/rules/http_404_spike.yaml

# Update rule with exceptions (must_not tuning)
sudo nano /etc/elastalert/rules/http_404_spike.yaml

# Validate YAML formatting
python3 -c "import yaml; yaml.safe_load(open('/etc/elastalert/rules/http_404_spike.yaml')); print('YAML OK')"

# -------------------------------
# Task 3: Test and Validate Changes
# -------------------------------

# Insert test inbound logs into Elasticsearch (benign + suspicious)
curl -s -X POST "http://localhost:9200/inbound-logs/_bulk" \
-H 'Content-Type: application/x-ndjson' \
-d '
{ "index": {} }
{ "@timestamp":"2026-02-28T07:50:00Z","source":{"ip":"192.168.0.10"},"destination":{"ip":"172.31.10.164"},"event_type":"http","message":"GET /favicon.ico 404" }
{ "index": {} }
{ "@timestamp":"2026-02-28T07:50:10Z","source":{"ip":"192.168.0.10"},"destination":{"ip":"172.31.10.164"},"event_type":"http","message":"GET /robots.txt 404" }
{ "index": {} }
{ "@timestamp":"2026-02-28T07:50:20Z","source":{"ip":"192.168.0.10"},"destination":{"ip":"172.31.10.164"},"event_type":"http","message":"GET /wp-login.php 404" }

{ "index": {} }
{ "@timestamp":"2026-02-28T07:51:00Z","source":{"ip":"185.220.101.4"},"destination":{"ip":"172.31.10.164"},"event_type":"http","message":"GET /wp-login.php 404" }
{ "index": {} }
{ "@timestamp":"2026-02-28T07:51:10Z","source":{"ip":"185.220.101.4"},"destination":{"ip":"172.31.10.164"},"event_type":"http","message":"GET /wp-login.php 404" }
{ "index": {} }
{ "@timestamp":"2026-02-28T07:51:20Z","source":{"ip":"185.220.101.4"},"destination":{"ip":"172.31.10.164"},"event_type":"http","message":"GET /wp-login.php 404" }
' | jq .

# Refresh index
curl -s -X POST "http://localhost:9200/inbound-logs/_refresh" | jq .

# Run ElastAlert rule test
elastalert-test-rule --config /etc/elastalert/elastalert.yaml --rule /etc/elastalert/rules/http_404_spike.yaml

# Before vs After evidence queries (noise reduction proof)

# Before exceptions: count all matching events
curl -s "http://localhost:9200/inbound-logs/_search" \
-H 'Content-Type: application/json' \
-d '{
  "query": {
    "bool": {
      "filter": [
        { "term": { "event_type": "http" } },
        { "query_string": { "query": "message:*404* OR message:*wp-login.php* OR message:*robots.txt* OR message:*favicon.ico*" } }
      ]
    }
  }
}' | jq '.hits.total'

# After exceptions: exclude benign IP and health checks
curl -s "http://localhost:9200/inbound-logs/_search" \
-H 'Content-Type: application/json' \
-d '{
  "query": {
    "bool": {
      "filter": [
        { "term": { "event_type": "http" } },
        { "query_string": { "query": "message:*404* OR message:*wp-login.php* OR message:*robots.txt* OR message:*favicon.ico*" } }
      ],
      "must_not": [
        { "term": { "source.ip": "192.168.0.10" } },
        { "query_string": { "query": "message:*GET /health*" } }
      ]
    }
  }
}' | jq '.hits.total'
