# 🧩 Lab 29: Regular Expressions in Log Searches

## 🧾 Lab Summary
This lab focused on using **Regular Expressions (Regex)** to search and extract structured information from log files. Using `grep -P` (PCRE) and a small Python script, I extracted **IPv4-like strings**, **user/ID patterns**, and **error code tags**, then automated filtering of error-related log lines.

---

## 🎯 Objectives
- Understand the basics of Regular Expressions (Regex) and their use in log searches
- Construct regex patterns for identifying components in logs
- Extract and manipulate log data using regex tools and scripts

---

## ✅ Prerequisites
- Basic filesystem + CLI knowledge
- Familiarity with logs and their structure
- A regex-capable tool/editor:
  - `grep` on Linux (PCRE via `grep -P`)
  - VS Code / Sublime Text (regex search mode)
- Sample log files available for practice

---

## 🧠 Key Concepts
- **Regex (Regular Expressions):** A pattern language for matching text
- **Character classes & quantifiers:**
  - `.` any char (except newline)
  - `*` zero or more
  - `+` one or more
  - `?` zero or one
  - `[]` any one of listed chars
  - `^` start of line
  - `$` end of line
- **PCRE (Perl-Compatible Regex):** Regex engine used by `grep -P` that supports `\b` word boundaries

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Hostname | ip-REDACTED |
| User | toor |
| Python | 3.12.3 |
| Tools | grep (PCRE via `-P`), nano |
| Working Directory | `Lab_Regex_LogSearch/` |

---

## 🗂️ Repository Structure
```text
lab29-regular-expressions-in-log-searches/
├── README.md
├── commands.sh
├── output.txt
├── scripts/
│   └── extract_error_lines.py
├── interview_qna.md
└── troubleshooting.md
````

> 📌 Data file created during this lab:

* `sample.log` (created as a realistic log dataset for regex practice)

---

## ✅ Tasks Overview (No Commands Here)

### ✅ Task 1: Constructing Basic Regex Patterns

* Reviewed common regex symbols and anchors
* Tested an IPv4-style regex pattern against a sample log file
* Used `grep -P` to support `\b` word boundary matching

### ✅ Task 2: Extracting Specific Information From Logs

* Extracted user IDs in two formats:

  * `user-123`
  * `ID-456`
* Extracted bracketed error codes:

  * `[error code: AUTH]`
  * `[error code: DENIED]`
  * etc.
* Deduplicated extracted values using `sort -u`

### ✅ Task 3: Applying Regex Learnings

* Wrote a Python script (`extract_error_lines.py`) to output only lines containing error codes
* Practiced regex highlighting inside a text editor (VS Code workflow)

---

## ✅ Results

✔ Built and tested regex patterns for:

* IP-style patterns
* user/ID patterns
* error code patterns
  ✔ Extracted and deduplicated matches using `grep -P` + `sort`
  ✔ Automated extraction of error lines using Python regex
  ✔ Practiced editor-based regex highlighting workflow

---

## 🌍 Why This Matters

Regex is a core skill for:

* log triage during incidents
* SOC investigations (searching patterns fast)
* parsing and normalizing logs before SIEM ingestion
* building detection logic and filtering noise

---

## 🧩 Real-World Applications

* Extracting attacker IPs, targeted usernames, and error indicators from auth logs
* Quickly locating failed login sequences, unauthorized access attempts
* Building lightweight CLI parsers before writing full tooling
* Data cleaning before ingestion into SIEM platforms (ELK/Grafana dashboards)

---

## 🧠 What I Learned

* `grep -P` is helpful when you need **PCRE features** like `\b`
* “Simple IP regex” can match **invalid** IPv4 values (e.g., `192.168.1.300`) — validation needs stricter patterns or post-processing
* Combining `grep` output with `sort -u` is a quick reporting trick
* Python regex scripts are useful when extraction needs more control than CLI one-liners

---

## ✅ Conclusion

This lab demonstrated how regex can efficiently extract structured indicators from raw logs. I practiced pattern creation for IP-like values, user/ID identifiers, and error codes, then automated error-line filtering with Python. These techniques form a strong foundation for log analysis workflows used in troubleshooting, incident response, and SIEM preparation.

✅ **Lab completed successfully on Ubuntu 24.04.1 LTS**

---

