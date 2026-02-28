# 🧠 Interview Q&A — Lab 35: Generating Security Reports

---

## 1) What is the goal of generating security reports?
Security reports summarize security telemetry into actionable insights, helping teams understand risk, detect anomalies, and communicate findings to stakeholders.

---

## 2) What types of data sources were used in this lab?
Two primary sources:
- **OSSEC (HIDS):** host integrity/log monitoring
- **Zeek (NSM):** network activity logs (conn, dns, http, notice, weird, reporter)

---

## 3) Why were both OSSEC and Zeek used?
They provide complementary visibility:
- OSSEC = host-level changes, log analysis, integrity monitoring
- Zeek = network-level behaviors and protocol activity  
Together they produce a richer picture for reporting.

---

## 4) What problem occurred when installing OSSEC on Ubuntu 24.04?
The package `ossec-hids` was not found in the default repositories (`Unable to locate package`).

---

## 5) How was OSSEC installed after the package was missing?
A realistic fallback method was used:
- installed build dependencies
- downloaded OSSEC source tarball (v3.7.0)
- ran the interactive installer (`./install.sh`)
- started OSSEC using `ossec-control`

---

## 6) What OSSEC feature is most directly related to reporting file integrity changes?
**Syscheck** (file integrity monitoring). It tracks file changes in monitored directories and produces alerts.

---

## 7) Which directories were configured for OSSEC syscheck monitoring?
- `/etc`
- `/var/log`

These are common targets because they contain configuration and critical log data.

---

## 8) What problem occurred when installing Zeek?
The package `zeek` was not available in default Ubuntu repos in this environment (`Unable to locate package zeek`).

---

## 9) How was Zeek installed successfully?
A Zeek repository was added, then Zeek was installed via apt after importing the repository key and updating package lists.

---

## 10) Why is Zeek useful for security reporting?
Zeek generates structured logs about network behavior, enabling:
- connection summaries
- DNS activity analysis
- HTTP activity visibility
- detection “notices” and unusual protocol behavior (weird.log)

---

## 11) What logs were confirmed in `/opt/zeek/logs/current`?
Examples included:
- `conn.log`
- `dns.log`
- `http.log`
- `notice.log`
- `reporter.log`
- `weird.log`

---

## 12) What did the lab attempt when searching for “CRITICAL” events?
It ran:
```bash
grep "CRITICAL" /opt/zeek/logs/current/*.log
````

No results were found (exit code 1), which is normal if logs contain no CRITICAL strings.

---

## 13) What was the report generation approach used?

A simple automation pipeline:

* use `grep -i "error"` to extract error indicators from Zeek logs
* write results to `summary.log`
* export to PDF and CSV

---

## 14) Why is exporting to PDF useful?

PDF is suitable for sharing with non-technical stakeholders and attaching to tickets or audit documentation as a static snapshot.

---

## 15) What is the main takeaway from this lab?

Security reporting is a repeatable workflow: collect telemetry, filter for meaningful signals, automate summaries, and export in stakeholder-friendly formats (PDF/CSV). Handling missing packages realistically is also part of real-world operations.

---
