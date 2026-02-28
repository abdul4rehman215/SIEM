#!/bin/bash
# Lab 40 - Final SIEM Health Check & Next Steps
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Step 0: Create working directory
# =========================
mkdir -p Final_SIEM_Health_Check
cd Final_SIEM_Health_Check

# =========================
# Task 1: Summarize current SIEM setup
# =========================

# Review data sources (Elasticsearch indices)
curl -s "http://localhost:9200/_cat/indices?v"

# Ingest/volume check (doc counts)
curl -s "http://localhost:9200/filebeat-7.15.2-2025.08.18/_count?pretty"
curl -s "http://localhost:9200/auditbeat-7.15.2-2025.08.18/_count?pretty"

# Examine alerts (Prometheus rules + current firing alerts)
curl -s http://localhost:9090/api/v1/rules | jq '.data.groups[] | {name:.name, rules:[.rules[]? | {name:.name, query:.query, type:.type, health:.health}]}'
curl -s http://localhost:9090/api/v1/alerts | jq '.data.alerts[]? | {labels:.labels, state:.state, activeAt:.activeAt}'

# Assess dashboards (Kibana reachable)
curl -I http://localhost:5601 | head

# =========================
# Task 3: Roadmap - simulated index settings update (lab snippet)
# =========================
curl -s -X PUT "http://localhost:9200/my-index-000001" \
  -H 'Content-Type: application/json' -d '{
    "settings": {
      "number_of_shards": 3
    }
  }' | jq

# =========================
# Final deliverable documentation
# =========================
nano Final_SIEM_Health_Check_Report.md
ls -lh
