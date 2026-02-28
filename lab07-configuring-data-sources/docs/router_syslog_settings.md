# Router Remote Syslog Settings (Example)

## Syslog-ng Server
- IP: 172.31.10.232
- Port: 514/UDP (preferred for classic syslog)
- Protocol: UDP
- Facility/Severity: default (or set facility to LOCAL0 if router supports it)

## Router-side Steps (Generic)
1. Open router admin GUI
2. Go to Logging / Syslog settings
3. Enable "Remote Syslog"
4. Set:
   - Remote syslog server: 172.31.10.232
   - Port: 514
   - Protocol: UDP
5. Save/Apply
