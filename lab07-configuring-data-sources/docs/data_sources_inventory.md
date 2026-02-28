# HOA SIEM Data Sources Inventory

## Network Devices
- Router/Gateway (remote syslog enabled)
  - Example hostname: router01
  - Logs: firewall events, DHCP, NAT, routing updates, admin logins

## Endpoints
- HOA Windows PC (via NXLog)
  - Example hostname: HOA-WIN10
  - Logs: Security, System, Application (logons, service start/stop, policy changes)

## SIEM/Server Logs (Syslog-ng host)
- Linux system logs
  - auth events, ssh logins, service status, package updates
