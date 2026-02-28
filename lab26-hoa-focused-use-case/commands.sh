#!/usr/bin/env bash
# Lab 26 - Creating an HOA-Focused Use Case (ELK in Docker)
# Commands Executed During Lab (sequential, copy/paste-ready)

# -------------------------------
# Task 1: Set up ELK Stack (Docker)
# -------------------------------
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

# Verify Docker
docker --version

# Create project directory
mkdir -p ~/lab26-hoa-elk
cd ~/lab26-hoa-elk

# Create docker-compose.yml (as provided, later updated with volumes)
nano docker-compose.yml

# Attempt with legacy docker-compose (not installed in this environment)
docker-compose up -d

# Verify Compose plugin and use modern command
docker compose version
docker compose up -d

# Check containers
docker ps

# Quick Elasticsearch check
curl -s http://localhost:9200 | head -n 8

# -------------------------------
# Task 2: Identify an event source (HOA gate logs)
# -------------------------------
nano gate_logs.log
cat gate_logs.log

# -------------------------------
# Task 3: Craft rule for unusual activity (00:00–05:00) using Logstash pipeline
# -------------------------------
nano logstash-gate.conf

# Update compose file to mount pipeline + log file into Logstash container
nano docker-compose.yml

# Restart stack to apply mounts
docker compose up -d

# Watch Logstash ingest once (verify tags + parsed fields)
docker logs logstash --tail 25

# -------------------------------
# Task 5: Test with manual log entry + validate detection
# -------------------------------
echo "2023-09-16T01:30:00 Security Gate1 User789 Entry" >> gate_logs.log
tail -n 3 gate_logs.log

# Restart Logstash to re-ingest quickly (sincedb_path => /dev/null)
docker restart logstash

# Confirm new event tagged unusual_activity
docker logs logstash --tail 20

# Refresh index and query Elasticsearch for tagged events
curl -s -X POST "http://localhost:9200/hoa-gate-*/_refresh"

curl -s "http://localhost:9200/hoa-gate-*/_search?pretty" \
-H 'Content-Type: application/json' \
-d '{
  "query": { "term": { "tags": "unusual_activity" } },
  "_source": ["@timestamp","gate","user","direction","hour","tags"],
  "sort": [{ "@timestamp": "desc" }]
}'
