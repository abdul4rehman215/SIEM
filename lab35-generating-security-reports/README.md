# 🧾 Lab 35: Generating Security Reports

## 🧾 Lab Summary
This lab focused on generating practical security reports by collecting host and network security telemetry using open-source tools. I installed **OSSEC HIDS** (from source due to missing Ubuntu package), configured file integrity monitoring targets, installed **Zeek** (Bro) for network visibility (via external repository because the default package was not available), and then generated reports by extracting relevant log signals. Finally, I exported the report into **PDF** (via `pandoc`) and **CSV** (via a Python script).

---

## 🎯 Objectives
- Generate and interpret security reports
- Use open-source tools to collect and compile security data
- Export and analyze key security metrics

---

## ✅ Prerequisites
- Basic network security concepts
- Familiarity with Linux CLI tools
- Ability to install and configure open-source monitoring tools (OSSEC, Zeek)

---

## 🧠 Key Concepts
- **HIDS (Host-based IDS):** Detects suspicious activity on a host via logs, file integrity checks, and rootkit detection (OSSEC)
- **NSM (Network Security Monitoring):** Observes network events and produces structured logs (Zeek)
- **Report pipeline:** Collect → filter → summarize → export (PDF/CSV)
- **Operational reality:** Packages may be missing on modern distros; fallback approaches are required (source install / repo enable)

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Hostname | ip-REDACTED |
| User | toor |
| OSSEC | 3.7.0 (installed from source) |
| Zeek | 6.0.3 (installed via repo) |
| Reporting Tools | grep, bash, python3, pandoc |
| Zeek Logs | `/opt/zeek/logs/current/` |
| OSSEC Config | `/var/ossec/etc/ossec.conf` |

---

## 🗂️ Repository Structure
```text
lab35-generating-security-reports/
├── README.md
├── commands.sh
├── output.txt
├── configs/
│   └── ossec.conf.snippet
├── scripts/
│   ├── generate_report.sh
│   └── convert_to_csv.py
├── artifacts/
│   ├── summary.log
│   ├── security_report.pdf
│   └── report.csv
├── interview_qna.md
└── troubleshooting.md
````

> 📌 Note: In a real GitHub repo, large artifacts can be stored in `artifacts/` or managed with Git LFS.
> This lab’s outputs (PDF/CSV/log) are small enough to keep in-repo.

---

## ✅ Tasks Overview (No Commands Here)

### ✅ Task 1: Set Up Security Monitoring Tool (OSSEC)

* Attempted package install (`ossec-hids`) but it was not available in Ubuntu 24.04 default repos
* Installed OSSEC from source (`3.7.0`) and completed interactive “local” installation
* Enabled key OSSEC capabilities during install:

  * syscheck (integrity checks)
  * rootkit detection
  * log analysis for `/var/log/auth.log` and `/var/log/syslog`
* Updated OSSEC syscheck configuration to monitor:

  * `/etc`
  * `/var/log`
* Restarted OSSEC to apply changes

### ✅ Task 2: Collect Security Event Data (Zeek)

* Attempted Zeek install from default repos but package was not available
* Added a Zeek repository and installed Zeek + zeekctl
* Deployed Zeek with `zeekctl deploy` and verified status
* Validated log generation inside:

  * `/opt/zeek/logs/current/`
* Reviewed logs (example: `notice.log` header)

### ✅ Task 3: Generate Security Reports

* Searched for “CRITICAL” signals across Zeek logs (none present; exit code 1 confirmed)
* Created a bash report script to extract error signals:

  * `grep -i "error" /opt/zeek/logs/current/*.log > summary.log`
* Ran script and verified `summary.log` generated with realistic matches

### ✅ Task 4: Export the Report

* Installed pandoc (not present initially)
* Converted `summary.log` to:

  * `security_report.pdf`
* Converted `summary.log` to:

  * `report.csv` using a Python CSV writer script
* Validated file existence and previewed CSV output

---

## ✅ Results

✔ OSSEC installed and running with syscheck monitoring configured
✔ Zeek installed and running; logs generated under `/opt/zeek/logs/current`
✔ Report generated (`summary.log`) from Zeek log error indicators
✔ Report exported to:

* PDF (`security_report.pdf`)
* CSV (`report.csv`)

---

## 🌍 Why This Matters

Security reporting is essential for:

* communicating risk and activity to stakeholders
* spotting recurring issues (errors, malformed traffic, unusual network behavior)
* supporting incident response with evidence
* validating monitoring coverage and tooling health

---

## 🧩 Real-World Applications

* Daily/weekly SOC summaries (top errors/notices, top talkers, protocol anomalies)
* Executive snapshots (PDF exports)
* Metrics pipelines (CSV outputs for dashboards)
* Continuous monitoring validation (tool health + log volume checks)

---

## 🧠 What I Learned

* How to adapt when security tools are not available via default OS repos
* How OSSEC and Zeek complement each other (host + network visibility)
* How to quickly extract reportable signals from large log sets using grep + scripts
* How to export reports into shareable formats (PDF/CSV)

---

## ✅ Conclusion

This lab demonstrated an end-to-end reporting workflow: deploying open-source monitoring tools (OSSEC + Zeek), collecting log evidence, generating a summary report automatically, and exporting results in PDF and CSV formats for analysis and sharing.

---
