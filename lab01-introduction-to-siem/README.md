# 🧪 Lab 01: Introduction to SIEM

## 🧾 Lab Summary
This lab introduces **Security Information and Event Management (SIEM)** and demonstrates its core functions through a hands-on deployment of **Wazuh** in a cloud-based Ubuntu environment.

The lab focuses on the SIEM fundamentals:
- **Log Collection** (ingesting firewall + web server logs)
- **Correlation** (custom rule matching JSON events)
- **Alerting** (configuring email alert settings and validating alert generation)

This lab is framed in a realistic small-environment context such as a **Homeowners Association (HOA)**, where visibility into login attempts and access patterns can significantly improve security posture.

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Explain what a SIEM is and why it is critical in cybersecurity monitoring.
- Identify SIEM key functions: log collection, correlation, and alerting.
- Deploy an open-source SIEM (Wazuh) in a cloud lab environment.
- Configure Wazuh to monitor multiple log sources.
- Create and test a custom correlation rule.
- Validate alert generation through SIEM logs and `alerts.json`.

---

## ✅ Prerequisites
- Basic understanding of network and cybersecurity concepts
- Familiarity with Linux command line usage
- Access to a virtualized/cloud environment for deploying open-source SIEM solutions

---

## 🧪 Lab Environment
- **Platform:** Cloud Lab (Ubuntu/Debian environment)
- **OS:** Ubuntu 24.04.1 LTS
- **User:** `toor`
- **SIEM Tool:** Wazuh (Docker container)
- **Prompt style:** `toor@ip-172-31-10-219:~$` (IP tail may vary)

---

## 🧠 Key Concepts
- **Log Collection:** Gathering logs from endpoints and infrastructure sources (servers, firewall logs, web logs).
- **Correlation:** Connecting related events across sources to identify attack patterns.
- **Alerting:** Notifying administrators when rules detect suspicious activity.

---

## 🛠️ Tasks Overview (What I Did)

### ✅ Task 1 — Deploy an Open Source SIEM (Wazuh)
- Verified OS environment
- Installed Docker
- Deployed Wazuh via Docker using host networking
- Verified container status using `docker ps`

### ✅ Task 2 — Configure Log Collection
- Opened Wazuh config file: `/var/ossec/etc/ossec.conf`
- Added monitoring entries for:
  - Firewall logs: `/var/log/ufw.log`
  - Web logs: `/var/log/nginx/access.log`, `/var/log/nginx/error.log`
- Created log paths/files (for lab simulation realism)
- Restarted Wazuh manager and validated log monitoring via `ossec.log`

### ✅ Task 3 — Implement Log Correlation
- Created custom rule file: `/var/ossec/etc/rules/custom_rules.xml`
- Added correlation logic for failed login attempts from JSON logs
- Added a monitored JSON log source: `/var/log/custom_app.json`
- Generated test JSON events and verified rule firing in `alerts.json`

### ✅ Task 4 — Configure Alerting
- Added email notification configuration under `<global>` in `ossec.conf`
- Verified alert generation via `alerts.json`
- Documented realistic cloud limitation: SMTP may not be available in lab environment

---

## ✅ Verification & Validation
- Confirmed Wazuh is running:
  - `sudo docker ps`
- Confirmed log monitoring:
  - `tail -f /var/ossec/logs/ossec.log`
- Confirmed correlation rule firing:
  - `tail -n 5 /var/ossec/logs/alerts/alerts.json`
- Confirmed alert output exists even if email delivery is unavailable:
  - `alerts.json` contains rule match entries

---

## 📁 Repository Structure
```text
lab01-introduction-to-siem/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## 🌍 Why This Matters

SIEM tools help detect suspicious behavior early by correlating events across systems. Even small organizations like an HOA can use SIEM to:

* Detect unauthorized access attempts
* Monitor shared systems (Wi-Fi, printers, admin portals)
* Produce security alerts and audit trails

Without centralized monitoring, attacks often go unnoticed until damage occurs.

---

## 🧩 Real-World Applications

* SOC monitoring and alert triage
* Incident response investigations
* Detecting brute force attempts and credential abuse
* Centralized logging for compliance and auditing
* Security monitoring for small businesses and residential orgs (HOAs)

---

## ✅ Result

* Docker installed and running successfully
* Wazuh deployed and verified running in container
* Log collection configured and validated (ufw + nginx log paths)
* Custom rule deployed and successfully triggered on test JSON events
* Alerts verified in `alerts.json`
* Email alert config applied (not delivered due to lab SMTP constraints)

---

## 🏁 Conclusion

This lab established foundational SIEM knowledge through hands-on setup of an open-source platform. I deployed Wazuh, configured multiple log sources, implemented a correlation rule, and validated that alerts are generated correctly. This forms a strong foundation for deeper SIEM labs involving dashboards, tuning, RBAC, incident workflows, and threat intelligence integration.

✅ Lab completed successfully on a cloud Ubuntu environment.

---
