# 💬 Interview Q&A — Lab 02: Understanding the HOA Security Needs

---

## 1) Why is asset identification the first step in security planning?
Because you can’t protect what you haven’t identified. Asset inventories define:
- what systems exist
- what data they store
- what services are critical
This becomes the baseline for threat modeling, vulnerability management, and SIEM onboarding.

---

## 2) What is the difference between physical assets and digital assets in an HOA?
- **Physical assets:** cameras, DVR/NVR devices, office hardware, routers, switches, storage devices  
- **Digital assets:** resident database, email accounts, financial portals, website/portal, cloud folders, meeting docs

Both require security controls, but risk types differ (theft/tampering vs breach/credential abuse).

---

## 3) Why is data classification important?
Data classification determines:
- access controls (who can view/modify)
- encryption requirements
- retention policies
- audit and monitoring priority
In HOAs, PII and finances have the highest impact if compromised.

---

## 4) Give examples of High sensitivity HOA data.
- resident PII (addresses, contacts)
- financial records and invoices
- banking portal access information
- credentials linked to admin portals or Wi-Fi

---

## 5) What is threat modeling?
Threat modeling is a structured approach to identifying:
- assets and entry points
- attacker goals
- potential threats
- mitigations and security controls
It helps prioritize security work before incidents happen.

---

## 6) Why would an HOA use OWASP Threat Dragon?
It enables visual threat modeling and documentation of:
- system components
- trust boundaries
- threats (STRIDE-style thinking)
For this lab, tool installation plus modeling notes demonstrate readiness to create diagrams in practice.

---

## 7) What are common HOA threat categories?
- Unauthorized access (weak credentials, shared admin logins)
- Data breach (cloud sharing misconfigurations, stolen devices)
- Physical threats (theft of DVR/NVR, camera tampering)
- Phishing and credential theft targeting board/admin emails

---

## 8) Why did `openvas` fail to install on Ubuntu?
On newer Ubuntu versions, the package name is commonly replaced/shifted to **GVM** packages. This is a realistic package-availability issue that requires adapting installation approach.

---

## 9) What is GVM?
GVM (Greenbone Vulnerability Management) is the open-source vulnerability scanning ecosystem that includes components similar to OpenVAS scanning and web interface management.

---

## 10) What does `greenbone-feed-sync` do?
It syncs vulnerability feeds such as:
- NVTs (Network Vulnerability Tests)
- SCAP data
- CERT data  
This ensures vulnerability checks and CVE mapping data are up-to-date.

---

## 11) What is the purpose of `gvm-setup`?
It initializes the GVM platform by:
- creating databases
- generating certificates
- configuring manager/scanner services
- creating admin credentials
- starting services

---

## 12) Why should HOAs enforce MFA?
Because email and payment portals are high-value targets. MFA reduces the risk of:
- credential stuffing
- phishing-based account takeover
- unauthorized logins from leaked passwords

---

## 13) How do these outputs connect to SIEM work later?
Asset + data classification informs:
- what to monitor first
- log source onboarding priority
- alert severity mapping (PII/finance-related alerts higher)
Threat modeling and vulnerability findings also guide correlation rules and incident workflows.

---

## 14) What’s one practical security goal you defined for an HOA?
Prevent unauthorized access by:
- unique accounts (no shared logins)
- least privilege
- strong passwords and MFA for critical systems
- monitoring access logs for anomalies

---
