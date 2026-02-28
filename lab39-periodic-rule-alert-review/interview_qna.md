# 🧠 Interview Q&A — Lab 39: Periodic Rule & Alert Review

---

## 1) Why is periodic rule and alert review important?
Because environments change over time. Without review, rules can become outdated, noisy, or miss real issues, reducing monitoring effectiveness and increasing alert fatigue.

---

## 2) What monitoring system was used in this lab?
**Prometheus** was used, and rules were inspected through the Prometheus Rules API.

---

## 3) How do you list active rules in Prometheus?
By calling the rules endpoint:
```bash
curl -X GET http://localhost:9090/api/v1/rules
````

In this lab, results were formatted using `jq`.

---

## 4) What did you observe when checking Prometheus rules initially?

There were **no custom rules loaded**, which is common for fresh Prometheus installs.

---

## 5) How did you handle “no rules exist” while still completing the lab meaningfully?

I created a realistic sample alert rule for SIEM host health monitoring, then reviewed it using the same structured review process.

---

## 6) What rule was selected for review?

**HighCPUUsage_SIEMHost** — an alert for sustained high CPU usage on the SIEM host.

---

## 7) Why choose a rule that hasn’t triggered recently?

Rules that never trigger can be:

* irrelevant (retire)
* too strict (revise)
* still valid but low-frequency (retain)
  They are good candidates for review.

---

## 8) How did you test the rule’s behavior?

I queried the underlying metric directly (CPU usage percentage) using Prometheus HTTP API and compared it to the threshold.

---

## 9) What was the main issue with the original rule threshold?

It was too late-stage:

* **>95% CPU for 10 minutes**
  This could miss early performance degradation that starts at lower sustained CPU levels.

---

## 10) What type of risk does an overly high threshold introduce?

**False negatives** — the system can be degraded without triggering the alert.

---

## 11) What decision was made about the rule?

**Revise** — the rule was still relevant but needed tuning.

---

## 12) What change was made during revision?

Threshold was lowered:

* from **95%** to **85%**
  Duration remained:
* **10 minutes** to avoid alert noise from brief spikes.

---

## 13) What are the three typical outcomes of a rule review?

* **Retire:** no longer relevant or valuable
* **Revise:** still useful but needs tuning
* **Retain:** valuable as-is

---

## 14) Why is documentation required after rule review?

Documentation ensures:

* accountability and audit trail
* team alignment
* future reviewers understand why decisions were made
* reduces “tribal knowledge” dependency

---

## 15) What is the main takeaway from this lab?

Monitoring rules should be continuously tuned. A methodical cycle—identify → evaluate → test → decide → document—keeps alerting meaningful and prevents both noise and missed detections.

---
