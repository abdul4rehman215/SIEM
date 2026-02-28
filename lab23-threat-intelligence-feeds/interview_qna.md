# 🎤 Interview Q&A — Lab 23: Threat Intelligence Feeds

## 1) What is a threat intelligence feed?
A threat intelligence feed is a stream/source of indicators and context about threats—such as malicious IPs, domains, URLs, file hashes, or C2 infrastructure—used to improve detection and response.

---

## 2) What benefits do threat feeds provide to a SIEM?
- **Early detection** of known bad infrastructure
- **Context enrichment** for alerts (why an event is suspicious)
- **Proactive defense** (blocklists, watchlists, prioritized triage)
- **Faster investigations** through correlation and hunting

---

## 3) What is an IOC?
IOC stands for Indicator of Compromise. It is an observable artifact that may indicate malicious activity, such as:
- IP address, domain, URL
- hash (MD5/SHA256)
- suspicious process name, registry key, file path

---

## 4) Why did you simulate a threat feed locally instead of using a public feed?
The lab’s URL was a placeholder, and many real feeds require:
- API keys
- authentication
- rate limits
To keep the lab fully testable and reproducible, I created a local JSON feed and served it via HTTP.

---

## 5) How did you ingest the threat feed into ELK?
I used Logstash with the `http_poller` input plugin to fetch the feed JSON from:
- `http://localhost:8000/malicious-ips-feed.json`
Then stored results in Elasticsearch index:
- `threat-feed`

---

## 6) Why did you use `split` in Logstash?
The feed contained an array of IPs. `split` converts that list into **one event per IP**, which is easier to:
- search
- correlate
- join with inbound logs
- build alerts around

---

## 7) What fields did you normalize into each threat indicator document?
Each event was normalized to include:
- `ip` (single IOC per document)
- `feed_name`
- `feed` (copied from feed_name)
- `generated_at`
- `@timestamp` (ingestion timestamp)

This structure supports consistent SIEM enrichment workflows.

---

## 8) How did you confirm the feed was ingested successfully?
I verified:
- Logstash stdout output (rubydebug) showed events being created
- Elasticsearch index exists: `/_cat/indices?v | grep threat-feed`
- Search results show 4 documents in `threat-feed`

---

## 9) What is correlation in SIEM terms?
Correlation is combining signals from different datasets to detect patterns, such as:
- inbound traffic **source.ip** matches known malicious IP feed
- repeated failures + later success login
- host alert + network alert from same asset

---

## 10) How did you perform correlation in this lab?
I:
1) ingested malicious IPs into `threat-feed`
2) inserted inbound logs into `inbound-logs`
3) queried inbound logs using a `terms` filter on `source.ip` with IOC list from the threat feed

This returned inbound events that match malicious indicators.

---

## 11) What correlation results did you observe?
Two inbound events matched threat intel:
- `45.133.1.10` → SSH failed password attempt
- `185.220.101.4` → suspicious web scan `/wp-login.php`

---

## 12) How would you turn this correlation into an alert in Kibana?
In Kibana Security / rules (or alerting), you could:
- create a threshold/EQL rule on `inbound-logs`
- match when `source.ip` is in the IOC dataset
- trigger action: email/slack/webhook

Or maintain the IOC list in a runtime lookup and alert on matches.

---

## 13) What are common issues with threat feeds in production?
- false positives (bad indicators that are not truly malicious)
- stale indicators (no longer active)
- duplicate indicators from multiple feeds
- inconsistent formats (normalization challenges)
- performance issues if matching huge IOC sets without optimization

---

## 14) How would you improve this pipeline for production reliability?
- schedule ingestion (keep Logstash running / pipeline service)
- add deduplication logic (avoid duplicates)
- add metadata (confidence score, source, tags, TTL)
- validate IP format + enrich with GeoIP/ASN
- implement retention/ILM for threat-feed index

---

## 15) Why is IOC normalization critical for detection engineering?
Normalization ensures indicators are stored in consistent fields so:
- correlation queries are simple and repeatable
- dashboards are reliable
- alerts don’t break due to format differences
It’s foundational for scalable detection engineering.
