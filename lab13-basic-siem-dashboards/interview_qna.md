# 💬 Interview Q&A — Lab 13: Basic SIEM Dashboards

---

## 1) What is the purpose of a SIEM dashboard?
A SIEM dashboard provides a summarized, visual view of security data so analysts can quickly monitor trends, detect spikes, and prioritize investigations.

---

## 2) What are the core components of the ELK-based SIEM used here?
- Elasticsearch: stores and indexes log data
- Logstash: ingests/parses/transforms logs
- Kibana: visualizes data and provides dashboards/search UI

---

## 3) Why verify Elasticsearch, Logstash, and Kibana before building dashboards?
Dashboards depend on data ingestion and indexing. If services are down, data won’t be available or visualizations won’t load correctly.

---

## 4) Why inject a test auth log entry into /var/log/auth.log?
It creates known test data to confirm ingestion and visualize a measurable event spike in dashboards.

---

## 5) What does the Logstash file input do in this lab?
It tails `/var/log/auth.log` and ships the content into the pipeline for parsing and indexing.

---

## 6) What does the Grok filter extract in the Logstash config?
It parses the syslog-style message into fields like:
- syslog_timestamp
- host_name
- program
- log_message

---

## 7) Why send output to a dedicated index like siem-auth-*?
It separates authentication-related logs for easier lifecycle management, searching, and dashboard targeting.

---

## 8) What is the purpose of “Log Count Over Time” visualization?
It shows event volume trends and helps detect spikes that may represent attacks, outages, or abnormal behavior.

---

## 9) Why is “Top 5 Source IPs” a useful panel?
It highlights the most frequent event sources. This helps identify noisy IPs, scanning activity, or suspicious repeating sources.

---

## 10) Why track “Top Event Categories”?
It summarizes the security themes present in the dataset (authentication, network, process, file, system), guiding where to focus monitoring and rule tuning.

---

## 11) What does it mean when Kibana is listening on 0.0.0.0:5601?
It means Kibana is bound to all interfaces, enabling access from remote hosts (depending on firewall/security group rules).

---

## 12) What is a realistic improvement after building a basic dashboard?
Add:
- alerts panels (high severity alerts)
- failed logon trend panel
- geo map for source IPs
- saved searches for investigations
- drilldowns to host details or timelines

---
