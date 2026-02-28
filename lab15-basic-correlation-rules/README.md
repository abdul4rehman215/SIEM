# 🧪 Lab 15: Basic Correlation Rules

## 🧾 Lab Summary
This lab focuses on **basic SIEM correlation rules**—detecting security-relevant patterns by linking multiple events together instead of evaluating one event at a time.

The scenario used in this lab is a classic brute-force indicator:

> **Multiple failed login attempts (threshold) followed by a successful login**

Because this cloud lab environment is **terminal-only** (no direct Kibana UI), I implemented the same logic using:
- a **Python log event generator**
- a **Python correlation rule checker** (SIEM-like rule evaluation)

This preserves the real learning outcome:
✅ define rule logic → ✅ generate events → ✅ evaluate correlation → ✅ confirm alert triggers.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand what correlation rules are in SIEM systems
- Define a realistic security scenario for correlation detection (brute-force)
- Create event data that simulates failed and successful logins
- Implement and test SIEM-like correlation logic using open-source scripts
- Validate both **positive triggers** and **non-trigger** scenarios

---

## ✅ Prerequisites
- Basic cybersecurity fundamentals
- Familiarity with logs and monitoring concepts
- Basic command-line usage
- Basic Python knowledge (or scripting understanding)
- Access to an open-source SIEM platform (ELK/Wazuh) *or* terminal-based simulation (used here)

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Environment | Cloud Lab Environment |
| User | `toor` |
| SIEM UI | Not available (terminal-only lab) |
| Approach | Python-based SIEM-like correlation simulation |

---

## 🗂️ Repository Structure
```text
lab15-basic-correlation-rules/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    ├── generate_failed_login_events.py
    ├── correlation_rule_checker.py
    └── failed_login_logs.log
````

---

## 🔎 Scenario: Brute-Force Login Attempt (Correlation Use Case)

### ✅ Scenario Definition

A brute-force attempt often looks like:

* **many failed logins** from the same source/user over a short window
* followed by **one successful login** (account compromised)

### ✅ Correlation Rule (Lab Logic)

* Window: **10 minutes**
* Threshold: **≥ 5 failed logins**
* Then: **1 successful login after failures**
* Expected output: **alert triggered**

### 🔍 Fields (SIEM mapping ideas)

If using a real SIEM (ELK/Wazuh), typical relevant fields would be:

* `user.name`
* `source.ip`
* `event.action`
* `@timestamp`

---

## 🧩 Tasks Overview (What I Performed)

### ✅ Task 1: Confirm Environment

* Verified OS version and working directory

### ✅ Task 2: Create a Dedicated Lab Working Directory

* Created a folder to keep scripts and log outputs organized for GitHub upload

### ✅ Task 3: Generate Events (Python)

* Wrote a script that:

  * logs **6 failed login attempts**
  * then logs **1 successful login attempt**
* Verified the generated log file contents

### ✅ Task 4: Implement Correlation Rule Checker (Python)

* Created a SIEM-like rule checker that:

  * reads the log file
  * counts failed login events
  * checks whether a success login is present
  * prints **ALERT TRIGGERED** when rule conditions are met

### ✅ Task 5: Validate Positive Trigger

* Ran the checker against the generated events
* Confirmed it triggers:

  * `Failed attempts detected: 6`
  * `Successful login detected: True`
  * `[ALERT TRIGGERED] ...`

### ✅ Task 6: Validate Non-Trigger Scenario (Optional Verification)

* Reduced the log file to only 3 failed entries
* Re-ran rule checker
* Confirmed it does **not** trigger:

  * `Failed attempts detected: 3`
  * `Successful login detected: False`
  * `[OK] Rule not triggered.`

---

## ✅ Verification & Validation

This lab is considered successful when:

* ✅ `failed_login_logs.log` contains both failed and successful login events
* ✅ correlation checker prints **[ALERT TRIGGERED]** for the brute-force pattern
* ✅ correlation checker prints **[OK]** when data does not meet thresholds

---

## 🧠 What I Learned

* Correlation rules detect patterns that single events cannot (context matters).
* Threshold + sequence logic is a common detection approach in SIEM platforms.
* Even without a SIEM UI, you can validate detection logic by:

  * generating controlled logs
  * writing evaluation logic
  * testing trigger vs non-trigger cases
* This approach improves detection engineering discipline before writing real SIEM rules.

---

## 🌍 Why This Matters

Attackers rarely succeed with a single event. SIEM correlation helps identify:

* brute-force attempts
* password spraying
* suspicious access patterns
* successful compromise after repeated failures

Correlation-based detection is essential for:

* SOC monitoring
* incident response escalation
* automated alerting workflows

---

## 🧰 Real-World Applications

This brute-force correlation pattern maps to:

* Wazuh rules + decoders
* Elastic Security threshold rules
* EQL sequence rules
* SIEM correlation engines (Splunk correlation searches, etc.)

---

## ✅ Result

* ✅ Generated realistic login event patterns using Python
* ✅ Implemented correlation logic using a SIEM-like rule checker
* ✅ Verified rule triggers correctly under brute-force scenario
* ✅ Verified rule does **not** trigger when thresholds are not met
* ✅ Produced scripts/log artifacts ready for GitHub upload

---

## 🏁 Conclusion

This lab successfully demonstrated a foundational SIEM correlation concept:
**multiple failed logins within a time window + a successful login** is a strong brute-force indicator.

By simulating logs and implementing rule evaluation in Python, I validated how SIEM correlation works in practice—even without access to Kibana/Wazuh UI in the lab environment.

---
