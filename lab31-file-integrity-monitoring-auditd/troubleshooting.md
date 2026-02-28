# 🛠️ Troubleshooting Guide — Lab 31: File Integrity Monitoring (FIM) with auditd

> This guide covers common installation, service, rule, and log-search issues when using auditd for file integrity monitoring.

---

## 1) `apt-get install auditd` fails or packages not found

### ❗ Problem
Installation fails with errors like:
- `Unable to locate package auditd`
- repository errors

### ✅ Possible Causes
- Package lists not updated
- Network/DNS issues in lab environment
- Repository misconfiguration

### ✅ Resolution
Update package lists and retry:
```bash id="l31ts1"
sudo apt-get update
sudo apt-get install -y auditd audispd-plugins
````

Check connectivity if needed:

```bash id="l31ts2"
ping -c 2 archive.ubuntu.com
```

### ✅ Prevention

Always run `apt-get update` before installing packages.

---

## 2) auditd service not starting

### ❗ Problem

`systemctl start auditd` fails or service shows `failed`.

### ✅ Possible Causes

* Conflicting audit settings
* Kernel audit disabled
* Permission or configuration errors

### ✅ Resolution

Check detailed status and logs:

```bash id="l31ts3"
systemctl status auditd --no-pager
sudo journalctl -u auditd --no-pager | tail -n 50
```

Restart service:

```bash id="l31ts4"
sudo systemctl restart auditd
```

### ✅ Prevention

Verify kernel auditing support and keep default configs for training labs unless customizing.

---

## 3) `auditctl: command not found`

### ❗ Problem

Running:

```bash
auditctl -v
```

returns `command not found`.

### ✅ Possible Causes

* audit tools not installed correctly
* package install incomplete

### ✅ Resolution

Reinstall auditd package:

```bash id="l31ts5"
sudo apt-get update
sudo apt-get install -y auditd audispd-plugins
which auditctl
auditctl -v
```

### ✅ Prevention

Verify tool paths after installation.

---

## 4) `sudo auditctl -w ...` works but events are not logged

### ❗ Problem

Rule appears present but `ausearch` shows no matching events.

### ✅ Possible Causes

* No real write/attribute change occurred
* Rule removed after reboot (runtime rules only)
* auditd not running at event time
* editing tool did not write changes (no file save)

### ✅ Resolution

1. Confirm auditd is running:

```bash id="l31ts6"
systemctl status auditd --no-pager | head -n 12
```

2. Confirm rule exists:

```bash id="l31ts7"
sudo auditctl -l
```

3. Make a controlled change and save:

```bash id="l31ts8"
sudo nano /etc/passwd
```

4. Search again:

```bash id="l31ts9"
sudo ausearch -f /etc/passwd
```

### ✅ Prevention

Always validate rules and generate an intentional, saved change to confirm event capture.

---

## 5) `ausearch` returns too much output

### ❗ Problem

`ausearch -f /etc/passwd` produces many results or is difficult to read.

### ✅ Possible Causes

* Multiple changes occurred
* File monitored frequently

### ✅ Resolution

Filter by key instead of file:

```bash id="l31ts10"
sudo ausearch -k passwd_changes
```

Limit to recent time (if needed):

```bash id="l31ts11"
sudo ausearch -k passwd_changes --start today
```

### ✅ Prevention

Use keys (`-k`) consistently for clean searches.

---

## 6) `aureport` does not show the expected key

### ❗ Problem

Running:

```bash
sudo aureport -f --summary | grep passwd_changes
```

returns nothing.

### ✅ Possible Causes

* No events recorded yet
* key name mismatch (typo)
* auditd restarted and no events since

### ✅ Resolution

1. Verify rule key:

```bash id="l31ts12"
sudo auditctl -l
```

2. Generate a change event and re-check:

```bash id="l31ts13"
sudo nano /etc/passwd
sudo aureport -f --summary | grep passwd_changes
```

### ✅ Prevention

Use consistent keys and generate at least one event after enabling watch rules.

---

## 7) Audit rule disappears after reboot

### ❗ Problem

After reboot, `auditctl -l` no longer shows the watch rule.

### ✅ Cause

`auditctl -w` rules are runtime-only unless saved in persistent rule files.

### ✅ Resolution (Optional improvement)

Persist rules by adding them to audit rules directory:

* Common locations:

  * `/etc/audit/rules.d/*.rules`
  * `/etc/audit/audit.rules`

Example:

```bash id="l31ts14"
echo "-w /etc/passwd -p wa -k passwd_changes" | sudo tee /etc/audit/rules.d/passwd.rules
sudo augenrules --load
sudo systemctl restart auditd
sudo auditctl -l
```

### ✅ Prevention

For production-like setups, store rules in `/etc/audit/rules.d/` so they load automatically at boot.

---

## 8) Risk of editing `/etc/passwd`

### ❗ Problem

A mistake while editing `/etc/passwd` could impact user logins.

### ✅ Safer Approach (Used in this lab)

Make only a minimal, non-structural change (e.g., trailing whitespace) and avoid altering separators/fields.

### ✅ Prevention

Before editing critical files:

* take a backup:

```bash id="l31ts15"
sudo cp /etc/passwd /etc/passwd.bak
```

---

