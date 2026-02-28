# 🧠 Lab 32: Setting Up User and Entity Behavior Analytics (UEBA)

## 🧾 Lab Summary
This lab set up a basic **UEBA-style analytics workflow** using the **Elastic Stack (Elasticsearch + Kibana)** and lightweight shippers (**Filebeat + Auditbeat**) to ingest authentication and host activity data. After deploying the stack on Ubuntu, I configured beats to send logs into Elasticsearch, verified ingestion, and used Kibana Discover/Data Views to explore behavioral timelines and identify potentially unusual activity patterns.

---

## 🎯 Objectives
- Understand and configure UEBA concepts to detect anomalies
- Identify unusual user account activities using open-source tools
- Interpret UEBA outputs to improve security measures

---

## ✅ Prerequisites
- Basic network security concepts
- Understanding of user/account activity and security configurations
- Linux server with internet connectivity
- Basic Git + command-line familiarity

---

## 🧰 Tools Used
- **Elasticsearch (ELK stack component)** — log indexing + search
- **Kibana** — visualization + discovery UI
- **Filebeat** — forwards system/log files (auth/system module useful for login behavior)
- **Auditbeat** — forwards host + audit events (process and activity telemetry)

---

## 🧠 Key Concepts
- **UEBA:** Detects deviations from normal user/entity behavior (insider threat + compromised accounts)
- **Anomaly Detection:** Finding outliers (spikes in failed logins, abnormal sudo usage, rare process execution)
- **Telemetry ingestion:** Shipping logs to a centralized indexer for correlation and analysis
- **Data Views (Index Patterns):** Kibana configuration required to explore indices (`filebeat-*`, `auditbeat-*`)

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Hostname | ip-REDACTED |
| User | toor |
| Elasticsearch | 7.15.2 (deb) |
| Kibana | 7.15.2 (deb) |
| Filebeat | 7.15.2 (deb) |
| Auditbeat | 7.15.2 (deb) |
| Elasticsearch Port | 9200 (localhost) |
| Kibana Port | 5601 (localhost) |

> 📌 Note: Versions were based on the lab instructions (7.15.2). In production, you would typically use a currently supported version and follow vendor guidance for security updates.

---

## 🗂️ Repository Structure
```text
lab32-ueba-elk-setup/
├── README.md
├── commands.sh
├── output.txt
├── configs/
│   ├── filebeat.yml.snippet
│   └── auditbeat.yml.snippet
├── interview_qna.md
└── troubleshooting.md
````

---

## ✅ Tasks Overview (No Commands Here)

### ✅ Task 1: Set Up Elastic Stack for UEBA

#### 1.1 Install Elasticsearch

* Verified Java availability (per lab prerequisite)
* Downloaded and installed Elasticsearch 7.15.2 (deb)
* Started and enabled the service
* Verified:

  * service status
  * port 9200 listening
  * API response from `http://localhost:9200`

#### 1.2 Install Kibana

* Downloaded and installed Kibana 7.15.2 (deb)
* Started and enabled the service
* Verified:

  * service status
  * port 5601 listening
  * HTTP response redirect to `/app/home`

---

### ✅ Task 2: Enable UEBA Features (Data Ingestion)

#### 2.1 Install Filebeat and Auditbeat

* Downloaded and installed Filebeat + Auditbeat (deb packages)

#### 2.2 Configure Filebeat for Data Ingestion

* Updated Filebeat output to send data directly to Elasticsearch:

  * `hosts: ["localhost:9200"]`
* Enabled the **system module** (practical step to ship login/auth events)
* Loaded templates and dashboards (`filebeat setup -e`)
* Started and enabled Filebeat, verified service running

#### ✅ (Practical Extension) Configure Auditbeat Output

* Updated Auditbeat output to send data to Elasticsearch:

  * `hosts: ["localhost:9200"]`
* Loaded templates and dashboards (`auditbeat setup -e`)
* Started and enabled Auditbeat, verified service running

#### ✅ Ingestion Validation

* Confirmed `filebeat-*` and `auditbeat-*` indices exist in Elasticsearch

---

### ✅ Task 3: Review a Sample User Behavior Timeline in Kibana

#### 3.1 Kibana Visualizations (Discover)

* Accessed Kibana UI: `http://localhost:5601`
* Created Data Views:

  * `filebeat-*`
  * `auditbeat-*`
* Used Discover to explore:

  * login/logout activity
  * ssh failures
  * sudo/privilege usage
  * host activity telemetry

#### 3.2 Identify Unusual Activity

* Explored Kibana Machine Learning section and anomaly detection job options
* Used simple UEBA-style filters in Discover for suspicious behavior patterns, such as:

  * repeated authentication failures
  * spikes in events tied to one user
  * unusual privileged command usage

---

## ✅ Results

✔ Elasticsearch installed, started, and verified via API
✔ Kibana installed, started, and verified on 5601
✔ Filebeat installed/configured + system module enabled
✔ Auditbeat installed/configured for host telemetry
✔ Indices created successfully (`filebeat-*`, `auditbeat-*`)
✔ Kibana Data Views created and logs explored in Discover
✔ UEBA-style investigative queries tested

---

## 🌍 Why This Matters

UEBA helps detect compromised accounts and insider threats by focusing on:

* **behavior changes**
* **frequency anomalies**
* **unusual privilege usage**
* **rare or abnormal process activity**

Centralizing telemetry in ELK and analyzing it in Kibana provides visibility that is difficult to achieve with isolated host logs.

---

## 🧩 Real-World Applications

* Detect brute-force attacks (failed login spikes)
* Detect suspicious sudo usage or privilege escalation patterns
* Identify new/rare processes executed by a user
* Build baselines for “normal” user behavior and alert on deviations
* Support SOC investigations via searchable timelines

---

## 🧠 What I Learned

* How to install and validate Elasticsearch/Kibana services
* How to ship auth and system logs with Filebeat system module
* How to ship host activity telemetry with Auditbeat
* How to verify ingestion using Elasticsearch indices
* How to explore logs in Kibana Discover for UEBA-style investigations

---

## ✅ Conclusion

This lab successfully set up a basic UEBA foundation using Elasticsearch, Kibana, Filebeat, and Auditbeat. With ingestion verified and Data Views created, Kibana can be used to investigate user behavior timelines and explore anomaly detection workflows to enhance security monitoring.

---
