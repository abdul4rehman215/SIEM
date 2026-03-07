# 🛰️ SIEM - Engineering & Log Management Portfolio

> Enterprise SIEM Architecture • Log Pipeline Engineering • Detection Foundations • SOC Operations • Alerting & IR Workflow • SIEM Operations Maturity

### A complete 40-lab hands-on SIEM engineering program progressing from log pipeline architecture and multi-source ingestion to detection logic, alert tuning, SOC investigations, automation, governance, and SIEM maturity planning.
### Simulates real-world SOC Tier 1 → Tier 2 → SIEM Engineering workflows across endpoint, server, and network telemetry.

<div align="center">
  
<!-- ===================== PLATFORM & STACK ===================== -->
![OS](https://img.shields.io/badge/OS-Ubuntu%2024.04-orange?style=for-the-badge&logo=ubuntu)
![Linux](https://img.shields.io/badge/Linux-Security-black?style=for-the-badge&logo=linux)
![Windows](https://img.shields.io/badge/Windows-Event%20Logs-0078D6?style=for-the-badge&logo=windows)
![Python](https://img.shields.io/badge/Python-3.x-3776AB?style=for-the-badge&logo=python)
![Bash](https://img.shields.io/badge/Bash-Scripting-4EAA25?style=for-the-badge&logo=gnubash)
![PowerShell](https://img.shields.io/badge/PowerShell-Core-5391FE?style=for-the-badge&logo=powershell)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker)

<!-- ===================== SOC FOCUS ===================== -->
![Focus](https://img.shields.io/badge/Focus-SOC%20Operations-red?style=for-the-badge)
![SIEM](https://img.shields.io/badge/SIEM-Engineering-0A66C2?style=for-the-badge)
![Log](https://img.shields.io/badge/Log-Engineering-111827?style=for-the-badge)
![Detection](https://img.shields.io/badge/Detection-Engineering-critical?style=for-the-badge)
![Correlation](https://img.shields.io/badge/Log-Correlation-important?style=for-the-badge)
![IR](https://img.shields.io/badge/Incident-Response-blueviolet?style=for-the-badge)
![DFIR](https://img.shields.io/badge/Forensics-Log%20Forensics-purple?style=for-the-badge)
![SOAR](https://img.shields.io/badge/SOAR-Lite%20Automation-orange?style=for-the-badge)

<!-- ===================== STATUS ===================== -->
![Labs](https://img.shields.io/badge/Labs-40%20Hands--On-brightgreen?style=for-the-badge)
![Level](https://img.shields.io/badge/Level-Foundation%20→%20Intermediate-blueviolet?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)

<!-- ===================== REPO METADATA (EDIT IF NEEDED) ===================== -->
![Repo Size](https://img.shields.io/github/repo-size/abdul4rehman215/Security-Information-Event-Management-SIEM?style=for-the-badge)
![Stars](https://img.shields.io/github/stars/abdul4rehman215/Security-Information-Event-Management-SIEM?style=for-the-badge)
![Forks](https://img.shields.io/github/forks/abdul4rehman215/Security-Information-Event-Management-SIEM?style=for-the-badge)
![Last Commit](https://img.shields.io/github/last-commit/abdul4rehman215/Security-Information-Event-Management-SIEM?style=for-the-badge)

</div>

---

## 🎯 Executive Summary

This portfolio demonstrates practical capability across:

- ✅ SIEM Deployment & Architecture (ELK Stack)
- ✅ Multi-Source Log Ingestion (Windows, Linux, Router/Firewall)
- ✅ Parsing & Normalization (Grok, Regex, structured fields)
- ✅ Detection & Correlation Engineering
- ✅ Alert Triage & SOC Investigation Workflow
- ✅ Threat Intelligence Integration
- ✅ Incident Response Simulation & Documentation
- ✅ SIEM Health Monitoring, Retention & Governance
- ✅ SOAR-Lite Automation & Containment Validation

This is not theoretical content.

Each lab includes:
- Executed commands with validation outputs
- Logstash / Beats / Alert rule configurations
- Structured dashboards (SOC + Executive views)
- Detection logic implementation
- Investigation notes & IR documentation
- Troubleshooting & engineering fixes
- Automation scripts (Bash / Python)

The portfolio represents operational SIEM engineering work — not academic exercises.

---

## 📌 About This Repository

A structured 40-lab SIEM Engineering program simulating real enterprise security monitoring environments.

The program progresses through:

- SIEM foundations & architecture design  
- Log onboarding & pipeline engineering  
- Field extraction & normalization  
- Detection logic & correlation development  
- Alert tuning & noise reduction  
- SOC investigation workflows  
- Incident simulation & documentation  
- Dashboarding & executive reporting  
- SIEM operations health checks  
- Governance, retention & maturity roadmap planning  

All labs are executed in controlled Ubuntu-based lab environments using open-source security tooling and production-style validation workflows.

This repository reflects hands-on SIEM administration and detection engineering capability across endpoint, server, and network telemetry layers.

---

## 👥 Who This Repository Is For

- SOC Analysts (Tier 1 / Tier 2) building real SIEM investigation depth  
- SIEM Engineers responsible for ingestion, parsing, retention, and operations  
- Detection Engineers developing correlation rules and reducing false positives  
- Blue Team practitioners strengthening monitoring architecture  
- Security professionals preparing for enterprise SOC roles  
- Recruiters and hiring managers evaluating applied SIEM engineering capability

---

## 🗂️ Labs Index (1–20)

> Click any lab title to jump directly to its folder.

---

# 🗂 Lab Architecture Overview

# 📌 Section 1 — SIEM Foundations & Log Engineering (Labs 1–13)

### 🏗️ Building the Log Pipeline Foundation

<div>

![Category](https://img.shields.io/badge/Category-SIEM%20Foundations-1f2937?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Log%20Ingestion-2563eb?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Parsing%20%26%20Normalization-7c3aed?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Dashboard%20Engineering-059669?style=for-the-badge)

</div>

**Focus:** Architecture → Ingestion → Parsing → Indexing → Visualization

### 🧪 Labs (1–13)

| Lab | Title                                                                                | Focus Area          |
| --: | ------------------------------------------------------------------------------------ | ------------------- |
|  01 | [Introduction to SIEM](./lab01-introduction-to-siem)                                 | SIEM fundamentals   |
|  02 | [Understanding the HOA Security Needs](./lab02-understanding-the-hoa-security-needs) | Threat modeling     |
|  03 | [Preparing the Lab Environment](./lab03-preparing-the-lab-environment)               | Environment setup   |
|  04 | [Selecting a SIEM Platform](./lab04-selecting-a-siem-platform)                       | Platform evaluation |
|  05 | [Installing Your Chosen SIEM](./lab05-installing-your-chosen-siem)                   | Deployment          |
|  06 | [Navigating the SIEM Interface](./lab06-navigating-the-siem-interface)               | UI workflows        |
|  07 | [Configuring Data Sources](./lab07-configuring-data-sources)                         | Log onboarding      |
|  08 | [Gathering Windows Event Logs](./lab08-gathering-windows-event-logs)                 | Windows logs        |
|  09 | [Gathering Linux Syslogs](./lab09-gathering-linux-syslogs)                           | Linux telemetry     |
|  10 | [Enabling Firewall or Router Logs](./lab10-enabling-firewall-or-router-logs)         | Network logs        |
|  11 | [Parsing & Normalization Basics](./lab11-parsing-and-normalization-basics)           | Parsing             |
|  12 | [Custom Field Extraction](./lab12-custom-field-extraction)                           | Grok/Regex          |
|  13 | [Basic SIEM Dashboards](./lab13-basic-siem-dashboards)                               | Visualization       |

### ✅ What This Section Demonstrates

* Full ELK stack deployment and validation
* Multi-source telemetry onboarding (Windows, Linux, Router)
* Structured log parsing using Grok & Regex
* Field normalization for detection-ready data
* Dashboard creation for operational SOC visibility
* Elasticsearch API-based ingestion verification

### 🧠 Skills Demonstrated

* Log lifecycle engineering (**Collect → Parse → Normalize → Index → Visualize**)
* Beats & syslog configuration
* Logstash pipeline construction
* Index validation & ingestion troubleshooting
* SOC dashboard design principles

---

# 📌 Section 2 — SIEM Engineering & SOC Workflow (Labs 14–26)

### 🚨 Detection, Alerting & Investigation Engineering

<div>

![Category](https://img.shields.io/badge/Category-SOC%20Workflow-111827?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Detection%20Engineering-dc2626?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Alert%20Tuning-f97316?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Incident%20Workflow-7c3aed?style=for-the-badge)

</div>

**Focus:** Detection → Correlation → Investigation → Tuning → IR Simulation

### 🧪 Labs (14–26)

| Lab | Title                                                                              | Core Focus          | Key Outcome             |
| --: | ---------------------------------------------------------------------------------- | ------------------- | ----------------------- |
|  14 | [Setting Up Email Notifications](./lab14-setting-up-email-notifications)           | Alert delivery      | Notification validation |
|  15 | [Basic Correlation Rules](./lab15-basic-correlation-rules)                         | Detection logic     | Rule testing            |
|  16 | [Investigating Alerts in SIEM](./lab16-investigating-alerts-in-siem)               | Investigation       | Alert triage            |
|  17 | [Host Monitoring Configuration](./lab17-host-monitoring-configuration)             | Host telemetry      | FIM concepts            |
|  18 | [Network Traffic IDS Integration](./lab18-network-traffic-ids-integration)         | Network detection   | IDS ingestion           |
|  19 | [Creating a Real-Time Dashboard](./lab19-creating-a-real-time-dashboard)           | Monitoring          | Live dashboards         |
|  20 | [Role-Based Access Control (RBAC)](./lab20-role-based-access-control-rbac)         | Access control      | Role validation         |
|  21 | [Searching & Filtering Data](./lab21-searching-and-filtering-data)                 | Querying            | Field filtering         |
|  22 | [Index Maintenance & Data Retention](./lab22-index-maintenance-and-data-retention) | Lifecycle           | Retention simulation    |
|  23 | [Threat Intelligence Feeds](./lab23-threat-intelligence-feeds)                     | TI integration      | IOC matching            |
|  24 | [Alarm Tuning](./lab24-alarm-tuning)                                               | Noise reduction     | False positive tuning   |
|  25 | [Basic Incident Response Workflow](./lab25-basic-incident-response-workflow)       | IR workflow         | Evidence tracking       |
|  26 | [HOA-Focused Use Case](./lab26-hoa-focused-use-case)                               | Real-world scenario | Custom detection        |

### ✅ What This Section Demonstrates

* Correlation rule design & validation
* Alert notification workflow testing
* SOC triage methodology (alert → pivot → evidence)
* Threat intelligence ingestion & IOC matching
* Noise reduction through rule tuning
* IR simulation & structured closure documentation

### 🧠 Skills Demonstrated

* Detection logic engineering
* Alert lifecycle governance
* Threat feed enrichment pipelines
* Incident documentation & mitigation reasoning
* Data retention & index maintenance strategy

---

# 📌 Section 3 — SIEM Operations & Engineering Maturity (Labs 27–40)

### 📊 Operational Excellence, Automation & Governance

<div>

![Category](https://img.shields.io/badge/Category-SIEM%20Operations-0f172a?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Observability-2563eb?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Automation-059669?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-Governance%20%26%20Maturity-7c3aed?style=for-the-badge)

</div>

**Focus:** Reporting → Forensics → Automation → Health Monitoring → Governance

### 🧪 Labs (27–40)

| Lab | Title                                                                        | Focus Area         | Key Deliverable     |
| --: | ---------------------------------------------------------------------------- | ------------------ | ------------------- |
|  27 | [Executive Dashboards](./lab27-utilizing-dashboards-for-executive-reporting) | Reporting          | Dashboard export    |
|  28 | [Simple Log Forensics](./lab28-simple-log-forensics)                         | Triage             | Evidence output     |
|  29 | [Regex Log Searches](./lab29-regular-expressions-in-log-searches)            | Parsing            | Extractor script    |
|  30 | [Trends Over Time](./lab30-analyzing-trends-over-time)                       | Analytics          | Anomaly logic       |
|  31 | [File Integrity Monitoring](./lab31-file-integrity-monitoring-auditd)        | Host security      | auditd validation   |
|  32 | [UEBA Setup](./lab32-ueba-elk-setup)                                         | Behavior analytics | Baseline workflow   |
|  33 | [Backup & Restore](./lab33-backup-restore-siem-data)                         | Resilience         | Recovery simulation |
|  34 | [Incident Response Plan](./lab34-creating-a-test-incident-response-plan)     | Process            | IR documentation    |
|  35 | [Security Reports](./lab35-generating-security-reports)                      | Reporting          | PDF/CSV export      |
|  36 | [SOAR Lite Automation](./lab36-soar-lite-automation)                         | Automation         | Containment script  |
|  37 | [New Log Source Onboarding](./lab37-onboarding-new-log-source)               | Integration        | Parsing validation  |
|  38 | [System Health Review](./lab38-system-health-performance)                    | Observability      | ES health checks    |
|  39 | [Rule & Alert Review](./lab39-periodic-rule-alert-review)                    | Governance         | Tuned rule          |
|  40 | [Final SIEM Health Check](./lab40-final-siem-health-check-next-steps)        | Strategy           | Roadmap             |

### ✅ What This Section Demonstrates

* Executive dashboard reporting
* CLI-driven log forensics
* Regex-based structured extraction
* Time-series trend & anomaly analysis
* Host integrity monitoring (auditd)
* SIEM backup & restore simulation
* SOAR-lite automated containment
* Rule lifecycle review & governance
* Final SIEM maturity roadmap planning

### 🧠 Skills Demonstrated

* Operational visibility engineering
* Evidence extraction & forensic filtering
* Automation scripting for containment
* Performance monitoring & index health checks
* Governance documentation & strategic planning

---

## 🧰 Tools & Technologies Used Across This Repository

<details>
<summary><b> Click to expand </b></summary>

### 🖥 Operating Systems

* Ubuntu 24.04 LTS (Primary lab VM)
* Windows (Event log testing)
* OpenWrt (Router/firewall telemetry simulation)

### 🧩 SIEM / Monitoring Stack

* Elasticsearch • Logstash • Kibana (ELK)
* Wazuh (intro/onboarding concepts)
* ElastAlert (alert testing + tuning workflows)
* Prometheus • node-exporter (system health + metrics visibility)
* Grafana (real-time dashboards concept)

### 📥 Telemetry & Data Sources

* Winlogbeat / NXLog (Windows logs)
* rsyslog / syslog-ng (Linux syslogs)
* Router syslog over UDP 514
* Filebeat / Auditbeat (UEBA-style telemetry)

### 🔎 Security Telemetry & Detection

* Zeek (network visibility + logs)
* OSSEC (HIDS + reporting pipeline)
* auditd (file integrity monitoring)
* Fail2Ban (incident simulation)

### 🤖 Automation / SOAR-lite

* osquery (endpoint visibility)
* StackStorm (orchestration concept)
* iptables (containment)
* Bash + Python automation tooling

### 🧪 Validation & Troubleshooting

* curl (Elasticsearch APIs)
* jq (JSON validation)
* tcpdump (traffic validation)
* grep/awk/sed/sort/uniq (forensics + aggregation)

</details>

---

# 📂 Repository Structure

```text
SIEM/
│
├── 🔹 SIEM Foundations & Log Engineering (Labs 1–13)
├── 🔹 SIEM Engineering & SOC Workflow (Labs 14–26)
├── 🔹 SIEM Operations & Engineering Maturity (Labs 27–40)
└── README.md
````

## 🧱 Standard Lab Structure

Each lab follows a consistent, execution-focused structure designed to reflect real SIEM engineering workflows:

```text
labXX-<lab-name>/
├── README.md                # Objectives, architecture context, step-by-step execution
├── commands.md              # Executed CLI commands (copy/paste runnable)
├── output.txt               # Real command outputs (validation evidence)
├── configs/                 # Logstash, Beats, alert rules, YAML configs
├── dashboards/              # Exported dashboard definitions (where applicable)
├── scripts/                 # Bash/Python automation (parsing, enrichment, SOAR-lite)
├── data/                    # Sample logs, threat feeds, test events
├── troubleshooting.md       # Errors encountered + applied fixes
└── investigation_notes.md   # Alert analysis, evidence, conclusions (where applicable)
````

This ensures:

* ✅ Reproducibility
* ✅ Real output validation
* ✅ Structured detection engineering documentation
* ✅ Investigation discipline
* ✅ Operational SIEM workflow alignment

---

## 🎓 Learning Outcomes Across 40 Labs

After completing this 40-lab SIEM engineering program, this portfolio demonstrates the ability to:

- Architect and deploy a production-style ELK SIEM stack
- Engineer multi-source log pipelines (Windows, Linux, Network devices)
- Parse, normalize, and enrich logs for detection readiness
- Design correlation logic and threshold-based alerting rules
- Perform SOC alert triage and evidence-driven investigations
- Integrate threat intelligence feeds for contextual detection
- Tune alerts to reduce false positives while preserving signal
- Implement host monitoring and file integrity validation
- Automate containment actions using SOAR-lite workflows
- Evaluate SIEM health, retention strategy, and maturity roadmap planning

---

## 🌍 Real-World Alignment

These labs simulate realistic enterprise SOC operations including:

- Centralized telemetry onboarding across heterogeneous environments
- Log lifecycle engineering (collect → parse → normalize → index → visualize)
- Detection engineering foundations (fields, correlation, rule validation)
- Alert investigation and escalation workflows
- Threat intelligence enrichment and IOC matching
- Incident response documentation and closure tracking
- SIEM operational governance (retention, backups, health monitoring)
- Executive reporting dashboards and visibility metrics

All labs were executed in controlled environments and validated with real system outputs.

---

## 📈 Professional Relevance

This portfolio reflects:

- Applied SIEM engineering capability
- SOC Tier 1 → Tier 2 operational workflow experience
- Detection engineering fundamentals
- Log pipeline architecture thinking
- Alert governance and tuning discipline
- Structured documentation and reporting standards
- Operational security engineering mindset

It represents practical implementation — not theoretical notes.

---

## 🛡️ Real-World Simulation Model

All labs were designed to simulate enterprise security monitoring environments:

- Endpoint + server + network telemetry ingestion
- Detection rule creation and validation cycles
- Multi-layer visibility (host + network + logs)
- Investigation workflows with evidence extraction
- Controlled attack simulation for detection testing
- SIEM reliability validation and performance checks
- Governance practices: rule reviews, retention, and roadmap planning

This repository demonstrates operational SIEM engineering execution across architecture, detection, investigation, automation, and maturity planning.

---

# 📊 Security Skills Heatmap

This heatmap reflects **hands-on implementation across 40 SIEM engineering labs** in:

**SIEM Architecture • Log Engineering • Detection Engineering • SOC Operations • Alert Governance • Automation • SIEM Maturity**

> Exposure bars represent execution depth — from foundational implementation to full operational validation.

| Skill Area | Exposure Level | Practical Depth | Tools / Frameworks Used |
|------------|---------------|----------------|--------------------------|
| 🛰 SIEM Deployment & Architecture | ██████████ 100% | Full ELK stack setup, validation, service health checks | Elasticsearch, Logstash, Kibana, Docker |
| 📥 Multi-Source Log Ingestion | ██████████ 100% | Windows, Linux, Router log onboarding & verification | Winlogbeat, rsyslog, syslog-ng, Wazuh |
| 🧩 Log Parsing & Normalization | █████████░ 90% | Grok patterns, field extraction, structured event creation | Logstash, Regex, Elasticsearch ingest |
| 🔍 Detection & Correlation Engineering | █████████░ 90% | Threshold rules, sequence logic, alert validation testing | Kibana rules, ElastAlert |
| 🚨 Alerting & Notification Workflow | █████████░ 90% | Rule testing, tuning, noise reduction | Kibana Alerts, Email notifications |
| 🕵️ SOC Investigation Workflow | █████████░ 90% | Alert triage → pivot → evidence extraction → documentation | Kibana Discover, CLI log analysis |
| 🧠 Threat Intelligence Integration | ████████░░ 80% | Feed ingestion, IOC matching, enrichment logic | Logstash http_poller, Elasticsearch |
| 🛡 Host Monitoring & FIM | █████████░ 90% | auditd rule validation, host telemetry monitoring | auditd, Auditbeat |
| 🌐 Network Visibility & IDS Integration | █████████░ 90% | IDS-style alert ingestion & validation | Zeek concepts, log ingestion workflows |
| 📊 Dashboard Engineering (SOC & Executive) | █████████░ 90% | Operational dashboards + executive reporting views | Kibana, Grafana |
| 🔄 Alert Tuning & Governance | █████████░ 90% | False positive reduction, rule review lifecycle | Kibana rules, YAML configs |
| ⚙ SOAR-Lite Automation | ████████░░ 80% | Detect → contain → verify workflow | Bash, Python, iptables |
| 💾 SIEM Retention & Backup Strategy | ████████░░ 80% | Index lifecycle awareness, backup & restore simulation | Elasticsearch APIs |
| 📈 SIEM Health & Performance Monitoring | █████████░ 90% | Ingestion stats, index checks, system observability | Prometheus, curl, _cat APIs |
| 🗂 SIEM Maturity & Roadmap Planning | █████████░ 90% | Gap analysis, improvement planning, governance modeling | Documentation, architecture planning |

## 🧭 Proficiency Scale

- ██████████ = Implemented end-to-end with validation & operational proof  
- █████████░ = Advanced practical implementation with real outputs  
- ████████░░ = Strong working implementation with applied context  
- ██████░░░░ = Foundational + applied engineering exposure  


This heatmap represents **operational SIEM engineering capability**, not isolated scripting tasks — covering:

> **Ingestion → Parsing → Detection → Investigation → Tuning → Automation → Governance → Maturity**


---

## 🧪 How To Use

```bash
# Clone the repository
git clone https://github.com/abdul4rehman215/SIEM.git
cd SIEM

# Open any lab folder
cd labXX-<lab-name>

# Review objectives and workflow
cat README.md
````

### Recommended Workflow

1. Read the lab objectives and architecture context.
2. Review ingestion / parsing / detection configs (if applicable).
3. Execute commands in a controlled lab environment.
4. Validate results:

   * Check Elasticsearch indices (`_cat/indices`)
   * Verify dashboard visibility in Kibana
   * Confirm alert triggers (where applicable)
   * Review logs for evidence consistency
5. Compare outputs with documented validation steps.

---

> Each lab is self-contained and includes:
>
> * Setup & architecture explanation
> * Executed commands with validation proof
> * Parsing / rule configurations
> * Investigation notes & evidence outputs
> * Troubleshooting documentation
> * Structured reporting where applicable

This repository is designed to be followed sequentially for full SIEM workflow progression — but each lab can also be executed independently.

---

## 🖥️ Execution Environment

All labs were executed in controlled Linux lab environments designed to simulate enterprise SIEM deployments and SOC monitoring workflows.

**Environment characteristics:**

- Ubuntu 24.04 LTS (primary lab VM)
- ELK Stack (Elasticsearch, Logstash, Kibana)
- Beats (Filebeat, Auditbeat, Winlogbeat concepts)
- Wazuh / OSSEC (selected monitoring labs)
- Prometheus + node-exporter (health monitoring labs)
- Docker / Docker Compose (isolated stack simulations)
- Bash & Python 3.x for parsing, automation, and validation
- curl, jq, tcpdump for ingestion and index verification

All outputs were validated using:
- Elasticsearch index checks
- Dashboard visibility confirmation
- Log correlation proof
- Before/after rule tuning validation
- System health and ingestion metrics

---

## 🎯 Intended Use

This repository is designed to support:

- SIEM Engineering skill development
- SOC Analyst (Tier 1 / Tier 2) workflow training
- Detection engineering fundamentals
- Log pipeline architecture understanding
- Alert tuning and governance practice
- Incident investigation and documentation discipline
- SIEM operational maturity planning

All detection simulations and automation workflows are intended strictly for defensive security engineering and SOC capability development.

Use only within authorized lab environments.

---

## ⚖️ Ethical & Legal Notice

All work in this repository was performed in **controlled, authorized lab environments** for **defensive security learning** and **SOC engineering practice**.
No production systems were targeted. Any simulation of attacks or scanning was conducted strictly for detection validation and response testing.

---

## ⭐ Final Note

This repository reflects **real, execution-driven SIEM engineering** — progressing through:

> **Ingest → Parse → Detect → Investigate → Tune → Automate → Govern**

Modern SOC capability is not just alerts.  
It is **visibility + detection logic + operational discipline + continuous improvement.**

If this portfolio adds value to your learning or evaluation, consider starring the repository ⭐

---

## 👨‍💻 Author

**Abdul Rehman**

SIEM Engineering • SOC Operations • Detection Engineering • Log Pipeline Architecture • Security Automation

### 📧 Reach Out

  <a href="https://github.com/abdul4rehman215">
    <img src="https://img.shields.io/badge/Follow-181717?style=for-the-badge&logo=github&logoColor=white" alt="Follow" />
  </a>  
  <a href="https://linkedin.com/in/abdul4rehman215">
     <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white&v=1" />
  </a>
  <a href="mailto:abdul4rehman215@gmail.com">
    <img src="https://img.shields.io/badge/Email-EE0000?style=for-the-badge&logo=gmail&logoColor=white" />
  </a>

---
