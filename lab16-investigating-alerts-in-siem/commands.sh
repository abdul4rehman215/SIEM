#!/usr/bin/env bash
# Lab 16 - Investigating Alerts in a SIEM System
# Commands Executed During Lab (sequential, copy/paste-ready)

# -------------------------------
# Step 0: Confirm environment + setup working directory
# -------------------------------
cat /etc/os-release
pwd
mkdir -p lab_investigating_alerts
cd lab_investigating_alerts
pwd

# -------------------------------
# Step 1: Install jq (for JSON filtering like SIEM queries)
# -------------------------------
sudo apt update
sudo apt install -y jq

# -------------------------------
# Step 2: Create sample alerts dataset (JSON Lines)
# -------------------------------
nano alerts.jsonl
wc -l alerts.jsonl

# -------------------------------
# Step 3: View all alerts (summary list)
# -------------------------------
jq -r '"\(.["@timestamp"]) | \(.["alert.id"]) | \(.["alert.category"]) | severity=\(.["alert.severity"]) | user=\(.["user.name"] // "-") | src_ip=\(.["source.ip"])"' alerts.jsonl

# -------------------------------
# Step 4: Filter suspicious_login alerts (raw JSON output)
# -------------------------------
jq -c 'select(.["alert.category"]=="suspicious_login")' alerts.jsonl

# -------------------------------
# Step 5: Filter suspicious_login alerts (clean summary list)
# -------------------------------
jq -r 'select(.["alert.category"]=="suspicious_login") | "\(.["alert.id"]) | \(.["@timestamp"]) | \(.["rule.name"]) | user=\(.["user.name"]) | ip=\(.["source.ip"]) | outcome=\(.["event.outcome"])"' alerts.jsonl

# -------------------------------
# Step 6: Drill down into a specific alert (a-1001)
# -------------------------------
jq 'select(.["alert.id"]=="a-1001")' alerts.jsonl

# -------------------------------
# Step 7: Extract key investigation fields (a-1001)
# -------------------------------
jq -r 'select(.["alert.id"]=="a-1001") | "time=\(.["@timestamp"]) | user=\(.["user.name"]) | src_ip=\(.["source.ip"]) | geo=\(.["source.geo.country"] // "n/a") | outcome=\(.["event.outcome"]) | rule=\(.["rule.name"])"' alerts.jsonl

# -------------------------------
# Step 8: Pivot: find all alerts from the same source IP (192.168.1.100)
# -------------------------------
jq -r 'select(.["source.ip"]=="192.168.1.100") | "\(.["alert.id"]) | \(.["@timestamp"]) | \(.["rule.name"]) | user=\(.["user.name"] // "-") | outcome=\(.["event.outcome"] // "-")"' alerts.jsonl

# -------------------------------
# Step 9: Timeline ordering for the pivoted IP (sort by timestamp)
# -------------------------------
jq -r 'select(.["source.ip"]=="192.168.1.100") | "\(.["@timestamp"]) \(.["alert.id"]) \(.["message"])"' alerts.jsonl | sort

# -------------------------------
# Step 10: Create investigation report
# -------------------------------
nano investigation_report.md
ls -l
head -n 20 investigation_report.md
