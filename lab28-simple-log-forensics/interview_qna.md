# 🧠 Interview Q&A — Lab 28: Simple Log Forensics

---

## 1) What is log forensics?
Log forensics is the process of analyzing system and application logs to reconstruct events, identify suspicious behavior, and collect evidence for investigations.

---

## 2) Why are timestamps important in log analysis?
Timestamps help establish the **timeline** of events, identify the sequence of actions, and correlate logs across multiple sources (e.g., auth logs + firewall logs).

---

## 3) Why did you define a time window (10:00–12:00) before searching the logs?
Defining a time window narrows the investigation scope, reduces noise, and helps focus on the period where suspicious activity likely occurred.

---

## 4) Why did you create a sample log file instead of using `/var/log/auth.log`?
The system’s `/var/log/auth.log` only contained current lab-date entries (Aug 18), while the lab scenario required Jul 15 entries. Creating a sample log file ensured the forensic steps could be performed correctly.

---

## 5) What kinds of events does `/var/log/auth.log` usually contain?
Common events include:
- SSH login success/failure
- sudo usage
- user authentication attempts
- PAM authentication messages
- session opened/closed records

---

## 6) Why is `grep` useful in log forensics?
`grep` is useful for quickly filtering large logs by:
- date/time patterns
- keywords like “Failed”, “error”, “unauthorized”
- specific usernames or IP addresses

---

## 7) What suspicious keywords did you search for in this lab?
The lab focused on:
- `failed`
- `error`
- `unauthorized`

These commonly appear in authentication failures, brute-force attempts, and abnormal access events.

---

## 8) How did you detect brute-force behavior in this lab?
By counting repeated failed login events grouped by source IP using:
- `awk` to extract the IP field
- `sort | uniq -c` to count occurrences
- sorting results to find the highest frequency offender

---

## 9) Which IP address looked the most suspicious and why?
`192.168.1.10` was most suspicious because it produced the highest number of failed password attempts within the selected time window.

---

## 10) Why is a high number of failed logins from one IP suspicious?
It often indicates:
- brute-force password guessing
- credential stuffing
- automated scanning of accounts (admin/root/etc.)

---

## 11) Why do fixed field positions sometimes fail in log parsing?
Authentication logs are not always uniform. Words like “invalid user” add extra tokens, shifting field positions. This causes fixed-position parsing (e.g., `$11`, `$13`) to return inconsistent results.

---

## 12) What was the practical fix used to extract evidence consistently?
A keyword-based approach:
- timestamp = `$1 $2 $3`
- username = token after `for`
- IP address = token after `from`

This method is more resilient when log formats vary.

---

## 13) What key elements did you extract as forensic evidence?
- Timestamp (when it happened)
- Username (who was targeted or authenticated)
- Source IP (where it came from)

These are core artifacts for incident reporting and response.

---

## 14) How would these findings be used in a real SOC workflow?
- Escalate repeated offender IPs for blocking (firewall/WAF)
- Add detection rules in a SIEM (threshold-based)
- Investigate targeted accounts (admin/root)
- Correlate with other telemetry (EDR, firewall logs, IDS alerts)

---

## 15) What is the main takeaway from this lab?
Using simple CLI tools, it’s possible to quickly:
- narrow investigations by time
- isolate suspicious patterns
- quantify attack activity
- extract evidence for reporting

---
