# 🛠️ Troubleshooting Guide — Lab 29: Regular Expressions in Log Searches

> This guide covers common issues when using regex with `grep -P`, extracting patterns from logs, and running the Python script.

---

## 1) `grep: invalid option -- P` (PCRE not supported)

### ❗ Problem
Running:
```bash
grep -P 'pattern' sample.log
````

fails with an error like:

* `grep: invalid option -- P`

### ✅ Possible Causes

* Some systems ship a minimal `grep` build without PCRE support

### ✅ Resolution

1. Check grep version:

```bash id="3y68z1"
grep --version
```

2. Use alternative tools:

* `perl` for PCRE:

```bash id="7aw6os"
perl -nle 'print $& while /\b(?:\d{1,3}\.){3}\d{1,3}\b/g' sample.log
```

* `ripgrep` (`rg`) if installed (supports regex features):

```bash id="z1b9uy"
rg -o '\b(?:\d{1,3}\.){3}\d{1,3}\b' sample.log
```

### ✅ Prevention

Confirm tool capability before writing patterns that depend on PCRE features.

---

## 2) Word boundary `\b` not working as expected

### ❗ Problem

Regex returns too many matches or misses expected matches.

### ✅ Possible Causes

* Using `grep -E` instead of `grep -P`
* Word boundaries behave differently across regex engines

### ✅ Resolution

Use PCRE:

```bash id="3d2cwp"
grep -oP '\b(user|ID)-\d+\b' sample.log
```

### ✅ Prevention

Use the correct regex engine for your pattern requirements.

---

## 3) IPv4 regex matches invalid IPs (e.g., `192.168.1.300`)

### ❗ Problem

The basic IPv4 regex returns values that are not valid IPv4 addresses.

### ✅ Cause

The “simple IPv4 regex” validates formatting only (digits and dots), not octet ranges.

### ✅ Resolution Options

**Option A: Post-process validation**
Extract IPs, then validate with a script (Python or awk logic).

**Option B: Use stricter regex**
A stricter regex exists but is longer and harder to maintain for quick searches.

### ✅ Prevention

Use simple regex for detection/triage, then validate suspicious values separately.

---

## 4) `grep -oP` returns nothing

### ❗ Problem

No matches returned even though you expect matches.

### ✅ Possible Causes

* Pattern typo (escaping missing)
* Log format differs from pattern expectation
* File doesn’t contain expected text

### ✅ Resolution

1. Confirm file content:

```bash id="l30a2a"
head -n 20 sample.log
```

2. Test a simpler pattern first:

```bash id="n0e1s8"
grep -n 'error code' sample.log
```

3. Verify escaping:

* Brackets must be escaped:

  * `\[`
  * `\]`

Example:

```bash id="rvq3ac"
grep -oP '\[error code:\s*[A-Z]+\]' sample.log
```

### ✅ Prevention

Start with a simple search, then refine into a regex extraction.

---

## 5) Too many duplicates in extracted results

### ❗ Problem

Extraction output contains repeated matches.

### ✅ Cause

Multiple log lines contain the same indicators (common in real logs).

### ✅ Resolution

Use `sort -u`:

```bash id="4fhy4d"
grep -oP '\b(user|ID)-\d+\b' sample.log | sort -u
grep -oP '\[error code:\s*[A-Z]+\]' sample.log | sort -u
```

### ✅ Prevention

Always deduplicate before writing summary reports.

---

## 6) Python script prints nothing

### ❗ Problem

Running:

```bash
python3 extract_error_lines.py
```

produces no output.

### ✅ Possible Causes

* `sample.log` path incorrect
* log file has no matching patterns
* script saved incorrectly or indentation errors

### ✅ Resolution

1. Confirm log file exists:

```bash id="1bpjnn"
ls -l sample.log
```

2. Confirm pattern exists:

```bash id="b20v1w"
grep -n 'error code' sample.log
```

3. Confirm script points to correct file:

```python
log_file_path = 'sample.log'
```

### ✅ Prevention

Validate both the data source and regex before running automation.

---

## 7) Python indentation errors

### ❗ Problem

Error like:

* `IndentationError: unexpected indent`
* `IndentationError: unindent does not match any outer indentation level`

### ✅ Possible Causes

* Mixed tabs and spaces
* Indentation changed during editing

### ✅ Resolution

Use consistent spaces (4 spaces recommended) and re-save:

* In VS Code: convert tabs to spaces
* Ensure `if` and `print` blocks are aligned correctly

### ✅ Prevention

Use an editor that highlights indentation issues and enable Python formatting.

---

## 8) Regex highlighting not working in the editor

### ❗ Problem

Patterns don’t highlight when searching in VS Code / Sublime.

### ✅ Possible Causes

* Regex mode not enabled
* Wrong escape sequences in editor search

### ✅ Resolution

* In VS Code:

  * Ctrl+F
  * enable regex mode (`.*`)
* Use the same patterns tested in CLI:

  * `\b(?:\d{1,3}\.){3}\d{1,3}\b`
  * `\b(user|ID)-\d+\b`
  * `\[error code:\s*[A-Z]+\]`

### ✅ Prevention

Always confirm regex mode is enabled in the editor search.

---
