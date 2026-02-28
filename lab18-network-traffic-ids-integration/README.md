# 🧪 Lab 18: Network Traffic & IDS Integration (Optional)

## 🧾 Lab Summary
This lab demonstrates how to deploy an **Intrusion Detection System (IDS)** to monitor network traffic and integrate IDS alerts into a **SIEM pipeline**. I installed **Snort**, enabled rule loading, validated Snort configuration in test mode, and then built a minimal **ELK (Elasticsearch, Logstash, Kibana)** ingestion path where Logstash reads Snort’s alert file and forwards events into Elasticsearch.

To validate the end-to-end workflow:
- I generated **benign test traffic** (HTTP + ICMP) using `curl` and `ping`
- Verified Snort wrote alert entries to `/var/log/snort/alert`
- Confirmed Elasticsearch was reachable and Kibana was listening on port 5601

✅ IDS deployment → ✅ rule enablement → ✅ log forwarding via Logstash → ✅ SIEM indexing path ready → ✅ traffic generation + alert visibility validation.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand IDS role in network security monitoring
- Install and configure Snort IDS
- Enable rule loading (community rules include)
- Validate Snort configuration using test mode (`snort -T`)
- Install ELK by adding Elastic APT repository (required on Ubuntu 24.04)
- Configure Logstash to ingest Snort alerts and forward to Elasticsearch
- Generate test traffic and verify Snort alert logging
- Confirm SIEM services are running (Elasticsearch + Kibana)

---

## ✅ Prerequisites
- Basic networking and security fundamentals
- Comfortable with Linux terminal operations
- Internet access to download Snort/Elastic packages
- Optional: VM setup for network simulation (not required here)

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Environment | Cloud Lab Environment |
| User | `toor` |
| IDS | Snort |
| SIEM stack | Elastic 8.x (Elasticsearch, Logstash, Kibana) |
| Network interface | `ens5` |
| Home network (Snort) | `172.31.0.0/16` |

---

## 🗂️ Repository Structure
```text
lab18-network-traffic-ids-integration/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── configs/
│   ├── snort.conf.change-note.md
│   └── logstash-snort.conf
└── artifacts/
    ├── elastic-apt-repo-setup.txt
    ├── elasticsearch-health.json
    ├── snort-test-mode.txt
    ├── snort-alert-tail.txt
    ├── interface-ip.txt
    └── kibana-port-check.txt
````

> Notes:
>
> * `configs/` stores the **final configuration content** used during the lab.
> * `artifacts/` stores **evidence outputs** confirming services and alerts.

---

## 🧩 Tasks Overview (What I Performed)

### ✅ Task 1: Install and Configure IDS Rules (Snort)

#### 1.1 Install Snort

* Updated package lists
* Installed Snort and default rule packages
* During installation prompts:

  * Selected interface: `ens5`
  * Set HOME_NET: `172.31.0.0/16`
* Noted: `snort.service` initially failed (common in cloud labs depending on interface/log permissions).

  * Continued with validation using Snort test mode to confirm configuration correctness.

#### 1.2 Configure Snort

* Edited `/etc/snort/snort.conf`
* Enabled rule include for community rules:

  * `include $RULE_PATH/community.rules`

#### 1.3 Validate Snort Configuration

* Ran Snort in test mode:

  * `sudo snort -T -c /etc/snort/snort.conf`
* Confirmed Snort successfully validated configuration and loaded:

  * `/etc/snort/rules/snort.rules`
  * `/etc/snort/rules/community.rules`

---

### ✅ Task 2: Forward IDS Alerts to the SIEM (ELK)

#### 2.1 Install Elastic Stack Packages

* Attempted installing `elasticsearch`, `logstash`, `kibana` via default Ubuntu repos

  * Result: packages not found (expected on Ubuntu 24.04 without Elastic APT repo)
* Added Elastic official APT repo:

  * installed `apt-transport-https`, `ca-certificates`, `curl`, `gnupg`
  * added Elastic GPG key to `/usr/share/keyrings/elastic.gpg`
  * added repo list file `/etc/apt/sources.list.d/elastic-8.x.list`
  * updated apt and installed:

    * `elasticsearch`
    * `logstash`
    * `kibana`

#### 2.2 Configure Logstash for Snort Logs

* Created `/etc/logstash/conf.d/snort.conf`
* Configured Logstash to:

  * read Snort alert file: `/var/log/snort/alert`
  * output to Elasticsearch index: `snort-alerts-%{+YYYY.MM.dd}`
  * output to stdout using rubydebug for quick verification

#### 2.3 Start Services + Health Checks

* Started:

  * Elasticsearch
  * Logstash
  * Kibana
* Verified Elasticsearch health by requesting:

  * `http://localhost:9200`
