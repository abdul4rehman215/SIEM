# 🔁 Lab 39: Periodic Rule & Alert Review

## 🧾 Lab Summary
This lab covered a repeatable process for periodically reviewing alert rules to ensure they remain relevant, accurate, and useful. I used **Prometheus** as the monitoring system. Since the Prometheus instance initially had **no custom rules loaded** (common for fresh installs), I created a realistic SIEM health alert rule, verified it loaded, then performed a structured review of the rule’s usefulness, false positive/negative risk, and threshold tuning. The outcome was documented in a dedicated **Rule Review Log** with a clear decision and rationale.

---

## 🎯 Objectives
- Understand why periodic rule reviews are essential
- Identify outdated or ineffective rules
- Decide whether to retire, revise, or retain rules
- Document review outcomes clearly for team alignment

---

## ✅ Prerequisites
- Basic understanding of monitoring systems and alerting
- Access to Prometheus (or similar tool) to view/edit rules
- Ability to interpret alert logic and thresholds

---

## 🧠 Key Concepts
- **Rule relevancy:** does the condition still matter to current infrastructure?
- **Signal quality:** balancing early detection vs alert fatigue
- **False positives:** rule fires too often for non-issues
- **False negatives:** rule is too strict and misses important events
- **Documentation:** keeping a review trail prevents “tribal knowledge” gaps

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Hostname | ip-REDACTED |
| User | toor |
| Monitoring | Prometheus (localhost:9090) |
| Exporter | Node Exporter (localhost:9100) |
| Tools | curl, jq |

---

## 🗂️ Repository Structure
```text
lab39-periodic-rule-alert-review/
├── README.md
├── commands.sh
├── output.txt
├── rules/
│   └── siem_alerts.yml
├── artifacts/
│   └── Rule_Review_Log.md
├── interview_qna.md
└── troubleshooting.md
````

---

## ✅ Tasks Overview (No Commands Here)

### ✅ Task 1: Identify a Rule for Review

* Confirmed Prometheus was reachable
* Queried Prometheus rules API to list active rule groups
* Observed no custom rules were loaded initially
* Created a sample SIEM health alert rule to make review meaningful
* Verified the new rule appears in `/api/v1/rules`

✅ Rule selected for review:

* **HighCPUUsage_SIEMHost**

---

### ✅ Task 2: Evaluate the Rule

* Checked relevancy:

  * CPU spikes can degrade SIEM ingestion and indexing
* Tested rule conditions using the underlying metric query
* Reviewed false positive/negative risk:

  * 95% for 10 minutes is strict → low false positives
  * but may miss earlier degradation → higher false negatives

---

### ✅ Task 3: Decide Rule Fate

Decision: **Revise**

* Lowered threshold:

  * from **>95%** to **>85%**
* Kept duration:

  * **10 minutes** to avoid noise from transient CPU spikes

---

### ✅ Task 4: Document Outcome

* Created `Rule_Review_Log.md` documenting:

  * rule ID, description, last triggered, decision, reasoning
* Documented sharing notes for team awareness and traceability

---

## ✅ Results

✔ Prometheus rules baseline checked
✔ New alert rule created and loaded successfully
✔ Rule evaluated for relevancy + effectiveness
✔ Threshold tuned to reduce false negatives
✔ Review decision documented clearly in a Rule Review Log

---

## 🌍 Why This Matters

Alert rules degrade over time when:

* infrastructure changes
* workloads evolve
* thresholds become outdated
* noise patterns shift

Periodic reviews keep alerting:

* actionable (less noise)
* timely (earlier warning)
* aligned with current risk and operational reality

---

## 🧩 Real-World Applications

* Quarterly SOC rule tuning cycles
* Post-incident improvements (adjust thresholds based on real data)
* Reducing alert fatigue by retiring noisy or irrelevant rules
* Improving detection by tightening gaps (lowering thresholds, adding context)

---

## 🧠 What I Learned

* How to use Prometheus rules API for rule inventory
* How to build a structured review method even when rules are “quiet”
* How to tune thresholds to reduce false negatives without creating noise
* Why documentation matters for team consistency and long-term monitoring quality

---

## ✅ Conclusion

This lab reinforced that rule reviews are not optional—monitoring quality depends on continuous tuning and documentation. Even a “good” rule can be ineffective if thresholds trigger too late. A clear review workflow plus a review log improves monitoring maturity and keeps SIEM performance alerts aligned with operational needs.

---
