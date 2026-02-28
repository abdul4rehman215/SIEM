# 🎤 Interview Q&A — Lab 25: Basic Incident Response Workflow (Fail2Ban + ELK)

## 1) What is incident response?
Incident response (IR) is a structured process to identify, contain, eradicate, and recover from security incidents, while preserving evidence and improving defenses to prevent recurrence.

---

## 2) What are common phases of an incident response lifecycle?
A common lifecycle includes:
1. Preparation  
2. Identification/Detection  
3. Containment  
4. Eradication  
5. Recovery  
6. Lessons Learned / Post-Incident Review

---

## 3) What incident did you simulate in this lab?
A brute-force style **SSH login failure** incident—multiple failed authentication attempts within a short period—leading to automated mitigation (IP ban) with Fail2Ban.

---

## 4) What role did Fail2Ban play in incident response?
Fail2Ban served as both:
- **detection** (monitoring auth logs for repeated failures)
- **containment** (automatically banning the source IP after threshold exceeded)

---

## 5) Which Fail2Ban settings are most important for brute-force protection?
Key settings:
- `maxretry`: number of failures before ban  
- `findtime`: time window to count failures  
- `bantime`: how long to ban the IP  
- `logpath`: where authentication failures are logged  
- jail enabled: `[sshd] enabled = true`

---

## 6) Why did the banned IP show as `127.0.0.1` in this lab?
Because the brute-force attempts were simulated from **localhost** (`ssh ...@localhost`). In a real network, the banned IP would be the attacker’s external source IP.

---

## 7) What evidence did you collect during the incident?
- `fail2ban-client status sshd` output showing banned IP
- `/var/log/fail2ban.log` entries showing:
  - `Found` events (detections)
  - `Ban` event (containment action)
- Elasticsearch documents after ingestion (`fail2ban-YYYY.MM.dd`)

---

## 8) Why is SIEM integration important during incident response?
SIEM centralizes logs and makes them searchable/correlatable across systems. It helps with:
- timeline reconstruction
- detection validation
- incident documentation
- reporting and auditing

---

## 9) How did you integrate Fail2Ban logs into ELK?
I configured Logstash with:
- file input reading `/var/log/fail2ban.log`
- grok parsing to extract structured fields (`timestamp`, `level`, `details`)
- Elasticsearch output to `fail2ban-%{+YYYY.MM.dd}` index

---

## 10) Why did you use `sincedb_path => "/dev/null"` in Logstash?
For lab testing, it forces Logstash to read the file from the beginning rather than remembering offsets. This ensures immediate ingestion for demonstration/validation.

---

## 11) How did you verify ingestion worked?
- Checked indices with:
  - `/_cat/indices?v | grep fail2ban`
- Queried sample documents via:
  - `fail2ban-2026.02.28/_search?size=3`
Confirmed presence of `Ban` and `Found` events.

---

## 12) What would containment look like in a real incident beyond Fail2Ban?
- Block attacker IP at firewall/WAF
- Disable or lock impacted accounts
- enforce MFA or restrict admin access
- isolate affected host if compromise is suspected

---

## 13) What eradication and recovery steps would you recommend after brute-force attempts?
- Investigate if any login succeeded
- review `/var/log/auth.log` for successful logins from suspicious IPs
- reset passwords for targeted accounts
- patch/update SSH and OS
- harden SSH config (disable password auth, disable root login)

---

## 14) What preventive measures help reduce SSH brute-force risk?
- SSH keys + disable password auth
- restrict SSH to VPN/allowlisted IPs
- rate limiting / connection limits
- Fail2Ban or similar IPS
- strong password policy + lockout controls
- monitoring/alerts for spikes in failures and ban events

---

## 15) What’s the main learning outcome from this lab?
I practiced an end-to-end IR workflow:
- detect brute-force behavior
- contain it automatically
- collect evidence
- ingest and document evidence in a SIEM
- close the incident with summary + prevention recommendations
