# 💬 Interview Q&A — Lab 05: Installing Your Chosen SIEM

---

## 1) What is the ELK stack and why is it used for SIEM?
ELK is:
- Elasticsearch (storage/search)
- Logstash (ingestion/processing)
- Kibana (visualization)
It is used for SIEM because it can ingest large log volumes, index them for fast search, and visualize security events.

---

## 2) Why does Elasticsearch require Java?
Elasticsearch runs on the JVM and bundles JVM tools. Java is a prerequisite for launching the Elasticsearch process and supporting runtime features.

---

## 3) Why did OpenJDK 11 installation fail on Ubuntu 24.04?
Ubuntu 24.04 may not ship OpenJDK 11 in default repositories. Installing OpenJDK 17 is a realistic compatibility fix in modern environments.

---

## 4) What is the role of Elasticsearch in a SIEM setup?
Elasticsearch stores logs and events and supports fast search queries during investigations, threat hunting, and dashboard analysis.

---

## 5) What does Kibana provide in SIEM operations?
Kibana provides dashboards, visualizations, and search interfaces for analysts to:
- investigate alerts
- create detection visualizations
- generate reports

---

## 6) What is Logstash used for?
Logstash ingests logs, parses them (grok, json, etc.), enriches/normalizes fields, and forwards events into Elasticsearch.

---

## 7) Why was `network.host: localhost` set for Elasticsearch in this lab?
Binding to localhost limits exposure and is safer for lab verification. It prevents external systems from connecting unless explicitly configured.

---

## 8) Why was security disabled (`xpack.security.enabled: false`) in this lab?
Elasticsearch 8.x enables security by default, which can block simple unauthenticated curl checks. Disabling security allows a basic “service-up” verification workflow in a lab.

---

## 9) How did you verify Elasticsearch was working?
Using:
- `systemctl status elasticsearch`
- `curl localhost:9200/`
A valid JSON response confirms the HTTP endpoint is functioning.

---

## 10) What does a 302 response from Kibana mean?
A `302 Found` redirect to `/login` indicates Kibana is up and serving HTTP properly, and the UI is protected behind authentication flows.

---

## 11) Why check ports with `ss -lntp`?
It confirms services are listening and helps validate configuration:
- Elasticsearch `:9200`
- Kibana `:5601`

---

## 12) What is one next step after installation?
Configure Logstash pipelines or Beats agents (Filebeat/Winlogbeat) to start ingesting real syslogs, auth logs, and application logs.

---

## 13) What are the minimum resources mentioned and why?
Minimum 4GB RAM and 20GB disk. SIEM components consume memory (JVM + indexing) and disk (index storage and retention).

---
