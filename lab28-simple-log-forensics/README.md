# 🕵️ Lab 28: Simple Log Forensics

## 🧾 Lab Summary
This lab introduced **basic log forensics** using command-line tools to identify suspicious authentication activity within a defined investigation window. Since the system’s real `/var/log/auth.log` contained only current lab-date entries, a controlled **sample authentication log** (`auth_sample.log`) with Jul 15 events was created to accurately perform time-based filtering and forensic extraction.

---

## 🎯 Objectives
- Understand the basics of log forensics to identify suspicious activities
- Use open-source CLI tools (`grep`, `awk`, `sed`) for log analysis
- Identify key log elements:
  - timestamps
  - usernames
  - IP addresses
- Summarize findings and document evidence for investigation

---

## ✅ Prerequisites
- Basic knowledge of network protocols
- Familiarity with Linux CLI
- Tools installed: `grep`, `awk`, `sed`
- Sample log files available for analysis

---

## 🧠 Key Concepts
- **Log Forensics**: Analyzing log data to detect security events and reconstruct activity
- **Timestamps**: Establish event sequence and timeline
- **Usernames**: Identify targeted or compromised accounts
- **IP Addresses**: Trace suspicious source systems and patterns (e.g., brute-force attempts)

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Hostname | ip-REDACTED |
| User | toor |
| Tools | grep, awk, sed |
| Primary log checked | `/var/log/auth.log` |
| Sample log created | `auth_sample.log` (Jul 15 dataset) |

---

## 🗂️ Repository Structure
```text
lab28-simple-log-forensics/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

> 📌 Files created during the lab (inside the lab working directory):

* `auth_sample.log`
* `filtered_logs.txt`
* `suspicious_activity.txt`
* `evidence.txt`
* `evidence_clean.txt`

(These are referenced in outputs and commands; you may store them under `artifacts/` later if you want, but this lab keeps them as generated evidence files.)

---

## ✅ Tasks Overview (No Commands Here)

### ✅ Task 1: Select a Date/Time Range

* Defined the investigation window based on the lab example:

  * **Jul 15, 10:00 to Jul 15, 12:00**
* Checked `/var/log/auth.log` and confirmed it contained current system entries (Aug 18)
* Created a controlled sample log file with Jul 15 events to complete the lab realistically

### ✅ Task 2: Filter Logs Within the Time Window

* Filtered `auth_sample.log` for:

  * `Jul 15 10:`
  * `Jul 15 11:`
  * `Jul 15 12:`
* Stored results in `filtered_logs.txt`
* Verified line counts and previewed extracted entries

### ✅ Task 3: Isolate Suspicious Patterns

* Searched for suspicious keywords:

  * `failed`, `error`, `unauthorized`
* Wrote suspicious results to `suspicious_activity.txt`
* Confirmed extracted suspicious activity volume

### ✅ Task 4: Analyze Repeated Failed Logins (Brute Force Indicators)

* Used `awk + sort + uniq` to count failed password events per IP
* Identified the most frequent source IP as the top suspect

### ✅ Task 5: Document Evidence (Timestamps, Users, IPs)

* Ran the lab’s simple extraction command into `evidence.txt`
* Observed real-world issue: field positions vary in auth logs
* Applied a practical forensic parsing fix to reliably extract:

  * timestamp
  * username (token after `for`)
  * IP (token after `from`)
* Saved cleaner results into `evidence_clean.txt`

---

## ✅ Findings (Executive Summary)

### 🔎 Top Suspicious Source

* **192.168.1.10**

  * Highest count of failed password attempts in the investigation window
  * Attempted multiple usernames including `admin`, `root`, and `suspicious_user`

### 👤 Targeted/Notable Accounts

* `admin` (invalid user attempts)
* `root`
* `suspicious_user` (clustered failures around 10:35–10:37)

### 🌐 Other Suspicious Sources

* `203.0.113.50` (repeated invalid guest attempts)
* `198.51.100.23` (failed attempts + “unauthorized user attempt” entry)

### 🧾 Example Evidence Match

* Username: `suspicious_user`
* IP: `192.168.1.10`
* Timestamp: **Jul 15 10:35:19**

---

## 🌍 Why This Matters

Log forensics is a foundational SOC skill:

* Detect brute force attempts early
* Correlate suspicious IPs and targeted accounts
* Provide evidence that supports escalation, blocking, or incident response

---

## 🧩 Real-World Applications

* SSH brute-force detection and reporting
* Identifying account probing and credential stuffing
* Building evidence timelines during IR investigations
* Supporting firewall rules / blocklists based on repeated offenders
* Feeding SIEM rules (threshold-based detection)

---

## ✅ Result

✔ Confirmed log sources and tool availability
✔ Built a controlled sample dataset for timeframe-based analysis
✔ Filtered logs by time window (10–12)
✔ Isolated suspicious keywords (failed/error/unauthorized)
✔ Counted failed login attempts per IP
✔ Extracted timestamp/username/IP evidence into evidence files

---

## 🧠 What I Learned

* How to filter logs quickly using time patterns and keywords
* How to summarize failed login attempts by source IP
* Why “fixed-position parsing” often fails in real logs
* A simple, reliable approach to extract fields using keyword-based scanning (`for`, `from`)

---

## ✅ Conclusion

This lab demonstrated a practical log forensics workflow using CLI tools: time-window filtering, suspicious keyword isolation, brute-force pattern detection via IP counting, and evidence extraction into structured text files. This approach forms the baseline for more advanced log analysis and SIEM rule development.

✅ **Lab completed successfully (Ubuntu 24.04.1 LTS)**

---
