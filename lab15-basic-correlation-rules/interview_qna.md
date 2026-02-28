# 🎤 Interview Q&A — Lab 15: Basic Correlation Rules

## 1) What is a correlation rule in a SIEM?
A correlation rule links multiple events together across time to detect meaningful security patterns. Instead of triggering on a single log entry, correlation rules evaluate sequences, thresholds, or relationships between events.

---

## 2) Why are correlation rules important compared to single-event alerts?
Single events can be noisy and lack context. Correlation rules reduce false positives and improve detection by combining:
- thresholds (e.g., 5 failed logins)
- time windows (e.g., 10 minutes)
- sequences (failures followed by success)

---

## 3) What scenario did you detect in this lab?
A brute-force login pattern:
- **≥ 5 failed login attempts within 10 minutes**
- followed by **1 successful login**

This can indicate password guessing that eventually succeeded.

---

## 4) What would this look like in a real SIEM like Elastic Security or Wazuh?
In Elastic Security, you could implement it as:
- a threshold rule for failures plus a sequence/EQL rule to combine failure + success  
In Wazuh, you could correlate authentication failure and success rules using rule chaining/grouping and decoder fields.

---

## 5) Why did you simulate the rule in Python instead of using Kibana UI?
The cloud lab environment was terminal-only, so Kibana UI access wasn’t available. I simulated SIEM behavior using scripts to still practice:
- defining detection logic
- setting thresholds
- generating events
- verifying triggers

---

## 6) What are the core components of a correlation rule?
Typically:
- **Data source** (authentication logs)
- **Fields used** (user, source IP, timestamp, action)
- **Time window**
- **Threshold**
- **Sequence logic** (failures then success)
- **Action** (alert/notify)

---

## 7) What threshold and time window did you use?
- Threshold: **5 failed logins**
- Window: **10 minutes**
- Plus: **successful login must be present**

---

## 8) How did you generate events for testing?
I used a Python script to write log entries to a file:
- 6 failed log entries
- 1 successful log entry

This created controlled data for testing correlation logic.

---

## 9) How did your correlation checker determine an alert should trigger?
It:
- read the log file
- counted "Failed login attempt" occurrences
- checked for presence of "Successful login attempt"
- triggered an alert when `failed_count >= 5` AND `success_seen == True`

---

## 10) What limitation existed in your simulated logs compared to real SIEM logs?
The simulated logs did not include timestamps. In a real SIEM, timestamps are essential to enforce the time window accurately. For this lab, all generated events were treated as within the window.

---

## 11) How did you validate that the rule does not trigger when conditions aren’t met?
I reduced the log file to only 3 failed attempts (and removed the success event). The checker then reported:
- failed_count = 3
- success_seen = False
- rule NOT triggered

---

## 12) How can correlation rules reduce false positives?
By requiring multiple conditions (threshold + time + sequence), correlation rules filter out random failures or normal user mistakes, focusing on patterns more likely to represent an attack.

---

## 13) What improvements would you make for production detection engineering?
- Parse structured fields (username, IP, timestamps)
- Enforce the actual time window using timestamps
- Correlate by unique dimensions (e.g., same user + same source IP)
- Add suppressions/cooldowns to prevent alert storms
- Enrich with context (geo-IP, asset criticality, user baseline)

---

## 14) How does this brute-force correlation relate to incident response?
It can be an early indicator of account compromise. IR actions may include:
- checking login source IP history
- resetting credentials
- reviewing other authentication logs
- checking for lateral movement after successful login

---

## 15) What’s the difference between “threshold rules” and “sequence rules”?
- **Threshold rules** trigger when count exceeds a number in a time window.
- **Sequence rules** trigger when events occur in a specific order (e.g., failures then success).
This lab combined both concepts in a simplified way.
