# 🧾 Incident Closure Summary — SSH Brute-Force Simulation (Fail2Ban + ELK)

## Incident Overview
- **Incident Type:** Suspected SSH brute-force attempt (repeated failed logins)
- **Date/Time (Lab):** February 28, 2026
- **Target System:** Ubuntu server `ip-172-31-10-203`
- **Target Service:** `sshd` (SSH)

## Detection
### Indicators Observed
- Multiple failed SSH authentication attempts in a short time window.
- Fail2Ban filter detections (`Found`) followed by an automatic ban (`Ban`).

### Key Evidence Sources
- `/var/log/auth.log` (SSH auth failures)
- `/var/log/fail2ban.log` (Fail2Ban detections and actions)
- Elasticsearch index `fail2ban-2026.02.28` (ingested SIEM evidence)

## Containment / Mitigation
- **Tool Used:** Fail2Ban
- **Action Taken:** Automatic IP ban triggered by sshd jail policy:
  - `maxretry=3` within `findtime=600s`
  - `bantime=3600s` (1 hour)

> **Lab note:** Because the brute-force simulation was executed from localhost, Fail2Ban banned `127.0.0.1`. In real environments, the banned IP would be the attacker’s external source address.

## SIEM Integration & Investigation
### Log Ingestion
- Logstash file input ingested `/var/log/fail2ban.log`
- Parsed key fields via grok:
  - `timestamp`, `level`, `details`
- Stored into Elasticsearch daily index:
  - `fail2ban-%{+YYYY.MM.dd}`

### SIEM Validation
- Verified index exists and documents are searchable.
- Confirmed the ban event is present:
  - `[sshd] Ban 127.0.0.1`

### Documentation in Kibana (Workflow)
- Created data view: `fail2ban-*`
- Filtered for ban actions using KQL:
  - `details : "Ban*"`
- Added incident notes/comments:
  - detection observed
  - mitigation applied
  - SIEM ingestion confirmed
- Assigned incident to analyst role (example): `analyst_user`

## Resolution
- The brute-force behavior was mitigated by Fail2Ban banning the source IP.
- No further brute-force attempts were observed post-ban during the lab window.

## Estimated Response Time (Lab)
- Detection → containment → SIEM ingestion validation: **~20–30 minutes** (lab execution time)

## Preventative Measures / Recommendations
1. **Harden SSH**
   - Prefer SSH keys; disable password authentication where possible.
   - Disable root login over SSH.
2. **Access Restrictions**
   - Restrict SSH to trusted IP ranges / VPN only.
   - Use firewall allowlists where feasible.
3. **Monitoring & Alerting**
   - Create Kibana alerts for:
     - spikes in `Found` events
     - any `Ban` events
4. **Account Security**
   - enforce stronger password policies and lockout protections
   - consider MFA or bastion host for administrative access

## Closure Statement
This lab successfully simulated a brute-force style SSH incident, demonstrated automatic containment via Fail2Ban, and validated SIEM documentation by ingesting actionable evidence into ELK. The incident was mitigated and closed with clear preventative recommendations to strengthen future resilience.
