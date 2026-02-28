#!/bin/bash
# Lab 12 - Custom Field Extraction
# Commands executed during lab (sequential, no explanations)

# Regex search via Elasticsearch Query DSL
curl -s -X GET "http://localhost:9200/logs-*/_search?pretty" \
-H "Content-Type: application/json" \
-d '
{
  "size": 3,
  "query": {
    "regexp": {
      "message": {
        "value": ".*(\\\\d{1,3}\\\\.){3}\\\\d{1,3}.*"
      }
    }
  },
  "_source": ["@timestamp","message","host.name"]
}
'

# Confirm Logstash installed
logstash --version

# Create pipeline config
mkdir -p ~/labs/custom-field-extraction
cd ~/labs/custom-field-extraction
nano custom_grok.conf

# Test grok extraction with sample log via stdin
echo 'Feb 28 21:45:12 web01 sshd[2441]: Failed password for invalid user admin from 203.0.113.55 port 51244 ssh2' | logstash -f custom_grok.conf
