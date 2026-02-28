# 🧪 Lab 11: Parsing & Normalization Basics

## 🧾 Lab Summary
This lab introduces **parsing and normalization** fundamentals in SIEM/log workflows. The goal is to ensure raw logs become **structured, consistent fields** that are easy to search, correlate, and alert on.

Hands-on work was completed using **Elasticsearch ingest pipelines** (open-source friendly approach):
- Built an ingest pipeline (`logdata_pipeline`) to:
  - parse timestamps into a normalized ISO format
  - normalize field names by renaming `ip_addr` → `source_ip`
- Tested parsing behavior safely using `_simulate`
- Tested edge cases:
  - bad timestamp formats (pipeline should not fail due to `ignore_failure`)
  - invalid IP formats (not validated by default)
- Demonstrated an event-id uniqueness approach by:
  - creating an index
  - ingesting a test document through the pipeline
  - aggregating `event_id.keyword` to detect duplicates

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand the fundamentals of parsing and normalization
- Identify key fields inside log events (timestamp, source IP, event ID)
- Configure a parser/pipeline to ensure accuracy and consistency
- Verify parsing output through simulation and controlled ingestion
- Review how validation and integrity checks work (edge cases + dedup logic)

---

## ✅ Prerequisites
- Basic knowledge of data formats (JSON/CSV/XML)
- Familiarity with command-line operations
- Access to a SIEM tool or log parsing system supporting open-source configs (Elasticsearch ingest pipelines)

---

## 🧪 Lab Environment
- **OS:** Ubuntu 24.04 (SIEM node)
- **Prompt style:** `toor@ip-172-31-10-193:~$`
- **Elasticsearch:** 8.13.4 (reachable at `http://localhost:9200`)
- **Approach:** Ingest pipeline + simulate API + sample index ingestion

---

## 🛠️ Tasks Overview (What I Did)

### ✅ Task 1 — Review Sample Logs and Key Fields
- In SIEM UI (Discover/log details panel):
  - Identified key fields:
    - `timestamp` (event time, ISO8601)
    - `source_ip` (source device / actor)
    - `event_id` (unique identifier for correlation / deduplication)
    - `event_type` (activity category)

### ✅ Task 2 — Configure Parser / Pipeline
- Confirmed Elasticsearch reachable
- Created a pipeline JSON file (`pipeline.json`)
- Uploaded ingest pipeline to Elasticsearch:
  - `PUT /_ingest/pipeline/logdata_pipeline`
- Verified pipeline exists and matches configuration

### ✅ Task 3 — Verify Parsing Process
- Used `_simulate` API to test pipeline safely
- Confirmed:
  - `ip_addr` renamed to `source_ip`
  - `timestamp` normalized into ISO8601 with milliseconds
- Tested edge cases:
  - bad timestamp format kept intact due to `ignore_failure`
  - invalid IP not validated by default
- Demonstrated dedup logic approach:
  - attempted aggregation query (failed due to missing index)
  - created `logs-test` index
  - ingested sample log via pipeline
  - re-ran aggregation query successfully and confirmed doc_count tracking

---

## ✅ Verification & Validation
- Elasticsearch reachable:
  - `curl http://localhost:9200`
- Pipeline created:
  - `PUT /_ingest/pipeline/logdata_pipeline`
- Pipeline verified:
  - `GET /_ingest/pipeline/logdata_pipeline`
- Parsing tested:
  - `POST /_ingest/pipeline/logdata_pipeline/_simulate`
- Real ingestion tested:
  - `PUT /logs-test`
  - `POST /logs-test/_doc?pipeline=logdata_pipeline`
- Event ID aggregation validated:
  - `GET /logs-test/_search` with `terms` aggregation on `event_id.keyword`

---

## 📁 Repository Structure
```text
lab11-parsing-and-normalization-basics/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts_and_configs/
    ├── pipeline.json
    ├── simulate_payload_good.json
    ├── simulate_payload_bad_timestamp.json
    ├── simulate_payload_invalid_ip.json
    ├── agg_event_id_query.json
    └── ingest_sample_doc.json
````

---

## 🌍 Why This Matters

Parsing and normalization are essential because SIEM detections rely on consistent structured fields:

* correlation rules need predictable field names
* dashboards need searchable normalized timestamps
* incident investigations require clean timelines and reliable host/IP fields
* bad parsing leads to false negatives, missed alerts, and investigation delays

---

## 🧩 Real-World Applications

* Standardizing logs from multiple sources (routers, Windows, Linux, apps)
* Building pipelines that normalize timestamps and key identity fields
* Supporting correlation rules (e.g., same source_ip across systems)
* Integrity checks and dedup detection using query-based validation
* Creating reliable indexes for alerting and threat hunting

---

## ✅ Result

* Created and verified an Elasticsearch ingest pipeline for normalization
* Successfully tested parsing behavior via `_simulate`
* Demonstrated safe handling of parsing errors using `ignore_failure`
* Created a test index, ingested sample data through the pipeline, and validated event ID aggregation behavior

---

## 🏁 Conclusion

This lab established the foundation for SIEM parsing and normalization by building an ingest pipeline, validating behavior via simulation, and performing a controlled ingestion test. These skills are critical for ensuring log integrity, reliable querying, and meaningful alerting across diverse data sources.

✔️ Lab completed successfully (pipeline created + simulated + real ingestion test)

---
