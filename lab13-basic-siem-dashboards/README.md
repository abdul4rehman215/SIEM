# 🧪 Lab 13: Basic SIEM Dashboards

## 🧾 Lab Summary
This lab demonstrates how to build a **basic SIEM dashboard** using the **ELK Stack (Elasticsearch, Logstash, Kibana)**. The workflow included:
- Verifying Elasticsearch, Logstash, and Kibana services are running
- Feeding a test authentication log entry into `/var/log/auth.log`
- Configuring Logstash to ingest auth logs, parse them with Grok, and index them into Elasticsearch
- Confirming Elasticsearch index creation (`siem-auth-*`)
- Creating and customizing a Kibana dashboard with foundational visualizations:
  - Log count over time (line chart)
  - Top 5 source IPs (data table)
  - Top event categories (data table)
- Arranging and saving a dashboard named **"Basic SIEM Overview"**, and generating a share link

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand the basic components and design of SIEM dashboards
- Create and customize basic visualizations in Kibana
- Ingest sample logs and validate indexed data for dashboard use
- Interpret dashboard panels for practical monitoring (volume trends, noisy sources, top categories)

---

## ✅ Prerequisites
- Basic understanding of network security concepts
- Familiarity with Linux command-line interface
- ELK Stack installed and configured (Elasticsearch, Logstash, Kibana)

---

## 🧪 Lab Environment
- **OS:** Ubuntu (lab node)
- **Prompt style:** `toor@ip-172-31-10-168:~$`
- **Elasticsearch:** running as systemd service
- **Logstash:** running as systemd service
- **Kibana:** running as systemd service (listening on `0.0.0.0:5601`)
- **Ingestion source:** `/var/log/auth.log`
- **Index created:** `siem-auth-2026.02.28`

---

## 🛠️ Tasks Overview (What I Did)

### ✅ Task 1 — Prepare the SIEM Environment
#### 1) Verify ELK services
- Checked status of:
  - `elasticsearch`
  - `logstash`
  - `kibana`

#### 2) Feed test logs into Logstash
- Appended a sample syslog/auth entry into `/var/log/auth.log`
- Updated Logstash pipeline config at:
  - `/etc/logstash/conf.d/logstash.conf`
- Pipeline behavior:
  - **input**: file `/var/log/auth.log`
  - **filter**: grok syslog parsing into fields
  - **output**: Elasticsearch index `siem-auth-%{+YYYY.MM.dd}` + rubydebug stdout
- Validated config syntax and restarted Logstash
- Confirmed Elasticsearch index created

---

### ✅ Task 2 — Access and Setup Kibana Dashboard
- Accessed Kibana at `http://localhost:5601`
- Logged in successfully (credentials not recorded)
- Navigated to Dashboard section
- Created a new dashboard and added new visualizations

---

### ✅ Task 3 — Build Basic Visualizations
#### 1) Log Count Over Time
- Visualization: Line chart
- X-axis: `@timestamp` (Date Histogram)
- Interval: Hourly
- Y-axis: Count
- Saved as: **"Log Count Over Time"**

#### 2) Top 5 Source IPs
- Visualization: Data Table
- Bucket: Terms
- Field: `source.ip`
- Size: 5
- Saved as: **"Top 5 Source IPs"**
- Example values observed:
  - 203.0.113.55 (12)
  - 192.168.1.1 (8)
  - 10.0.2.23 (6)
  - 198.51.100.22 (4)
  - 10.0.2.10 (3)

#### 3) Top Event Categories
- Visualization: Data Table
- Bucket: Terms
- Field: `event.category`
- Size: 5
- Saved as: **"Top Event Categories"**
- Example values observed:
  - authentication (15)
  - network (11)
  - process (9)
  - file (6)
  - system (4)

---

### ✅ Task 4 — Finalize Dashboard
- Added all visualizations to dashboard
- Arranged layout:
  - Line chart at top (wide)
  - Two tables below side-by-side
- Saved dashboard as: **"Basic SIEM Overview"**
- Used Kibana Share to generate a shareable URL (internal authenticated access)

---

## ✅ Verification & Validation
- ELK services running:
  - `sudo systemctl status elasticsearch`
  - `sudo systemctl status logstash`
  - `sudo systemctl status kibana`
- Log injection confirmed:
  - appended line echoed via `tee -a`
- Logstash config validated:
  - `logstash -t` → Configuration OK
- Index created and visible:
  - `curl http://localhost:9200/_cat/indices?v`

---

## 📁 Repository Structure
```text
lab13-basic-siem-dashboards/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── configs/
    ├── logstash.conf
    ├── dashboard_build_notes.md
    └── sample_auth_log_entry.txt
````

---

## 🌍 Why This Matters

Dashboards provide fast operational visibility:

* spotting spikes in log volume
* identifying top talkers/noisy or suspicious sources
* understanding dominant event categories
* enabling faster triage and investigation workflows

A basic dashboard is a foundation that can be expanded with alert panels, anomaly charts, geo maps, and threat hunting saved searches.

---

## 🧩 Real-World Applications

* SOC daily monitoring overview boards
* authentication monitoring (failed logons, brute force trends)
* network visibility (top IPs, firewall events)
* executive reporting (high-level summaries)
* tuning detection strategy based on observed data categories

---

## ✅ Result

* ELK verified running
* Test auth log ingested successfully via Logstash
* Index `siem-auth-2026.02.28` created in Elasticsearch
* Kibana dashboard built with 3 key visualizations
* Dashboard saved as **Basic SIEM Overview** and shared internally

---

## 🏁 Conclusion

This lab successfully demonstrated how to build a foundational SIEM dashboard in Kibana by validating ELK health, ingesting sample logs, verifying indices, and creating visualizations that support basic security monitoring. These skills directly translate to SOC dashboards and operational monitoring in real environments.

✔️ Lab completed successfully (ELK verified + test log ingestion + dashboard built in Kibana)

---
