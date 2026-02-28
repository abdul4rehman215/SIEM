# 🛠️ Troubleshooting Guide — Lab 37: Onboarding a New Log Source (Wazuh Agent + JSON Logs)

> This guide covers common issues during onboarding: installation problems, agent connectivity, log collection, parsing, and validation.

---

## 1) `Unable to locate package wazuh-agent`

### ❗ Problem
Installing with:
```bash
sudo apt-get install wazuh-agent
````

returns:

* `E: Unable to locate package wazuh-agent`

### ✅ Cause

Wazuh agent is not in Ubuntu default repositories. It requires the official Wazuh repo.

### ✅ Resolution (Lab approach)

```bash
sudo apt-get update
sudo apt-get install -y curl gnupg apt-transport-https
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo gpg --dearmor -o /etc/apt/keyrings/wazuh.gpg
echo "deb [signed-by=/etc/apt/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list
sudo apt-get update
sudo apt-get install -y wazuh-agent
```

### ✅ Prevention

Confirm required third-party repos before provisioning SIEM agents.

---

## 2) Wazuh agent service fails to start

### ❗ Problem

`systemctl start wazuh-agent` fails or shows `failed`.

### ✅ Possible Causes

* invalid config syntax in `/var/ossec/etc/ossec.conf`
* permission issues
* missing dependencies

### ✅ Resolution

Check status and logs:

```bash
systemctl status wazuh-agent --no-pager
sudo journalctl -u wazuh-agent --no-pager | tail -n 80
sudo tail -n 80 /var/ossec/logs/ossec.log
```

Fix config issues and restart:

```bash
sudo systemctl restart wazuh-agent
```

### ✅ Prevention

Edit config carefully and validate changes with logs after restart.

---

## 3) Agent cannot connect to manager/server

### ❗ Problem

Agent log shows connection retries or no connection lines.

### ✅ Possible Causes

* wrong manager IP/port/protocol
* firewall blocking traffic
* manager service not running
* network routing issues

### ✅ Resolution

Verify `<client><server>` in `ossec.conf`:

* address
* port (often 1514)
* protocol (tcp/udp)

Check connectivity (basic):

```bash
# For TCP check (if allowed in lab)
nc -vz 192.168.56.10 1514
```

Check agent logs:

```bash
sudo tail -n 120 /var/ossec/logs/ossec.log
```

### ✅ Prevention

Confirm manager endpoint is reachable and firewall allows port 1514.

---

## 4) Custom log file not being collected

### ❗ Problem

No “Analyzing file” messages for the custom log path.

### ✅ Possible Causes

* wrong `<location>` path
* file doesn’t exist
* permissions prevent agent from reading file
* `<localfile>` block placed incorrectly in config

### ✅ Resolution

Verify file exists:

```bash
sudo ls -l /var/log/iot_device/iot_events.log
sudo head -n 5 /var/log/iot_device/iot_events.log
```

Ensure readable:

```bash
sudo chmod 644 /var/log/iot_device/iot_events.log
sudo chown root:root /var/log/iot_device/iot_events.log
```

Restart agent:

```bash
sudo systemctl restart wazuh-agent
sudo tail -n 60 /var/ossec/logs/ossec.log
```

### ✅ Prevention

Create logs in standard readable locations and verify file permissions.

---

## 5) JSON parsing not working (fields not extracted)

### ❗ Problem

Events show up as raw text or fields are not structured.

### ✅ Possible Causes

* `<log_format>json</log_format>` not set
* invalid JSON lines
* mixed formatting in log file (some lines not JSON)

### ✅ Resolution

Validate JSON:

```bash
sudo apt-get install -y jq
sudo cat /var/log/iot_device/iot_events.log | jq -c '.' | head -n 5
```

Confirm config:

```xml
<localfile>
  <log_format>json</log_format>
  <location>/var/log/iot_device/iot_events.log</location>
</localfile>
```

Restart agent after edits:

```bash
sudo systemctl restart wazuh-agent
```

### ✅ Prevention

Keep each log line valid JSON and avoid trailing commas or partial JSON fragments.

---

## 6) Logs are collected locally but not visible in SIEM UI

### ❗ Problem

Agent reads the file, but events don’t appear in the dashboard.

### ✅ Possible Causes

* agent connected but manager ingestion not configured
* indexer pipeline issues (outside agent scope)
* wrong time range or wrong index in UI
* filtering not matching the correct field

### ✅ Resolution

Confirm agent shows “Connected to server” in `ossec.log`.
If UI is available:

* broaden time range (Last 24h / Last 7 days)
* search/filter by log location:

  * `location:/var/log/iot_device/iot_events.log`
* verify correct index/data view selection

### ✅ Prevention

Validate ingestion at each hop (agent → manager → indexer → UI).

---

## 7) Too much noise / too many events after onboarding

### ❗ Problem

New source floods SIEM with high-volume telemetry.

### ✅ Possible Causes

* high-frequency logs from device
* no filtering/deduplication
* lack of rule tuning

### ✅ Resolution

* tune source logging level
* implement basic filtering at source (only security-relevant keys)
* create Wazuh rules for prioritization and suppression if needed

### ✅ Prevention

Start with a small set of key events, then expand coverage gradually.

---
