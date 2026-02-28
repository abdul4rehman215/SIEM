# 🩺 Lab 38: Reviewing System Health & Performance

## 🧾 Lab Summary
This lab focused on monitoring and evaluating the health of a SIEM host by reviewing **CPU and memory utilization**, checking **ingestion/indexing performance**, and identifying **errors/bottlenecks** from system logs. I installed **Prometheus + Node Exporter**, verified services and ports, and queried CPU/memory metrics through the Prometheus HTTP API. For ingestion/indexing performance, I used Elasticsearch’s APIs to review indexing stats and write thread pool health (since Prometheus needs an Elasticsearch exporter for native ES metrics). Finally, I detected a Prometheus startup failure due to config permissions in `/var/log/syslog` and fixed it by correcting file permissions.

---

## 🎯 Objectives
- Examine CPU and memory usage of the SIEM host
- Review ingestion rates and indexing performance
- Identify and resolve bottlenecks or errors in system logs

---

## ✅ Prerequisites
- Familiarity with CPU/memory metrics and basic performance troubleshooting
- Ability to read system logs and interpret errors
- Access to monitoring tools (Prometheus used)
- Access to SIEM/log pipeline (Elasticsearch used for indexing stats)

---

## 🧠 Key Concepts
- **Prometheus:** Time-series monitoring + query engine
- **Node Exporter:** Exposes host-level metrics (CPU, memory, disk, etc.)
- **Indexing health signals (Elasticsearch):**
  - indexing totals / time
  - throttling status
  - write thread pool queue and rejections
- **Bottleneck detection:** repeated errors, service restart loops, growing queues, rejected writes

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Hostname | ip-REDACTED |
| User | toor |
| Prometheus | 2.51.1 |
| Node Exporter | 1.7.0 |
| Prometheus Port | 9090 (localhost) |
| Node Exporter Port | 9100 (localhost) |
| Elasticsearch | 7.15.2 (from prior labs) |

---

## 🗂️ Repository Structure
```text
lab38-system-health-performance/
├── README.md
├── commands.sh
├── output.txt
├── configs/
│   └── prometheus.yml.permissions.note
├── interview_qna.md
└── troubleshooting.md
````

---

## ✅ Tasks Overview (No Commands Here)

### ✅ Task 1: Examine CPU and Memory Usage

* Installed Prometheus + Node Exporter
* Verified services and listening ports (9090/9100)
* Queried metrics via Prometheus HTTP API:

  * CPU usage query (idle time → usage %)
  * Memory usage % query (active / total)

### ✅ Task 2: Review Ingestion Rates and Indexing Performance

* Noted that ingestion/indexing metrics depend on SIEM pipeline
* Used Elasticsearch APIs as a practical performance check:

  * `_cat/indices` for doc counts and storage
  * `_stats/indexing` for indexing totals and timing
  * `_cat/thread_pool/write` to detect queue build-up and rejections

### ✅ Task 3: Identify Bottlenecks or Errors in Logs

* Searched syslog for errors
* Found Prometheus startup failures due to:

  * `permission denied` opening `/etc/prometheus/prometheus.yml`
* Fixed by adjusting ownership/group + permissions so Prometheus service could read its config
* Restarted Prometheus and validated it became healthy

---

## ✅ Results

✔ Prometheus and Node Exporter installed and running
✔ CPU usage observed via Prometheus API (~7.84%)
✔ Memory usage observed via Prometheus API (~42.12%)
✔ Elasticsearch indexing stats reviewed (no throttling)
✔ Thread pool write queue checked (no rejections/queue buildup)
✔ Prometheus startup error detected in syslog and fixed via permissions update
✔ Prometheus restarted successfully after fix

---

## 🌍 Why This Matters

SIEM platforms are performance-sensitive:

* high ingestion and indexing load can cause delays and missed alerts
* CPU/memory pressure can lead to dropped events, slow queries, and unstable services
* log-based troubleshooting catches misconfigurations quickly (like permission failures)

Proactive monitoring prevents silent failures and reduces SOC blind spots.

---

## 🧩 Real-World Applications

* Monitoring SIEM host resources during traffic spikes
* Detecting indexing backpressure via write queue and rejections
* Rapid diagnosis of service failures via syslog/journalctl
* Capacity planning (RAM/CPU/disk IOPS)
* Alerting for:

  * high CPU/memory
  * disk usage thresholds
  * ingestion spikes
  * Elasticsearch write rejections

---

## 🧠 What I Learned

* How to deploy Prometheus + Node Exporter quickly for host monitoring
* How to query Prometheus metrics via HTTP API when UI access is limited
* How to assess Elasticsearch indexing health using built-in APIs
* How to identify and fix a real startup bottleneck from syslog (config permission issue)

---

## ✅ Conclusion

This lab validated a practical workflow for checking SIEM host health: monitor CPU/memory, review indexing performance, and confirm service reliability by analyzing logs and resolving bottlenecks. These steps help maintain stability and ensure timely ingestion and detection in real SOC environments.

--
