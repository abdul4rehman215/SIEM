# 🎤 Interview Q&A — Lab 21: Searching & Filtering Data

## 1) Why are field-based queries important in log analysis?
They allow you to narrow results quickly by focusing on specific fields (IP, username, host, severity). This reduces noise and speeds up triage and investigations.

---

## 2) What is KQL and where is it used?
KQL (Kibana Query Language) is used in Kibana (Discover, dashboards, alerts) to filter and search indexed data in Elasticsearch in a user-friendly syntax.

---

## 3) What field-based query did you use in this lab?
I searched for logs where `source.ip` starts with `192.168.0.*` using:
- Kibana KQL: `source.ip:192.168.0.*`
- Equivalent Elasticsearch API query: wildcard on `source.ip`

---

## 4) Why did you create a sample index (`logs-demo`) for this lab?
Kibana searches require data already indexed in Elasticsearch. To ensure the lab produced real results, I created a small index with a mapping and inserted predictable sample documents.

---

## 5) What is an Elasticsearch index mapping and why does it matter?
A mapping defines field types (date, keyword, text, ip). Correct field types improve search accuracy and performance:
- `@timestamp` as date enables time filters
- `severity` as keyword enables exact filtering
- `source.ip` as ip enables IP-aware queries

---

## 6) How does filtering by time range help investigations?
Most incidents are time-bound. Filtering to “last 24 hours” or around an incident window helps isolate relevant logs and reduces the dataset size significantly.

---

## 7) How did you filter logs by severity and time range?
In Kibana:
- Time filter: Last 24 hours
- KQL: `severity:error`

In Elasticsearch API:
- `term` filter: severity = error
- `range` filter: @timestamp between now-24h and now

---

## 8) What is the difference between `term` queries and `match` queries?
- `term`: exact match (best for keyword fields like severity)
- `match`: full-text search (best for text fields like message)
Using the correct query type prevents unexpected results.

---

## 9) Why did the last-24h + error filter return 2 logs instead of 3?
One error log had an older timestamp (`2026-02-27...`) which fell outside the “last 24 hours” time window, so it was correctly excluded.

---

## 10) What does “saving a query” mean in Kibana?
It saves a common search (query + filters + sometimes time range) so you can reload it later instantly without retyping. This is useful during recurring investigations.

---

## 11) What saved query did you create in this lab?
I saved:
- Name: `Error_Logs_Last_24_Hours`
- Query: `severity:error`
- Time range: Last 24 hours

---

## 12) How did you prove the saved query exists without using the Kibana UI?
I used Kibana’s Saved Objects API from terminal:
- `_find?type=search&search=Error_Logs_Last_24_Hours`
This returned `total: 1` and the saved object metadata.

---

## 13) How does this lab relate to SOC workflows?
SOC analysts constantly pivot and filter by:
- IP ranges, users, hosts
- severity and time windows
- saved searches for common incident patterns
These techniques speed up triage and support repeatable investigations.

---

## 14) What are common pitfalls when searching logs in SIEM tools?
- wrong field types (keyword vs text vs ip)
- forgetting time range filters (missing data or too much data)
- using wildcard searches too broadly (performance hit)
- not saving reusable queries (wasting time during incidents)

---

## 15) How would you expand this lab to be more production-like?
- Add more fields: host.name, user.name, event.action, event.outcome
- Add additional indices and index patterns
- Build dashboards for error volume and top source IPs
- Create alert rules using saved queries
- Enforce ingest pipelines and enrichments (GeoIP, threat intel)
