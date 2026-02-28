# 🛠️ Troubleshooting Guide — Lab 17: Host Monitoring Configuration

> This guide covers common issues when installing and configuring OSSEC for host monitoring, enabling syscheck, and validating alerts via OSSEC logs.

---

## 1) OSSEC service not found (`Unit ossec.service could not be found`)

### ✅ Symptoms
- `systemctl status ossec` returns:
  - `Unit ossec.service could not be found.`

### ✅ Causes
- Installer did not complete successfully
- OSSEC not installed to expected path
- systemd unit not created

### ✅ Fix
1) Confirm OSSEC exists:
```bash
ls -l /var/ossec/ || true
````

2. Re-run installer:

```bash
sudo sh ossec-installer.sh
```

3. If OSSEC installed but no unit exists, use OSSEC control:

```bash
sudo /var/ossec/bin/ossec-control start
sudo /var/ossec/bin/ossec-control status
```

---

## 2) Installer fails (dependencies / compilation errors)

### ✅ Symptoms

* Installer output shows build errors or missing libraries.

### ✅ Fix

Update packages and install build dependencies:

```bash
sudo apt-get update
sudo apt-get install -y build-essential gcc make libc6-dev zlib1g-dev libpcre2-dev
```

Then re-run:

```bash
sudo sh ossec-installer.sh
```

---

## 3) `wget` fails to download installer script

### ✅ Symptoms

* DNS/connection errors
* TLS errors
* `Unable to resolve host address`

### ✅ Fix Checklist

1. Confirm networking:

```bash
ping -c 2 1.1.1.1
ping -c 2 updates.atomicorp.com
```

2. Try downloading again:

```bash
wget -U ossec https://updates.atomicorp.com/installers/ossec-installer.sh
```

3. If DNS issues exist, verify resolv.conf:

```bash
cat /etc/resolv.conf
```

---

## 4) OSSEC components not running after install

### ✅ Symptoms

* `ossec-control status` shows some components stopped.

### ✅ Fix

Restart OSSEC:

```bash
sudo /var/ossec/bin/ossec-control restart
sudo /var/ossec/bin/ossec-control status
```

Check OSSEC log:

```bash
sudo tail -n 100 /var/ossec/logs/ossec.log
```

---

## 5) Syscheck not detecting changes in monitored directories

### ✅ Symptoms

* You create a file in `/etc` but no syscheck alert appears.

### ✅ Fix Checklist

1. Confirm syscheck configuration contains monitored paths:

```bash
sudo grep -n "<syscheck>" -n /var/ossec/etc/ossec.conf
sudo sed -n '80,120p' /var/ossec/etc/ossec.conf
```

2. Ensure `scan_on_start` is enabled:

* `scan_on_start` helps trigger checks after restart.

3. Restart OSSEC to force scan-on-start behavior:

```bash
sudo /var/ossec/bin/ossec-control restart
```

4. Look for syscheck scan logs:

```bash
sudo grep -i "syscheck" /var/ossec/logs/ossec.log | tail -n 50
```

---

## 6) Alert exists but you can’t find it in `alerts.log`

### ✅ Symptoms

* Syscheck scan occurs, but alerts don’t appear.

### ✅ Fix Checklist

1. Confirm alerts directory exists:

```bash
sudo ls -l /var/ossec/logs/alerts/
```

2. Check alerts log file:

```bash
sudo tail -n 100 /var/ossec/logs/alerts/alerts.log
```

3. Search directly for your file:

```bash
sudo grep -n "monitored_file" /var/ossec/logs/alerts/alerts.log | tail -n 20
```

---

## 7) XML errors after editing `local_rules.xml`

### ✅ Symptoms

* OSSEC fails to start after editing rules
* Logs show parsing errors

### ✅ Cause

Broken XML structure, missing closing tags, nested groups incorrectly.

### ✅ Fix

1. Re-open file and validate structure visually:

```bash
sudo nano /var/ossec/rules/local_rules.xml
```

2. Confirm you did not remove required XML sections.
3. If OSSEC won’t start, revert the last change (remove the added block) and restart.

Check OSSEC logs for rule errors:

```bash
sudo tail -n 200 /var/ossec/logs/ossec.log
```

---

## 8) Alert storm / too many syscheck alerts

### ✅ Symptoms

* Many alerts triggering from frequent file changes

### ✅ Fix (Production tuning ideas)

* Narrow monitored directories
* Reduce sensitivity (`check_all="yes"` is strict)
* Exclude noisy paths (logs, caches)
* Increase `frequency` and only scan critical paths

---

## 9) SIEM “verification” not possible in this environment

### ✅ Symptoms

* No Kibana/Wazuh dashboard access available

### ✅ Lab-Appropriate Validation

This lab validates alerts locally using:

* `/var/ossec/logs/alerts/alerts.log`
  This is the same content a SIEM would ingest and display.

Optional “export” view:

```bash
sudo awk 'BEGIN{p=0} /\*\* Alert/{p=1} p{print}' /var/ossec/logs/alerts/alerts.log | tail -n 30
```

---

## ✅ Quick Validation Checklist (After Fixes)

Run:

```bash
sudo systemctl status ossec --no-pager || true
sudo /var/ossec/bin/ossec-control status
sudo sed -n '90,105p' /var/ossec/etc/ossec.conf
sudo touch /etc/monitored_file
sudo /var/ossec/bin/ossec-control restart
sudo grep -n "monitored_file" /var/ossec/logs/alerts/alerts.log | tail -n 5
```

If the grep finds the file path inside an alert block, syscheck alerting is working correctly.

---
