# 🧠 Interview Q&A — Lab 38: Reviewing System Health & Performance

---

## 1) Why is monitoring SIEM host health important?
Because SIEM systems are ingestion- and query-heavy. If CPU, memory, disk, or indexing performance degrades, log delays or missed detections can occur, creating blind spots during incidents.

---

## 2) What tool was used for host monitoring in this lab?
**Prometheus** was used for time-series monitoring, and **Prometheus Node Exporter** was used to expose host metrics (CPU/memory).

---

## 3) What ports were used by Prometheus and Node Exporter?
- Prometheus: **9090**
- Node Exporter: **9100**
Both were bound to `127.0.0.1` in the lab for local access.

---

## 4) What Prometheus query was used to measure CPU usage?
```promql
100 - (avg by(instance)(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
````

It calculates CPU usage by subtracting idle percentage from 100%.

---

## 5) What Prometheus query was used to measure memory usage percentage?

```promql
node_memory_Active_bytes / node_memory_MemTotal_bytes * 100
```

---

## 6) How did you query Prometheus without using the UI?

By using the Prometheus HTTP API:

* `http://localhost:9090/api/v1/query`
  This is useful in CLI-only environments.

---

## 7) What is an ingestion rate and why does it matter?

Ingestion rate is how fast logs/events are entering the SIEM pipeline. If ingestion exceeds processing capacity, data can queue, drop, or arrive late.

---

## 8) Why didn’t `rate(log_entries_total[1m])` work in Prometheus by default?

Because `log_entries_total` is not a default metric—this requires custom instrumentation or exporters that publish ingestion counters.

---

## 9) How did you review indexing performance in this lab?

By using Elasticsearch APIs directly:

* `_stats/indexing` for totals and time
* `_cat/thread_pool/write` for queue/rejections
* `_cat/indices` for doc count/storage baseline

---

## 10) What are the key signs of indexing bottlenecks in Elasticsearch?

* write queue growing
* write rejections increasing
* throttling enabled
* indexing time rising significantly
* high CPU/memory and disk I/O saturation

---

## 11) What did the thread pool write stats indicate in this lab?

It showed:

* `queue = 0`
* `rejected = 0`
  Meaning indexing was healthy with no backpressure.

---

## 12) Why check `/var/log/syslog` during performance reviews?

Syslog can reveal service failures, repeated errors, permission issues, resource exhaustion, and restart loops—common causes of performance and availability problems.

---

## 13) What error was found in syslog?

Prometheus failed to load its config due to:

* `permission denied` on `/etc/prometheus/prometheus.yml`

---

## 14) How was the Prometheus error resolved?

By ensuring the config was readable by the Prometheus service user:

* changed group ownership to `prometheus`
* set permissions to `640`
  Then restarted Prometheus.

---

## 15) What is the main takeaway from this lab?

Healthy SIEM performance depends on both host resources and pipeline health. Using monitoring tools plus log analysis helps detect bottlenecks early and resolve misconfigurations quickly (like permission errors).

---
