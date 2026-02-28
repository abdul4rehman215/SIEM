# 💬 Interview Q&A — Lab 10: Enabling Firewall or Router Logs

---

## 1) Why are firewall/router logs valuable for SIEM monitoring?
They provide high-signal network telemetry such as firewall drops, NAT events, admin access attempts, and routing anomalies—useful for detecting attacks and building incident timelines.

---

## 2) What syslog transport is most commonly used by routers?
UDP/514 is the most commonly used legacy syslog transport, widely supported by routers and network appliances.

---

## 3) How did you confirm logging was active on OpenWrt?
By confirming `logd` was running:
- `/sbin/logd -S 64` appeared in the process list.

---

## 4) How does OpenWrt configure remote syslog forwarding?
Using UCI fields in `system.@system[0]` such as:
- `log_ip`
- `log_port`
- `log_proto`

---

## 5) What does it mean when `log_ip` is empty?
It means syslog forwarding is supported but not configured to send logs to a remote collector yet.

---

## 6) What changes did you apply to forward logs to the SIEM?
Configured:
- `log_ip='10.0.2.15'`
- `log_port='514'`
- `log_proto='udp'`
and committed changes.

---

## 7) How did you adjust log verbosity on OpenWrt?
By setting:
- `conloglevel='8'`
- `cronloglevel='8'`
which increases logging verbosity similar to “debug-like” behavior.

---

## 8) Why restart the log service after configuration changes?
Restarting ensures syslog forwarding settings and verbosity changes take effect immediately.

---

## 9) Why use tcpdump on the SIEM receiver?
tcpdump provides network-level proof that syslog packets are reaching the SIEM host on the correct port from the correct device IP.

---

## 10) What did the tcpdump output confirm?
It confirmed packets were sent from:
- `192.168.1.1` to `10.0.2.15:514` and identified them as SYSLOG messages.

---

## 11) Why generate a test log using `logger` on the router?
A test message provides an unambiguous proof that:
- the router is generating syslog events
- forwarding is functioning end-to-end
- receiver is writing the message to disk

---

## 12) How did you confirm the SIEM receiver wrote the router logs?
By checking `/var/log/messages` on the SIEM host and finding:
- the forwarded router test message text

---

## 13) What is a real-world next step after confirming router log ingestion?
- parse and normalize fields in SIEM (source IP, action, rule name)
- create alert rules for repeated drops/scans
- correlate with endpoint logs (failed logons + firewall events)

---
