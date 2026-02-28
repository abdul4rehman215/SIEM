# 📧 Lab 14: Setting Up Email Notifications

## 🧾 Lab Summary
This lab demonstrates how to configure **email notifications** for alerts using an SMTP relay and validate the end-to-end alert delivery workflow.  
Because this is a **cloud lab** (and external SMTP examples are not usable for testing), I implemented a **local SMTP relay (Postfix)** on Ubuntu and verified alert delivery using a **real local mailbox**.

This is a foundational monitoring skill used in:
- Security monitoring & alerting
- Operational incident response
- SIEM/SOC workflows (notifications + escalation paths)

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Configure email notifications using an SMTP server
- Create and store alert rule definitions in configuration files
- Implement a simple alert engine (CLI version) to trigger email alerts
- Generate test alerts using realistic log simulation
- Verify successful email delivery end-to-end using local mailbox validation

---

## ✅ Prerequisites
- Basic understanding of email systems (SMTP concept)
- Basic Linux CLI skills
- Ability to edit configuration files (nano)
- Access to a Linux environment where SMTP testing is allowed

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Environment | Cloud Lab Environment |
| User | `toor` |
| SMTP Approach | Local relay using Postfix (lab-realistic testing) |

---

## 🗂️ Repository Structure
```text
lab14-setting-up-email-notifications/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    └── failed_login_alert.sh
````

---

## 🧩 Tasks Overview (What I Performed)

### ✅ Task 1: Verify Environment

* Confirmed OS version and working directory
* Ensured the lab environment matches requirements for SMTP testing

### ✅ Task 2: Install Mail Utilities + Configure Local SMTP Relay (Postfix)

* Installed Postfix and mail tools (`mailutils`)
* Verified Postfix service is active
* Confirmed the system can send mail locally using SMTP (port 25)

### ✅ Task 3: Configure SMTP Settings for the Alert System

* Created `/etc/alert_system.conf`
* Added SMTP parameters configured for **localhost relay**
* Validated configuration file contents

### ✅ Task 4: Define an Alert Rule (CLI-based lab format)

* Created `/etc/alert_rules.conf` defining:

  * Alert name
  * Condition (5 failed logins in 1 minute)
  * Trigger action (send email)
  * Recipient address ([admin@example.com](mailto:admin@example.com) format)

### ✅ Task 5: Implement Alert Engine (Bash Script)

* Created an alert checker script:

  * Reads recent failed login attempts from journalctl (last 1 minute)
  * Includes fallback logic for `/var/log/auth.log` if present
  * Triggers email notification when threshold is met
* Made the script executable and tested initial state (no alerts)

### ✅ Task 6: Simulate Failed Login Events + Validate Email Delivery

* Simulated 5 failed SSH login logs using `logger`
* Verified log entries exist via `journalctl`
* Re-ran the alert script → email alert triggered
* Checked mailbox of local recipient user and validated message content

---

## 🔍 Verification & Validation

I validated success using the following checks:

* ✅ Postfix service status shows **active (running)**
* ✅ Alert rule exists and is readable from `/etc/alert_rules.conf`
* ✅ Alert script reports:

  * **No alert** when failed logins are missing
  * **Alert sent** when threshold is reached
* ✅ Local mailbox (`admin`) contains the delivered message:

  * Subject: `Alert: Failed Login Attempts`
  * Body: expected alert message

---

## 🧠 What I Learned

* Email notifications are a critical last-mile component of monitoring and alerting.
* A lab-safe way to test email alerts is to deploy a **local SMTP relay** and use local delivery.
* Failed authentication events can be tested safely by **log simulation** (`logger`) rather than real brute force.
* The full chain must be validated:

  * Log event → rule condition → alert trigger → SMTP send → mailbox delivery

---

## 🌍 Why This Matters

Email alerting is still widely used in production because it enables:

* Fast escalation during incidents
* Operational awareness for SOC/IT teams
* Integration with ticketing and on-call workflows
* Alert confirmation during monitoring stack setup

If alerts are not validated end-to-end, organizations often discover problems **only after a real incident**.

---

## 🧰 Real-World Applications

This workflow maps directly to:

* SIEM alert notifications (SOC escalations)
* Host-based monitoring alerts (authentication failures, suspicious activity)
* Infrastructure monitoring (service down, disk full, high CPU)
* Compliance monitoring (critical policy violations)

---

## ✅ Result

* ✅ Local SMTP relay (Postfix) installed and running
* ✅ SMTP configuration file created and validated
* ✅ Alert rule created and stored in config
* ✅ Alert engine implemented via Bash
* ✅ Alert triggered successfully using simulated failed login logs
* ✅ Email delivered and verified through local mailbox inspection

---

## 🏁 Conclusion

This lab successfully demonstrated a complete email notification workflow using a realistic lab setup.
By configuring Postfix as a local SMTP relay and validating alerts using simulated authentication failures, I verified that the alert + notification chain works end-to-end — a key capability for SOC monitoring and operational security response.

✅ Lab completed successfully on Ubuntu cloud environment
✅ SMTP configured and validated using an end-to-end test
✅ Alert rule verified via simulated failed logins + email notification

---
