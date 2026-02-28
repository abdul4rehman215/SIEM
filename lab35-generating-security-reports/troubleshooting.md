# 🛠️ Troubleshooting Guide — Lab 35: Generating Security Reports (OSSEC + Zeek)

> This guide covers common issues with tool installation (missing packages), service startup, log generation, report extraction, and exporting reports to PDF/CSV.

---

## 1) `Unable to locate package ossec-hids`

### ❗ Problem
Running:
```bash
sudo apt-get install ossec-hids
````

returns:

* `E: Unable to locate package ossec-hids`

### ✅ Cause

On Ubuntu 24.04, OSSEC may not be available in default repositories.

### ✅ Resolution (Lab approach)

Install from source:

```bash id="ts35_1"
sudo apt-get update
sudo apt-get install -y build-essential zlib1g-dev libpcre2-dev curl
wget -O ossec-hids.tar.gz https://github.com/ossec/ossec-hids/archive/refs/tags/3.7.0.tar.gz
tar -xzf ossec-hids.tar.gz
cd ossec-hids-3.7.0
sudo ./install.sh
sudo /var/ossec/bin/ossec-control start
```

### ✅ Prevention

Confirm package availability for your distro version or plan for source installs.

---

## 2) OSSEC does not start or shows missing components

### ❗ Problem

OSSEC start fails or daemons don’t launch properly.

### ✅ Possible Causes

* build dependencies missing
* incomplete install
* permission issues

### ✅ Resolution

Restart and re-check:

```bash id="ts35_2"
sudo /var/ossec/bin/ossec-control restart
```

If still failing, check logs:

```bash id="ts35_3"
sudo tail -n 80 /var/ossec/logs/ossec.log
```

### ✅ Prevention

Ensure install completes successfully and monitor the OSSEC log after configuration changes.

---

## 3) OSSEC syscheck monitoring doesn’t seem to trigger

### ❗ Problem

No integrity events appear after enabling syscheck.

### ✅ Possible Causes

* syscheck frequency is long (3600 seconds)
* no file changes occurred in monitored directories
* OSSEC not restarted after config change

### ✅ Resolution

Restart OSSEC after config edits:

```bash id="ts35_4"
sudo /var/ossec/bin/ossec-control restart
```

Wait for next scan interval or reduce frequency temporarily (lab-only).

### ✅ Prevention

After changing `ossec.conf`, restart OSSEC and validate log activity.

---

## 4) `Unable to locate package zeek`

### ❗ Problem

Running:

```bash
sudo apt-get install zeek
```

returns:

* `E: Unable to locate package zeek`

### ✅ Cause

Zeek often requires an external repository on some Ubuntu versions.

### ✅ Resolution (Lab approach)

Add repo + install:

```bash id="ts35_5"
sudo apt-get install -y gnupg apt-transport-https
echo "deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_24.04/ /" | sudo tee /etc/apt/sources.list.d/zeek.list
curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_24.04/Release.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/zeek.gpg
sudo apt-get update
sudo apt-get install -y zeek
```

### ✅ Prevention

Verify package sources for security tooling on newer distributions.

---

## 5) `zeekctl deploy` shows permission warnings

### ❗ Problem

Deploy outputs:

* `Warning: cannot write to /opt/zeek/logs (permission denied)`

### ✅ Possible Causes

* log directory not created yet
* permissions needed for Zeek user/group

### ✅ Resolution

Since deploy created the directory and started Zeek in this lab, validate status:

```bash id="ts35_6"
sudo zeekctl status
ls -ld /opt/zeek/logs /opt/zeek/logs/current
```

If logs still fail to write, fix ownership:

```bash id="ts35_7"
sudo chown -R zeek:zeek /opt/zeek/logs
```

### ✅ Prevention

Confirm `/opt/zeek/logs` is writable by the Zeek runtime user.

---

## 6) Zeek logs directory is empty

### ❗ Problem

`/opt/zeek/logs/current` has no `.log` files.

### ✅ Possible Causes

* Zeek not running
* low/no network traffic
* deploy not successful

### ✅ Resolution

Check status:

```bash id="ts35_8"
sudo zeekctl status
```

Restart Zeek:

```bash id="ts35_9"
sudo zeekctl stop
sudo zeekctl deploy
```

Generate a little traffic (lab-safe):

```bash id="ts35_10"
curl -I http://example.com | head
```

### ✅ Prevention

Validate Zeek status and confirm log generation before report extraction.

---

## 7) `grep "CRITICAL"` returns nothing

### ❗ Problem

No matches found and exit code is `1`.

### ✅ Cause

This is normal if there are no CRITICAL strings in the logs.

### ✅ Resolution

Use other meaningful patterns for reporting:

* `error`
* `weird`
* `notice`
* `warning`

Example:

```bash id="ts35_11"
grep -i "error" /opt/zeek/logs/current/*.log | head
```

### ✅ Prevention

Choose report indicators based on the log sources you actually have.

---

## 8) `pandoc: command not found`

### ❗ Problem

Running `pandoc --version` fails.

### ✅ Resolution

Install pandoc:

```bash id="ts35_12"
sudo apt-get update
sudo apt-get install -y pandoc
```

### ✅ Prevention

Validate export tooling before report conversion tasks.

---

## 9) PDF generated but looks “plain”

### ❗ Problem

The PDF output is minimal formatting.

### ✅ Cause

`summary.log` is raw text; pandoc converts it as-is.

### ✅ Resolution (Optional improvement)

Convert from markdown instead of raw log text:

* wrap report in a `.md` template and export via pandoc for cleaner presentation.

### ✅ Prevention

Use a structured report template if stakeholder readability matters.

---

## 10) CSV output splits unevenly / columns look inconsistent

### ❗ Problem

CSV rows have varying column counts because log lines differ.

### ✅ Cause

The script splits on whitespace, but logs have variable formatting.

### ✅ Resolution (Practical)

This is acceptable for a quick export. For cleaner CSV, parse the fields more deliberately (e.g., split on tabs for Zeek logs or parse “file:line message” format separately).

### ✅ Prevention

Use structured logs (Zeek TSV/JSON) for stable CSV exports when possible.

---
