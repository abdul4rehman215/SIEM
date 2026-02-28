# 🧠 Interview Q&A — Lab 37: Onboarding a New Log Source

---

## 1) What does “onboarding a new log source” mean in a SIEM context?
It means integrating a new system/device/application so its logs are collected, parsed into structured fields, and made searchable and alertable inside the SIEM.

---

## 2) What was the new log source in this lab?
A **simulated IoT device** (Raspberry Pi–style) producing **JSON-formatted events** into a log file.

---

## 3) Why simulate the IoT log source instead of using real hardware?
In cloud lab environments, physical devices are usually unavailable. Simulating logs is a realistic way to practice onboarding workflows (collection, parsing, validation) without hardware.

---

## 4) What collector/agent was used for log ingestion?
**Wazuh agent** was used as the collector on the log source host.

---

## 5) What happened when trying to install `wazuh-agent` using default Ubuntu repositories?
The package was not found (`Unable to locate package wazuh-agent`), which is common when tools require official vendor repositories.

---

## 6) How was Wazuh agent installed successfully?
By adding the **official Wazuh repository and GPG key**, then installing via `apt`.

---

## 7) Where is the Wazuh agent configuration located?
`/var/ossec/etc/ossec.conf`

---

## 8) How did you configure Wazuh to collect the IoT logs?
By adding a `<localfile>` block pointing to the custom log file:
- `/var/log/iot_device/iot_events.log`

---

## 9) Why was `log_format` set to `json`?
Because the log entries are JSON. Setting `<log_format>json</log_format>` allows Wazuh to automatically parse keys into structured fields.

---

## 10) What is the purpose of configuring the manager/server address in the agent?
The agent must know where to forward logs. The `<client><server>` section defines:
- manager IP/hostname
- port
- protocol (tcp/udp)

---

## 11) How did you verify the agent was running?
By checking service status:
```bash
systemctl status wazuh-agent
````

---

## 12) How did you verify logs were being collected and forwarded?

By viewing agent logs:

```bash
sudo tail -f /var/ossec/logs/ossec.log
```

The output showed logcollector analyzing/reading the file and agent connecting to the server.

---

## 13) How did you validate the JSON logs were well-formed?

Using `jq` to parse them:

```bash
cat /var/log/iot_device/iot_events.log | jq -c '.'
```

---

## 14) What types of detections could this IoT log source enable?

Examples:

* multiple failed logins for the same `device_id` (brute-force pattern)
* unusual `usb_event` (possible physical tampering)
* abnormal device telemetry (unexpected temperature/value spikes)

---

## 15) What is the main takeaway from this lab?

Effective onboarding requires validating at multiple layers:

* the source log file exists and contains correct data
* the agent collects and parses logs correctly
* logs are forwarded to the SIEM manager
* structured fields appear in the SIEM UI for filtering, correlation, and alerting

---
