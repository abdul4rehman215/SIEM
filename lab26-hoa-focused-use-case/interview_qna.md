# 🎤 Interview Q&A — Lab 26: Creating an HOA-Focused Use Case (ELK + Docker)

## 1) What does “HOA-focused use case” mean in a SIEM context?
It means building monitoring and alerting rules around events relevant to a Homeowners Association—typically physical security systems like gate access, visitor entries, badge logs, camera events, and maintenance access.

---

## 2) Why would after-hours gate access be considered suspicious?
Most communities have predictable access patterns. Gate activity between **00:00–05:00** can indicate:
- unauthorized entry or tailgating
- stolen credentials or badge misuse
- insider abuse
- suspicious visitor access or reconnaissance

---

## 3) What was the event source used in this lab?
A simulated HOA gate access log file:
- `gate_logs.log`
Each log line contained:
- timestamp, event type, gate, user, direction (Entry/Exit)

---

## 4) Why did you use Docker for ELK deployment?
Docker makes it fast and repeatable to stand up ELK without manually installing packages. It’s ideal for lab testing, demos, and proof-of-concept use cases.

---

## 5) What components make up ELK and what role does each play?
- **Elasticsearch:** stores and indexes events for fast search
- **Logstash:** ingests/parses/transforms logs and forwards to Elasticsearch
- **Kibana:** query, visualize, dashboard, and create alerts

---

## 6) What problem occurred with `docker-compose` and how did you fix it?
The legacy `docker-compose` binary was not installed. Modern Docker uses the Compose plugin:
- `docker compose up -d`

Same outcome, different command.

---

## 7) How did you parse the gate log fields in Logstash?
I used:
- `grok` filter to extract structured fields:
  - `log_time`, `event_type`, `gate`, `user`, `direction`
- `date` filter to convert `log_time` into `@timestamp`

---

## 8) Why was the lab’s original time comparison logic incorrect?
The lab compared `@timestamp` to string times like `"00:00:00"`.  
But `@timestamp` is a full datetime, so comparing it to time-only strings is not valid.

---

## 9) How did you correctly implement the after-hours detection logic?
After setting `@timestamp`, I used a Ruby filter to:
- extract the hour (`t.time.hour`)
- set `hour` field
- add tag `unusual_activity` when `hour >= 0 && hour < 5`

---

## 10) What is the purpose of tagging events like `unusual_activity`?
Tags simplify:
- hunting (Kibana search: `tags:"unusual_activity"`)
- dashboards (panels can filter on tag)
- alert rules (trigger when tag appears)
This is a clean “detection engineering” pattern.

---

## 11) How did you ensure Logstash could access the pipeline config and log file?
I mounted files into the Logstash container via Docker Compose volumes:
- pipeline config → `/usr/share/logstash/pipeline/logstash.conf`
- log file → `/data/gate_logs.log`

Without mounts, Logstash would have nothing to ingest.

---

## 12) How did you validate ingestion worked?
- Used `docker logs logstash` to view parsed events and tags
- Queried Elasticsearch:
  - `hoa-gate-*` index
  - `term` query on `tags: unusual_activity`

---

## 13) How would you build an alert in Kibana for this use case?
Create a rule that:
- searches index: `hoa-gate-*`
- query: `tags:"unusual_activity"`
- condition: count >= 1 within last 5 minutes
- action: dashboard indicator, email, webhook, etc. (email requires SMTP config)

---

## 14) What are ways to reduce false positives for this HOA use case?
- whitelist maintenance windows (e.g., scheduled work)
- whitelist known staff user IDs
- require multiple signals (e.g., unusual hour + unknown user + repeated attempts)
- add geo/IP context if logs include network info
- baseline per-gate activity patterns

---

## 15) What’s the main learning outcome from this lab?
I practiced designing a real-world SIEM use case:
- choose an event source
- parse and structure logs
- implement a detection rule (after-hours access)
- validate through testing
- make it alertable and searchable in Kibana
