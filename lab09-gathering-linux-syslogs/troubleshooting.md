# 🛠️ Troubleshooting Guide — Lab 09: Gathering Linux Syslogs

---

## Issue 1: rsyslog service not found / not running

### ❌ Problem
`systemctl status rsyslog` fails or shows inactive.

### ✅ Resolution
Install and start:
```bash
sudo apt update
sudo apt install -y rsyslog
sudo systemctl enable --now rsyslog
````

---

## Issue 2: UDP listener not receiving logs

### ❌ Problem

Remote syslog events are not received.

### ✅ Causes

* imudp module not enabled
* port not configured
* firewall/security group blocking UDP/514

### ✅ Resolution

Ensure these lines exist in `/etc/rsyslog.conf`:

```conf
module(load="imudp")
input(type="imudp" port="514")
```

Restart:

```bash id="6psm1u"
sudo systemctl restart rsyslog
```

---

## Issue 3: Logs not appearing in SIEM

### ❌ Problem

Local syslog shows events but SIEM does not.

### ✅ Causes

* forwarding destination unreachable
* SIEM not listening on port 5544
* wrong IP/port
* protocol mismatch (UDP vs TCP)

### ✅ Resolution

* verify forwarding rule:

```bash id="7ddgy1"
sudo grep -n '\*\.\* @' /etc/rsyslog.conf
```

* confirm SIEM receiver is listening on the correct port
* if TCP is required, use `@@` instead of `@`

---

## Issue 4: rsyslog config syntax errors

### ❌ Problem

rsyslog fails to start after editing config.

### ✅ Resolution

Check service logs:

```bash id="4n6052"
sudo journalctl -u rsyslog -xe --no-pager | tail -50
```

Revert recent changes or fix syntax and restart:

```bash id="23b7y8"
sudo systemctl restart rsyslog
```

---

## Issue 5: No test message shows up locally after using logger

### ❌ Problem

`logger` run but message not found.

### ✅ Resolution

Try searching:

```bash id="f2s6b1"
sudo grep -R "Test log message" /var/log/syslog /var/log/messages 2>/dev/null
```

Also check journald:

```bash id="3d1x7h"
sudo journalctl -n 50 --no-pager
```

---
