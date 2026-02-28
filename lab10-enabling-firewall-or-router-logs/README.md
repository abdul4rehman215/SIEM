# 🧪 Lab 10: Enabling Firewall or Router Logs

## 🧾 Lab Summary
This lab demonstrates how to **enable and forward firewall/router logs** to a SIEM using syslog. The lab uses:
- An **OpenWrt** router/firewall (SSH access + UCI configuration)
- A **CentOS 7** SIEM receiver host (rsyslog + tcpdump validation)

Key outcomes:
- Verified syslog support on the router (OpenWrt `logd` + UCI syslog fields)
- Configured router syslog forwarding destination (SIEM IP + port + protocol)
- Increased log verbosity (debug-like behavior via log level settings)
- Confirmed syslog packets reaching the SIEM using `tcpdump`
- Generated a router test syslog event using `logger`
- Verified the message was written on the SIEM host’s `/var/log/messages`

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Enable logging on a router/firewall device
- Configure log destination and verbosity for monitoring
- Verify logs are being captured and received by a SIEM
- Validate ingestion using packet capture (`tcpdump`) and SIEM log file review

---

## ✅ Prerequisites
- Basic understanding of routers/firewalls and syslog concepts
- Administrative access to a router/firewall device
- A SIEM receiver host (or syslog receiver) accessible on the network
- Terminal/CLI tools (ssh, tcpdump) available

---

## 🧪 Lab Environment
### Router / Firewall Device
- **OS:** OpenWrt 23.05.2 (SSH access)
- **Router IP:** `192.168.1.1`
- **User:** `admin` (SSH login)
- **Log process:** `/sbin/logd`

### SIEM / Log Receiver Host
- **OS:** CentOS 7 (receiver VM)
- **Interface:** `eth0`
- **SIEM IP:** `10.0.2.15/24`
- **Receiver Port:** UDP/514
- **Validation tools:** tcpdump, rsyslog, /var/log/messages

---

## 🛠️ Tasks Overview (What I Did)

### ✅ Task 1 — Identify Router/Firewall Log Support
- SSH into router:
  - `ssh admin@192.168.1.1`
- Verified logging process on OpenWrt:
  - `ps | grep -E "logd|syslog"`
- Verified syslog forwarding fields exist using UCI:
  - `uci show system.@system[0] | grep -E "log_|log"`
- Confirmed that `log_ip` is empty initially (no forwarding configured)

---

### ✅ Task 2 — Configure Log Level and Destination
- Configured router syslog destination:
  - SIEM: `10.0.2.15`
  - Port: `514`
  - Protocol: `udp`
- Increased router log verbosity:
  - `conloglevel='8'`
  - `cronloglevel='8'`
- Restarted router logging services:
  - `/etc/init.d/log restart`
- Verified settings were applied via UCI show output

---

### ✅ Task 3 — Verify Logs Reaching SIEM
- On SIEM server (CentOS 7):
  - Verified interface and IP:
    - `ip a show eth0`
  - Captured syslog traffic from router:
    - `tcpdump -i eth0 'udp port 514 and host 192.168.1.1' -nn`
  - Confirmed syslog packets arriving (3 packets captured)
- Generated a test syslog message on router:
  - `logger -p local0.notice "Firewall/Router syslog test from $(hostname)"`
- Verified message received on SIEM:
  - `tail -n 10 /var/log/messages`
- Confirmed end-to-end forwarding: router → syslog → SIEM receiver

---

## ✅ Verification & Validation
- Router syslog support confirmed:
  - `ps | grep logd`
  - `uci show system.@system[0] ... log_*`
- Router forwarding config validated:
  - `log_ip='10.0.2.15'`, `log_port='514'`, `log_proto='udp'`
- Network validation:
  - `tcpdump` shows syslog packets from `192.168.1.1` to `10.0.2.15:514`
- SIEM receiver validation:
  - `/var/log/messages` contains forwarded router test log

---

## 📁 Repository Structure
```text
lab10-enabling-firewall-or-router-logs/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── configs/
    ├── openwrt_syslog_uci_commands.txt
    └── tcpdump_filter.txt
````

---

## 🌍 Why This Matters

Firewall/router logs provide high-signal security telemetry:

* inbound/outbound drops
* NAT activity
* admin access attempts
* routing and network anomalies

Forwarding these logs into a SIEM enables correlation with endpoint and server logs, improving detection, triage, and incident response visibility.

---

## 🧩 Real-World Applications

* Detecting scanning and attack attempts through firewall drops
* Identifying unauthorized router configuration changes
* Correlating failed logons (Windows/Linux) with firewall activity
* Building alert rules by facility/severity and known patterns
* Supporting SOC monitoring and incident response timelines

---

## ✅ Result

* Router logging verified active and syslog forwarding capability confirmed
* Syslog destination configured to SIEM (`10.0.2.15:514/udp`)
* Log verbosity increased
* Syslog packets validated using tcpdump
* Test router message received and written on SIEM host log file
* End-to-end forwarding confirmed as functioning

---

## 🏁 Conclusion

This lab enabled and validated firewall/router logging to a SIEM using syslog forwarding. By configuring OpenWrt syslog destination settings and verifying delivery using packet capture and SIEM-side log review, the lab demonstrated a cost-effective and realistic approach to centralized network monitoring.

✅ Lab completed successfully (router/firewall syslog forwarding enabled + validated)

---
