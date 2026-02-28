# 🎤 Interview Q&A — Lab 16: Investigating Alerts in a SIEM System

## 1) What is the goal of SIEM alert investigation?
To validate whether an alert represents true malicious activity, understand scope/impact, collect evidence, and decide on next response actions (containment, remediation, monitoring, escalation).

---

## 2) What steps do you typically follow when investigating a SIEM alert?
A common workflow is:
1. Triage (severity, category, rule name, time)
2. Validate alert details (raw event drill-down)
3. Extract key indicators (user, IP, host, geo, outcome)
4. Pivot/hunt (search related events by indicators)
5. Build timeline and assess risk
6. Document findings and recommend actions

---

## 3) Why is drilling down into raw events important?
Alerts are summaries. Raw events provide the actual evidence:
- exact fields and values
- context around action/outcome
- indicators needed for pivots (IP/user/host)
Without raw data, you can’t confirm if an alert is accurate.

---

## 4) What indicators were important in this lab’s suspicious login alert?
Key fields included:
- `@timestamp` (when it happened)
- `user.name` (target account)
- `source.ip` (where it came from)
- `source.geo.country` (geo indicator)
- `event.outcome` (success/failed)
- `rule.name` (detection context)

---

## 5) Why is an “Unknown” geo location suspicious?
It may indicate:
- missing enrichment data
- a VPN/proxy/TOR exit node
- a source outside known/expected regions
It’s not proof of compromise, but it’s a strong anomaly worth validating.

---

## 6) What does it mean to “pivot” during investigation?
Pivoting means using an indicator from the alert (like a source IP) to search for additional related events:
- other alerts from same IP
- other users targeted by same IP
- related categories (bruteforce, scan, malware)
This helps find patterns and scope.

---

## 7) What did your pivot show in this lab?
The same source IP (`192.168.1.100`) appeared in multiple suspicious_login alerts involving the same user (`jdoe`), including one with a brute-force suspicion rule. This increased confidence the activity might be malicious.

---

## 8) How do you decide if an alert is a false positive or true positive?
You evaluate:
- consistency with known baselines (normal login times/locations)
- repetition/patterns (multiple alerts from same IP)
- event outcome (successful vs failed)
- enrichment (geo, threat intel, asset criticality)
- supporting logs (auth logs, firewall, endpoint telemetry)

---

## 9) In a real SIEM, what would you do beyond filtering by category?
You would also filter by:
- time range
- severity
- user name
- source IP / destination IP
- host name
- rule ID / rule name
And then correlate with other sources (EDR, firewall, VPN, IAM logs).

---

## 10) What is the difference between alert triage and alert investigation?
- **Triage**: quick assessment (is this urgent? what category? what’s the priority?)
- **Investigation**: deeper analysis (raw logs, pivots, timeline, evidence, scope, response plan)

---

## 11) What incident response actions would you recommend for suspicious login patterns?
Common actions:
- block or rate-limit suspicious source IP
- enforce password reset / credential review
- enable or enforce MFA
- check recent session activity and tokens
- hunt for lateral movement or privilege escalation
- monitor for repeated attempts

---

## 12) Why is documenting findings important in SOC work?
It enables:
- consistent handoffs between analysts/shifts
- auditability and compliance evidence
- clear justification for actions taken
- faster future investigations via repeatable patterns

---

## 13) What’s the benefit of producing an “Investigation Report”?
It summarizes:
- what happened
- evidence and indicators
- related events and scope
- risk assessment
- recommended next steps
This turns technical output into operational decision support.

---

## 14) How did you simulate SIEM investigation in a terminal-only environment?
I created a realistic SIEM export file using JSON Lines (`alerts.jsonl`) and used `jq` to filter and extract fields—similar to how Kibana queries reduce and present results.

---

## 15) What improvements would you add if this was a full SIEM platform?
- real-time ingestion from auth logs (Linux/Windows)
- timestamp-based range filtering (last 24h)
- enrichment (GeoIP, threat intel, user baseline)
- case management integration (tickets, SOAR)
- automated response actions (blocking, disabling accounts, notifying on-call)
