# 💬 Interview Q&A — Lab 01: Introduction to SIEM

---

## 1) What is a SIEM?
A **SIEM (Security Information and Event Management)** is a platform that **collects**, **normalizes**, **correlates**, and **analyzes** logs/events from multiple sources to detect suspicious activity and generate security alerts.

---

## 2) Why is SIEM important in cybersecurity?
SIEM provides:
- Centralized visibility across infrastructure
- Faster detection of threats through correlation
- Historical log retention for investigations
- Alerting and reporting for incident response and compliance

---

## 3) What are the three core functions of a SIEM demonstrated in this lab?
- **Log Collection** (collecting firewall + web logs)
- **Correlation** (rules that match patterns across logs)
- **Alerting** (creating alerts and optionally notifying admins)

---

## 4) What is log collection?
Log collection is the process of gathering logs from systems such as:
- endpoints
- servers
- firewalls
- web servers
- authentication services

In this lab, Wazuh monitored `ufw.log` and nginx logs.

---

## 5) What is correlation in SIEM?
Correlation is the ability to **connect related events** and detect patterns (e.g., repeated failed logins, suspicious IP behavior) that may indicate an attack.

---

## 6) How does Wazuh support correlation?
Wazuh uses:
- Rules (XML rule files)
- Decoders (to interpret log formats like syslog/json)
- Alert levels (severity scoring)

---

## 7) Why did the custom rule use `<decoded_as>json</decoded_as>`?
Because the test event was generated as JSON, and the rule needed Wazuh to interpret fields like:
- `action`
- `status`
so it could match `login` + `failure`.

---

## 8) What is the role of `alerts.json` in Wazuh?
`alerts.json` contains SIEM-generated alerts, including:
- rule ID
- description
- level (severity)
- fired times
- event data fields
- log source location

It’s a key validation artifact.

---

## 9) Why did you add `custom_app.json` as a monitored log file?
Because the rule was designed for JSON events, so a JSON log file needed to be monitored by Wazuh logcollector to trigger the rule properly.

---

## 10) Why use `--network host` for the Wazuh container?
Host networking allows services inside the container to bind directly to the host network stack. This is common in testing labs for:
- easier port exposure
- fewer networking complications
- realistic service binding behavior

---

## 11) What alert level was generated and what does it mean?
The rule fired with **level 10**, which generally indicates a higher severity event requiring attention (in this case, a failed login attempt).

---

## 12) Why did email alerting not show “email sent” logs?
In many cloud lab environments:
- no SMTP service is running locally
- outbound email may be restricted

The important verification is: **event → correlation match → alert generated**, confirmed in `alerts.json`.

---

## 13) How can a SIEM help an HOA environment?
An HOA can use SIEM to:
- detect unauthorized logins on shared admin systems
- monitor firewall and access logs
- identify abnormal patterns (brute force, scanning)
- improve security posture with alerts and reporting

---

## 14) What is one improvement you would add next?
A realistic next step would be:
- integrate dashboards (Wazuh UI/Kibana)
- enable RBAC roles
- add additional sources (Windows events, router logs)
- tune rules to reduce false positives

---
