# 🛠️ Troubleshooting Guide — Lab 40: Final SIEM Health Check & Next Steps

> This guide covers common issues when validating SIEM health across Elasticsearch, Prometheus, and Kibana, plus common pitfalls when creating an improvement roadmap.

---

## 1) Elasticsearch API not responding (`curl localhost:9200` fails)

### ❗ Problem
Commands like:
```bash
curl -s http://localhost:9200
````

fail or return connection errors.

### ✅ Possible Causes

* Elasticsearch service is down
* bound to a different interface/port
* firewall/network restrictions

### ✅ Resolution

Check service:

```bash
systemctl status elasticsearch --no-pager
sudo journalctl -u elasticsearch --no-pager | tail -n 80
```

Check listening ports:

```bash
sudo ss -lntp | grep 9200
```

Restart if needed (lab-safe):

```bash id="vbdnq7"
sudo systemctl restart elasticsearch
```

---

## 2) `_cat/indices` shows red/yellow health

### ❗ Problem

Index health is not green.

### ✅ What it Usually Means

* **yellow:** replicas not assigned (common on single-node clusters)
* **red:** missing shards or corrupted/unavailable indices (urgent)

### ✅ Resolution

Check cluster health:

```bash id="catr89"
curl -s "http://localhost:9200/_cluster/health?pretty"
```

For single-node labs:

* yellow is acceptable if replicas cannot be assigned

For red:

* review elasticsearch logs and disk space

```bash id="zqkq6o"
df -h
sudo journalctl -u elasticsearch --no-pager | tail -n 120
```

---

## 3) Doc count queries fail (`_count` endpoint errors)

### ❗ Problem

Index name mismatch or index does not exist.

### ✅ Resolution

List indices first:

```bash id="dzavqv"
curl -s "http://localhost:9200/_cat/indices?v"
```

Then run `_count` against the exact index name.

### ✅ Prevention

Avoid hardcoding index names; copy from `_cat/indices`.

---

## 4) Prometheus rules API fails or `jq` not installed

### ❗ Problem

`curl .../api/v1/rules | jq ...` fails.

### ✅ Resolution

Install jq:

```bash id="wqq7p7"
sudo apt-get update
sudo apt-get install -y jq
```

Verify Prometheus is running:

```bash id="v9et8j"
systemctl status prometheus --no-pager
sudo ss -lntp | grep 9090
```

---

## 5) Prometheus shows no alerts but you expected some

### ❗ Problem

No active alerts in `/api/v1/alerts`.

### ✅ Possible Causes

* system truly stable
* rule thresholds too high
* `for:` duration not met
* node exporter not scraped

### ✅ Resolution

Check rule health in `/api/v1/rules`, verify underlying metric exists, and review thresholds/durations.

---

## 6) Kibana not reachable (`curl localhost:5601` fails)

### ❗ Problem

Kibana doesn’t respond.

### ✅ Possible Causes

* Kibana service stopped
* Elasticsearch unreachable
* Kibana bound to localhost only
* plugin/memory issues

### ✅ Resolution

Check service:

```bash id="e1s9qs"
systemctl status kibana --no-pager
sudo journalctl -u kibana --no-pager | tail -n 120
```

Check port:

```bash id="lg4u6v"
sudo ss -lntp | grep 5601
```

Restart (lab-safe):

```bash id="s5nnd9"
sudo systemctl restart kibana
```

---

## 7) Dashboards exist but don’t show data

### ❗ Problem

Dashboard panels are empty.

### ✅ Common Causes

* wrong time range in Kibana
* wrong data view/index pattern selected
* ingestion stopped (beats down)
* field mappings mismatch (parsing issues)

### ✅ Resolution

* widen time range (Last 24h / 7d)
* confirm indices exist and doc counts > 0
* confirm beats are running:

```bash id="g8a5o8"
systemctl status filebeat --no-pager
systemctl status auditbeat --no-pager
```

---

## 8) Index creation / shard change confusion

### ❗ Problem

Attempting to change shard count on an existing index.

### ✅ Important Note

You generally **cannot change `number_of_shards` after index creation**.
The lab’s PUT example is a “format snippet” for roadmap planning.

### ✅ Real fix in production

Use:

* index templates
* ILM rollover
* reindex into a new index with desired shards

---

## 9) Roadmap is too generic (not measurable)

### ❗ Problem

Roadmap steps don’t lead to trackable progress.

### ✅ Fix

Make actions measurable:

* Add 2 new log sources by date
* Implement ILM with retention X days
* Reduce false positives by Y% after tuning cycle
* Add alerts for rejected writes/disk/JVM heap
* Track ingestion rate and indexing latency baselines

---

## 10) Threat intelligence integration causes noise

### ❗ Problem

TI feeds create too many matches (false positives).

### ✅ Mitigation

* score IoCs with confidence tiers
* use allowlists for known good services
* validate enrichment fields (ip/domain/hash)
* start with high-confidence feeds only
* tune correlation rules based on observed FP rates

---
