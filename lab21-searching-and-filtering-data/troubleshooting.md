# 🛠️ Troubleshooting Guide — Lab 21: Searching & Filtering Data

> This guide covers common issues when creating a demo index, querying Elasticsearch, using time/severity filters, and verifying saved searches in Kibana.

---

## 1) Elasticsearch not reachable on `localhost:9200`

### ✅ Symptoms
- `curl http://localhost:9200` fails or times out

### ✅ Fix Checklist
1) Check service:
```bash
sudo systemctl status elasticsearch --no-pager
````

2. Start it:

```bash id="4r8cbn"
sudo systemctl enable --now elasticsearch
```

3. Check port:

```bash id="2e0b7m"
sudo ss -lntp | grep 9200
```

4. Review logs:

```bash id="v0aah0"
sudo journalctl -u elasticsearch --no-pager -n 200
```

---

## 2) Kibana not reachable on `localhost:5601`

### ✅ Symptoms

* `curl http://localhost:5601/api/status` fails
* browser can’t load Kibana

### ✅ Fix

1. Check service:

```bash id="m8t2t3"
sudo systemctl status kibana --no-pager
```

2. Start it:

```bash id="f5hrp4"
sudo systemctl enable --now kibana
```

3. Confirm port:

```bash id="a1p88e"
sudo ss -lntp | grep 5601
```

4. View logs:

```bash id="wcfh4p"
sudo journalctl -u kibana --no-pager -n 200
```

---

## 3) `jq: command not found`

### ✅ Symptoms

* piping JSON into `jq` fails

### ✅ Fix

Install jq:

```bash
sudo apt update
sudo apt install -y jq
jq --version
```

---

## 4) Index creation fails (400 error)

### ✅ Symptoms

* `PUT /logs-demo` returns an error
* Common message: mapping error or invalid JSON

### ✅ Fix Checklist

1. Validate JSON is well-formed (quotes/braces):

* Use a heredoc or a file to avoid quoting errors

2. Check if index already exists:

```bash id="0j80lb"
curl -s "http://localhost:9200/_cat/indices?v" | head -n 30
```

3. If it exists and you want a clean re-run (lab only):

```bash id="l1lmsu"
curl -s -X DELETE "http://localhost:9200/logs-demo" | jq .
```

Then recreate index.

---

## 5) Bulk insert returns `"errors": true`

### ✅ Symptoms

* `_bulk` response shows:

  * `"errors": true`

### ✅ Fix

1. Inspect bulk response items (look for status 400/500):

```bash id="3qx70r"
# Re-run bulk insert without piping to jq, or pipe full output to a file for review
```

2. Common causes:

* Invalid NDJSON format (each line must be JSON, newline-separated)
* Missing newline at end of payload
* Wrong content-type (must be `application/x-ndjson`)
* Mapping conflicts (wrong field types)

3. After fixing, refresh:

```bash id="0p98k5"
curl -s -X POST "http://localhost:9200/logs-demo/_refresh" | jq .
```

---

## 6) Searches return zero hits when you expect results

### ✅ Symptoms

* `_search` returns 0
* Kibana query shows no hits

### ✅ Fix Checklist

1. Confirm documents exist:

```bash id="d9q9d4"
curl -s "http://localhost:9200/logs-demo/_count" | jq .
```

2. Refresh index:

```bash id="8yl0qm"
curl -s -X POST "http://localhost:9200/logs-demo/_refresh" | jq .
```

3. Verify field names match mapping:

* `source.ip`, `severity`, `@timestamp`

4. Confirm wildcard query matches values exactly:

* `192.168.0.*` only matches that subnet

---

## 7) Time range filter returns fewer results than expected

### ✅ Symptoms

* You expect more `severity:error` logs, but last-24h filter returns fewer

### ✅ Explanation

Time filter excludes older events (e.g., previous day), which is correct behavior.

### ✅ Fix / Verify

Query without time filter to compare:

```bash id="ckq7h2"
curl -s "http://localhost:9200/logs-demo/_search" \
-H 'Content-Type: application/json' \
-d '{
  "query": { "term": { "severity": "error" } },
  "sort": [{ "@timestamp": "desc" }]
}' | jq '.hits.total'
```

---

## 8) Wildcard queries are slow or fail in large datasets

### ✅ Symptoms

* slow searches in production-like datasets

### ✅ Guidance

Wildcard queries can be expensive at scale. Prefer:

* CIDR queries for IP fields (when possible)
* structured filters and exact matches
* well-designed mappings and ingest pipelines

(For this small lab dataset, wildcard is fine.)

---

## 9) Saved Objects API request fails (401/403/400)

### ✅ Symptoms

* `/_find` returns auth errors or rejected request

### ✅ Fix Checklist

1. Ensure Kibana is reachable:

```bash id="7k8er7"
curl -s http://localhost:5601/api/status | head -n 5
```

2. Ensure you send the required header:

* `kbn-xsrf: true`

3. If security is enabled (auth required), include credentials/token
   (example only; depends on your setup):

```bash
curl -u elastic:YOURPASS -H 'kbn-xsrf: true' ...
```

---

## ✅ Quick Validation Checklist (After Fixes)

Run:

```bash id="2d2pma"
curl -s http://localhost:9200 | head
curl -s http://localhost:5601/api/status | head -n 5
curl -s "http://localhost:9200/logs-demo/_count" | jq .
curl -s -X POST "http://localhost:9200/logs-demo/_refresh" | jq .

# Field-based query
curl -s "http://localhost:9200/logs-demo/_search" -H 'Content-Type: application/json' -d '{
  "query": { "wildcard": { "source.ip": "192.168.0.*" } }
}' | jq '.hits.total'

# Time+severity query
curl -s "http://localhost:9200/logs-demo/_search" -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "filter": [
        { "term": { "severity": "error" } },
        { "range": { "@timestamp": { "gte": "now-24h", "lte": "now" } } }
      ]
    }
  }
}' | jq '.hits.total'

# Saved search proof
curl -s -X GET "http://localhost:5601/api/saved_objects/_find?type=search&search_fields=title&search=Error_Logs_Last_24_Hours" \
-H 'kbn-xsrf: true' | jq '.total'
```

If these checks succeed, your searching/filtering workflow and saved query verification are working correctly.

---
