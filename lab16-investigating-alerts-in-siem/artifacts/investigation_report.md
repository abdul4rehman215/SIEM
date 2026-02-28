# SIEM Alert Investigation Report

## Alert Investigated
- Alert ID: a-1001
- Category: suspicious_login
- Severity: high
- Rule Name: Suspicious Login - Unusual Geo

## Key Fields (Raw Event Extract)
- Timestamp: 2026-02-28T10:12:10Z
- User: jdoe
- Source IP: 192.168.1.100
- Geo Country: Unknown
- Action: login_attempt
- Outcome: failed
- Message: Login attempt from unusual location

## Related Alerts / Patterns
Source IP 192.168.1.100 appears in multiple suspicious alerts:
- a-1001 (Suspicious Login - Unusual Geo)
- a-1005 (Brute Force Suspected)

## Observations
- Multiple alerts tied to the same user (jdoe) and the same source IP.
- Activity clustered within a short time window.
- Geo location marked as Unknown, which may indicate spoofing, VPN usage, or untrusted origin.

## Recommended Next Steps
1. Temporarily block the source IP (192.168.1.100) at firewall/WAF level.
2. Force password reset / audit for user jdoe.
3. Review authentication logs for other users targeted from the same IP.
4. Enable MFA (if not enabled) and tighten brute-force protections.
5. Continue monitoring for further attempts or lateral movement indicators.
