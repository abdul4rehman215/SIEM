# 🛠️ Troubleshooting Guide — Lab 07: Configuring Data Sources

---

## Issue 1: syslog-ng not installed or service missing

### ❌ Problem
`systemctl status syslog-ng` fails or command not found.

### ✅ Resolution
```bash
sudo apt-get update
sudo apt-get install -y syslog-ng
sudo systemctl enable --now syslog-ng
````

---

## Issue 2: syslog-ng not listening on port 514

### ❌ Problem

`ss -lunpt | grep :514` shows nothing.

### ✅ Causes

* remote source block not configured
* service not restarted after config change
* port blocked by firewall

### ✅ Resolution

1. Confirm config includes UDP/TCP sources on 514
2. Restart syslog-ng:

```bash id="p0klb1"
sudo systemctl restart syslog-ng
```

3. Verify ports:

```bash id="i7brj9"
sudo ss -lunpt | grep ':514'
```

---

## Issue 3: Logs not appearing in /var/log/messages

### ❌ Problem

`tail -f /var/log/messages` shows no incoming remote events.

### ✅ Causes

* destination file missing
* remote device not configured to send to collector
* network restrictions/security groups
* wrong IP/port

### ✅ Resolution

Ensure file exists:

```bash id="w5hsq0"
sudo touch /var/log/messages
```

Confirm syslog-ng running:

```bash id="c9qvmu"
sudo systemctl status syslog-ng --no-pager
```

If testing locally, simulate syslog:

```bash id="zq8x1l"
echo '<34>Aug 18 14:05:30 router01 firewall: DROP ...' | nc -u -w1 127.0.0.1 514
```

---

## Issue 4: Remote devices cannot reach collector

### ❌ Problem

Router/endpoint logs not received remotely.

### ✅ Causes

* cloud firewall/security group blocks 514
* local firewall blocks 514
* wrong destination IP (collector IP changed)

### ✅ Resolution

* confirm collector IP via `ip addr show ens5`
* allow UDP/TCP 514 in security group/firewall (lab policy dependent)
* verify port is open:

```bash id="o18x1w"
sudo ss -lunpt | grep ':514'
```

---

## Issue 5: syslog-ng config parser warnings

### ❌ Problem

syslog-ng warns about version mismatch.

### ✅ Cause

Config `@version` does not match installed major version.

### ✅ Resolution

Use `@version: 4.0` for syslog-ng 4.x installs (Ubuntu 24.04 packaging).

---
