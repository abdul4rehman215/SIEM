# 🛠️ Troubleshooting Guide — Lab 34: Creating a Test Incident Response Plan (IRP)

> This lab is documentation-focused, so troubleshooting is about improving the IRP’s clarity, usability, and realism during high-pressure incidents.

---

## 1) The IRP is too vague to use during a real incident

### ❗ Problem
Team members read the IRP but still ask:
- “Who owns this step?”
- “What do we do first?”
- “When do we escalate?”

### ✅ Likely Causes
- Responsibilities not explicit enough
- Missing step-by-step checklist
- Severity definitions too broad

### ✅ Resolution
- Add a short “First 60 minutes checklist” section
- Add an “Owner” field for each step (IRM / Security Lead / IT Support)
- Add decision points (e.g., “If X happens → escalate to High”)

### ✅ Prevention
Run tabletop exercises and revise the plan after each simulation.

---

## 2) Confusion about incident severity classification

### ❗ Problem
Different team members classify the same incident differently.

### ✅ Likely Causes
- Severity definitions rely on subjective terms (“minor”, “major”)
- No concrete examples

### ✅ Resolution
Add measurable criteria, for example:
- number of users affected
- confirmed vs suspected data exposure
- critical systems impacted
- duration of outage
- ransomware indicators

### ✅ Prevention
Maintain a short severity cheat sheet with example incidents.

---

## 3) Escalation timeline is unrealistic

### ❗ Problem
Targets like “resolve in 24 hours” or “respond in 4 hours” are not achievable.

### ✅ Likely Causes
- Underestimated investigation and coordination time
- Missing staffing/on-call detail

### ✅ Resolution
- Define **response vs resolution** targets separately
- Add an “on-call coverage” note
- Add minimum staffing requirements for Medium/High severity

### ✅ Prevention
Use tabletop timing notes to calibrate response targets.

---

## 4) Communication steps are unclear or risky

### ❗ Problem
People share sensitive incident details in inappropriate channels.

### ✅ Likely Causes
- No explicit “approved channels”
- No guidance for what can/can’t be shared

### ✅ Resolution
Add:
- a dedicated incident comms channel requirement
- “Do not share IOCs publicly”
- “One spokesperson for external communication”
- templates for internal updates (status + next steps)

### ✅ Prevention
Train team members with a short incident communications guide.

---

## 5) Evidence handling is too high-level

### ❗ Problem
During an incident, systems are rebooted or wiped before evidence is collected.

### ✅ Likely Causes
- No minimum evidence checklist
- No instructions for SIEM/log preservation

### ✅ Resolution
Add a minimum evidence checklist:
- preserve auth logs / SIEM timeline export
- record timestamps and actions taken
- snapshot affected VM or take disk image (if possible)
- capture network indicators (IPs/domains)

### ✅ Prevention
Make evidence handling part of the “first actions” section.

---

## 6) Tabletop exercise feels unrealistic

### ❗ Problem
The tabletop doesn’t reveal real gaps because it’s too simple.

### ✅ Likely Causes
- Scenario not detailed enough
- Missing constraints (time pressure, missing logs, user unavailability)

### ✅ Resolution
Add constraints:
- multiple users affected
- attacker uses VPN / rotating IPs
- logs delayed or missing
- leadership requests immediate briefing

### ✅ Prevention
Rotate scenarios (phishing, ransomware, insider abuse, cloud key leak) across sessions.

---

## 7) The IRP is not updated as the environment changes

### ❗ Problem
Roles/contact lists are outdated and tools referenced no longer match reality.

### ✅ Likely Causes
- No review schedule
- Ownership of the document unclear

### ✅ Resolution
Add a “review cadence” section and assign document ownership:
- quarterly review
- update after major incidents or tool changes

### ✅ Prevention
Include IRP review in security program calendar.

---

## 8) Missing incident tracking and documentation structure

### ❗ Problem
Incident notes are scattered across messages and documents.

### ✅ Likely Causes
- No standard template for incident tickets
- No timeline format enforced

### ✅ Resolution
Add:
- incident ticket template fields (time, impact, actions, IOCs, owner)
- timeline section requirement
- decision log section

### ✅ Prevention
Use the tabletop notes format as a template for future incidents.

---
