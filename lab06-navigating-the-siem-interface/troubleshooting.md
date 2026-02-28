# 🛠️ Troubleshooting Guide — Lab 06: Navigating the SIEM Interface

---

## Issue 1: Kibana not running

### ❌ Problem
Kibana UI not reachable or `curl` fails.

### ✅ Resolution
Check service:
```bash
sudo systemctl status kibana --no-pager
````

Start it:

```bash
sudo systemctl start kibana
sudo systemctl enable kibana
```

Check logs:

```bash
sudo journalctl -u kibana -xe --no-pager | tail -50
```

---

## Issue 2: Kibana not listening on port 5601

### ❌ Problem

`ss -lntp | grep :5601` returns nothing.

### ✅ Resolution

Verify Kibana is running:

```bash
sudo systemctl status kibana --no-pager
```

If running but no port:

* check configuration in `/etc/kibana/kibana.yml`
* restart service:

```bash
sudo systemctl restart kibana
```

---

## Issue 3: Login fails in GUI

### ❌ Problem

Credentials rejected or cannot reach home page.

### ✅ Resolution

* Confirm correct user credentials
* Check kibana log for auth errors:

```bash
sudo tail -n 50 /var/log/kibana/kibana.log
```

---

## Issue 4: Selenium script fails with `NoSuchDriverException`

### ❌ Problem

```text
Unable to obtain driver for chrome
```

### ✅ Cause

Chrome/Chromium and chromedriver are not installed or not discoverable.

### ✅ Resolution (typical desktop/lab fix)

Install Chromium and driver (package names can vary by distro):

```bash
sudo apt update
sudo apt install -y chromium-browser chromium-chromedriver
```

Or install Google Chrome + chromedriver manually and ensure PATH is correct.

> 📌 Note: In many cloud labs, GUI browsers are intentionally not installed, so the script is kept as “practice evidence” unless the environment supports it.

---

## Issue 5: Theme settings not visible in UI

### ❌ Problem

Theme/appearance options missing.

### ✅ Cause

Menu layout differs by Kibana version and permissions.

### ✅ Resolution

* Check `Stack Management → Advanced Settings`
* Confirm user role permissions include advanced settings access
* Document theme settings via JSON sample (as done in this lab)

---
