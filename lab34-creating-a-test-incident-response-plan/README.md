# 🧾 Lab 34: Creating a Test Incident Response Plan (IRP)

## 🧾 Lab Summary
This lab focused on creating a foundational **Incident Response Plan (IRP)** tailored to a realistic SIEM/SOC workflow. I defined core response roles (Incident Response Manager, HOA Security Lead, IT Support), built severity-based escalation procedures, and validated the plan using a short tabletop exercise scenario (phishing → account compromise). The outcome is a structured IRP document and a tabletop notes artifact.

---

## 🎯 Objectives
- Develop an Incident Response Plan (IRP) to manage and mitigate cybersecurity incidents
- Define roles and responsibilities within the response team
- Establish escalation procedures for different incident severities
- Conduct a tabletop exercise to test and validate the plan

---

## ✅ Prerequisites
- Basic cybersecurity knowledge
- Familiarity with IR frameworks (NIST / SANS)
- Access to a collaborative document tool (Markdown acceptable for lab)
- Ability to document and organize response procedures clearly

---

## 🧠 Key Concepts
- **Incident Response Plan (IRP):** Documented process for detection, response, containment, recovery, and improvement
- **Roles & Responsibilities:** Clear ownership reduces confusion under pressure
- **Severity-based Escalation:** Ensures the right response effort matches incident impact
- **Tabletop Exercise:** Simulated discussion-based test to validate procedures and identify gaps

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Hostname | ip-REDACTED |
| User | toor |
| Work Product | IRP document + tabletop notes |
| Scripting | None (planning/procedure focused) |

---

## 🗂️ Repository Structure
```text
lab34-creating-a-test-incident-response-plan/
├── README.md
├── commands.sh
├── output.txt
├── artifacts/
│   ├── Incident_Response_Plan.md
│   └── Tabletop_Exercise_Notes.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## ✅ Tasks Overview (No Commands Here)

### ✅ Task 1: Define Roles and Responsibilities

* Documented key roles:

  * Incident Response Manager
  * HOA Security Lead
  * IT Support
* Assigned responsibilities for:

  * coordination & reporting
  * validation of IOCs and risk scope
  * containment and recovery actions

### ✅ Task 2: Establish Escalation Procedures

* Defined severity levels:

  * Low / Medium / High
* Defined response expectations:

  * who to notify
  * response timelines
  * escalation chain
  * communications readiness requirements

### ✅ Task 3: Conduct a Mini Tabletop Exercise

* Scenario used:

  * phishing email → user enters credentials → suspicious logins observed
* Walkthrough included:

  * detection simulation (SIEM alert + user report)
  * classification (Medium severity)
  * containment actions (password reset + MFA + block IP)
  * investigation steps (auth logs + file access review)
  * lessons learned for tuning + awareness improvements
* Captured outcomes and decisions in a separate tabletop notes file

---

## ✅ Results

✔ Created structured IRP document in Markdown
✔ Created tabletop exercise notes for realistic validation
✔ Defined severity levels with clear escalation paths
✔ Included evidence-handling and communication guidance
✔ Produced reusable documentation suitable for SOC workflows

---

## 🌍 Why This Matters

When incidents happen, speed and clarity matter. A documented plan:

* reduces confusion and delays
* ensures correct escalation
* improves coordination and communication
* strengthens compliance posture
* enables repeatable incident handling

---

## 🧩 Real-World Applications

* SOC playbook foundation for account compromise incidents
* Standard operating procedures for incident handling
* Training material for new team members
* Audit readiness (documented response process)
* Continuous improvement through tabletop exercises

---

## 🧠 What I Learned

* How to structure an IR plan that stays readable under pressure
* The importance of explicit roles and response ownership
* How severity levels drive escalation decisions and timelines
* How tabletop exercises reveal gaps (MFA enforcement, detection tuning, awareness workflows)

---

## ✅ Conclusion

This lab produced a practical test IRP and validated it using a tabletop scenario. The documentation provides a reusable baseline for incident response readiness, and the exercise highlighted clear next steps such as improved MFA enforcement and SIEM tuning for unusual login behavior.

---
