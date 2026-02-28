# 🛠️ Troubleshooting Guide — Lab 18: Network Traffic & IDS Integration

> This guide covers common issues when installing Snort, enabling rules, installing the Elastic Stack on Ubuntu 24.04, configuring Logstash ingestion, and validating traffic + alert generation.

---

## 1) Snort installation prompts confusion (interface / HOME_NET)

### ✅ Symptoms
- Snort install asks for:
  - interface(s)
  - home network CIDR
- Incorrect values can lead to Snort not monitoring expected traffic.

### ✅ Fix
Confirm your interface:
```bash
ip a
ip route
````

Use the active interface (example: `ens5`) and set HOME_NET to your internal CIDR (example: `172.31.0.0/16`).

If you need to reconfigure Snort’s Debian package settings:

```bash
sudo dpkg-reconfigure snort
```

---

## 2) `snort.service` failed after installation

### ✅ Symptoms

* Installer ends with:

  * `Job for snort.service failed...`

### ✅ Why it happens (common in cloud labs)

* Interface settings mismatch
* Permissions/log directory issues
* Snort expected paths/config not aligned
* Systemd service configuration not ready for the environment

### ✅ Fix / Validation Approach (Lab-safe)

Even if the service fails, validate config using test mode:

```bash
sudo snort -T -c /etc/snort/snort.conf
```

To debug service failure:

```bash
sudo systemctl status snort.service --no-pager
sudo journalctl -xeu snort.service --no-pager | tail -n 100
```

---

## 3) Snort test mode fails (`Snort exiting` with errors)

### ✅ Symptoms

* `sudo snort -T -c /etc/snort/snort.conf` shows parsing errors or missing rule files.

### ✅ Fix Checklist

1. Confirm include path exists:

```bash
ls -l /etc/snort/rules/
```

2. Ensure community rules include line is present in `snort.conf`:

```bash
grep -n "community.rules" /etc/snort/snort.conf
```

3. If rule file missing, ensure `snort-rules-default` is installed:

```bash
dpkg -l | grep snort
sudo apt install snort-rules-default
```

---

## 4) Elastic packages not found (`Unable to locate package elasticsearch`)

### ✅ Symptoms

* `sudo apt install elasticsearch` returns:

  * `E: Unable to locate package elasticsearch`

### ✅ Cause

Ubuntu default repos do not include Elastic Stack packages.

### ✅ Fix (Add Elastic APT repo)

```bash
sudo apt install apt-transport-https ca-certificates curl gnupg -y
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
sudo apt update
sudo apt install elasticsearch logstash kibana
```

---

## 5) Elasticsearch not responding on port 9200

### ✅ Symptoms

* `curl http://localhost:9200` fails or times out.

### ✅ Fix Checklist

1. Check service status:

```bash
sudo systemctl status elasticsearch --no-pager
```

2. View logs:

```bash
sudo journalctl -u elasticsearch --no-pager -n 200
```

3. Confirm port listening:

```bash
sudo ss -lntp | grep 9200
```

---

## 6) Logstash fails to start due to pipeline config

### ✅ Symptoms

* `service logstash start` starts but pipeline errors appear
* Common cause: missing `output {}` block or syntax errors

### ✅ Fix Checklist

1. Validate your pipeline exists:

```bash
ls -l /etc/logstash/conf.d/
```

2. Ensure pipeline has both input and output blocks:

```conf
input { ... }
output { ... }
```

3. Check Logstash logs:

```bash
sudo journalctl -u logstash --no-pager -n 200
```

---

## 7) Logstash ingests nothing (no events appear)

### ✅ Symptoms

* Snort alert file exists, but nothing appears in Elasticsearch index

### ✅ Fix Checklist

1. Confirm Snort alert file path matches config:

* `/var/log/snort/alert`

2. Confirm permissions (Snort file may be readable only by snort/snort group):

```bash
sudo ls -l /var/log/snort/alert
```

If needed, adjust Logstash permissions or run Logstash with correct access patterns (production approach usually uses Filebeat).

3. Confirm Snort is actually writing alert lines:

```bash
sudo tail -n 20 /var/log/snort/alert
```

---

## 8) Kibana not accessible (port 5601 not listening)

### ✅ Symptoms

* Browser connection refused
* `ss -lntp | grep 5601` returns nothing

### ✅ Fix

Check Kibana service:

```bash
sudo systemctl status kibana --no-pager
sudo journalctl -u kibana --no-pager -n 200
```

Confirm port:

```bash
sudo ss -lntp | grep 5601
```

---

## 9) Example traffic does not show up as alerts

### ✅ Symptoms

* `curl` and `ping` work, but Snort alert file is unchanged

### ✅ Fix Checklist

1. Ensure Snort is running in a mode that captures traffic (not only test mode).
2. Confirm correct interface is monitored (ens5).
3. Confirm rules exist that detect your traffic patterns.
4. Check if the alert file is being written by Snort:

```bash
sudo tail -n 50 /var/log/snort/alert
```

> In this lab, alert evidence exists (ICMP + HTTP observed), confirming Snort logging is active.

---

## ✅ Quick Validation Checklist (After Fixes)

Run:

```bash
sudo snort -T -c /etc/snort/snort.conf
curl -s http://localhost:9200 | head
sudo ss -lntp | egrep '(:9200|:5601)' || true
sudo ls -l /var/log/snort/alert
sudo tail -n 10 /var/log/snort/alert
```

If Snort validates successfully, Elasticsearch responds, Kibana listens, and the alert file contains entries, the IDS → SIEM pipeline is ready for further tuning.

---
