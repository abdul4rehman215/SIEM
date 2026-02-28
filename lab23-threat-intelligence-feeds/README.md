# 🧪 Lab 23: Threat Intelligence Feeds

## 🧾 Lab Summary
This lab demonstrates how **threat intelligence feeds** (malicious IPs, domains, URLs, hashes) can be integrated into a SIEM pipeline to enhance detection and correlation.

✅ Realistic execution note:
The lab’s example feed URL (`http://example.com/malicious-ips-feed`) is a placeholder. To keep this lab fully **real and testable** without API keys or rate limits, I:

- Created a **local threat feed** (`malicious-ips-feed.json`)
- Served it over HTTP using Python (`python3 -m http.server`)
- Ingested the feed using **Logstash `http_poller`** into Elasticsearch index `threat-feed`
- Split the feed array into **one event per malicious IP** for easy correlation
- Simulated inbound traffic logs in another index `inbound-logs`
- Correlated inbound logs with threat feed IPs using a **terms query** (core SIEM enrichment workflow)

Result: ✅ Feed ingestion works and correlation identifies inbound events from known malicious IPs.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Explain what threat intelligence feeds are and how they help
- Build a working feed ingestion pipeline in ELK
- Convert a “list-style feed” into normalized events for correlation
- Store threat intel into Elasticsearch for hunting/detection
- Correlate inbound logs against the threat intel dataset
- Validate results through Elasticsearch searches and Kibana Discover workflows

---

## 📌 Prerequisites
- Basic cybersecurity concepts
- Familiarity with SIEM workflows
- ELK Stack running (Elasticsearch, Logstash, Kibana)
- Internet access (used here only for normal operations; threat feed itself is served locally)
- Tools: `curl`, `jq`, Python 3

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Environment | Cloud Lab Environment |
| User | `toor` |
| Elastic Stack | Elasticsearch + Logstash + Kibana (8.13.4) |
| Threat feed index | `threat-feed` |
| Inbound logs index | `inbound-logs` |
| Local feed server | Python HTTP server on `:8000` |

---

## 🗂️ Repository Structure
```text
lab23-threat-intelligence-feeds/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── configs/
│   ├── malicious-ips-feed.json
│   ├── logstash-threat-feed.conf
│   └── inbound-logs-mapping.json
└── artifacts/
    ├── elk-service-status.txt
    ├── feed-curl-head.txt
    ├── logstash-ingest-stdout.txt
    ├── threat-feed-index-check.txt
    ├── threat-feed-search.json
    ├── inbound-logs-create.json
    ├── inbound-logs-bulk-result.json
    ├── malicious-ip-list.txt
    └── correlation-results.json
````

> Notes:
>
> * `configs/` contains the local feed JSON and the Logstash pipeline used.
> * `artifacts/` captures evidence outputs proving ingestion and correlation.

---

## 🧩 Tasks Overview (What I Performed)

### ✅ Task 1: Understand Threat Intelligence Feeds

Threat intel feeds provide updated indicators such as:

* malicious IPs
* malicious domains/URLs
* malware hashes
* C2 infrastructure indicators

Benefits:

* early detection and faster response
* proactive defense
* added context to SIEM alerts and investigations

---

### ✅ Task 2: Select a Threat Feed Type

The lab suggests sources like AlienVault OTX or VirusTotal.

✅ For this lab:

* Feed type chosen: **Malicious IP list**
* Implemented as a local feed to avoid external API requirements

---

### ✅ Task 3: Integrate Threat Feed into SIEM (ELK)

#### 3.1 Confirm ELK services are running

Validated:

* elasticsearch
* logstash
* kibana

#### 3.2 Create and serve a local threat feed

Created `malicious-ips-feed.json` with:

* `feed_name`
* `generated_at`
* `malicious_ips` array

Served it via:

* `python3 -m http.server 8000`

Verified access:

* `curl http://localhost:8000/malicious-ips-feed.json`

#### 3.3 Configure Logstash ingestion (http_poller)

Created Logstash pipeline:

* input: `http_poller` fetches feed JSON
* filter:

  * `split` the array into individual events
  * rename into `ip` field for normalized IOC format
* output:

  * Elasticsearch index: `threat-feed`
  * stdout debug for proof

Ran Logstash once to confirm ingest and stopped after first successful fetch.

#### 3.4 Verify threat-feed index in Elasticsearch

Confirmed:

* index exists
* 4 documents indexed
* each doc contains one malicious IP

---

### ✅ Task 4: Correlate Threat Feed with Inbound Logs

#### 4.1 Create inbound logs index

Created `inbound-logs` with mapping including:

* `@timestamp`
* `source.ip`
* `destination.ip`
* `event_type`
* `message`

#### 4.2 Insert inbound events (some malicious, some benign)

Inserted 4 inbound events:

* 2 benign
* 2 matching threat-feed malicious IPs:

  * `45.133.1.10` (SSH failed auth)
  * `185.220.101.4` (web scan attempt)

#### 4.3 Correlation query (SIEM-style)

Process:

1. Extract malicious IP list from `threat-feed`
2. Search `inbound-logs` for `source.ip` in that list (`terms` query)

✅ Result:

* 2 inbound events matched threat intel indicators

---

### ✅ Task 5: Validation + Visualization (Kibana workflow)

In Kibana:

* Created data views:

  * `threat-feed*`
  * `inbound-logs*`
* Used Discover to:

  * view threat feed entries
  * search inbound logs for matching source IPs
* Optional dashboard ideas:

  * top `source.ip` values
  * data table with `source.ip`, `event_type`, `message`
  * time range last 15 minutes for near-real-time view

---

## 🔍 Verification & Validation

This lab is successful when:

* ✅ ELK services are running
* ✅ feed is reachable via HTTP on localhost:8000
* ✅ Logstash fetches and outputs events (stdout rubydebug)
* ✅ Elasticsearch index `threat-feed` exists with 4 docs
* ✅ `inbound-logs` index exists and contains simulated events
* ✅ Correlation search returns 2 matched inbound events

---

## 🧠 What I Learned

* Threat intel is most useful when normalized into searchable fields (like `ip`)
* A list-based feed should be split into per-indicator documents for SIEM correlation
* Logstash `http_poller` is a simple method to ingest external feeds on schedules
* Correlation between IOC sets and event logs is core SIEM detection logic
* Even without external APIs, you can build a realistic feed ingestion + correlation lab

---

## 🌍 Why This Matters (Real-World Relevance)

SOC teams use threat feeds to:

* enrich alerts
* block malicious IPs/domains
* identify C2 traffic
* prioritize investigations

This lab mirrors real pipelines:
Threat feed → ingestion → IOC index → correlation against events → detection/hunting.

---

## ✅ Result

* ✅ Local threat intel feed created and served
* ✅ Feed ingested via Logstash into Elasticsearch (`threat-feed`)
* ✅ Inbound logs simulated (`inbound-logs`)
* ✅ Correlation detected 2 matches between inbound traffic and malicious IPs
* ✅ Ready for GitHub upload with reproducible configs and evidence

---

## 🏁 Conclusion

This lab successfully implemented a practical threat intelligence feed integration workflow using the Elastic Stack. By ingesting a malicious IP feed into Elasticsearch and correlating inbound logs against those indicators, I demonstrated how SIEM platforms can turn external threat intelligence into actionable detections for proactive cyber defense.

---
