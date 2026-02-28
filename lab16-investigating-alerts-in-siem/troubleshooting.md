# 🛠️ Troubleshooting Guide — Lab 16: Investigating Alerts in a SIEM System

> This guide covers common issues when investigating SIEM-like alerts using a JSONL dataset and CLI filtering with `jq`.

---

## 1) `jq: command not found`

### ✅ Symptoms
- Running `jq ...` returns:
  - `jq: command not found`

### ✅ Fix
Install jq:
```bash
sudo apt update
sudo apt install -y jq
jq --version
````

---

## 2) `alerts.jsonl` not found / wrong directory

### ✅ Symptoms

* `jq ... alerts.jsonl` returns:

  * `jq: error: Could not open file alerts.jsonl`

### ✅ Fix

Confirm you are in the correct directory and file exists:

```bash
pwd
ls -l
```

If needed, navigate:

```bash
cd ~/lab_investigating_alerts
ls -l
```

---

## 3) `jq` errors due to invalid JSON

### ✅ Symptoms

* You see errors like:

  * `parse error: Invalid numeric literal at line ...`
  * `parse error: Expected separator between values ...`

### ✅ Cause

JSON syntax issues in `alerts.jsonl`, such as:

* missing quotes
* trailing commas
* broken braces
* multiline JSON objects (should be 1 object per line for JSONL)

### ✅ Fix

Validate quickly:

```bash
# This will fail fast on the first invalid line
jq -c '.' alerts.jsonl >/dev/null
echo $?
```

To locate the problem:

```bash
nl -ba alerts.jsonl | head -n 30
```

Fix the offending line in nano:

```bash
nano alerts.jsonl
```

---

## 4) Output is empty when filtering (no matching records)

### ✅ Symptoms

* `jq -c 'select(.["alert.category"]=="suspicious_login")' alerts.jsonl` prints nothing

### ✅ Fix Checklist

1. Confirm the field name exists:

```bash
jq -c '.' alerts.jsonl | head -n 1
```

2. Confirm values match exactly (case sensitive):

* `suspicious_login` is not the same as `Suspicious_Login`

3. List categories present:

```bash
jq -r '.["alert.category"]' alerts.jsonl | sort | uniq -c
```

---

## 5) Key fields show as `null` in output

### ✅ Symptoms

* user shows as blank or `null` for some alerts

### ✅ Explanation

Not all alert categories contain user fields (e.g., malware alerts may not include `user.name`).

### ✅ Fix / Best Practice

Use safe defaults in jq output:

```bash
jq -r '"user=\(.["user.name"] // "-")"' alerts.jsonl
```

---

## 6) Drill-down by alert ID returns nothing

### ✅ Symptoms

* `jq 'select(.["alert.id"]=="a-1001")' alerts.jsonl` prints nothing

### ✅ Fix Checklist

1. Confirm the alert ID exists:

```bash
jq -r '.["alert.id"]' alerts.jsonl
```

2. Copy/paste exact ID (case-sensitive)
3. Ensure there are no hidden characters/spaces

---

## 7) Sorting timeline doesn’t look correct

### ✅ Symptoms

* You sort and timestamps appear out of order

### ✅ Explanation

ISO timestamps sort correctly as strings **if** they are consistently formatted (UTC `Z` timestamps are fine).
If your timestamps vary in format, string sort may not reflect actual time order.

### ✅ Fix

Ensure consistent ISO format in JSONL:

* `YYYY-MM-DDTHH:MM:SSZ`

For more complex cases:

* parse timestamps using tools like `date` or do sorting within jq (advanced).

---

## 8) Investigation report file missing or incomplete

### ✅ Symptoms

* `head -n 20 investigation_report.md` fails or shows unexpected content

### ✅ Fix

Confirm file exists:

```bash
ls -l investigation_report.md
```

If missing, recreate:

```bash
nano investigation_report.md
```

---

## 9) How to make the terminal simulation closer to a real SIEM

### ✅ Enhancements (Optional)

* Add more fields:

  * `host.name`, `process.name`, `event.dataset`, `agent.id`
* Add more related alerts to practice pivoting
* Include success/failure sequences for deeper correlation
* Add tags for mapping to MITRE ATT&CK

---

## ✅ Quick Validation Checklist (After Fixes)

Run:

```bash
ls -l
wc -l alerts.jsonl
jq -r '"\(.["@timestamp"]) | \(.["alert.id"]) | \(.["alert.category"]) | severity=\(.["alert.severity"]) | user=\(.["user.name"] // "-") | src_ip=\(.["source.ip"])"' alerts.jsonl
jq -r 'select(.["alert.category"]=="suspicious_login") | "\(.["alert.id"]) | \(.["@timestamp"]) | \(.["rule.name"]) | user=\(.["user.name"]) | ip=\(.["source.ip"]) | outcome=\(.["event.outcome"])"' alerts.jsonl
jq 'select(.["alert.id"]=="a-1001")' alerts.jsonl
```

If these commands produce expected output, the investigation workflow is working correctly.

---
