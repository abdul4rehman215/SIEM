# 🧪 Lab 16: Investigating Alerts in a SIEM System

## 🧾 Lab Summary
This lab focuses on the practical workflow of **investigating SIEM alerts**—finding an alert, filtering it down to relevant events, drilling into raw data, and producing an investigation report with recommended response actions.

Because this cloud lab environment is **terminal-only** (no Kibana/Wazuh web UI), I simulated the same investigation process using:
- a local **JSONL alerts dataset** (as if exported from a SIEM index)
- command-line filtering and drill-down using **jq** (similar to Kibana filtering)
- a written **investigation report** documenting findings and next steps

This still matches the real-world SIEM analyst workflow:
✅ locate alerts → ✅ filter results → ✅ drill down raw events → ✅ correlate related events → ✅ document findings → ✅ recommend response.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Locate and interpret alerts inside a SIEM-like dataset
- Filter alerts by category and key fields (e.g., suspicious_login)
- Drill down into raw event records for a specific alert ID
- Identify patterns by correlating alerts using shared indicators (e.g., same source IP)
- Document findings and propose actionable incident response steps

---

## ✅ Prerequisites
- Basic cybersecurity and incident response concepts
- Comfort navigating Linux terminal and files
- Basic log analysis mindset (timestamp, IP, user, outcome, severity)
- Familiarity with SIEM concepts (alerts, rules, categories, drill-down)

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Environment | Cloud Lab Environment |
| User | `toor` |
| SIEM UI | Not available (terminal-only) |
| Tooling | `jq` for JSON filtering + investigation report markdown |

---

## 🗂️ Repository Structure
```text
lab16-investigating-alerts-in-siem/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── artifacts/
│   ├── alerts.jsonl
│   └── investigation_report.md
````

> **Note:** Alerts are stored in **JSON Lines format (`.jsonl`)**, which is realistic for SIEM exports (one JSON object per line).

---

## 🧩 Tasks Overview (What I Performed)

### ✅ Task 0: Confirm Environment + Setup Workspace

* Verified the OS version and current directory
* Created a dedicated lab folder to keep artifacts organized

### ✅ Task 1: Build a Sample SIEM Alerts Dataset (Terminal Simulation)

* Installed `jq` to filter/search JSON (similar to Kibana queries)
* Created `alerts.jsonl` containing multiple alert types:

  * suspicious_login
  * malware
  * network_scan
* Validated dataset size to confirm multiple records exist for investigation practice

### ✅ Task 2: Locate Suspicious Login Alerts (SIEM Filtering)

* Displayed a quick “alert list view” summarizing:

  * timestamp, alert ID, category, severity, user, source IP
* Filtered the dataset down to only:

  * `alert.category == suspicious_login`
* Produced a clean summary list of suspicious_login alerts to pick a target for investigation

### ✅ Task 3: Drill Down Into Raw Event Data (Alert Detail View)

* Selected alert ID: **a-1001**
* Extracted the full JSON record (equivalent to clicking an alert in Kibana)
* Extracted key fields into a single-line “investigation view”:

  * timestamp, user, source IP, geo, outcome, rule name
* Evaluated suspiciousness indicators (unknown geo + authentication failure)

### ✅ Task 4: Correlate Related Alerts (Pattern Finding)

* Investigated whether the source IP appears elsewhere in the dataset
* Discovered the same IP appears in multiple alerts for the same user:

  * a-1001 (Suspicious Login - Unusual Geo)
  * a-1005 (Brute Force Suspected)
* Checked timeline ordering to confirm clustering (activity within minutes)

### ✅ Task 5: Document Findings + Recommend Next Steps (Incident Response)

* Created an investigation report (`investigation_report.md`) including:

  * investigated alert metadata
  * raw event evidence (key fields)
  * related alerts / pattern evidence
  * observations
  * recommended response actions (containment, account security, hunting, hardening)

---

## 🔍 Investigation Focus (Case Summary)

### Alert Investigated

* **Alert ID:** `a-1001`
* **Category:** `suspicious_login`
* **Severity:** `high`
* **Rule:** `Suspicious Login - Unusual Geo`
* **User:** `jdoe`
* **Source IP:** `192.168.1.100`
* **Geo:** `Unknown`
* **Outcome:** `failed`

### Key Pattern Identified

The source IP **192.168.1.100** appears in multiple suspicious authentication-related alerts, including a brute-force suspicion alert. This increases confidence that the activity is malicious rather than an isolated failed login.

---

## ✅ Verification & Validation

This lab is successful when:

* ✅ `alerts.jsonl` contains multiple alert records across categories
* ✅ suspicious_login alerts can be filtered and summarized using jq
* ✅ a specific alert (a-1001) can be drilled into for full raw JSON
* ✅ a shared indicator (source IP) can be used to find related alerts
* ✅ findings are documented in a structured investigation report

---

## 🧠 What I Learned

* SIEM investigations require moving from **alert summary → raw evidence** quickly.
* Simple filters (category/time/user/IP) dramatically reduce noise.
* Patterns become clearer when correlating alerts using shared indicators (like IP/user).
* A good investigation ends with a **clear written report** and **actionable next steps** for IR.

---

## 🌍 Why This Matters

In real SOC operations, alert triage and investigation must be fast, accurate, and well documented. Analysts must:

* assess severity and credibility
* extract key evidence
* identify related activity
* recommend containment and remediation steps

This lab builds foundational skills for:

* SIEM alert triage
* incident response documentation
* threat hunting pivoting using indicators

---

## 🧰 Real-World Applications

This investigation workflow maps directly to tools like:

* Elastic Security (Kibana alerts/rules + KQL/EQL pivots)
* Wazuh dashboard alerts + event drill-down
* Splunk notable events + raw log pivots
* Sentinel incidents + entity investigation

---

## ✅ Result

* ✅ Created a realistic SIEM alert dataset in JSONL format
* ✅ Filtered alerts to suspicious_login category using jq
* ✅ Investigated a specific alert and extracted key evidence fields
* ✅ Identified correlation pattern (same IP across multiple alerts)
* ✅ Produced an investigation report with recommended response steps

---

## 🏁 Conclusion

This lab successfully demonstrated a SIEM alert investigation workflow in a terminal-only environment. By simulating SIEM alerts in JSONL and using jq-based filtering/drill-down, I practiced the same core skills required in a real SIEM: triage, evidence extraction, correlation, and incident response reporting.

---
