#!/usr/bin/env bash
# Lab 23 - Threat Intelligence Feeds (ELK + Logstash http_poller)
# Commands Executed During Lab (sequential, copy/paste-ready)

# -------------------------------
# Verify ELK services are running
# -------------------------------
sudo service elasticsearch status | head
sudo service logstash status | head
sudo service kibana status | head

# -------------------------------
# Create local threat feed + serve via HTTP
# -------------------------------
mkdir -p ~/lab23-threat-feed
cd ~/lab23-threat-feed

nano malicious-ips-feed.json

# Start local HTTP server (run in one terminal session)
python3 -m http.server 8000

# In a second terminal session (or after backgrounding), verify feed is reachable
curl -s http://localhost:8000/malicious-ips-feed.json | head

# -------------------------------
# Configure Logstash to ingest the threat feed
# -------------------------------
sudo nano /etc/logstash/conf.d/logstash.conf

# Run Logstash with the pipeline (Ubuntu package path)
sudo /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/logstash.conf

# Stop Logstash after first successful ingest (Ctrl+C)
# ^C

# -------------------------------
# Verify threat-feed index and documents exist
# -------------------------------
curl -s "http://localhost:9200/_cat/indices?v" | grep threat-feed
curl -s "http://localhost:9200/threat-feed/_search?size=5&pretty"

# -------------------------------
# Create inbound-logs index for correlation + insert sample events
# -------------------------------
curl -s -X PUT "http://localhost:9200/inbound-logs" \
-H 'Content-Type: application/json' \
-d '{
  "mappings": {
    "properties": {
      "@timestamp": { "type": "date" },
      "source": { "properties": { "ip": { "type": "ip" } } },
      "destination": { "properties": { "ip": { "type": "ip" } } },
      "event_type": { "type": "keyword" },
      "message": { "type": "text" }
    }
  }
}' | jq .

curl -s -X POST "http://localhost:9200/inbound-logs/_bulk" \
-H 'Content-Type: application/x-ndjson' \
-d '
{ "index": {} }
{ "@timestamp":"2026-02-28T07:40:00Z","source":{"ip":"203.0.113.10"},"destination":{"ip":"172.31.10.197"},"event_type":"http","message":"GET /index.html 200" }
{ "index": {} }
{ "@timestamp":"2026-02-28T07:41:00Z","source":{"ip":"45.133.1.10"},"destination":{"ip":"172.31.10.197"},"event_type":"ssh","message":"Failed password for invalid user admin" }
{ "index": {} }
{ "@timestamp":"2026-02-28T07:42:00Z","source":{"ip":"198.51.100.23"},"destination":{"ip":"172.31.10.197"},"event_type":"icmp","message":"Ping request" }
{ "index": {} }
{ "@timestamp":"2026-02-28T07:43:00Z","source":{"ip":"185.220.101.4"},"destination":{"ip":"172.31.10.197"},"event_type":"http","message":"Suspicious scan /wp-login.php" }
' | jq .

curl -s -X POST "http://localhost:9200/inbound-logs/_refresh" | jq .

# -------------------------------
# Correlation workflow (threat-feed IPs vs inbound logs)
# -------------------------------

# Pull malicious IP list from threat-feed
curl -s "http://localhost:9200/threat-feed/_search?size=100&_source=ip" \
-H 'Content-Type: application/json' \
-d '{ "query": { "match_all": {} } }' | jq -r '.hits.hits[]._source.ip'

# Search inbound logs for matches
curl -s "http://localhost:9200/inbound-logs/_search?pretty" \
-H 'Content-Type: application/json' \
-d '{
  "query": {
    "terms": {
      "source.ip": ["45.133.1.10","103.87.212.77","185.220.101.4","91.92.109.43"]
    }
  }
}'
