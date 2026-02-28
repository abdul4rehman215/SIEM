# 🛡️ Lab 31: File Integrity Monitoring (FIM) with auditd (Optional)

## 🧾 Lab Summary
This lab implemented a basic **File Integrity Monitoring (FIM)** setup using **auditd** on Ubuntu. I installed and enabled auditd, configured an audit rule to monitor a sensitive system file (`/etc/passwd`), generated a safe change event, and verified that audit logs captured the modification with a searchable key (`passwd_changes`).

---

## 🎯 Objectives
- Understand the fundamentals of File Integrity Monitoring (FIM)
- Configure FIM using open-source tools (`auditd`, `auditctl`)
- Monitor files/directories for unauthorized changes
- Trigger and observe alerts/log entries for file changes

---

## ✅ Prerequisites
- Basic Linux command-line skills
- Linux environment (Ubuntu, CentOS, etc.)
- Packages:
  - `auditd`
  - `auditctl` (provided with auditd package on Ubuntu)
  - `ausearch`, `aureport` (audit utilities)

---

## 📌 Introduction
**File Integrity Monitoring (FIM)** is a core defensive security practice. It detects unauthorized changes to critical files (system configs, auth files, policies), helping identify persistence attempts, privilege escalation, or configuration tampering.  
In this lab, **auditd** was used to monitor file changes and record events in a structured way for forensic review.

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Hostname | ip-REDACTED |
| User | toor |
| Tooling | auditd / auditctl / ausearch / aureport |
| Target monitored | `/etc/passwd` |
| Audit key | `passwd_changes` |

---

## 🗂️ Repository Structure
```text
lab31-file-integrity-monitoring-auditd/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## ✅ Tasks Overview (No Commands Here)

### ✅ Task 1: Install and Configure auditd

* Verified the OS environment
* Installed required packages (`auditd`, `audispd-plugins`)
* Started and enabled the auditd service
* Verified auditctl version to confirm install success

### ✅ Task 2: Identify Files/Directories to Monitor

* Selected a sensitive system file for demonstration:

  * `/etc/passwd`

### ✅ Task 3: Configure auditd Monitoring Rules

* Applied a watch rule for `/etc/passwd`
* Monitored:

  * `w` (writes)
  * `a` (attribute changes)
* Assigned an audit key:

  * `passwd_changes` (used to search and summarize alerts easily)

### ✅ Task 4: Generate a Change Event

* Performed a safe modification using `sudo nano /etc/passwd`
* Made an insignificant change to trigger the audit event **without breaking file format**

  * Added a trailing space to the `toor` user line
* Saved and exited editor

### ✅ Task 5: Verify Alert Generation

* Searched audit logs for `/etc/passwd` events using `ausearch`
* Verified event contents:

  * timestamp
  * file path
  * process (`nano`)
  * user context (`auid` vs `uid`)
  * key (`passwd_changes`)
* Generated summary report using `aureport` and confirmed event count

---

## ✅ Verification & Evidence (Key Forensic Elements Observed)

From the captured audit event, key forensic fields included:

* **time**: when the change occurred
* **file**: `/etc/passwd`
* **process**: `nano`
* **uid=0**: change executed as root (via sudo)
* **auid=1001**: original authenticated user (`toor`)
* **key**: `passwd_changes` (fast searching + reporting)

---

## 🌍 Why This Matters

FIM helps detect:

* unauthorized user or attacker persistence
* unexpected changes to auth files
* stealth privilege escalation via config tampering
* policy violations or accidental misconfigurations

Even simple watch rules can provide early warning signals for compromise.

---

## 🧩 Real-World Applications

* Monitor authentication and privilege files:

  * `/etc/passwd`, `/etc/shadow`, `/etc/sudoers`
* Monitor SSH configuration changes:

  * `/etc/ssh/sshd_config`
* Compliance and auditing (baseline integrity enforcement)
* Forensics during incident response:

  * Identify who changed what, when, and by which process

---

## 🧠 What I Learned

* How to install and verify auditd on Ubuntu
* How to create file watch rules using `auditctl`
* How to validate rule installation (`auditctl -l`)
* How to confirm events in audit logs using `ausearch`
* How audit keys simplify reporting and investigations

---

## ✅ Conclusion

This lab successfully demonstrated basic File Integrity Monitoring using auditd. By applying a watch on `/etc/passwd`, triggering a controlled change, and validating logs with `ausearch` and `aureport`, I confirmed that auditd can be used to detect and document sensitive file modifications—an essential capability for system hardening and incident response.

---