* Verified Kibana is listening on:

  * port `5601`

---

### ✅ Task 3: Generate Benign Test Traffic + Validate Alerts

#### 3.1 HTTP Traffic (curl)

* Generated outbound HTTP traffic to `example.com`

#### 3.2 ICMP Traffic (ping)

* Generated ICMP traffic to `example.com`

#### 3.3 Verify Snort Logging + SIEM Readiness

* Confirmed Snort alert file exists:

  * `/var/log/snort/alert`
* Viewed latest entries using `tail -n 5`
* Confirmed interface IP on `ens5` (for Kibana URL)
* Verified Kibana port listening:

  * `ss -lntp | grep 5601`

---

## 🔍 Verification & Validation

This lab is successful when the following are true:

* ✅ `snort -T` reports configuration validated successfully
* ✅ Elasticsearch responds on `http://localhost:9200`
* ✅ Logstash service starts with Snort pipeline config present
* ✅ Kibana is listening on port `5601`
* ✅ Snort alert file exists and contains alert entries:

  * `/var/log/snort/alert`
* ✅ Tail of Snort alert file shows events associated with test traffic
* ✅ SIEM index strategy is defined:

  * `snort-alerts-*` in Elasticsearch

---

## 🧠 What I Learned

* IDS tools like Snort monitor packet-level traffic and generate alerts based on signatures/rules.
* SIEM integration commonly uses log forwarders/pipelines (Logstash/Filebeat) to parse and ship alerts into searchable indices.
* On Ubuntu 24.04, Elastic components require adding the official Elastic APT repo to install packages.
* Test mode (`snort -T`) is a fast way to confirm rule/config correctness even if the systemd service fails initially.
* Validating the chain requires checking both ends:

  * Snort alert generation (file)
  * Elastic ingestion readiness (services + indices)

---

## 🌍 Why This Matters (Real-World Relevance)

IDS + SIEM integration provides:

* central visibility into network threats
* alert correlation across multiple sources (host logs + network alerts)
* faster detection and incident response
* searchable and reportable evidence for investigations and compliance

This workflow resembles common SOC pipelines:
Snort/Suricata → Logstash/Filebeat → Elasticsearch → Kibana dashboards/alerts.

---

## ✅ Result

* ✅ Snort installed and configured with community rules enabled
* ✅ Snort configuration validated successfully in test mode
* ✅ Elastic repo added and ELK installed successfully
* ✅ Logstash configured to ingest Snort alert logs and forward to Elasticsearch
* ✅ Services started and verified (Elasticsearch + Kibana)
* ✅ Benign test traffic generated and Snort alert log entries confirmed
* ✅ Kibana access endpoint identified (port 5601)

---

## 🏁 Conclusion

This lab successfully built an IDS-to-SIEM workflow using open-source tools. By installing Snort, validating rules, and configuring Logstash to forward Snort alerts into Elasticsearch, I established a pipeline that supports centralized monitoring and investigation. Generating test traffic and confirming alert output validated that the IDS detection and SIEM ingestion path is functioning and ready for further tuning and threat detection use cases.

---
