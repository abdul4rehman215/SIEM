#!/bin/bash
# Lab 11 - Parsing & Normalization Basics
# Commands executed during lab (sequential, no explanations)

# Confirm Elasticsearch reachable
curl -s http://localhost:9200

# Create working directory + pipeline file
mkdir -p ~/labs/parsing-normalization
cd ~/labs/parsing-normalization
nano pipeline.json

# Upload pipeline
curl -s -X PUT "http://localhost:9200/_ingest/pipeline/logdata_pipeline" \
-H "Content-Type: application/json" \
-d @pipeline.json

# Verify pipeline exists
curl -s "http://localhost:9200/_ingest/pipeline/logdata_pipeline?pretty"

# Simulate parsing (good input)
curl -s -X POST "http://localhost:9200/_ingest/pipeline/logdata_pipeline/_simulate?pretty" \
-H "Content-Type: application/json" \
-d '
{
  "docs": [
    {
      "_source": {
        "timestamp": "2023-10-15T13:45:30Z",
        "ip_addr": "192.168.1.1",
        "event_id": "abc123",
        "event_type": "UserLogin"
      }
    }
  ]
}
'

# Simulate parsing (bad timestamp)
curl -s -X POST "http://localhost:9200/_ingest/pipeline/logdata_pipeline/_simulate?pretty" \
-H "Content-Type: application/json" \
-d '
{
  "docs": [
    {
      "_source": {
        "timestamp": "15-10-2023 13:45:30",
        "ip_addr": "192.168.1.50",
        "event_id": "abc124",
        "event_type": "UserLogin"
      }
    }
  ]
}
'

# Simulate parsing (invalid IP)
curl -s -X POST "http://localhost:9200/_ingest/pipeline/logdata_pipeline/_simulate?pretty" \
-H "Content-Type: application/json" \
-d '
{
  "docs": [
    {
      "_source": {
        "timestamp": "2023-10-15T13:45:30Z",
        "ip_addr": "999.999.1.1",
        "event_id": "abc125",
        "event_type": "UserLogin"
      }
    }
  ]
}
'

# Example aggregation query (initial attempt on missing index)
curl -s -X GET "http://localhost:9200/logs-test/_search?pretty" \
-H "Content-Type: application/json" \
-d '
{
  "size": 0,
  "aggs": {
    "event_ids": {
      "terms": {
        "field": "event_id.keyword",
        "size": 10
      }
    }
  }
}
'

# Create index + ingest sample doc through pipeline
curl -s -X PUT "http://localhost:9200/logs-test?pretty"
curl -s -X POST "http://localhost:9200/logs-test/_doc?pipeline=logdata_pipeline&pretty" \
-H "Content-Type: application/json" \
-d '
{
  "timestamp": "2023-10-15T13:45:30Z",
  "ip_addr": "192.168.1.1",
  "event_id": "abc123",
  "event_type": "UserLogin"
}
'

# Run aggregation again
curl -s -X GET "http://localhost:9200/logs-test/_search?pretty" \
-H "Content-Type: application/json" \
-d '
{
  "size": 0,
  "aggs": {
    "event_ids": {
      "terms": {
        "field": "event_id.keyword",
        "size": 10
      }
    }
  }
}
'
