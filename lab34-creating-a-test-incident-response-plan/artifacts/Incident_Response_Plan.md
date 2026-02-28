# artifacts/Incident_Response_Plan.md
# Incident Response Plan (IRP) - Test Version (Lab 34)

## 1. Purpose
This plan defines how the organization will detect, respond to, contain, and recover from cybersecurity incidents.
It also defines roles, responsibilities, escalation paths, and communication steps.

## 2. Scope
- Applies to phishing, malware, unauthorized access, data exposure, account compromise, and service disruption.
- Covers detection → triage → containment → eradication → recovery → post-incident review.

## 3. Incident Response Roles & Responsibilities

| Role | Responsibilities |
|------|------------------|
| Incident Response Manager | Coordinate incident response, communication, and reporting |
| HOA Security Lead | Monitor security alerts, conduct assessments, and report findings |
| IT Support | Implement technical solutions, recover affected systems |

### 3.1 Incident Response Manager (IRM)
- Confirm incident classification and severity
- Assign tasks and coordinate response timeline
- Approve containment actions
- Ensure executive reporting and documentation
- Coordinate external communication if required

### 3.2 HOA Security Lead
- Review alerts/logs and confirm indicators of compromise (IOCs)
- Provide security risk assessment and scope (users affected, data impacted)
- Recommend containment and remediation steps
- Maintain evidence handling and logging

### 3.3 IT Support
- Implement account actions (disable, reset, MFA enforcement)
- Patch/restore systems, isolate infected endpoints
- Support log collection, backups, and system recovery
- Validate services are restored securely

## 4. Severity Levels & Escalation Procedures

### Low Severity
Definition: Minor incidents with minimal impact; no confirmed data exposure.
Escalation:
- Notify IT Support
- Resolution target: within 24 hours
- Document in incident tracking system

### Medium Severity
Definition: Partial service disruption, suspicious activity, or limited exposure.
Escalation:
- Notify IT Support + HOA Security Lead immediately
- Response target: within 4 hours
- HOA Security Lead reports findings to IR Manager
- IR Manager decides next actions (containment, comms, legal if needed)

### High Severity
Definition: Confirmed breach, sensitive data exposure, ransomware, major outage.
Escalation:
- Alert Incident Response Manager immediately
- Assemble full incident response team
- Prepare external communications (legal/PR)
- Full investigation and detailed reporting

## 5. Communication Plan (Basic)
- Use a dedicated incident communication channel (e.g., Teams/Slack/Email group)
- Do not share sensitive details in public channels
- Maintain a timeline of decisions and actions

## 6. Evidence Handling (Basic)
- Preserve logs (auth logs, endpoint logs, SIEM data)
- Avoid wiping impacted systems before capturing evidence
- Track who accessed evidence and when

## 7. Mini Tabletop Exercise Scenario (Lab Simulation)

### Scenario
Phishing email sent to multiple staff. One user entered credentials on a fake login page.
Indicators show suspicious logins and possible unauthorized data access.

### Simulated Detection
- Alert from SIEM: multiple failed logins followed by successful login from unfamiliar IP
- Report from user: "I clicked a link and entered credentials"

### Walkthrough Actions
1) Triage & Severity:
   - Classified as Medium (suspicious login and possible compromise)
2) Notify:
   - IT Support + HOA Security Lead (immediate)
   - IR Manager informed after initial validation
3) Containment:
   - Force password reset for impacted account
   - Enable/verify MFA
   - Block suspicious IP at firewall if applicable
4) Investigation:
   - Review auth logs and SIEM timeline
   - Check for unusual file access or forwarding rules
5) Recovery:
   - Confirm account access restored only after reset + MFA
6) Lessons Learned:
   - Add phishing awareness training reminder
   - Improve alert tuning for impossible travel / unusual IP

## 8. Review & Updates
- Review quarterly or after any major incident
- Update roles/contact list as staff changes
