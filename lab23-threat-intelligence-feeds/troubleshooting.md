# 🛠️ Troubleshooting Guide — Lab 23: Threat Intelligence Feeds

> This guide covers common issues when serving a local feed, ingesting it via Logstash `http_poller`, indexing it into Elasticsearch, and correlating against inbound logs.

---

## 1) ELK services not running

### ✅ Symptoms
- `service elasticsearch status` shows inactive
- Logstash/Kibana not reachable

### ✅ Fix
Start and enable services:
```bash
sudo systemctl enable --now elasticsearch
sudo systemctl enable --now logstash
sudo systemctl enable --now kibana

sudo systemctl status elasticsearch --no-pager | head
sudo systemctl status logstash --no-pager | head
sudo systemctl status kibana --no-pager | head
````

---

## 2) Python feed server not reachable (`curl localhost:8000` fails)

### ✅ Symptoms

* `curl http://localhost:8000/malicious-ips-feed.json` times out or connection refused

### ✅ Fix Checklist

1. Ensure server is running in the correct directory:

```bash
cd ~/lab23-threat-feed
python3 -m http.server 8000
```

2. Confirm port is listening:

```bash id="v38ylv"
sudo ss -lntp | grep 8000
```

3. If port is in use, choose another port:

```bash id="qxtkyr"
python3 -m http.server 8080
curl -s http://localhost:8080/malicious-ips-feed.json | head
```

4. Confirm file name matches URL:

* `malicious-ips-feed.json` must exist in the served directory:

```bash id="t0x8d4"
ls -l
```

---

## 3) Logstash `http_poller` does not fetch the feed

### ✅ Symptoms

* No events printed in stdout
* Logstash logs show connection errors

### ✅ Fix Checklist

1. Validate feed URL works:

```bash
curl -s http://localhost:8000/malicious-ips-feed.json | head
```

2. Confirm Logstash config points to correct URL:

* `http://localhost:8000/malicious-ips-feed.json`

3. Run Logstash with `--log.level debug` (optional for deeper visibility):

```bash id="wzbr7x"
sudo /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/logstash.conf --log.level debug
```

4. Check Logstash service logs:

```bash id="dl1m5h"
sudo journalctl -u logstash --no-pager -n 200
```

---

## 4) Logstash config syntax errors

### ✅ Symptoms

* Logstash exits immediately
* Error message mentions pipeline config parse failure

### ✅ Fix

Validate configuration file path and syntax:

* check brackets `{}` and quotes
* ensure `input {}`, `filter {}`, `output {}` sections exist

Common mistakes:

* missing closing brace
* wrong indentation doesn’t matter, but missing braces does

---

## 5) No `threat-feed` index created in Elasticsearch

### ✅ Symptoms

* `/_cat/indices?v | grep threat-feed` returns nothing

### ✅ Fix Checklist

1. Confirm Elasticsearch reachable:

```bash id="cp7rxq"
curl -s http://localhost:9200 | head
```

2. Confirm Logstash output host format:

* preferred:

  * `hosts => ["http://localhost:9200"]`

3. Check Logstash stdout output:

* if stdout shows events but index is missing, output config likely failing

4. Search for any indices created recently:

```bash id="un0ofv"
curl -s "http://localhost:9200/_cat/indices?v" | head -n 30
```

---

## 6) Feed ingested but documents are not “one per IP”

### ✅ Symptoms

* One document contains an array `malicious_ips` instead of single `ip`

### ✅ Fix

Ensure Logstash filter contains `split` and rename logic:

```conf
filter {
  split { field => "[malicious_ips]" }
  mutate {
    rename => { "[malicious_ips]" => "ip" }
    add_field => { "feed" => "%{[feed_name]}" }
  }
}
```

---

## 7) Inbound correlation returns 0 matches (but expected matches)

### ✅ Symptoms

* terms query on `source.ip` returns `total: 0`

### ✅ Fix Checklist

1. Confirm inbound docs exist:

```bash id="gr1u95"
curl -s "http://localhost:9200/inbound-logs/_count" | jq .
```

2. Confirm threat docs exist:

```bash id="aztqym"
curl -s "http://localhost:9200/threat-feed/_count" | jq .
```

3. Validate field names:

* inbound logs use `source.ip`
* threat docs store `ip`

4. Confirm IP types:

* Mapping should use `ip` type, not `text`
* If wrong mapping, recreate index (lab-only):

```bash id="6qj8w2"
curl -s -X DELETE "http://localhost:9200/inbound-logs" | jq .
curl -s -X PUT "http://localhost:9200/inbound-logs" -H 'Content-Type: application/json' -d @configs/inbound-logs-mapping.json
```

5. Confirm `terms` query includes correct values:

```bash id="v0pq4t"
curl -s "http://localhost:9200/inbound-logs/_search?pretty" -H 'Content-Type: application/json' -d '{
  "query": { "match_all": {} }
}'
```

---

## 8) Bulk insert fails (`errors: true`)

### ✅ Symptoms

* `_bulk` returns `"errors": true`

### ✅ Fix

Bulk payload must be NDJSON and each line must be valid JSON separated by newlines.

* Ensure content-type is correct:

  * `application/x-ndjson`

Inspect bulk response `items` for details.

---

## ✅ Quick Validation Checklist (After Fixes)

Run:

```bash id="2e1xm0"
# Feed reachable
curl -s http://localhost:8000/malicious-ips-feed.json | head

# Elasticsearch reachable
curl -s http://localhost:9200 | head

# Threat-feed index exists + has docs
curl -s "http://localhost:9200/_cat/indices?v" | grep threat-feed || true
curl -s "http://localhost:9200/threat-feed/_count" | jq .

# Inbound index exists + has docs
curl -s "http://localhost:9200/inbound-logs/_count" | jq .

# Correlation query
curl -s "http://localhost:9200/inbound-logs/_search?pretty" -H 'Content-Type: application/json' -d '{
  "query": {
    "terms": {
      "source.ip": ["45.133.1.10","103.87.212.77","185.220.101.4","91.92.109.43"]
    }
  }
}'
```

Expected:

* Feed returns JSON
* `threat-feed` count = 4
* `inbound-logs` count = 4
* correlation hits total = 2

```
