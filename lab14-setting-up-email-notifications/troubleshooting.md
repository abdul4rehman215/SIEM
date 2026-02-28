# 🛠️ Troubleshooting Guide — Lab 14: Setting Up Email Notifications

> This guide covers common issues when configuring email notifications using a local SMTP relay (Postfix) and validating alert delivery via a CLI alert script.

---

## 1) Postfix service is not running

### ✅ Symptoms
- `systemctl status postfix` shows **inactive**, **failed**, or **not-found**
- Email does not deliver to local mailbox

### ✅ Fix
```bash
sudo systemctl enable --now postfix
systemctl status postfix --no-pager
````

### 🔎 Check logs

```bash
sudo journalctl -u postfix --no-pager -n 100
```

---

## 2) Postfix installation prompts block automation

### ✅ Symptoms

* `apt install postfix` opens configuration prompts and pauses

### ✅ Fix

During install, choose a safe lab configuration such as:

* **General type of mail configuration:** *Internet Site* (or *Local only* depending on lab)
* **System mail name:** default is fine for lab

If needed, reconfigure:

```bash
sudo dpkg-reconfigure postfix
```

---

## 3) `mail` command not found

### ✅ Symptoms

* Running `mail` returns: `command not found`

### ✅ Fix

```bash
sudo apt install -y mailutils
```

Verify:

```bash
which mail
mail --help | head
```

---

## 4) Email is sent but mailbox is empty

### ✅ Symptoms

* Script prints `[INFO] Alert sent ...`
* `sudo -u admin mail` shows no messages

### ✅ Fix Checklist

1. Confirm local mailbox file exists:

```bash
ls -l /var/mail/
ls -l /var/mail/admin
```

2. Confirm Postfix queue is not stuck:

```bash
mailq
```

3. Inspect mail log (if available):

```bash
sudo tail -n 100 /var/log/mail.log 2>/dev/null || true
sudo journalctl -u postfix --no-pager -n 100
```

4. Ensure the recipient user exists:

```bash
id admin
```

If user missing:

```bash
sudo adduser --disabled-password --gecos "" admin
```

---

## 5) Alert does not trigger (count stays 0)

### ✅ Symptoms

* Script prints: `[INFO] No alert triggered (count=0, threshold=5)`
* But you believe logs exist

### ✅ Fix Checklist

1. Confirm the logs actually contain the keyword used:

```bash
journalctl --since "5 minutes ago" | grep "Failed password" | tail -n 20
```

2. Ensure your simulated messages match **exact string**:

* Script searches for: `Failed password`

3. If your environment doesn’t log sshd messages to journal:

* Try checking `/var/log/auth.log` (if present)

```bash
sudo ls -l /var/log/auth.log
sudo tail -n 50 /var/log/auth.log
```

4. Simulate again:

```bash
for i in {1..5}; do
  logger -t sshd "Failed password for invalid user testuser from 203.0.113.25 port 552$i ssh2"
done
```

---

## 6) `journalctl --since "1 minute ago"` returns permission errors

### ✅ Symptoms

* `journalctl` shows: `Failed to open journal files: Permission denied`
* Script count fails or becomes 0

### ✅ Fix

Run the script with sufficient privileges:

```bash
sudo /usr/local/bin/failed_login_alert.sh
```

Or allow user to read logs (not recommended in real production unless justified):

```bash
sudo usermod -aG systemd-journal toor
# log out and log back in
```

---

## 7) Script sends multiple emails repeatedly (alert spam)

### ✅ Symptoms

* Every run triggers another email if logs remain in window

### ✅ Fix (Lab-safe improvement idea)

Add a cooldown/lock file (not implemented in this lab by default):

* Create a timestamp file and only alert once per X minutes
* Or store last alert time and enforce suppression

Example approach (concept):

* `/tmp/failed_login_alert_last_sent`

---

## 8) SMTP TLS confusion (TLS enabled but using localhost:25)

### ✅ Symptoms

* TLS errors if you attempt TLS on local relay without configuration

### ✅ Fix

For local relay testing, use:

* `smtp_host = localhost`
* `smtp_port = 25`
* `smtp_use_tls = false`

If using external SMTP later (production), enable TLS and configure credentials properly.

---

## 9) Emails delayed or stuck in queue

### ✅ Symptoms

* `mailq` shows queued messages

### ✅ Fix

Try flushing the queue:

```bash
sudo postfix flush
mailq
```

Check Postfix logs:

```bash
sudo journalctl -u postfix --no-pager -n 200
```

---

## ✅ Quick Validation Checklist (After Fixes)

Run these checks:

```bash
systemctl status postfix --no-pager
journalctl --since "2 minutes ago" | grep "Failed password" | tail -n 5
/usr/local/bin/failed_login_alert.sh
sudo -u admin mail
```

If the mailbox shows the message with subject **"Alert: Failed Login Attempts"**, the lab workflow is validated end-to-end.

---
