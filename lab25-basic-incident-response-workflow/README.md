# 🧪 Lab 25: Basic Incident Response Workflow

## 🧾 Lab Summary
This lab walks through a basic **incident response workflow** using open-source tools:

- **Fail2Ban** to simulate and automatically mitigate repeated SSH login failures (brute-force behavior)
- **ELK Stack** (Elasticsearch, Logstash, Kibana) to ingest, search, and document incident evidence

The workflow mirrors real SOC steps:
1) Detect suspicious activity (failed logins)
2) Contain/mitigate (Fail2Ban ban)
3) Collect evidence (Fail2Ban logs + service status)
4) Ingest into SIEM (Logstash → Elasticsearch)
5) Investigate and document in SIEM (Kibana Discover)
6) Close out with a structured summary + prevention actions

✅ Environment note:
The lab mentions Ubuntu 20.04, but this run was on Ubuntu 24.04.1 LTS. The commands and configuration steps are identical.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Configure Fail2Ban to detect and ban repeated failed SSH attempts
- Simulate an SSH brute-force scenario and verify an IP ban
- Collect and validate evidence from Fail2Ban logs and status output
- Integrate Fail2Ban logs into ELK via Logstash file input + grok parsing
- Verify indexed Fail2Ban events in Elasticsearch and document the incident in Kibana
- Produce a professional incident closure summary and recommended preventative controls

---

## 📌 Prerequisites
- Basic understanding of network security and SSH brute-force patterns
- Familiarity with Linux terminal commands
- ELK stack installed and running (Elasticsearch, Logstash, Kibana)
- Root/sudo privileges in the environment

---

## 🧪 Tools & Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS (Cloud Lab Environment) |
| User | `toor` |
| SIEM | ELK Stack (Elasticsearch, Logstash, Kibana) |
| Simulation tool | Fail2Ban |
| Primary logs | `/var/log/auth.log` (SSH auth) and `/var/log/fail2ban.log` |

---

## 🗂️ Repository Structure
```text
lab25-basic-incident-response-workflow/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── configs/
│   ├── fail2ban-jail.local
│   └── logstash-fail2ban.conf
└── artifacts/
    ├── fail2ban-service-status.txt
    ├── fail2ban-jail-status.txt
    ├── fail2ban-log-tail.txt
    ├── elk-health-checks.txt
    ├── fail2ban-index-cat.txt
    ├── fail2ban-es-search.json
    └── incident-closure-summary.md
````

> Notes:
>
> * `configs/` contains the exact configs applied for Fail2Ban and Logstash.
> * `artifacts/` captures evidence outputs needed for SIEM documentation and incident reporting.

---

## 🧩 Incident Response Workflow (What I Did)

## ✅ Phase 1: Preparation

* Ensured I had the tools needed:

  * Fail2Ban installed for mitigation
  * ELK stack operational for SIEM logging and investigation

---

## ✅ Phase 2: Detection & Analysis (Simulating the Incident)

### 1) Install Fail2Ban

Installed Fail2Ban as the detection/containment tool.

### 2) Enable SSH jail and define ban policy

Created `/etc/fail2ban/jail.local` with:

* `maxretry = 3`
* `findtime = 600` seconds (10 minutes)
* `bantime = 3600` seconds (1 hour)
* `logpath = /var/log/auth.log`
* jail enabled for `sshd`

Restarted Fail2Ban and verified:

* service running
* `sshd` jail enabled

### 3) Simulate brute-force attempts

Triggered multiple failed SSH logins using `ssh wronguser@localhost` and `ssh admin@localhost`.

### 4) Validate detection + containment

Confirmed Fail2Ban banned the source IP:

* Because the brute-force simulation was from localhost, the banned IP became `127.0.0.1` (lab-realistic outcome).

Collected evidence:

* jail status output (`fail2ban-client status sshd`)
* tail of Fail2Ban logs showing `Found` entries and `Ban` event

---

## ✅ Phase 3: Containment (Automatic via Fail2Ban)

Fail2Ban automatically banned the abusive source IP once thresholds were exceeded.
This demonstrates immediate containment in a real incident.

---

## ✅ Phase 4: SIEM Logging & Documentation (ELK Integration)

### 1) Confirm ELK services operational

Verified:

* Elasticsearch responding on `localhost:9200`
* Logstash and Kibana active

### 2) Configure Logstash to ingest Fail2Ban logs

Created `/etc/logstash/conf.d/fail2ban.conf`:

* `file` input reads `/var/log/fail2ban.log`
* `sincedb_path => "/dev/null"` ensures full read during lab testing
* `grok` parses Fail2Ban log format into structured fields:

  * `timestamp`, `level`, `details`
* output sends events to index:

  * `fail2ban-YYYY.MM.dd`

Restarted Logstash and confirmed it stayed running.

### 3) Verify in Elasticsearch + Kibana

Confirmed in Elasticsearch:

* index exists (`fail2ban-2026.02.28`)
* documents are searchable (`Ban` and `Found` events)

In Kibana (documented actions):

* created data view `fail2ban-*`
* filtered for ban events using KQL:

  * `details : "Ban*"`
* recorded incident notes and assigned to an analyst (example: `analyst_user`)

---

## ✅ Phase 5: Eradication & Recovery (Lab Context)

In a real incident:

* eradication includes removing attacker access, patching, resetting passwords, tightening auth controls
* recovery includes restoring services safely and increasing monitoring

In this lab:

* mitigation was demonstrated via automated banning and SIEM visibility.

---

## ✅ Phase 6: Lessons Learned / Closure

### Incident Closure Summary (Key Points)

* Incident: repeated SSH login failures (brute-force style)
* Date: **February 28, 2026**
* Target: SSH service (`sshd`) on host `ip-172-31-10-203`
* Indicators:

  * multiple failed login attempts
  * Fail2Ban `Ban` event
* Actions taken:

  1. Installed Fail2Ban
  2. Enabled sshd jail + configured ban thresholds
  3. Simulated brute-force failures to validate detection
  4. Verified ban status and collected logs
  5. Ingested Fail2Ban logs into ELK via Logstash
  6. Verified searchable SIEM evidence in Elasticsearch/Kibana
  7. Documented and closed incident with preventative controls

### Preventative Recommendations

* Enable SSH key-based auth and disable password auth where possible
* Enforce strong password policy + lockout controls
* Restrict SSH exposure (VPN, allowlist, firewall rules)
* Add Kibana alerts:

  * spike in `Found` events
  * any `Ban` events
* Consider MFA or bastion host for admin access

---

## ✅ Result

* ✅ Fail2Ban installed and sshd jail enabled
* ✅ Brute-force simulation triggered detection and ban
* ✅ Ban verified via Fail2Ban status + logs
* ✅ Fail2Ban logs ingested into ELK via Logstash
* ✅ Fail2Ban events searchable in Elasticsearch (fail2ban-YYYY.MM.dd)
* ✅ Incident documented and closed with structured summary

---

## 🏁 Conclusion

This lab provided hands-on experience in a basic incident response workflow: detection, containment, evidence collection, SIEM ingestion, investigation, and closure. Integrating Fail2Ban events into ELK demonstrates how operational security tooling and SIEM platforms work together to improve visibility, speed response, and provide a clear audit trail for security incidents.

---
