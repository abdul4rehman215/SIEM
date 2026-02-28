# HOA Basic Security Policy (Draft)

## 1. Access Control Policy
- All administrative systems must use unique user accounts (no shared logins).
- Least privilege must be applied: users only get access required for their role.
- Default credentials on devices (CCTV/NVR/router) must be changed during installation.

## 2. Password & MFA Policy
- Passwords must be at least 12 characters long.
- MFA is required for:
  - HOA email accounts
  - Payment/banking portals
  - Cloud storage containing resident/financial records

## 3. CCTV Footage Protection Policy
- All CCTV footage must be stored with encryption (at rest).
- Footage access is limited to authorized HOA personnel only.
- Footage retention must follow HOA rules (e.g., 30/60/90 days) unless needed for investigation.
- Remote vendor access to CCTV must be time-limited and logged.

## 4. Data Handling Policy
- Resident PII and financial documents must not be stored on personal devices.
- Cloud sharing links must be restricted (no public links).
- USB usage should be minimized; if used, drives must be encrypted.

## 5. Patch & Update Policy
- Network devices (router/AP/CCTV firmware) must be reviewed monthly.
- Operating systems must apply critical security updates within 7 days.

## 6. Incident Response Policy
- Incidents must be reported immediately to HOA admin/board.
- Maintain logs for:
  - portal access
  - CCTV access
  - Wi-Fi access (admin network)
- Incident steps: Identify → Contain → Eradicate → Recover → Lessons Learned.
