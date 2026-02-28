# 🧪 Lab 08: Gathering Windows Event Logs

## 🧾 Lab Summary
This lab demonstrates how to collect **Windows Event Logs** and ingest them into a SIEM using **Winlogbeat** (Elastic Beats). The workflow includes:
- Downloading and installing Winlogbeat on a Windows host
- Installing Winlogbeat as a Windows service
- Configuring which event log channels to collect (Application, Security, System)
- Verifying Winlogbeat is actively reading logs and generating its own log files
- Confirming logs are visible in the SIEM dashboard (Kibana/Discover)

This lab is written in a realistic “endpoint onboarding” style used in SOC environments when bringing new log sources into a SIEM.

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand the process of gathering Windows Event Logs
- Install an agent (Winlogbeat) to collect event logs
- Configure Winlogbeat to collect specific log channels
- Validate Winlogbeat service status and log generation
- Confirm successful ingestion of Windows events into the SIEM dashboard

---

## ✅ Prerequisites
- Windows machine with administrative privileges
- Internet access to download tools
- Basic understanding of Windows Event Logs and SIEM tools

---

## 🧪 Lab Environment
- **Endpoint OS:** Windows (Admin PowerShell)
- **Agent:** Winlogbeat 8.13.4 (Windows x86_64 zip)
- **Install Path:** `C:\Program Files\Winlogbeat`
- **SIEM/Backend:** Elasticsearch + Kibana (Elastic Stack)
- **Verification:** Windows event logs + Winlogbeat local logs + Kibana Discover ingestion checks

---

## 🛠️ Tasks Overview (What I Did)

### ✅ Task 1 — Install / Enable an Agent (Winlogbeat)
- Created staging directory `C:\Temp`
- Downloaded Winlogbeat zip using `Invoke-WebRequest`
- Extracted Winlogbeat to `C:\Program Files\Winlogbeat`
- Moved extracted contents to match expected folder structure
- Installed Winlogbeat as a Windows service using `install-service-winlogbeat.ps1`
- Verified service is running

### ✅ Task 2 — Configure Agent to Collect Event Logs
- Edited `winlogbeat.yml` (Notepad)
- Configured channels:
  - Application
  - Security
  - System
- Verified configuration using `Select-String`

### ✅ Task 3 — Confirm Log Collection and Transmission Readiness
- Attempted `Start-Service winlogbeat` (error due to service already running)
- Verified service status with `Get-Service`
- Restarted service to apply configuration changes
- Verified Windows Event Logs are present and Winlogbeat logs appear in:
  - `C:\Program Files\Winlogbeat\logs`

### ✅ Task 4 — Ingest and View Logs in SIEM Dashboard
- Verified Winlogbeat output configuration points to Elasticsearch
- Confirmed ingestion in SIEM (Kibana):
  - Discover / Logs view
  - filters used:
    - `event.code:*`
    - `winlog.channel: "Security" OR "System" OR "Application"`
- Observed fresh incoming events with timestamps updating

---

## ✅ Verification & Validation
- Winlogbeat installed and running as a service:
  - `.\install-service-winlogbeat.ps1`
  - `Get-Service winlogbeat`
- Config validated:
  - `Select-String winlogbeat.event_logs`
  - `Select-String output\.`
- Endpoint log visibility confirmed:
  - `Get-EventLog -LogName Application -Newest 5`
- Winlogbeat local logs confirmed:
  - `Get-ChildItem .\logs`
- SIEM ingestion verified:
  - Kibana Discover shows Security/System/Application channel events

---

## 📁 Repository Structure
```text
lab08-gathering-windows-event-logs/
├── README.md
├── commands.ps1
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── configs/
    ├── winlogbeat_event_logs.snippet.yml
    └── winlogbeat_output.snippet.yml
````

> 📌 Note: This lab uses `commands.ps1` instead of `commands.sh` because the primary execution was on Windows PowerShell.

---

## 🌍 Why This Matters

Windows Event Logs are one of the most valuable data sources in enterprise security monitoring:

* authentication events (logon success/failures)
* policy and privilege changes
* service creation and persistence indicators
* endpoint operational signals for detection and response

Onboarding Windows logs is a foundational SOC task and a critical prerequisite for correlation rules and alerting workflows.

---

## 🧩 Real-World Applications

* SOC endpoint onboarding (agent deployment + configuration)
* detecting brute force attempts (e.g., repeated failed logons)
* monitoring privileged account activity
* investigating malware persistence and service changes
* compliance/audit evidence through centralized logging

---

## ✅ Result

* Winlogbeat 8.13.4 successfully downloaded, extracted, and installed
* Winlogbeat configured to collect Application/Security/System logs
* Service verified running; restart applied configuration successfully
* Winlogbeat logs created and updated locally on disk
* Windows events observed in Kibana Discover confirming SIEM ingestion

---

## 🏁 Conclusion

This lab successfully onboarded Windows Event Logs into the SIEM using Winlogbeat. The agent was installed, configured, validated through Windows event views, and confirmed ingesting into the SIEM dashboard. This forms a strong foundation for future detection rules, alert tuning, and incident investigation workflows.

✔️ Lab completed successfully on a Windows host (Admin PowerShell)

---
