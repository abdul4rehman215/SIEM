# 🧪 Lab 06: Navigating the SIEM Interface

## 🧾 Lab Summary
This lab focuses on learning how to **navigate a SIEM GUI**, using **Kibana (part of Elastic Stack)** as the SIEM interface for practice. The lab covers:
- Confirming Kibana is running and reachable
- Accessing the login page and validating authentication events
- Exploring key SIEM interface areas:
  - Dashboards
  - Alerts
  - Configuration / Management
- Reviewing user settings and UI customization
- Practicing **GUI automation** using a Selenium script (with realistic cloud lab limitations)

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand the layout and features of a SIEM interface (Kibana)
- Identify and navigate key sections like Dashboards, Alerts, and Configuration
- Understand where integrations, index management, rules, and connectors live in the UI
- Explore user settings and theme customization options
- Attempt SIEM GUI login automation using Python + Selenium (practice workflow)

---

## ✅ Prerequisites
- Basic understanding of network security and monitoring concepts
- Access to an open-source SIEM solution (ELK / Kibana)
- An account with permissions to log in and navigate the SIEM interface

---

## 🧪 Lab Environment
- **OS:** Ubuntu 24.04.1 LTS
- **SIEM Interface Used:** Kibana (ELK)
- **Prompt style:** `toor@ip-172-31-10-197:~$`
- **Python:** 3.12.3
- **pip:** 24.0
- **Notes:** GUI navigation was performed via browser access to Kibana; terminal commands were used for service verification and evidence.

---

## 🛠️ Tasks Overview (What I Did)

### ✅ Task 1 — Log in to the SIEM GUI
- Verified Kibana service status (`systemctl status kibana`)
- Verified Kibana listening port (`ss -lntp | grep :5601`)
- Verified login endpoint response (`curl -I http://localhost:5601`)
- Performed login via browser:
  - Opened: `http://localhost:5601/login`
  - Entered credentials (lab admin account)
  - Logged in and reached Kibana home
- Verified login evidence from Kibana logs:
  - Successful authentication event recorded in `/var/log/kibana/kibana.log`

### ✅ Task 2 — Identify Key Sections
- **Dashboards**
  - Navigated to: `Analytics → Dashboard`
  - Viewed default dashboards / SIEM overview
  - Observed widgets such as event counts, top sources, recent alerts/events, and search filtering

- **Alerts**
  - Navigated to: `Security → Alerts` (or `Observability → Alerts`, depending on Kibana layout)
  - Observed alert categories by severity, rule name, time, and source
  - Opened an alert to view rule details and matched fields

- **Configuration / Management**
  - Navigated to:
    - `Management → Integrations`
    - `Stack Management → Index Management`
    - `Stack Management → Rules and Connectors`
  - Noted configuration areas for inputs, parsing, outputs, and notifications

### ✅ Task 3 — User Settings and Theme Options
- Opened user/profile menu (top-right) to explore profile/session/notification settings (permission-dependent)
- Navigated to `Stack Management → Advanced Settings` to locate UI appearance options
- Documented theme config example by creating a JSON file:
  - `theme_config.json`

### ✅ Automation Practice — Selenium Login Script (Python)
- Installed Selenium using pip
- Wrote `scripts/selenium_login.py` using modern Selenium syntax (`By.ID`, `By.NAME`)
- Ran script and captured realistic cloud-lab limitation:
  - Chrome/Chromium and chromedriver were not available → `NoSuchDriverException`

---

## ✅ Verification & Validation
- Kibana is running:
  - `sudo systemctl status kibana --no-pager`
- Port is listening:
  - `ss -lntp | grep ':5601'`
- Login endpoint responds:
  - `curl -I http://localhost:5601`
- Successful GUI login confirmed in logs:
  - `sudo tail -n 15 /var/log/kibana/kibana.log`
- Selenium installed:
  - `pip3 install selenium`
- Theme config file created and verified:
  - `cat theme_config.json`

---

## 📁 Repository Structure
```text
lab06-navigating-the-siem-interface/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── scripts/
    ├── selenium_login.py
    └── theme_config.json
````

---

## 🌍 Why This Matters

A SIEM is only useful if analysts can quickly:

* locate dashboards and logs
* interpret alerts and drill into context
* manage integrations and pipelines
* tune detection rules and connectors

Knowing where key SIEM features live in the interface directly improves SOC response time and investigation efficiency.

---

## 🧩 Real-World Applications

* SOC analyst workflow: dashboards → alerts → investigation → reporting
* Alert tuning and rule management in production SIEMs
* Faster triage by using filters, queries, and context views
* Basic automation practice for repetitive tasks (UI testing and navigation checks)

---

## ✅ Result

* Kibana verified running and responding (HTTP redirect to login page)
* GUI login completed successfully (validated in kibana.log)
* Key UI areas explored: dashboards, alerts, stack management configuration
* Selenium automation script created using modern syntax
* Script execution failed as expected in cloud lab due to missing Chrome/chromedriver
* Theme configuration JSON file created for customization practice

---

## 🏁 Conclusion

This lab built confidence in navigating a SIEM interface by exploring Kibana’s dashboards, alerts, configuration menus, and user settings. It also included automation practice with Selenium, demonstrating realistic tool constraints in a headless cloud lab environment. These skills support faster investigations and better SIEM usability in real SOC workflows.

✅ Lab completed successfully (GUI navigation documented + automation practice included)

----
