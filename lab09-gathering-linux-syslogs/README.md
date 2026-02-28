# 🧪 Lab 09: Gathering Linux Syslogs

## 🧾 Lab Summary
This lab focuses on collecting and forwarding **Linux syslogs** using **rsyslog**, then validating that logs are successfully received by a SIEM. The workflow includes:
- Confirming rsyslog is installed and running
- Enabling UDP syslog listening (imudp on port 514)
- Configuring rsyslog forwarding to a SIEM endpoint
- Restarting rsyslog and verifying configuration
- Generating a test syslog event using `logger`
- Validating local syslog receipt and confirming SIEM-side ingestion

This lab simulates a common enterprise scenario: onboarding a Linux host as a log source for centralized monitoring.

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand the basics of syslog in Linux
- Enable and configure rsyslog for system log collection
- Configure rsyslog log forwarding to a SIEM system
- Verify log reception locally and confirm visibility in SIEM

---

## ✅ Prerequisites
- Basic Linux command line understanding
- Admin privileges on a Linux machine
- Access to a SIEM log receiver (or simulated SIEM environment)
- SSH client (if accessing remote systems)

---

## 🧪 Lab Environment
- **OS:** Ubuntu 24.04.x (Ubuntu environment used in lab run)
- **Prompt style:** `toor@ip-172-31-10-219:~$`
- **Syslog daemon:** rsyslog (8.x)
- **Forwarding target (SIEM example):** `10.0.2.15:5544`
- **Test method:** `logger` to write into syslog

---

## 🛠️ Tasks Overview (What I Did)

### ✅ 1) Verify Syslog and rsyslog
- Confirmed rsyslog service is installed, enabled, and running:
  - `systemctl status rsyslog`

### ✅ 2) Start + Enable (Checklist Step)
- Ran start/enable as a real-world checklist step (even though already active):
  - `sudo systemctl start rsyslog`
  - `sudo systemctl enable rsyslog`

### ✅ 3) Configure rsyslog for Log Forwarding
- Edited `/etc/rsyslog.conf`:
  - enabled UDP listener module:
    - `module(load="imudp")`
    - `input(type="imudp" port="514")`
  - added forwarding rule to SIEM:
    - `*.* @10.0.2.15:5544`
- Verified configuration lines via grep
- Restarted rsyslog and confirmed clean restart

### ✅ 4) Verify Logs on SIEM
- Generated a test message:
  - `logger "Test log message from $(hostname)"`
- Confirmed the message exists locally in `/var/log/syslog`
- Verified SIEM-side ingestion by searching for the keyword and filtering by host

---

## ✅ Verification & Validation
- rsyslog running:
  - `systemctl status rsyslog --no-pager -l`
- configuration present:
  - `sudo grep -nE 'imudp|port="514"|\*\.\* @' /etc/rsyslog.conf`
- local test message exists:
  - `sudo tail -n 8 /var/log/syslog`
- SIEM ingestion validated:
  - dashboard search for `"Test log message"` and host filter

---

## 📁 Repository Structure
```text
lab09-gathering-linux-syslogs/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── configs/
    └── rsyslog.conf.snippet
````

---

## 🌍 Why This Matters

Syslogs are one of the most important data sources for security monitoring because they capture:

* authentication events (SSH logins, sudo usage)
* service changes and failures
* system warnings and abnormal behaviors

Forwarding syslogs into a SIEM enables:

* centralized monitoring
* correlation across hosts and endpoints
* alerting on anomalies (e.g., brute-force, suspicious privilege usage)

---

## 🧩 Real-World Applications

* Centralized Linux logging for SOC monitoring
* Detecting SSH brute-force attempts via auth logs
* Alerting on repeated failed logins or privilege escalation attempts
* Forensics timeline reconstruction during incident response
* Compliance/audit logging for operational environments

---

## ✅ Result

* rsyslog confirmed installed and running
* UDP syslog listener enabled (imudp on 514)
* Forwarding rule added to SIEM endpoint (`10.0.2.15:5544`)
* rsyslog restarted cleanly
* Test message generated and verified locally
* SIEM dashboard confirmed log ingestion successfully

---

## 🏁 Conclusion

This lab demonstrated a complete pipeline for Linux syslog forwarding: configuring rsyslog to listen on UDP 514, forwarding all logs to a SIEM endpoint, and verifying successful ingestion using a generated test log event. This is a foundational skill for SIEM onboarding and future correlation/alerting labs.

✔️ Lab completed successfully on Ubuntu 24.04 (rsyslog forwarding enabled)

---
