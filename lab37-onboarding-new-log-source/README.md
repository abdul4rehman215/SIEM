# 📥 Lab 37: Onboarding a New Log Source

## 🧾 Lab Summary
This lab demonstrated the end-to-end process of onboarding a **new log source** into a SIEM using a **Wazuh agent**. Since a physical IoT device wasn’t available in the cloud VM environment, I simulated a Raspberry Pi–style device by generating **JSON-formatted “IoT syslog-like” events** in a dedicated log file and configured the Wazuh agent to ingest and forward them. Finally, I validated collection and parsing through Wazuh agent logs and confirmed JSON validity locally using `jq`.

---

## 🎯 Objectives
- Understand the workflow of onboarding a new log source into a SIEM
- Install and configure a log collector/agent
- Validate log ingestion and parsing

---

## ✅ Prerequisites
- Basic SIEM architecture understanding (agent → manager → indexer → dashboard)
- Linux command-line familiarity
- Access to a configured open-source SIEM (Wazuh used as example)
- Ability to simulate or access an external log source (IoT/Cloud application)

---

## 🧠 Key Concepts
- **Collector/Agent:** Collects logs at the source and forwards them to SIEM (Wazuh agent)
- **Log Parsing:** Converting raw logs into structured fields (JSON parsing)
- **Onboarding:** Selecting source → shipping logs → parsing → validation in dashboard
- **Validation:** Proving the SIEM is receiving and interpreting the logs correctly

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Hostname | ip-REDACTED |
| User | toor |
| SIEM Agent | Wazuh Agent 4.8.2 |
| Simulated Source | IoT device JSON events (Raspberry Pi–style) |
| IoT Log Path | `/var/log/iot_device/iot_events.log` |
| Agent Config | `/var/ossec/etc/ossec.conf` |
| Manager (example) | `192.168.56.10:1514/tcp` |

> 📌 Note: The “manager IP” is a lab placeholder. In real environments, this is your Wazuh manager/indexer endpoint reachable from the agent.

---

## 🗂️ Repository Structure
```text
lab37-onboarding-new-log-source/
├── README.md
├── commands.sh
├── output.txt
├── configs/
│   └── ossec.conf.snippet
├── artifacts/
│   └── iot_events.log
├── interview_qna.md
└── troubleshooting.md
````

---

## ✅ Tasks Overview (No Commands Here)

### ✅ Task 1: Select a New Source

* Chosen source (simulated):

  * **IoT device logs** (Raspberry Pi–style events in JSON)
* Rationale:

  * Cloud VM lab environment cannot attach real hardware
  * JSON logs are common for IoT telemetry and easy to parse in SIEM

---

### ✅ Task 2: Install/Configure Collector (Wazuh Agent)

* Attempted to install `wazuh-agent` via default repos (package not found)
* Added official Wazuh repository and installed agent successfully
* Created simulated IoT log directory + log file:

  * `/var/log/iot_device/iot_events.log`
* Updated Wazuh agent config (`ossec.conf`) to:

  * monitor the IoT log file using `<localfile>`
  * parse as JSON using `<log_format>json</log_format>`
  * set manager connection details under `<client><server>...`

---

### ✅ Task 3: Validate and Parse Logs in SIEM

* Verified log collection and forwarding via agent logs:

  * `tail -f /var/ossec/logs/ossec.log`
* Confirmed the logcollector was analyzing and reading the IoT log file
* Confirmed the agent connected to the manager endpoint
* Verified JSON formatting using `jq` (local correctness check)
* Performed UI verification steps (Wazuh Dashboard / Discover):

  * filtered by log file location
  * confirmed structured fields exist (key/value/device_id/ip/user/timestamp)

---

## ✅ Results

✔ Wazuh agent installed via official repository
✔ Simulated IoT JSON log source created and populated
✔ Wazuh agent configured to ingest JSON logs from `/var/log/iot_device/iot_events.log`
✔ Agent started and running
✔ Logcollector confirmed reading the new log file
✔ Agent showed connection to server endpoint
✔ JSON validated via `jq`
✔ SIEM UI checks confirmed structured fields visible for searching/filtering

---

## 🌍 Why This Matters

Onboarding new log sources improves:

* visibility across environments (cloud, endpoints, IoT)
* threat detection coverage
* incident investigation timelines (centralized evidence)

Well-parsed logs (structured JSON fields) allow better correlation and alerting (e.g., failed logins, device anomalies, physical access indicators).

---

## 🧩 Real-World Applications

* IoT device fleet monitoring (logins, USB events, sensor anomalies)
* Cloud log onboarding (CloudWatch, GCP logging)
* Endpoint activity visibility (auth failures, system changes)
* Enabling alert logic:

  * repeated failed logins per device
  * unusual USB events
  * unexpected temperature/value spikes (device malfunction or tampering)

---

## 🧠 What I Learned

* How to install Wazuh agent using official repositories when default repos lack packages
* How to onboard a new custom log file using `<localfile>` configuration
* How JSON parsing in Wazuh enables searchable structured fields
* How to validate ingestion at multiple layers:

  * file content
  * agent logcollector
  * SIEM dashboard visibility

---

## ✅ Conclusion

This lab successfully onboarded a simulated IoT log source into Wazuh by configuring the agent to monitor and parse JSON logs, confirming log transmission, validating parsing structure, and verifying visibility in the SIEM interface.

---
