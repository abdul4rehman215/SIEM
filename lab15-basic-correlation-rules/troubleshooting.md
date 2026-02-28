# 🛠️ Troubleshooting Guide — Lab 15: Basic Correlation Rules

> This troubleshooting guide covers common issues when simulating SIEM correlation logic using Python event generation + rule evaluation scripts.

---

## 1) `python3: command not found`

### ✅ Symptoms
- Running `python3 generate_failed_login_events.py` fails:
  - `python3: command not found`

### ✅ Fix
Install Python 3:
```bash
sudo apt update
sudo apt install -y python3
python3 --version
````

---

## 2) Log file not created (`failed_login_logs.log` missing)

### ✅ Symptoms

* `ls -l failed_login_logs.log` shows:

  * `No such file or directory`

### ✅ Fix Checklist

1. Confirm you ran the generator script:

```bash
python3 generate_failed_login_events.py
```

2. Confirm your current directory:

```bash
pwd
ls -l
```

3. Ensure the generator script has correct filename:

* It must log to: `failed_login_logs.log`

---

## 3) Log file is empty or incomplete

### ✅ Symptoms

* `cat failed_login_logs.log` shows nothing (or fewer lines than expected)

### ✅ Fix

Re-run generator:

```bash
rm -f failed_login_logs.log
python3 generate_failed_login_events.py
cat failed_login_logs.log
```

Note: generator sleeps 2 seconds between failed attempts. Wait until it finishes.

---

## 4) Correlation checker fails: `FileNotFoundError`

### ✅ Symptoms

* Running checker shows something like:

  * `FileNotFoundError: [Errno 2] No such file or directory: 'failed_login_logs.log'`

### ✅ Fix

Make sure the checker and log file are in the same directory:

```bash
pwd
ls -l
```

If needed, either:

* run from the correct directory, or
* update `LOG_FILE` in `correlation_rule_checker.py` to a full path.

---

## 5) Correlation checker does not trigger when you expect it to

### ✅ Symptoms

* Output shows:

  * `[OK] Rule not triggered.`
    even though you expect an alert.

### ✅ Fix Checklist

1. Confirm log contains both:

* multiple `Failed login attempt`
* a `Successful login attempt`

```bash
cat failed_login_logs.log
```

2. Confirm threshold logic:

* default threshold is `FAIL_THRESHOLD = 5`
* if you only have 4 failed attempts, it won’t trigger

3. Confirm exact string matching:

* Checker searches for:

  * `"Failed login attempt"`
  * `"Successful login attempt"`
    If log lines differ, update script or regenerate logs.

---

## 6) Correlation checker triggers when it should NOT

### ✅ Symptoms

* It prints `[ALERT TRIGGERED]` unexpectedly

### ✅ Fix Checklist

1. Confirm log file contents:

```bash
cat failed_login_logs.log
```

2. Ensure “success” line is not present during a negative test:

* If success exists, the rule will trigger if failures >= threshold.

3. For negative testing, rebuild a clean file:

```bash
printf "INFO:root:Failed login attempt 1\nINFO:root:Failed login attempt 2\nINFO:root:Failed login attempt 3\n" > failed_login_logs.log
python3 correlation_rule_checker.py
```

---

## 7) Optional negative test changed your main log file permanently

### ✅ Symptoms

* After the “head -n 3 …” step, your original `failed_login_logs.log` is overwritten.

### ✅ Fix

Regenerate the original file:

```bash
python3 generate_failed_login_events.py
cat failed_login_logs.log
```

If you want to preserve both:

```bash
cp failed_login_logs.log failed_login_logs_full.log
# do your negative test manipulations on failed_login_logs.log
# restore later:
cp failed_login_logs_full.log failed_login_logs.log
```

---

## 8) “Time window” is not enforced realistically

### ✅ Symptoms

* You notice the lab does not truly enforce 10 minutes.

### ✅ Explanation (Lab Design)

The simulated logs do not include timestamps, so the lab assumes all events occur within the time window.

### ✅ Improvement (Optional)

Enhancements for realism:

* include timestamps in each generated log line
* parse timestamps in checker
* only count failures within `WINDOW_MINUTES`

---

## ✅ Quick Validation Checklist (After Fixes)

Run:

```bash
ls -l
cat failed_login_logs.log
python3 correlation_rule_checker.py
```

✅ Expected “triggered” state:

* Failed attempts detected: >= 5
* Successful login detected: True
* `[ALERT TRIGGERED] ...`

✅ Expected “not triggered” state:

* Failed attempts detected: < 5 OR success_seen = False
* `[OK] Rule not triggered.`

---
