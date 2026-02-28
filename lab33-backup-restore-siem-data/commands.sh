#!/bin/bash
# Lab 33 - Backup & Restore of SIEM Data (ELK)
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Identify indices available
# =========================
curl -s "http://localhost:9200/_cat/indices?v" | head -n 25

# =========================
# Create snapshot repository directory
# =========================
sudo mkdir -p /var/backups/elasticsearch
sudo chown -R elasticsearch:elasticsearch /var/backups/elasticsearch
sudo chmod 750 /var/backups/elasticsearch

# =========================
# Configure path.repo in Elasticsearch (manual edit)
# =========================
sudo nano /etc/elasticsearch/elasticsearch.yml

# =========================
# Restart Elasticsearch after config change
# =========================
sudo systemctl restart elasticsearch

# Confirm Elasticsearch is back online
curl -s http://localhost:9200 | head

# =========================
# Register snapshot repository
# =========================
curl -s -X PUT "http://localhost:9200/_snapshot/my_backup" \
  -H 'Content-Type: application/json' -d '{
    "type": "fs",
    "settings": {
      "location": "/var/backups/elasticsearch",
      "compress": true
    }
  }'

# =========================
# Create a snapshot of SIEM index (real index used)
# =========================
curl -s -X PUT "http://localhost:9200/_snapshot/my_backup/snapshot_1?wait_for_completion=true" \
 -H 'Content-Type: application/json' -d'{
 "indices": "filebeat-7.15.2-2025.08.18",
 "ignore_unavailable": true,
 "include_global_state": false
 }'

# =========================
# Export Kibana Saved Objects (dashboards/config baseline)
# =========================
curl -s -X POST "http://localhost:5601/api/saved_objects/_export" \
  -H "kbn-xsrf: true" -H "Content-Type: application/json" \
  -d '{"type":["dashboard","visualization","search","index-pattern"],"includeReferencesDeep":true}' \
  -o kibana_saved_objects_backup.ndjson

# Verify saved objects backup file
ls -lh kibana_saved_objects_backup.ndjson

# =========================
# Verify snapshot list
# =========================
curl -s "http://localhost:9200/_snapshot/my_backup/_all?pretty" | head -n 60

# Verify repository folder contains snapshot files
sudo ls -lah /var/backups/elasticsearch

# =========================
# Simulated test restore
# =========================

# Delete index (simulate data loss)
curl -s -X DELETE "http://localhost:9200/filebeat-7.15.2-2025.08.18?pretty"

# Confirm index is gone
curl -s "http://localhost:9200/_cat/indices?v" | grep filebeat || echo "filebeat index not found (as expected)"

# Restore from snapshot
curl -s -X POST "http://localhost:9200/_snapshot/my_backup/snapshot_1/_restore" \
 -H 'Content-Type: application/json' -d'{
 "indices": "filebeat-7.15.2-2025.08.18",
 "ignore_unavailable": true,
 "include_global_state": false
 }'

# Check recovery status
curl -s "http://localhost:9200/_cat/recovery/filebeat-7.15.2-2025.08.18?v"

# =========================
# Validate restored data integrity
# =========================
curl -s "http://localhost:9200/_cat/indices?v" | grep filebeat
curl -s "http://localhost:9200/filebeat-7.15.2-2025.08.18/_count?pretty"
wc -l kibana_saved_objects_backup.ndjson
