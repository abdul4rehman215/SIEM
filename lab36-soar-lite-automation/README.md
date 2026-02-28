# 🤖 Lab 36: Automating Simple Responses (SOAR Lite)

## 🧾 Lab Summary
This lab demonstrated a **SOAR Lite** workflow: **detect → alert → automated containment**. I installed and enabled **osquery** (via the official repo), created a simple firewall auto-block script using `iptables`, and prepared a lightweight **StackStorm** rule to trigger the action on a “port scan detected” alert. For testing, I simulated a port scan locally using `nmap` with a loopback source IP (`127.0.0.2`) and validated that the block action was effective by confirming the port state changed to **filtered** after the firewall rule was applied. I also logged the response action for auditability.

---

## 🎯 Objectives
- Understand SOAR fundamentals (Security Orchestration, Automation, and Response)
- Configure an automated response to a simple security event (port scan)
- Show how automation improves response time and consistency

---

## ✅ Prerequisites
- Linux CLI familiarity
- Basic network security knowledge
- Internet connectivity (for repos/packages)
- Monitoring tool: **osquery**
- Response tool: **iptables**
- Orchestration (optional): **StackStorm**

---

## 🧠 Key Concepts
- **SOAR:** Automates repeatable response actions to reduce manual work and speed containment
- **osquery:** Endpoint visibility via SQL-like queries on system state (processes, sockets, users, etc.)
- **iptables:** Linux firewall rule management (drop/accept traffic)
- **StackStorm:** Event-driven automation platform for connecting triggers → actions

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Hostname | ip-REDACTED |
| User | toor |
| osquery | 5.14.1 |
| nmap | 7.95 |
| Firewall | iptables |
| Orchestration | StackStorm (assumed available for lab) |

---

## 🗂️ Repository Structure
```text
lab36-soar-lite-automation/
├── README.md
├── commands.sh
├── output.txt
├── scripts/
│   └── auto_block.sh
├── rules/
│   └── auto-block-rule.yaml
├── artifacts/
│   └── soar_actions.log
├── interview_qna.md
└── troubleshooting.md
````

---

## ✅ Tasks Overview (No Commands Here)

### ✅ Task 1: Configure Automated Response

**Scenario:** Unauthorized port scanning detected
**Approach:**

* Install osquery (official repo)
* Create `auto_block.sh` to drop traffic from attacker IP using iptables
* Create a StackStorm rule to run `auto_block.sh` when an alert payload indicates a port scan

### ✅ Task 2: Trigger the Condition (Simulated Attack)

* Installed `nmap`
* Simulated attacker IP without a second VM:

  * added loopback alias `127.0.0.2`
  * scanned localhost from the simulated attacker IP
* Used osquery to detect `nmap` execution as the “alert signal”

### ✅ Task 3: Verify Response Execution

* Executed `auto_block.sh` with attacker IP `127.0.0.2`
* Verified iptables rule exists
* Verified scan results changed from **open** to **filtered**
* Logged action to `soar_actions.log` for response audit trail

---

## ✅ Results

✔ osquery installed and running (`osqueryd`)
✔ nmap scan simulated successfully from `127.0.0.2`
✔ “Detection” performed via osquery process query (nmap execution)
✔ Auto-block script added DROP rule in iptables
✔ Post-block scan showed port **filtered** confirming containment
✔ Response action logged in `soar_actions.log`

---

## 🌍 Why This Matters

SOAR Lite automation helps security teams:

* respond faster to common threats
* reduce analyst fatigue
* standardize containment actions
* create consistent audit trails

Even simple actions like **auto-blocking a scanning IP** can reduce exposure time in early incident stages.

---

## 🧩 Real-World Applications

* Blocking brute-force IPs at firewall
* Disabling compromised accounts automatically
* Isolating endpoints on detection of known malware processes
* Auto-ticket creation + response logging for SOC workflows
* “First response” automation during after-hours incidents

---

## 🧠 What I Learned

* How to install and validate osquery via official repositories
* How to simulate attack traffic safely in a single-host lab
* How to automate a basic containment action using iptables
* How orchestration rules (StackStorm) connect alert payloads to response scripts
* Why response logging matters for accountability and review

---

## ✅ Conclusion

This lab provided a working example of SOAR Lite: using endpoint detection signals (osquery) and fast containment (iptables) to automatically block suspicious activity. Even simple automation can significantly improve response speed and consistency when applied to common, repeatable security events.

---
