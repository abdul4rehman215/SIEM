# 🧪 Lab 21: Searching & Filtering Data

## 🧾 Lab Summary
This lab focuses on efficient **searching and filtering of logs** in an Elasticsearch + Kibana environment using:

- **Field-based queries** (example: filter by `source.ip`)
- **Time range + severity filtering** (example: last 24 hours + `severity:error`)
- **Saved queries** (to reuse common searches quickly during investigations)

✅ Realistic lab setup note:
Kibana searches require data already indexed in Elasticsearch. To ensure the lab is fully testable and produces real output, I created a small demo index (`logs-demo`) with a simple mapping and inserted sample log documents containing:
- `@timestamp`
- `severity`
- `source.ip`
- `message`

This makes both Kibana and CLI (Elasticsearch API) queries return predictable results.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Use **field-based queries** to narrow large datasets efficiently
- Filter logs by **time range** and **severity**
- Save frequently used searches in Kibana for fast reuse
- Validate Kibana-style queries using Elasticsearch API (CLI verification)

---

## 📌 Prerequisites
- Basic understanding of logs and common fields (timestamp, severity, message)
- Familiarity with command-line interfaces
- Access to an environment with:
  - Elasticsearch
  - Kibana
  - `jq` (for JSON formatting in terminal)

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Environment | Cloud Lab Environment |
| User | `toor` |
| Elasticsearch | `http://localhost:9200` |
| Kibana | `http://localhost:5601` |
| Demo Index | `logs-demo` |
| Tools | `curl`, `jq` |

---

## 🗂️ Repository Structure
```text
lab21-searching-and-filtering-data/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── configs/
│   ├── logs-demo-mapping.json
│   ├── logs-demo-bulk.ndjson
│   └── kibana-saved-query-notes.md
└── artifacts/
    ├── elasticsearch-head.txt
    ├── kibana-status.json
    ├── search-ip-wildcard-results.json
    ├── search-last24h-error-results.json
    └── saved-query-find-results.json
````

> Notes:
>
> * `configs/` contains reusable JSON/NDJSON payloads used to build the demo dataset.
> * `artifacts/` stores key evidence outputs proving searches, filters, and saved query creation.

---

## 🧩 Tasks Overview (What I Performed)

### ✅ Pre-Lab: Verify Elasticsearch & Kibana are reachable

* Confirmed Elasticsearch is responding on port 9200
* Confirmed Kibana is available on port 5601 (`overall.level: available`)

---

### ✅ Task 0: Sample Data Setup (to make queries return real results)

#### 0.1 Create index with mapping

Created index: `logs-demo` with mapping:

* `@timestamp` as `date`
* `severity` as `keyword`
* `source.ip` as `ip`
* `message` as `text`

#### 0.2 Insert sample documents (bulk)

Inserted 5 events with varying:

* IPs (192.168.0.*, 192.168.1.50, 10.0.2.15)
* severities (info, warning, error)
* timestamps (mix of today + yesterday)

#### 0.3 Refresh index

Refreshed index so data becomes searchable immediately.

---

### ✅ Task 1: Field-Based Queries (search by `source.ip`)

Goal: return all events where source IP starts with `192.168.0.*`

* Kibana KQL query used:

  * `source.ip:192.168.0.*`
* Observed results in Kibana Discover:

  * **3 hits** (192.168.0.10, 192.168.0.55, 192.168.0.99)

✅ CLI verification (Elasticsearch wildcard query on `source.ip`) confirmed:

* total hits: 3
* documents match expected IP range

---

### ✅ Task 2: Filter Logs by Time Range + Severity

Goal: show errors in the last 24 hours

* Kibana settings:

  * time filter: **Last 24 hours**
  * KQL query: `severity:error`

Observed results:

* **2 hits** in last 24 hours with severity error:

  * 192.168.0.55 (Failed SSH login attempt)
  * 192.168.0.99 (Application exception)

✅ CLI verification used:

* `term` filter on `severity: error`
* `range` filter on `@timestamp` (`now-24h` to `now`)
* results sorted by timestamp desc

---

### ✅ Task 3: Save a Frequently Used Query

Goal: save common investigation query for fast reuse

Saved Kibana query/search:

* Name: `Error_Logs_Last_24_Hours`
* Query: `severity:error`
* Time range: Last 24 hours

✅ CLI proof (Kibana Saved Objects API):

* used `_find` endpoint to locate the saved search by title
* confirmed `total: 1` and retrieved saved object metadata

---

## 🔍 Verification & Validation

This lab is successful when:

* ✅ Elasticsearch responds: `curl http://localhost:9200`
* ✅ Kibana status is available: `curl http://localhost:5601/api/status`
* ✅ Index `logs-demo` exists and contains documents
* ✅ Field-based query returns 3 hits for `192.168.0.*`
* ✅ Time+severity filter returns 2 hits for last 24h `error`
* ✅ Saved query exists in Kibana saved objects list

---

## 🧠 What I Learned

* Field-based filtering (IP, severity, user, host) is essential for fast investigation triage.
* Combining a **time window** with severity dramatically reduces noise.
* Saved queries accelerate incident response by making common filters reusable instantly.
* Validating Kibana searches via Elasticsearch API is useful for:

  * terminal-only environments
  * automation
  * reproducible evidence in reports

---

## 🌍 Why This Matters (Real-World Relevance)

In SOC and SIEM workflows, analysts constantly need to:

* pivot by IP/user/host
* narrow to a time window around an incident
* prioritize high-severity events
* reuse proven searches during recurring incidents

These skills reduce analysis time and improve response quality.

---

## ✅ Result

* ✅ Elasticsearch + Kibana verified reachable
* ✅ Demo index created with realistic mapping
* ✅ Logs inserted and searchable
* ✅ Field-based search tested (`source.ip:192.168.0.*`) → 3 results
* ✅ Time + severity filter validated (last 24h + `severity:error`) → 2 results
* ✅ Saved query created and confirmed via Kibana API (`Error_Logs_Last_24_Hours`)

---

## 🏁 Conclusion

This lab successfully demonstrated core SIEM search workflows: field-based searches, severity/time filtering, and saved queries. By building a small test dataset in Elasticsearch, I ensured all searches produced verifiable results, and I validated both Kibana UI behavior and equivalent API queries—skills directly applicable to real incident response and threat hunting.

---
