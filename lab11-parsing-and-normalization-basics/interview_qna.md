# 💬 Interview Q&A — Lab 11: Parsing & Normalization Basics

---

## 1) What is parsing in SIEM/log workflows?
Parsing is converting raw log data into structured fields (e.g., extracting timestamp, IPs, usernames) so the data becomes searchable and usable for detections.

---

## 2) What is normalization?
Normalization ensures consistent field names and formats across data sources (e.g., always using `source_ip`, always using ISO8601 timestamps), enabling correlation and clean dashboards.

---

## 3) Why are timestamps a critical field?
Timestamps support:
- timeline reconstruction
- correlation windows
- alert thresholds
- sequence analysis during investigations

---

## 4) What is the benefit of JSON logs compared to plain text logs?
JSON logs are structured, making parsing easier because fields already exist. Plain text logs often require regex/grok extraction.

---

## 5) What is an Elasticsearch ingest pipeline?
An ingest pipeline is a server-side processing chain that transforms documents before indexing. It can parse dates, rename fields, drop fields, run scripts, etc.

---

## 6) What did your pipeline do in this lab?
- Parsed `timestamp` using ISO8601
- Renamed `ip_addr` → `source_ip`
- Allowed safe operation using `ignore_failure` and `ignore_missing`

---

## 7) Why use `ignore_failure: true` for date parsing?
So bad timestamps don’t break ingestion. Instead, the original value is kept, allowing troubleshooting without dropping the entire event.

---

## 8) Why doesn’t the pipeline reject invalid IP formats automatically?
Rename processors do not validate data. IP validation would require:
- strict mappings
- script processors
- validation logic in ingest pipelines or downstream controls

---

## 9) What is the purpose of the `_simulate` API?
It tests pipeline behavior safely without indexing data, which is ideal for developing and validating parsing rules.

---

## 10) What happened when you queried `logs-test` before creating it?
Elasticsearch returned `index_not_found_exception` because the index didn’t exist yet.

---

## 11) Why create a test index and ingest a sample event?
It demonstrates real indexing behavior and supports follow-up validation queries like aggregations for deduplication or quality checks.

---

## 12) How did you check event ID uniqueness?
By using a `terms` aggregation on `event_id.keyword`. If duplicates exist, the `doc_count` for an event_id would be greater than 1.

---

## 13) What’s a realistic next step after baseline normalization?
Expand the pipeline to:
- add geoip enrichment
- parse user agents
- normalize host fields
- enforce mapping types
- route different event types to different indices

---
