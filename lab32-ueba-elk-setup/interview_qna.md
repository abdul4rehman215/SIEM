# 🧠 Interview Q&A — Lab 32: Setting Up User and Entity Behavior Analytics (UEBA) with ELK

---

## 1) What is UEBA?
UEBA (User and Entity Behavior Analytics) is a security approach that detects threats by identifying deviations from normal behavior patterns for users and systems (entities).

---

## 2) What kinds of threats can UEBA help detect?
UEBA can help detect:
- compromised accounts
- insider threats
- unusual privilege escalation behavior
- brute-force patterns and repeated failed logins
- abnormal process execution patterns
- suspicious access times or unusual device usage

---

## 3) Why use Elasticsearch and Kibana for UEBA-style monitoring?
Elasticsearch provides centralized indexing and fast searching across events. Kibana provides visualization and investigative workflows (Discover, dashboards, ML features), making behavior timelines easier to analyze.

---

## 4) What telemetry sources did you ingest in this lab?
- **Filebeat (system module):** auth/system logs (login, sudo, ssh activity)
- **Auditbeat:** host and audit telemetry (process, activity events)

---

## 5) Why did you verify Java even though Elasticsearch 7.x often bundles a JDK?
The lab explicitly required Java verification. Also, validating dependencies is a good practice in real deployments because environment differences can cause runtime issues.

---

## 6) What does it mean to “ingest data” into Elasticsearch?
Ingestion means collecting logs/events from the host and sending them into Elasticsearch indices so they can be searched, visualized, and correlated in Kibana.

---

## 7) Why did you configure `output.elasticsearch.hosts: ["localhost:9200"]` in beats?
This directs Filebeat/Auditbeat to send data directly to the local Elasticsearch instance running on the same host.

---

## 8) Why was the Filebeat system module enabled?
Without modules, Filebeat may not ship meaningful user/auth logs by default. The system module provides structured parsing for system/auth logs, which are important for UEBA-style login analysis.

---

## 9) What is the purpose of `filebeat setup -e`?
It loads important assets into Elasticsearch and Kibana:
- index templates / mappings
- ILM settings (where applicable)
- dashboards and saved objects  
This makes analysis and visualization easier immediately after ingestion.

---

## 10) What is Auditbeat used for in UEBA?
Auditbeat provides host telemetry that supports behavior analysis, such as:
- process executions
- user activity context
- audit-related signals  
This helps correlate “who did what” beyond just login logs.

---

## 11) How did you verify that ingestion was working?
By listing indices in Elasticsearch:
```bash
curl -s "http://localhost:9200/_cat/indices?v"
````

This confirmed `filebeat-*` and `auditbeat-*` indices existed and contained documents.

---

## 12) What are Kibana Data Views (Index Patterns) and why are they necessary?

Data Views tell Kibana which indices to search and how to interpret fields/time. Without them, you cannot easily use Discover or dashboards.

---

## 13) What is the purpose of Kibana Discover in a UEBA workflow?

Discover is used to:

* explore raw events
* filter by user, host, event types
* build timelines
* validate suspicious behavior patterns before creating alerts or dashboards

---

## 14) What are examples of UEBA-style filters you used?

Examples included:

* Searching repeated authentication failures:

  * `event.module:system AND (message:*Failed* OR message:*authentication failure*)`
* Broad behavior exploration:

  * `event.action:* AND user.name:* AND host.name:*`

---

## 15) What is one key takeaway from this lab?

UEBA is built on good telemetry. By installing ELK and shipping user/system events through Filebeat and Auditbeat, you create a foundation to detect behavior anomalies and investigate suspicious activity through centralized timelines.

---
