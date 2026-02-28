# Log Validation Checks

## What I verified in /var/log/messages
- Timestamps present (Aug 18 14:05:30, etc.)
- Device identifiers present:
  - router01
  - HOA-WIN10
- Event indicators present:
  - firewall DROP (router-style)
  - EventID=4625 (Windows security failed logon)

## Why it matters for SIEM parsing
- Hostnames allow grouping by source system.
- Event IDs and structured patterns help build correlation rules.
- Timestamps enable timeline analysis and alert thresholds.
