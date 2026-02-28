# 🧪 Lab 12: Custom Field Extraction

## 🧾 Lab Summary
This lab demonstrates how to perform **custom field extraction** when logs arrive in an unstructured format (often only a `message` field). The lab covers:
- Identifying logs with missing parsed fields in Kibana Discover
- Using **regex** to locate log events containing IP-like patterns
- Implementing **Grok extraction** using Logstash to convert raw syslog-style messages into structured fields
- Validating extracted fields inside the SIEM interface (Discover) and ensuring data quality

The main example log line was an SSH failed login event that originally appeared as raw text:
```text
Feb 28 21:45:12 web01 sshd[2441]: Failed password for invalid user admin from 203.0.113.55 port 51244 ssh2
````

---

## 🎯 Objectives

By the end of this lab, I was able to:

* Understand custom field extraction in log management workflows
* Use regex patterns to identify log entries matching certain patterns (e.g., IPv4)
* Use Grok patterns to extract fields from unstructured logs
* Validate extracted fields in the SIEM (Kibana/Elasticsearch) and confirm correctness

---

## ✅ Prerequisites

* Basic understanding of log formats and log management concepts
* Familiarity with regex syntax
* Access to an open-source SIEM with appropriate permissions
* Sample logs with missing fields or unrecognized formats

---

## 🧪 Lab Environment

* **OS:** Ubuntu 24.04 (SIEM node)
* **Prompt style:** `toor@ip-172-31-10-207:~$`
* **Elasticsearch:** reachable at `http://localhost:9200`
* **Logstash:** 8.13.4
* **SIEM UI:** Kibana Discover (index pattern example: `logs-*`)
* **Parsing method:** Logstash Grok filter + validation of extracted fields

---

## 🛠️ Tasks Overview (What I Did)

### ✅ Task 1 — Identify Logs with Missing Fields

* Opened Kibana → Discover
* Selected log index pattern: `logs-*` (example)
* Found events where only `message` existed and parsed fields were missing:

  * missing timestamp mapping or original timestamp not parsed
  * missing IP fields such as `source.ip` / `client.ip`
* Confirmed raw/unstructured syslog/app style messages exist

---

### ✅ Task 2 — Extract Fields Using Regex

* Reviewed regex basics:

  * `^` start of line
  * `+` one or more
  * `[a-zA-Z0-9]` allowed characters
* Selected IPv4-like regex:

```text
(\d{1,3}\.){3}\d{1,3}
```

* Ran an Elasticsearch Query DSL regex search (via curl) to find logs containing IP-like patterns in `message`
* Verified hits returned from `logs-*` indices and confirmed the SSH failed login messages were discoverable

---

### ✅ Task 3 — Use Grok for Field Extraction

* Verified Logstash availability:

  * `logstash --version` → `logstash 8.13.4`
* Created a Logstash pipeline `custom_grok.conf`:

  * **First grok**: extracts syslog header fields:

    * logdate, logsource, program, pid, logmessage
  * **Second grok**: extracts src_ip and src_port from `logmessage`
* Tested extraction using stdin input + rubydebug stdout output:

  * piped sample sshd failure log into Logstash
* Confirmed structured fields were extracted successfully, including `src_ip` and `src_port`

---

### ✅ Task 4 — Validate Extracted Fields

* In SIEM interface (Discover):

  * verified extracted fields appear:

    * logdate, logsource, program, pid, logmessage, src_ip, src_port
* Data quality checks:

  * src_ip matches raw message (203.0.113.55)
  * src_port matches raw message (51244)
  * program correctly identified (sshd)
  * logmessage preserved (no truncation)

---

## ✅ Verification & Validation

* Regex-based log discovery:

  * `GET logs-*/_search` using `regexp` query on `message`
* Grok extraction validation:

  * Logstash pipeline output shows extracted fields in rubydebug output
* SIEM validation:

  * Confirmed fields appear in event details panel in Discover

---

## 📁 Repository Structure

```text
lab12-custom-field-extraction/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── configs/
    ├── custom_grok.conf
    ├── regex_ip_search_query.json
    └── sample_log.txt
```

---

## 🌍 Why This Matters

In real environments, many logs arrive as raw text:

* syslog lines from network devices
* application logs without JSON formatting
* legacy services without structured output

Custom extraction is required so SIEM can:

* correlate events by IP/user/host
* trigger alerts reliably
* build dashboards using structured fields
* reduce analyst workload during investigations

---

## 🧩 Real-World Applications

* Extracting attacker IPs from SSH brute force logs
* Parsing web server access logs into structured fields
* Normalizing multi-source syslog streams
* Building detections using extracted fields (src_ip thresholds, failed logon spikes)
* Improving searchable metadata for threat hunting

---

## ✅ Result

* Identified unstructured logs with missing parsed fields
* Located IP-containing logs using regex search in Elasticsearch
* Built and tested a custom Logstash Grok pipeline
* Successfully extracted syslog and SSH-related fields:

  * logdate, logsource, program, pid, logmessage, src_ip, src_port
* Validated extracted fields in SIEM interface and confirmed data accuracy

---

## 🏁 Conclusion

This lab demonstrated how to move from “raw message-only logs” to structured SIEM-ready events using regex discovery and Grok extraction. These skills are essential for onboarding new log sources and improving detection quality across mixed environments.

✔️ Lab completed successfully (Regex search + Grok extraction + validation)

---
