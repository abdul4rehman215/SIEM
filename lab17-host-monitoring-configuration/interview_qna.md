# 🎤 Interview Q&A — Lab 17: Host Monitoring Configuration

## 1) What is a Host-based Intrusion Detection System (HIDS)?
A HIDS monitors internal host activity such as log events, file integrity changes, user actions, and suspicious processes. Unlike network IDS, it focuses on what happens on the machine itself.

---

## 2) Why use OSSEC or Wazuh for host monitoring?
They provide:
- file integrity monitoring (syscheck)
- log analysis and alerting
- rootkit detection
- active response capabilities
- integration pipelines for SIEM dashboards and alerting workflows

---

## 3) What installation type did you use for OSSEC and why?
I used the **local** installation type for simplicity in the lab. It runs OSSEC on the same host and generates alerts locally, which is good for learning and testing.

---

## 4) What is Syscheck in OSSEC?
Syscheck is OSSEC’s file integrity monitoring component. It detects file changes (content, permissions, ownership, checksums) within monitored paths and generates alerts when changes occur.

---

## 5) Which directories did you monitor and why?
- `/etc` → critical system configuration integrity
- `/usr/bin` → system binaries (tampering detection)
- `/var/www` → web root (web shell, defacement, unauthorized changes)

These are common high-value targets in real attacks.

---

## 6) How did you confirm OSSEC was running properly?
I checked:
- `systemctl status ossec`
- `/var/ossec/bin/ossec-control status`
This confirmed the service and components (analysisd, syscheckd, rootcheck, logcollector, execd) were active.

---

## 7) How do OSSEC alerts typically reach a SIEM?
Usually through:
- an agent/manager architecture (e.g., Wazuh Manager ingesting agent events)
- log forwarders (Filebeat/Logstash/rsyslog)
- direct ingestion of OSSEC alert logs into an index
In this terminal-only lab, I validated alerts locally in OSSEC logs (the same content a SIEM would ingest).

---

## 8) How did you test that file integrity monitoring was working?
I created a file in a monitored directory:
- `sudo touch /etc/monitored_file`
Then forced a scan by restarting OSSEC, and validated the syscheck alert in:
- `/var/ossec/logs/alerts/alerts.log`

---

## 9) What evidence did you use to prove the alert was generated?
I verified:
- the alert block exists in `alerts.log`
- it references the file path `/etc/monitored_file`
- it shows rule details (Rule 550, syscheck)
This is SIEM-ready evidence.

---

## 10) What is “rootcheck” in OSSEC?
Rootcheck is OSSEC’s rootkit and policy auditing component. It checks for common rootkit indicators and suspicious system artifacts.

---

## 11) What are “local rules” in OSSEC and why are they used?
Local rules allow custom detections specific to an environment. They are used to:
- tune alerts
- reduce noise
- add organization-specific detection logic
In this lab, I added a template rule group to demonstrate customization.

---

## 12) What is “active response” in OSSEC?
Active response is the ability to automatically react to alerts (e.g., block an IP, disable a user, execute a script). It can improve response time but must be carefully controlled to avoid disrupting legitimate activity.

---

## 13) What are common challenges when deploying HIDS at scale?
- alert noise (false positives)
- performance overhead (large file monitoring scopes)
- tuning rules and thresholds
- secure log forwarding to SIEM
- ensuring consistent configs across hosts
- handling updates without breaking monitoring

---

## 14) How would you make this lab closer to a production SIEM setup?
- forward OSSEC alerts into ELK/Wazuh Manager
- enrich events with asset tags, environment metadata
- create dashboards for syscheck and auth anomalies
- implement alert routing (email/webhook/ticket)
- tune syscheck frequency and monitored scope

---

## 15) Why is host monitoring important even if you already have network monitoring?
Network monitoring may miss:
- insider actions
- local privilege escalation
- file tampering and persistence
- offline changes
Host monitoring provides deeper visibility into what actually changed on the system.
