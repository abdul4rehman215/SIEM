# 🧪 Lab 05: Installing Your Chosen SIEM

## 🧾 Lab Summary
This lab demonstrates the installation and baseline configuration of an **open-source SIEM** using the **Elastic Stack (ELK)**. The focus is on getting the core services installed, configured, started, and verified:

- **Elasticsearch (8.8.0)** — storage + search engine for log data  
- **Kibana (8.8.0)** — visualization and web UI for searching and dashboards  
- **Logstash (8.8.0)** — log processing pipeline to ingest and forward events to Elasticsearch  

A realistic lab adjustment was applied: **OpenJDK 11** was not available on Ubuntu 24.04 default repositories, so **OpenJDK 17** was installed instead (compatible for this setup).

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand basic installation procedures for an open-source SIEM system
- Configure core parameters (cluster name, network binding, Kibana endpoint)
- Start and enable SIEM services
- Verify that Elasticsearch and Kibana are responding correctly
- Validate listening ports for SIEM services

---

## ✅ Prerequisites
- Basic understanding of network security concepts
- Machine resources: minimum 4GB RAM and 20GB disk space
- Internet access for downloads and dependencies
- Familiarity with Linux (Ubuntu Server preferred)
- Terminal access with superuser privileges

---

## 🧰 Tools Required
- **Elastic Stack (ELK)**

---

## 🧪 Lab Environment
- **Platform:** Cloud Lab (Ubuntu/Debian environment, EC2-style)
- **OS:** Ubuntu 24.04.1 LTS
- **User:** `toor`
- **Prompt style:** `toor@ip-172-31-10-164:~$` (IP tail may vary)
- **Elastic Components Installed:** 8.8.0 (downloaded as `.deb` packages)
- **Java Runtime:** OpenJDK 17 (installed due to package availability)

---

## 🛠️ Tasks Overview (What I Did)

### ✅ 1) Preparation and Setup
- Updated and upgraded system packages
- Installed Java dependency:
  - Attempted OpenJDK 11 (not available)
  - Installed OpenJDK 17 and verified with `java -version`

### ✅ 2) Install Elasticsearch (8.8.0)
- Downloaded `elasticsearch-8.8.0-amd64.deb`
- Installed via `dpkg -i`
- Edited `/etc/elasticsearch/elasticsearch.yml`:
  - set cluster name
  - bind to localhost
  - disabled security for simple `curl` verification in lab context
- Started + enabled Elasticsearch service
- Verified service status

### ✅ 3) Install Kibana (8.8.0)
- Downloaded `kibana-8.8.0-amd64.deb`
- Installed via `dpkg -i`
- Updated `/etc/kibana/kibana.yml` to point Kibana to Elasticsearch
- Started + enabled Kibana
- Verified service status and HTTP response

### ✅ 4) Install Logstash (8.8.0)
- Downloaded `logstash-8.8.0-amd64.deb`
- Installed via `dpkg -i`
- (Baseline install completed; pipeline configs added in later labs)

### ✅ 5) Verification
- Verified Elasticsearch response via:
  - `curl -X GET "localhost:9200/"`
- Verified listening ports:
  - Elasticsearch `9200`, Kibana `5601`
- Verified Kibana HTTP response:
  - `curl -I http://localhost:5601`

---

## ✅ Verification & Validation
- Java installed and verified:
  - `java -version`
- Elasticsearch running:
  - `systemctl status elasticsearch`
  - `curl localhost:9200`
- Kibana running:
  - `systemctl status kibana`
  - `curl -I http://localhost:5601`
- Ports confirmed:
  - `ss -lntp | grep -E '(:9200|:5601)'`

---

## 📁 Repository Structure
```text
lab05-installing-your-chosen-siem/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── evidence/
    └── ELK_8_8_0/
        ├── vm_notes.md
        └── config_snippets/
            ├── elasticsearch.yml.snippet
            └── kibana.yml.snippet
````

> 📌 Note: Evidence includes documented config snippets used during setup (not full system files), and lab notes for repeatability.

---

## 🌍 Why This Matters

Installing a SIEM is not just “install software”—it requires:

* correct dependencies (Java)
* correct service configuration (network bindings)
* validation (HTTP endpoints + service status)
* baseline understanding of how log data will flow later

This lab establishes the core foundation needed for log ingestion, dashboards, correlation, and alerting in future labs.

---

## 🧩 Real-World Applications

* Building a SOC lab SIEM stack for learning and simulation
* Collecting syslogs, authentication logs, and application logs centrally
* Investigating incidents using indexed logs and dashboards
* Detecting anomalies such as brute-force attempts or unusual access patterns
* Supporting compliance reporting and audit trails

---

## ✅ Result

* System updated and dependencies installed successfully
* OpenJDK 17 installed and verified (OpenJDK 11 unavailable in default repos)
* Elasticsearch 8.8.0 installed, configured, started, and verified via `curl`
* Kibana 8.8.0 installed, configured, started, and verified via HTTP response
* Logstash 8.8.0 installed successfully
* Services and ports validated (`9200`, `5601`)

---

## 🏁 Conclusion

This lab delivered a working baseline SIEM stack using Elastic Stack (ELK) on Ubuntu 24.04. The platform is now ready to ingest logs through Logstash, and dashboards can be built in Kibana for security monitoring use cases.

✅ Lab completed successfully on a cloud Ubuntu environment
✅ Elasticsearch + Kibana + Logstash (8.8.0) installed, configured, and verified

---
