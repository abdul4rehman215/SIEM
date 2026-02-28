# 🛠️ Troubleshooting Guide — Lab 38: Reviewing System Health & Performance

> This guide covers common issues when installing Prometheus, querying host metrics, checking SIEM ingestion/indexing performance, and diagnosing bottlenecks from logs.

---

## 1) Prometheus service not starting

### ❗ Problem
`systemctl status prometheus` shows failed or restarting.

### ✅ Common Causes
- Config file syntax errors
- Permission issues on `/etc/prometheus/prometheus.yml`
- Port conflicts on 9090
- Missing/incorrect file paths

### ✅ Resolution
Check status and logs:
```bash
systemctl status prometheus --no-pager
sudo journalctl -u prometheus --no-pager | tail -n 80
````

Validate config (if `promtool` exists):

```bash id="ky4ij6"
promtool check config /etc/prometheus/prometheus.yml
```

Restart after fixing:

```bash id="cdv6g9"
sudo systemctl restart prometheus
```

---

## 2) `permission denied` reading `prometheus.yml`

### ❗ Problem

Syslog/journal shows:

* `Error loading config ... permission denied`

### ✅ Cause

Prometheus service runs as `prometheus`, but config is too restrictive.

### ✅ Resolution (Lab fix)

```bash
ls -l /etc/prometheus/prometheus.yml
sudo chown root:prometheus /etc/prometheus/prometheus.yml
sudo chmod 640 /etc/prometheus/prometheus.yml
sudo systemctl restart prometheus
```

### ✅ Prevention

Ensure config files are readable by the service user/group after edits.

---

## 3) Prometheus UI not reachable

### ❗ Problem

`curl -I http://localhost:9090` fails.

### ✅ Possible Causes

* Prometheus not running
* Bound only to localhost (remote browser won’t work)
* Firewall rules block access
* Port conflict

### ✅ Resolution

Check listening port:

```bash id="s4jox2"
sudo ss -lntp | grep 9090
```

If you need remote access, adjust bind address carefully (lab only).

---

## 4) Node Exporter not producing metrics

### ❗ Problem

Prometheus queries return empty results for `node_cpu_seconds_total` or memory metrics.

### ✅ Possible Causes

* Node Exporter not running
* Prometheus not scraping Node Exporter target
* Target mismatch (wrong hostname/port)

### ✅ Resolution

Check Node Exporter status:

```bash
systemctl status prometheus-node-exporter --no-pager
sudo ss -lntp | grep 9100
```

Verify Node Exporter endpoint responds:

```bash id="cx5jbl"
curl -s http://localhost:9100/metrics | head
```

---

## 5) Prometheus query returns no results

### ❗ Problem

The API returns `result: []`.

### ✅ Possible Causes

* Not enough data yet (fresh install)
* Wrong metric name
* Scrape not configured or failing

### ✅ Resolution

Check scrape targets in Prometheus UI (`/targets`) or via API:

```bash id="3v0wxy"
curl -s http://localhost:9090/api/v1/targets | head -n 60
```

Wait a few minutes after start, then re-run query.

---

## 6) `rate(log_entries_total[1m])` doesn’t work

### ❗ Problem

Metric does not exist by default.

### ✅ Cause

Prometheus only knows what exporters/instrumentation expose. `log_entries_total` requires:

* a custom exporter
* or application instrumentation
* or a log pipeline that publishes counters

### ✅ Resolution

Use a practical alternative:

* Elasticsearch `_stats/indexing`
* `_cat/thread_pool/write`
* doc count deltas over time

---

## 7) Elasticsearch indexing seems slow or delayed

### ❗ Problem

Log ingestion feels delayed; dashboards show stale data.

### ✅ Bottleneck Signals

* write thread pool queue grows
* `rejected` write ops increase
* throttling enabled
* high indexing time
* disk I/O saturation

### ✅ Checks (used in lab)

```bash id="zb6yc5"
curl -s "http://localhost:9200/_stats/indexing?pretty" | head -n 80
curl -s "http://localhost:9200/_cat/thread_pool/write?v"
curl -s "http://localhost:9200/_cat/indices?v" | head -n 30
```

---

## 8) Syslog is missing or `/var/log/syslog` does not exist

### ❗ Problem

Some systems use only `journalctl` instead of syslog.

### ✅ Resolution

Use journald:

```bash id="88ldf9"
sudo journalctl -p err -n 80 --no-pager
sudo journalctl -u prometheus -n 80 --no-pager
```

---

## 9) High CPU or memory usage observed

### ✅ Possible Causes

* heavy ingestion spike
* too many shards / inefficient mappings
* insufficient RAM → swapping
* query load from dashboards

### ✅ Mitigations (production guidance)

* add CPU/RAM, increase disk IOPS
* tune Elasticsearch heap and JVM settings
* review shard strategy / ILM policies
* reduce high-cardinality metrics and noisy logs
* implement alerting thresholds and capacity planning

---

## 10) Best practice: add alerting early

### ✅ Why

Catches failures before the SOC notices missing events.

### ✅ Practical alerts

* Prometheus down / target down
* Node exporter down
* CPU > 80% sustained
* Memory > 80% sustained
* Disk > 85%
* Elasticsearch write rejections > 0
* Elasticsearch cluster health not green

---
