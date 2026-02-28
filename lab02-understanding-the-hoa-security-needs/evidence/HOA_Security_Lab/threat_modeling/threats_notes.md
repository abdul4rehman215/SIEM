# HOA Threat Modeling Notes (OWASP Threat Dragon)

## Key Systems to Model
- Resident portal / HOA website
- CCTV system (cameras + DVR/NVR + remote access)
- HOA Wi-Fi network
- Office endpoints (laptops/desktops)
- Financial/payment system (online payments/banking portal)

## Threat Categories (Examples)
### Unauthorized Access
- Weak/default passwords on CCTV/NVR
- Shared admin credentials for HOA portal
- Unsecured vendor remote access (RDP/TeamViewer)
- Poor Wi-Fi security (weak WPA key, no guest network separation)

### Data Breach
- Resident PII leaked via compromised portal or stolen laptop
- Financial data exposed in unencrypted spreadsheets
- Cloud drive sharing misconfiguration (public link enabled)

### Physical Security Threats
- Theft of DVR/NVR device
- Unauthorized entry to HOA office/server closet
- Tampering with CCTV cameras

## Common Attack Paths
- Phishing HOA board member email → access to docs/payment portals
- Brute force CCTV web panel exposed to internet
- Malware infection on staff laptop → credential theft
