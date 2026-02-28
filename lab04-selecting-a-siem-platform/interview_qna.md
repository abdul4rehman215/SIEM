# 💬 Interview Q&A — Lab 04: Selecting a SIEM Platform

---

## 1) What is the purpose of a SIEM platform?
A SIEM centralizes logs/events, correlates activity across sources, and generates alerts to help detect threats, support investigations, and improve monitoring and compliance.

---

## 2) What are the key components of Elastic Stack (ELK)?
- **Elasticsearch:** indexing and search engine for log/event data  
- **Logstash:** ingestion pipeline for parsing and transforming logs  
- **Kibana:** dashboards and visualization for searching and reporting

---

## 3) Why might a small organization choose an open-source SIEM?
Because it can provide strong capabilities with lower licensing cost. The tradeoff is typically higher operational effort (setup, tuning, upgrades).

---

## 4) What are important factors when selecting a SIEM?
- Cost (licenses + infrastructure)
- Complexity (skills needed to run it)
- Scalability (handling log growth)
- Support (community vs vendor support)

---

## 5) What is Wazuh and how does it relate to SIEM?
Wazuh is a security monitoring platform (HIDS/FIM/rules/alerts). It is often integrated with ELK/OpenSearch for search and dashboards, creating a SIEM-like workflow.

---

## 6) Why are Splunk and QRadar considered strong commercial SIEMs?
They provide enterprise features like:
- advanced analytics and correlation
- support and integrations
- vendor-backed deployment guidance  
But they require licensing and higher costs.

---

## 7) Why did you install OpenJDK 17 instead of OpenJDK 11?
On Ubuntu 24.04, OpenJDK 11 may not be available by default. Installing OpenJDK 17 is a realistic adjustment because Elastic Stack can run on newer supported Java versions.

---

## 8) Why is it important to validate Elasticsearch using `curl localhost:9200`?
It confirms:
- Elasticsearch is running
- the HTTP endpoint responds
- cluster/node configuration is active

---

## 9) What does `discovery.type: single-node` do?
It tells Elasticsearch to run as a single-node cluster, avoiding multi-node discovery requirements—ideal for labs.

---

## 10) What is the purpose of Logstash Beats input on port 5044?
It allows ingestion from Beats agents (e.g., Filebeat). Port 5044 is the common default for Beats → Logstash pipelines.

---

## 11) Why check ports with `ss -lntp`?
It verifies services are listening and helps troubleshoot connectivity. This lab confirmed:
- Elasticsearch :9200
- Kibana :5601
- Logstash :5044

---

## 12) What is Grok used for in Logstash?
Grok parses unstructured text logs into structured fields. Example: parsing Apache access logs using `%{COMBINEDAPACHELOG}`.

---

## 13) What is a realistic next step after the ELK baseline is running?
- Ingest real logs (syslog, auth.log, nginx)
- Deploy Beats agents
- Build dashboards in Kibana
- Define detection rules and alerts
- Tune pipelines for performance and field normalization

---
