# 🧪 Lab 04: Selecting a SIEM Platform

## 🧾 Lab Summary
This lab covers the process of **selecting a SIEM platform** suitable for small-to-medium environments and validates the decision through a hands-on lab installation.

The workflow included:
- Identifying **open-source** and **commercial** SIEM platform options
- Evaluating platforms using practical selection factors (cost, complexity, scalability, support)
- Installing a functional **Elastic Stack (ELK)** lab baseline:
  - Elasticsearch (search + indexing engine)
  - Logstash (log ingestion + parsing pipeline)
  - Kibana (dashboard + visualization interface)

This lab also included realistic troubleshooting decisions, such as installing **OpenJDK 17** because **OpenJDK 11** was not available by default on Ubuntu 24.04.

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand the fundamentals of SIEM tools and typical architectures
- Compare open-source and commercial SIEM options for small/medium organizations
- Evaluate SIEM platforms based on cost, complexity, scalability, and support
- Install and configure a baseline **Elastic Stack (ELK)** SIEM deployment in a lab environment
- Validate service health and network ports for Elasticsearch, Logstash, and Kibana

---

## ✅ Prerequisites
- Basic understanding of cybersecurity concepts
- Familiarity with Linux command line interface
- Access to a Linux VM or server environment

---

## 🧪 Lab Environment
- **Platform:** Cloud Lab (Ubuntu/Debian environment)
- **OS:** Ubuntu 24.04.1 LTS
- **User:** `toor`
- **Prompt style:** `toor@ip-172-31-10-206:~$` (IP tail may vary)
- **SIEM Stack Installed:** Elastic Stack 7.17.22 (Elasticsearch, Logstash, Kibana)
- **Java Runtime:** OpenJDK 17 (installed due to package availability)

---

## 🛠️ Tasks Overview (What I Did)

### ✅ Task 1 — Identify SIEM Platform Options
- Documented candidate SIEM platforms:
  - Open-source: ELK, Wazuh
  - Commercial: Splunk, IBM QRadar

### ✅ Task 2 — Evaluate SIEM Platforms
- Created an evaluation document using:
  - Cost
  - Complexity
  - Scalability
  - Support
- Captured pros/cons for ELK and Wazuh
- Recorded commercial platform notes for Splunk and QRadar

### ✅ Task 3 — Install and Configure Elastic Stack (ELK) Baseline
**Step 3.1: Preliminary Setup**
- Updated system packages
- Installed Java runtime (OpenJDK 17)

**Step 3.2: Install Elasticsearch**
- Added Elastic repository and key
- Installed Elasticsearch
- Updated configuration for a single-node lab
- Started + enabled service
- Verified using `curl localhost:9200`

**Step 3.3: Install Logstash**
- Installed Logstash
- Created pipeline config with Beats input and Grok parsing
- Started + enabled service
- Verified service status

**Step 3.4: Install Kibana**
- Installed Kibana
- Configured host + Elasticsearch endpoint
- Started + enabled service
- Validated ports for Elasticsearch (9200), Kibana (5601), Logstash (5044)

---

## ✅ Verification & Validation
- OS verified:
  - `cat /etc/os-release`
- Java verified:
  - `java -version`
- Elasticsearch verified:
  - `systemctl status elasticsearch`
  - `curl http://localhost:9200`
- Logstash verified:
  - `systemctl status logstash`
- Kibana verified:
  - `systemctl status kibana`
- Ports verified:
  - `ss -lntp | grep -E '(:9200|:5601|:5044)'`

---

## 📁 Repository Structure
```text
lab04-selecting-a-siem-platform/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── evidence/
    └── SIEM_Platform_Selection_Lab/
        ├── siem_options.md
        └── siem_evaluation.md
````

---

## 🌍 Why This Matters

Choosing the right SIEM is a practical engineering decision. Small-to-medium organizations must balance:

* cost vs capability
* staffing and skills vs operational complexity
* long-term scalability vs immediate deployment needs

Running a lab installation validates real-world feasibility, reveals resource requirements, and provides operational experience before production adoption.

---

## 🧩 Real-World Applications

* SIEM tool selection for small companies, HOAs, and mid-sized orgs
* Building and maintaining logging pipelines (inputs → filters → outputs)
* Deploying searchable security data stores for investigations
* Creating dashboards for SOC workflows and executive reporting
* Understanding performance and operational tradeoffs in SIEM tooling

---

## ✅ Result

* SIEM platform options and evaluation documented in markdown
* OpenJDK 17 installed successfully and verified
* Elastic Stack installed and configured:

  * Elasticsearch running and responding on `:9200`
  * Logstash running with Beats input on `:5044`
  * Kibana running on `:5601`
* Baseline ELK deployment validated with service and port checks

---

## 🏁 Conclusion

This lab demonstrated SIEM selection fundamentals and validated an open-source SIEM platform deployment through a working ELK installation. The environment now supports log ingestion, search, and dashboards—forming the base for future SIEM tasks such as log onboarding, rule tuning, dashboards, and alerting integrations.

✅ Lab completed successfully on a cloud Ubuntu environment
✅ ELK stack installed + configured + verified (ports/services validated)

---
