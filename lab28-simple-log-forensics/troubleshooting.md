# 🛠️ Troubleshooting Guide — Lab 28: Simple Log Forensics

> This guide covers common issues when filtering auth logs, creating sample logs, and parsing fields using `grep` and `awk`.

---

## 1) `/var/log/auth.log` not found

### ❗ Problem
Running:
```bash
ls -l /var/log/auth.log
````

returns:

* `No such file or directory`

### ✅ Possible Causes

* Some systems (especially newer Ubuntu or minimal builds) use **journald** instead of traditional log files
* Auth logs may be stored in `/var/log/auth.log.1` or rotated/compressed logs

### ✅ Resolution

Check available auth-related logs:

```bash
ls -l /var/log/auth*
```

If system uses journald:

```bash
sudo journalctl -u ssh --no-pager | head
sudo journalctl | grep -i ssh | head
```

### ✅ Prevention

Know your log source before starting analysis:

* file-based (`/var/log/auth.log`)
* journald (`journalctl`)

---

## 2) Permission denied when reading `/var/log/auth.log`

### ❗ Problem

`head /var/log/auth.log` shows:

* `Permission denied`

### ✅ Possible Causes

* `auth.log` is readable only by `root` or members of `adm`

### ✅ Resolution

Use sudo:

```bash
sudo head -n 20 /var/log/auth.log
```

Or add your user to `adm` group (requires logout/login):

```bash
sudo usermod -aG adm <username>
```

### ✅ Prevention

Use sudo for system log access in controlled lab environments.

---

## 3) Lab timeframe date is not present in real logs

### ❗ Problem

Lab asks for events on a specific date (e.g., Jul 15),
but `/var/log/auth.log` only contains current system date entries.

### ✅ Possible Causes

* Fresh VM with only recent logs
* Log rotation removed older records

### ✅ Resolution (Used in this lab)

Create a **sample log dataset** (`auth_sample.log`) matching the required timeframe and perform the same analysis steps against it.

### ✅ Prevention

For training labs, maintain sample datasets to test forensic techniques.

---

## 4) `grep` returns no matches

### ❗ Problem

Example:

```bash
grep 'Jul 15 10:' auth_sample.log
```

returns nothing.

### ✅ Possible Causes

* The date/time pattern does not match the log format
* The log uses a different month name or spacing
* The time format differs (e.g., single-digit hour spacing)

### ✅ Resolution

Inspect the file to confirm formatting:

```bash
head -n 20 auth_sample.log
```

Try broader matching:

```bash
grep 'Jul 15' auth_sample.log | head
```

### ✅ Prevention

Always inspect a sample of logs before writing filter patterns.

---

## 5) `filtered_logs.txt` is empty or missing expected lines

### ❗ Problem

`wc -l filtered_logs.txt` shows 0 lines, or too few entries.

### ✅ Possible Causes

* Incorrect grep patterns
* The time window is too strict
* Appended redirects not used correctly

### ✅ Resolution

Re-run filtering commands carefully:

```bash
grep 'Jul 15 10:' auth_sample.log > filtered_logs.txt
grep 'Jul 15 11:' auth_sample.log >> filtered_logs.txt
grep 'Jul 15 12:' auth_sample.log >> filtered_logs.txt
```

Validate:

```bash
wc -l filtered_logs.txt
head filtered_logs.txt
```

### ✅ Prevention

Validate after each step (line count + preview).

---

## 6) Suspicious keyword search misses events

### ❗ Problem

`grep -E 'failed|error|unauthorized'` misses expected lines.

### ✅ Possible Causes

* Case sensitivity (Failed vs failed)
* Keyword not present exactly as expected

### ✅ Resolution

Use case-insensitive search:

```bash
grep -Ei 'failed|error|unauthorized' filtered_logs.txt > suspicious_activity.txt
```

### ✅ Prevention

Use `-i` when logs may have mixed capitalization.

---

## 7) IP extraction using `awk` returns wrong field

### ❗ Problem

Command:

```bash
awk '/Failed password/ {print $(NF-3)}' filtered_logs.txt
```

returns incorrect tokens or unexpected values.

### ✅ Possible Causes

* Log format varies across different lines
* Additional words (e.g., “invalid user”) shift fields

### ✅ Resolution

Validate by printing the full line + extracted field:

```bash
awk '/Failed password/ {print $0 " | extracted=" $(NF-3)}' filtered_logs.txt | head
```

Or switch to keyword-based extraction (more reliable):

```bash
awk '{
  ip="-";
  for (i=1;i<=NF;i++) if($i=="from" && (i+1)<=NF) ip=$(i+1);
  print ip
}' filtered_logs.txt | sort | uniq -c | sort -nr
```

### ✅ Prevention

Avoid fixed positions when logs vary—use keywords like `from`, `for`.

---

## 8) Evidence extraction fields are inconsistent (`port` appears instead of IP)

### ❗ Problem

In `evidence.txt`, some lines show:

* username correct but IP becomes `port`

### ✅ Cause

Fixed field extraction:

```bash
awk '{print $1, $2, $3, $11, $13}'
```

assumes a consistent token layout, which is not always true.

### ✅ Resolution (Used in this lab)

Use keyword-based parsing to consistently extract:

* timestamp ($1 $2 $3)
* username after `for`
* IP after `from`

```bash
awk '{
  ts=$1" "$2" "$3
  user="-"
  ip="-"
  for (i=1;i<=NF;i++){
    if($i=="for" && (i+1)<=NF) user=$(i+1)
    if($i=="from" && (i+1)<=NF) ip=$(i+1)
  }
  print ts, user, ip
}' suspicious_activity.txt > evidence_clean.txt
```

### ✅ Prevention

When building forensic tools/scripts, parse based on keywords instead of fixed positions.

---

## 9) Output formatting looks messy when reviewing evidence

### ❗ Problem

Evidence lines are hard to read due to spacing differences.

### ✅ Resolution

Use `column -t` for aligned output:

```bash
column -t evidence_clean.txt | head
```

### ✅ Prevention

For reports and screenshots, always format output to be readable.

---
