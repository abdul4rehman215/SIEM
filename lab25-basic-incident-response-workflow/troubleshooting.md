# 🛠️ Troubleshooting Guide — Lab 25: Basic Incident Response Workflow (Fail2Ban + ELK)

> This guide covers common problems while configuring Fail2Ban, triggering bans, and ingesting Fail2Ban logs into ELK.

---

## 1) Fail2Ban service not running

### ✅ Symptoms
- `systemctl status fail2ban` shows inactive/failed
- `fail2ban-client` cannot connect

### ✅ Fix
```bash
sudo systemctl enable --now fail2ban
sudo systemctl restart fail2ban
sudo systemctl status fail2ban --no-pager | head -n 15
````

If it still fails, check logs:

```bash
sudo journalctl -u fail2ban --no-pager -n 200
```

---

## 2) `sshd` jail not listed / not enabled

### ✅ Symptoms

* `fail2ban-client status` shows no `sshd` in jail list
* `Number of jail: 0`

### ✅ Fix Checklist

1. Ensure `/etc/fail2ban/jail.local` exists and includes:

```ini
[sshd]
enabled = true
```

2. Restart Fail2Ban:

```bash
sudo systemctl restart fail2ban
sudo fail2ban-client status
```

3. Validate jail config:

```bash
sudo fail2ban-client -d | head -n 40
```

---

## 3) Incorrect `logpath` (`/var/log/auth.log` missing or empty)

### ✅ Symptoms

* Jail enabled but no bans happen
* Fail2Ban logs show it cannot read auth.log

### ✅ Fix

On Ubuntu, SSH auth failures are typically in:

* `/var/log/auth.log` (when rsyslog writes it)

Check if file exists:

```bash
sudo ls -l /var/log/auth.log
```

If missing, check journal:

```bash
sudo journalctl -u ssh --since "30 min ago" | tail -n 50
```

If system uses journald-only logging, consider configuring Fail2Ban backend:

```ini
# in jail.local
backend = systemd
```

Then restart:

```bash
sudo systemctl restart fail2ban
```

---

## 4) Ban does not trigger even after multiple failed SSH attempts

### ✅ Symptoms

* `Total failed` increases but `Currently banned` stays 0
* or `Total failed` stays 0 (no detection)

### ✅ Fix Checklist

1. Confirm jail thresholds:

* `maxretry = 3`
* `findtime = 600`

2. Confirm SSH attempts are actually failing and logged:

```bash
sudo tail -n 50 /var/log/auth.log
```

3. Check jail status:

```bash
sudo fail2ban-client status sshd
```

4. Force a lower threshold for testing (lab only):

```ini
maxretry = 2
findtime = 300
bantime = 600
```

Restart Fail2Ban.

---

## 5) Banned IP is `127.0.0.1` (unexpected)

### ✅ Explanation

In this lab, brute-force was simulated from localhost using:

* `ssh wronguser@localhost`

So Fail2Ban bans the source IP seen in logs, which becomes `127.0.0.1`.

### ✅ If you want a non-local IP in lab

Simulate attempts from another host/VM, or generate auth-like logs with a different source IP (advanced lab approach).

---

## 6) Want to unban during lab (restore access)

### ✅ Command

```bash
sudo fail2ban-client set sshd unbanip 127.0.0.1
sudo fail2ban-client status sshd
```

---

## 7) Logstash pipeline fails after adding `fail2ban.conf`

### ✅ Symptoms

* `systemctl status logstash` shows failed
* `journalctl -u logstash` shows pipeline errors

### ✅ Fix Checklist

1. Validate Logstash logs:

```bash
sudo journalctl -u logstash --no-pager -n 200
```

2. Common issues:

* wrong braces in config
* invalid grok pattern
* missing output block

3. Quick config sanity:
   Ensure you have:

* `input { ... }`
* `filter { ... }`
* `output { ... }`

---

## 8) Grok parsing not extracting fields (timestamp/level/details missing)

### ✅ Symptoms

* documents appear in Elasticsearch but fields are unparsed
* only `message` exists

### ✅ Fix

Confirm Fail2Ban log format matches your grok:

```bash
sudo head -n 5 /var/log/fail2ban.log
```

If format differs, adjust grok accordingly.
As a fallback, ingest raw logs and parse later, or add `dissect` filter (often simpler than grok).

---

## 9) Elasticsearch index `fail2ban-YYYY.MM.dd` not appearing

### ✅ Symptoms

* `/_cat/indices` shows no fail2ban index

### ✅ Fix Checklist

1. Confirm Elasticsearch reachable:

```bash
curl -s http://localhost:9200 | head
```

2. Confirm Logstash running:

```bash
sudo systemctl status logstash --no-pager | head -n 20
```

3. Force Logstash to read file from beginning (lab only):

* keep:

  * `sincedb_path => "/dev/null"`
  * `start_position => "beginning"`

4. Confirm Fail2Ban log has events:

```bash
sudo tail -n 20 /var/log/fail2ban.log
```

---

## 10) Kibana can’t find data / no documents in Discover

### ✅ Symptoms

* Kibana Discover shows no results

### ✅ Fix

1. Create a Data View:

* `fail2ban-*`

2. Ensure time picker covers event time:

* set to Last 24 hours (or wider)

3. Validate ES has docs:

```bash
curl -s "http://localhost:9200/fail2ban-*/_count?pretty"
```

---

## ✅ Quick Validation Checklist (After Fixes)

```bash
# Fail2Ban running and sshd jail enabled
sudo systemctl status fail2ban --no-pager | head -n 12
sudo fail2ban-client status

# Confirm ban evidence
sudo fail2ban-client status sshd
sudo tail -n 20 /var/log/fail2ban.log

# ELK pipeline checks
curl -s http://localhost:9200 | head
sudo systemctl status logstash --no-pager | head -n 12

# Confirm index exists and has docs
curl -s "http://localhost:9200/_cat/indices?v" | grep fail2ban || true
curl -s "http://localhost:9200/fail2ban-*/_search?size=3&pretty"
```

Expected:

* `sshd` jail listed
* ban event appears in Fail2Ban logs
* fail2ban index exists in Elasticsearch and contains Ban/Found events

---
