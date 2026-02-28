# 🧪 Lab 07: Configuring Data Sources

## 🧾 Lab Summary
This lab focuses on configuring **essential SIEM data sources** and validating end-to-end log ingestion using open-source tools. The lab uses **syslog-ng** as the log collection service and demonstrates how typical HOA-related sources (router + Windows endpoint) can forward logs to a centralized collector.

Key outcomes:
- Identified critical data sources (router/gateway, Windows endpoint, Linux host logs)
- Installed and configured **syslog-ng** for local + remote log ingestion
- Enabled syslog reception on **UDP/TCP 514**
- Validated ingestion by monitoring `/var/log/messages` in real time
- Simulated router and Windows log events via `nc -u` to confirm pipeline functionality

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Identify essential data sources for SIEM log collection (network devices + endpoints)
- Configure an open-source ingestion pipeline using syslog-ng
- Validate successful data collection using real-time log monitoring
- Confirm log quality indicators (timestamps, hostnames, event IDs)

---

## ✅ Prerequisites
- Basic understanding of network/system log formats
- Access to an environment with router and Windows endpoint (or simulated sources)
- Open-source ingestion tools (syslog-ng, logstash, fluentd)
- CLI fundamentals

---

## 🧪 Lab Environment
- **OS:** Ubuntu 24.04.1 LTS
- **Prompt style:** `toor@ip-172-31-10-232:~$`
- **Network Interface:** `ens5`
- **Collector Tool:** syslog-ng 4.x (Ubuntu package)
- **Log Destination:** `/var/log/messages`
- **Remote Syslog Ports:** UDP/514 and TCP/514

---

## 🛠️ Tasks Overview (What I Did)

### ✅ Task 1 — Identify and Select Data Sources
- Created a lab workspace directory structure
- Documented a HOA SIEM data source inventory including:
  - Router/Gateway logs (firewall, DHCP, NAT, admin logins)
  - Windows endpoint logs (Security/System/Application via NXLog)
  - Linux collector logs (auth, ssh, service events)

### ✅ Task 2 — Configure Log Collection Tools
- Installed syslog-ng
- Updated syslog-ng configuration:
  - Adjusted `@version` to match syslog-ng 4.x packaging
  - Enabled local sources (`system()`, `internal()`)
  - Enabled remote syslog ingestion on UDP/TCP 514
  - Wrote logs to `/var/log/messages`
- Enabled and restarted syslog-ng service
- Verified syslog-ng is listening on UDP/TCP 514

### ✅ Task 3 — Verify Data Ingestion
- Created log destination file if missing (`/var/log/messages`)
- Monitored logs in real-time using `tail -f`
- Simulated router syslog traffic using UDP netcat to localhost port 514
- Simulated Windows security events using UDP netcat to localhost port 514
- Confirmed both messages appear in `/var/log/messages`
- Performed validation checks (timestamps, hostnames, event IDs)

---

## ✅ Verification & Validation
- syslog-ng service status:
  - `sudo systemctl status syslog-ng --no-pager`
- syslog-ng listening ports:
  - `sudo ss -lunpt | grep ':514'`
- ingestion verified:
  - `sudo tail -f /var/log/messages`
- formatting validation:
  - `sudo tail -n 20 /var/log/messages`

---

## 📁 Repository Structure
```text
lab07-configuring-data-sources/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── configs/
│   └── syslog-ng.conf
└── docs/
    ├── data_sources_inventory.md
    ├── router_syslog_settings.md
    ├── log_validation_checks.md
    └── windows_router_samples/
        └── nxlog.conf
````

---

## 🌍 Why This Matters

A SIEM is only as effective as its log sources. Configuring routers and endpoints to forward logs allows:

* centralized monitoring
* better incident timeline reconstruction
* correlation across systems (e.g., firewall drops + failed logons)
* stronger detection capabilities (rule tuning depends on clean sources)

---

## 🧩 Real-World Applications

* Centralized syslog collection for routers, firewalls, and servers
* Windows event forwarding using NXLog/Winlogbeat
* Building correlation rules (e.g., firewall drop + repeated 4625 failures)
* Validating log source quality before SIEM parsing and indexing

---

## ✅ Result

* syslog-ng installed and configured successfully
* Remote ingestion enabled on UDP and TCP 514
* Router and Windows-like syslog events ingested and visible in `/var/log/messages`
* Log validation checks documented for SIEM parsing readiness

---

## 🏁 Conclusion

This lab established a practical baseline for SIEM data source configuration by installing syslog-ng, enabling remote syslog ingestion, and validating that simulated router and Windows events are received and correctly recorded. These fundamentals prepare for future labs involving parsing, normalization, dashboards, and alerting rules.

✅ Lab completed successfully on Ubuntu (syslog-ng installed, remote ingestion enabled, logs validated)

---
