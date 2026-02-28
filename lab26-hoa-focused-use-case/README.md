# 🧪 Lab 26: Creating an HOA-Focused Use Case

## 🧾 Lab Summary
This lab builds a **HOA (Homeowners Association) physical security use case** using the Elastic Stack (ELK) running in Docker. The goal is to simulate a realistic HOA event source (gate access logs), ingest it into ELK, tag unusual activity (events between **00:00–05:00**), and build an alert in Kibana based on that tag.

✅ Key outcomes:
- ELK stack deployed in Docker (Elasticsearch, Logstash, Kibana)
- Simulated HOA gate access log source (`gate_logs.log`)
- Logstash pipeline parses logs and applies a custom rule:
  - add tag: `unusual_activity` for events occurring after midnight and before 5 AM
- Verified ingestion and tagging via Logstash stdout and Elasticsearch queries
- Documented Kibana steps to create a rule/alert on `tags:"unusual_activity"`

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Integrate event sources relevant to HOA physical security monitoring
- Create a custom rule to detect unusual gate activity (after-hours access)
- Tag and store events for investigation and alerting
- Test responsiveness by appending new log events and verifying detection
- Validate results through Elasticsearch queries and Kibana Discover workflow

---

## 📌 Prerequisites
- Basic understanding of logs and rule-based alerting
- Linux terminal familiarity
- Docker installed and running
- Text editor (nano/vim/VS Code)

---

## 🧪 Tools & Technologies
| Tool | Purpose |
|---|---|
| Docker + Compose | Containerized deployment of ELK |
| Elasticsearch | Storage + search for security events |
| Logstash | Ingest + parse + apply detection logic |
| Kibana | Visualize logs + build alerts/rules |
| HOA Gate Logs (simulated) | Physical security event source |

---

## 🗂️ Repository Structure
```text
lab26-hoa-focused-use-case/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── configs/
│   ├── docker-compose.yml
│   ├── logstash-gate.conf
│   └── gate_logs.log
└── artifacts/
    ├── docker-compose-version.txt
    ├── docker-ps.txt
    ├── elasticsearch-health.txt
    ├── logstash-ingest-stdout.txt
    ├── gate-logs-tail.txt
    ├── refresh-response.json
    └── hoa-gate-search-results.json
````

> Notes:
>
> * `configs/` contains the compose file, Logstash pipeline, and the simulated gate logs.
> * `artifacts/` contains evidence outputs proving ingestion, tagging, and searches.

---

## 🧩 Tasks Overview (What I Performed)

## ✅ Task 1: Set Up ELK Stack (Docker)

### 1. Verify Docker

* Confirmed Docker is installed and running.

### 2. Deploy ELK using Docker Compose

Created a `docker-compose.yml` file based on lab text (Elastic 7.17.9):

* Elasticsearch on `9200`
* Logstash on `5044`
* Kibana on `5601`

**Realistic adjustment (Compose command):**

* `docker-compose` command was not available, so I used the modern plugin:

  * `docker compose up -d`

Validated:

* Containers are running via `docker ps`
* Elasticsearch responds on `http://localhost:9200`

---

## ✅ Task 2: Identify an HOA Event Source (Gate Access Logs)

Created a simulated HOA physical security log file:

* `gate_logs.log`

Example entries:

* Gate entry/exit logs including timestamp, gate, user, direction.

---

## ✅ Task 3: Craft Rule for Unusual After-Hours Activity

The lab wanted a rule like:

* tag activities between 00:00 and 05:00

**Reality check (implemented correctly):**

* `@timestamp` is a datetime, so comparing it to `"00:00:00"` strings won’t work.
* Instead:

  1. parse timestamp
  2. extract hour
  3. add `unusual_activity` tag if hour is between 0 and 4

Implemented in `logstash-gate.conf`:

* `grok` → parse fields
* `date` → set `@timestamp`
* `ruby` → compute hour and add tag

Output to Elasticsearch index:

* `hoa-gate-YYYY.MM.dd`

---

## ✅ Task 4: Set Up Alerts in Kibana

In Kibana:

* Created Data View: `hoa-gate-*`
* Verified tagged events in Discover:

  * KQL: `tags : "unusual_activity"`

Created a rule (alert) based on Elasticsearch query:

* Index: `hoa-gate-*`
* Query: `tags:"unusual_activity"`
* Condition: `count() >= 1` in last 5 minutes
* Action: dashboard/visual indicator (email requires SMTP config)

---

## ✅ Task 5: Test with Manual Log Entry + Validate Detection

Appended:

* `2023-09-16T01:30:00 Security Gate1 User789 Entry`

Because Logstash uses `sincedb_path => /dev/null`, restarting Logstash forces re-read for quick demo validation.

Validated:

* Logstash stdout shows the new event tagged `unusual_activity`
* Elasticsearch query returns 3 tagged events

---

## 🔍 Verification & Validation

This lab is successful when:

* ✅ Docker containers for Elasticsearch/Logstash/Kibana are running
* ✅ Elasticsearch responds on `localhost:9200`
* ✅ Logstash ingests `gate_logs.log`
* ✅ Events between 00:00–05:00 receive tag: `unusual_activity`
* ✅ Index `hoa-gate-*` contains the parsed events
* ✅ A new after-hours log entry triggers the same tagging and appears in search results
* ✅ Kibana can filter `tags:"unusual_activity"` and alert rule logic is valid

---

## 🧠 What I Learned

* “Use case building” in SIEM begins with **choosing meaningful event sources**
* Correct time-based detection requires extracting time components (hour) from timestamps
* Containerized ELK is quick for testing realistic security workflows
* Tagging is a simple but powerful technique to drive dashboards and alert rules
* Testing by appending events and confirming ingestion is essential for confidence

---

## 🌍 Why This Matters (Real-World Relevance)

HOAs often rely on physical access controls:

* security gates
* visitor logs
* camera events

After-hours gate activity can indicate:

* unauthorized access
* tailgating
* stolen credentials
* insider misuse

This lab demonstrates a realistic approach:
**Event source → parsing → rule logic → tagging → alerting → investigation.**

---

## ✅ Result

* ✅ ELK deployed successfully in Docker (Elastic 7.17.9)
* ✅ Gate logs ingested and parsed into Elasticsearch
* ✅ Unusual activity rule applied and verified (00:00–05:00 tagging)
* ✅ New test entry successfully detected and searchable
* ✅ Kibana workflow documented for alert creation

---

## 🏁 Conclusion

This lab successfully created an HOA-focused SIEM use case by ingesting gate access events into ELK, applying a custom after-hours detection rule, and validating the system through testing. The approach is directly reusable for real-world HOA monitoring, where after-hours access is an important security indicator.

---
