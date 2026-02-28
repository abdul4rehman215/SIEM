# 🧪 Lab 02: Understanding the HOA Security Needs

## 🧾 Lab Summary
This lab focuses on understanding the **security needs of a Homeowners Association (HOA)** by building a practical foundation for SIEM-driven security planning. The work follows a structured approach:

1. **Identify and document assets** (physical + digital)
2. **Classify HOA data** by sensitivity (PII, financial, operational, public)
3. **Threat model likely risks** using an open-source tool (OWASP Threat Dragon)
4. **Set up a vulnerability assessment platform** (GVM/OpenVAS equivalent)
5. **Propose security goals and draft policies** tailored to an HOA environment

This creates a realistic security planning baseline that can later feed into SIEM onboarding (log sources, alert priorities, incident workflows, reporting).

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Identify and document HOA assets and sensitive data
- Understand realistic threats, vulnerabilities, and attack paths in HOA environments
- Propose practical security goals aligned to confidentiality, integrity, and availability (CIA)
- Create draft security policies and operational guidance
- Install and validate open-source tooling for threat modeling and vulnerability assessment

---

## ✅ Prerequisites
- Basic knowledge of network security concepts
- Familiarity with open-source tools and installation steps
- Access to a Linux environment (Ubuntu/Debian lab)

---

## 🧪 Lab Environment
- **Platform:** Cloud Lab (Ubuntu/Debian environment)
- **OS:** Ubuntu 24.04.1 LTS
- **User:** `toor`
- **Prompt style:** `toor@ip-172-31-10-188:~$` (IP tail may vary)

---

## 🛠️ Tasks Overview (What I Did)

### ✅ Task 1 — List HOA Assets and Data Types
- Created a structured working directory for HOA security planning
- Documented physical and digital assets in an inventory file
- Classified data into High/Medium/Low sensitivity to define protection priorities

### ✅ Task 2 — Identify Threats and Vulnerabilities
- Installed OWASP Threat Dragon (tool availability for threat modeling)
- Documented threat modeling scope, threat categories, and attack paths
- Attempted to install OpenVAS and resolved package availability issue by installing **GVM**
- Synced vulnerability feeds and completed `gvm-setup`
- Validated installation using `gvm-check-setup`
- Documented scanning targets and common expected findings for HOA environments

### ✅ Task 3 — Propose Initial Security Goals and Policies
- Wrote initial HOA security goals aligned to CIA principles
- Created a draft HOA security policy including:
  - access control
  - password + MFA requirements
  - CCTV security controls
  - patch management
  - incident response workflow
- Verified overall project structure using `tree`

---

## ✅ Verification & Validation
- Confirmed working directory created and structured
- Confirmed Threat Dragon installed:
  - `snap list | grep threat-dragon`
- Confirmed GVM setup completed and validated:
  - `sudo gvm-check-setup`
- Confirmed documentation files exist and are organized:
  - `tree`

---

## 📁 Repository Structure
```text
lab02-understanding-the-hoa-security-needs/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── evidence/
    └── HOA_Security_Lab/
        ├── assets/
        │   └── hoa_assets.md
        ├── data_classification/
        │   └── data_types.md
        ├── threat_modeling/
        │   └── threats_notes.md
        ├── vulnerability_assessment/
        │   └── vuln_assessment_notes.md
        └── security_policy/
            ├── security_goals.md
            └── hoa_security_policy.md
````

> 📌 Note: The `evidence/HOA_Security_Lab/` folder contains the lab-created documentation artifacts (assets, data classification, threat notes, vulnerability notes, and policies).

---

## 🌍 Why This Matters

HOAs often handle sensitive information but operate with limited security resources. A structured approach to:

* asset identification,
* data classification,
* threat modeling,
* vulnerability scanning,
* and policy definition

…is essential for building a realistic security roadmap and SIEM alert priorities.

---

## 🧩 Real-World Applications

* Building security baselines for small organizations
* Prioritizing SIEM onboarding (log sources + alert severity)
* Supporting incident response playbooks with asset/data context
* Improving governance with lightweight security policies
* Enabling vulnerability management as an ongoing process

---

## ✅ Result

* Created a structured HOA security planning workspace
* Documented HOA physical/digital assets and external dependencies
* Classified HOA data and identified high-impact exposure risks
* Installed and validated OWASP Threat Dragon (threat modeling tool availability)
* Installed GVM (OpenVAS equivalent), synced feeds, and completed setup successfully
* Drafted HOA security goals and an initial security policy document
* Verified organized outputs via directory tree evidence

---

## 🏁 Conclusion

This lab built a practical understanding of HOA security needs by translating real-world HOA operations into a security model:
assets → data → threats → vulnerabilities → goals/policies. These outputs can be directly used later in SIEM labs for defining alert priorities, log onboarding strategy, and incident response workflows.

✅ Lab completed successfully on a cloud Ubuntu environment.

---
