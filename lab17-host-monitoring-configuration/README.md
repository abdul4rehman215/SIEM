# 🧪 Lab 17: Host Monitoring Configuration

## 🧾 Lab Summary
This lab covers configuring **host monitoring** using a **Host-based Intrusion Detection System (HIDS)**. I installed **OSSEC**, enabled **active monitoring** through file integrity checks (syscheck), added a **local custom rules** section, and validated that alerts are generated when monitored files change.

Because this environment is a **terminal-only cloud VM**, I validated alert generation locally inside OSSEC logs (which is the same content a SIEM would ingest and display in its alert dashboard).

✅ Install HIDS agent → ✅ enable file integrity monitoring → ✅ add rule placeholders → ✅ generate test event → ✅ verify alert output.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Install a host intrusion detection agent (OSSEC)
- Enable active monitoring for:
  - file integrity changes (syscheck)
  - suspicious process activity (custom rule placeholder)
- Verify alerts are generated and available for SIEM ingestion

---

## ✅ Prerequisites
- Basic Linux CLI experience
- Familiarity with SIEM concepts (alerts, agents, log pipelines)
- Access to a Linux environment (Ubuntu preferred)
- (Optional) Access to a SIEM dashboard (not available in this lab VM; simulated via log review)

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Environment | Cloud Lab Environment |
| User | `toor` |
| HIDS | OSSEC (installed locally) |
| SIEM UI | Not available (validated via OSSEC logs) |

---

## 🗂️ Repository Structure
```text
lab17-host-monitoring-configuration/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── configs/
│   ├── ossec.conf.snippet
│   └── local_rules.xml.snippet
└── artifacts/
    ├── ossec_status.txt
    ├── ossec_log_tail.txt
    └── syscheck_alert_excerpt.txt
````

> Notes:
>
> * `configs/` contains only the **relevant snippets** added/verified during the lab (not the full OSSEC configs).
> * `artifacts/` contains evidence outputs that demonstrate OSSEC activity and alert generation.

---

## 🧩 Tasks Overview (What I Performed)

### ✅ Task 0: Confirm Environment

* Verified OS version and working directory

### ✅ Task 1: Install Host Intrusion Detection Agent (OSSEC)

* Updated package lists
* Ensured `wget` was installed
* Downloaded the Atomicorp OSSEC installer script
* Ran installer using **local installation** mode
* Enabled:

  * email notifications (configured for localhost in lab)
  * integrity check daemon (syscheck)
  * rootkit detection
  * active response
* Verified service is running and OSSEC components are active

### ✅ Task 2: Enable Active Monitoring

#### 2.1 File Integrity Monitoring (Syscheck)

* Edited OSSEC configuration to monitor:

  * `/etc`
  * `/usr/bin`
  * `/var/www`
* Confirmed syscheck configuration block is present in `/var/ossec/etc/ossec.conf`

#### 2.2 Suspicious Process Monitoring (Local Rules Placeholder)

* Added a local custom rules group inside:

  * `/var/ossec/rules/local_rules.xml`
* This demonstrates how to extend OSSEC with organization-specific logic.
* Restarted OSSEC and confirmed it remains active.

### ✅ Task 3: Confirm Alerts (SIEM Verification via Local Logs)

* Generated a file integrity event:

  * created `/etc/monitored_file`
* Triggered a fresh scan by restarting OSSEC
* Verified syscheck activity in:

  * `/var/ossec/logs/ossec.log`
* Confirmed the alert entry exists in:

  * `/var/ossec/logs/alerts/alerts.log`
* Exported alert excerpt as “SIEM verification evidence”

---

## 🔍 Verification & Validation

This lab is successful when:

* ✅ OSSEC service is **active (running)** via systemd
* ✅ OSSEC components show as running via `ossec-control status`
* ✅ `ossec.conf` includes syscheck directories:

  * `/etc,/usr/bin,/var/www`
* ✅ A file change event triggers a syscheck alert in `alerts.log`

  * The alert references the monitored file path
  * Example: `File: '/etc/monitored_file'`

---

## 🧠 What I Learned

* Host monitoring provides visibility into **on-host activity** (files/logs/rootkits/processes), complementing network-based detection.
* File integrity monitoring is a powerful early-warning control for:

  * unauthorized config changes
  * web shell drops
  * tampering in system binaries
* Validating alerts locally (logs) is a useful fallback when SIEM UI is unavailable.
* Custom rules are how HIDS deployments get tuned for real environments (reduce noise, increase detection relevance).

---

## 🌍 Why This Matters

In real SOC operations, host telemetry is often the difference between:

* “a suspicious signal” and “confirmed malicious behavior”

HIDS solutions help detect:

* persistence attempts (file modifications in startup/system paths)
* tampering (critical binaries, configs)
* policy violations and anomalies
* rootkits and suspicious behavior patterns

---

## 🧰 Real-World Applications

This lab maps to production workflows such as:

* Deploying OSSEC/Wazuh agents across servers
* Enabling file integrity monitoring for:

  * `/etc` (config integrity)
  * web roots (`/var/www`) to detect defacement/web shells
  * system binaries (`/usr/bin`) to detect tampering
* Sending alerts to SIEM pipelines (ELK/Wazuh Manager/Splunk)
* Writing and tuning custom detection rules

---

## ✅ Result

* ✅ OSSEC installed and running successfully
* ✅ Syscheck configured to monitor critical directories
* ✅ Local rule group added as a baseline for custom detections
* ✅ File integrity test event generated and detected
* ✅ Alerts confirmed inside OSSEC alert logs (ready for SIEM ingestion)

---

## 🏁 Conclusion

This lab successfully implemented host monitoring using OSSEC on Ubuntu. By enabling file integrity monitoring and validating alerts through OSSEC logs, I confirmed that host-based security monitoring is operational and generating actionable alerts—exactly the type of telemetry SIEM platforms rely on for detection and response.

---
