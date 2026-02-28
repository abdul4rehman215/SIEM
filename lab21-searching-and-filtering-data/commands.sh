#!/usr/bin/env bash
# Lab 21 - Searching & Filtering Data
# Commands Executed During Lab (sequential, copy/paste-ready)

# -------------------------------
# Pre-Lab: Verify Elasticsearch & Kibana Are Reachable
# -------------------------------
curl -s http://localhost:9200 | head
curl -s http://localhost:5601/api/status | head -n 12

# -------------------------------
# Sample Data Setup (so searches return results)
# -------------------------------

# Create an index with mapping
curl -s -X PUT "http://localhost:9200/logs-demo" \
-H 'Content-Type: application/json' \
-d '{
  "mappings": {
    "properties": {
      "@timestamp": { "type": "date" },
      "message": { "type": "text" },
      "severity": { "type": "keyword" },
      "source": {
        "properties": {
          "ip": { "type": "ip" }
        }
      }
    }
  }
}' | jq .

# Insert test documents via bulk API
curl -s -X POST "http://localhost:9200/logs-demo/_bulk" \
-H 'Content-Type: application/x-ndjson' \
-d '
{ "index": {} }
{ "@timestamp":"2026-02-28T06:10:00Z","severity":"info","source":{"ip":"192.168.0.10"},"message":"User login success" }
{ "index": {} }
{ "@timestamp":"2026-02-28T07:20:00Z","severity":"error","source":{"ip":"192.168.0.55"},"message":"Failed SSH login attempt" }
{ "index": {} }
{ "@timestamp":"2026-02-27T09:05:00Z","severity":"error","source":{"ip":"10.0.2.15"},"message":"Disk space low warning" }
{ "index": {} }
{ "@timestamp":"2026-02-28T08:42:00Z","severity":"warning","source":{"ip":"192.168.1.50"},"message":"Multiple HTTP 404 responses" }
{ "index": {} }
{ "@timestamp":"2026-02-28T09:15:00Z","severity":"error","source":{"ip":"192.168.0.99"},"message":"Application exception in auth module" }
' | jq .

# Refresh index
curl -s -X POST "http://localhost:9200/logs-demo/_refresh" | jq .

# -------------------------------
# Task 1: Field-Based Queries (wildcard IP search)
# -------------------------------
curl -s "http://localhost:9200/logs-demo/_search" \
-H 'Content-Type: application/json' \
-d '{
  "query": {
    "wildcard": {
      "source.ip": "192.168.0.*"
    }
  }
}' | jq '.hits.total, (.hits.hits[]._source | { "@timestamp", severity, "source.ip", message })'

# -------------------------------
# Task 2: Filtering by Time Range + Severity (last 24h + error)
# -------------------------------
curl -s "http://localhost:9200/logs-demo/_search" \
-H 'Content-Type: application/json' \
-d '{
  "query": {
    "bool": {
      "filter": [
        { "term": { "severity": "error" } },
        { "range": { "@timestamp": { "gte": "now-24h", "lte": "now" } } }
      ]
    }
  },
  "sort": [{ "@timestamp": "desc" }]
}' | jq '.hits.total, (.hits.hits[]._source | { "@timestamp", severity, "source.ip", message })'

# -------------------------------
# Task 3: Saving a Frequently Used Query (verify via Kibana Saved Objects API)
# -------------------------------
curl -s -X GET "http://localhost:5601/api/saved_objects/_find?type=search&search_fields=title&search=Error_Logs_Last_24_Hours" \
-H 'kbn-xsrf: true' | jq '.total, (.saved_objects[] | {id, type, title: .attributes.title})'
