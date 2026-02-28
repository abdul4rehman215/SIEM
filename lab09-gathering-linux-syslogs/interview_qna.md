# 💬 Interview Q&A — Lab 09: Gathering Linux Syslogs

---

## 1) What is syslog in Linux?
Syslog is a standard logging mechanism used by Unix/Linux systems to record system and application messages in a consistent format for monitoring and troubleshooting.

---

## 2) What is rsyslog?
rsyslog is a widely used syslog implementation that collects logs from local sources and can forward them to remote collectors or SIEM systems.

---

## 3) Why forward Linux syslogs to a SIEM?
To centralize visibility, enable correlation across multiple systems, support investigations, and generate alerts for suspicious patterns.

---

## 4) What does `module(load="imudp")` do?
It enables the UDP input module so rsyslog can receive syslog messages over UDP.

---

## 5) What does `input(type="imudp" port="514")` do?
It tells rsyslog to listen on UDP port 514 for incoming syslog messages.

---

## 6) What does `*.* @10.0.2.15:5544` mean?
It forwards all facilities and severities (`*.*`) to the remote host at `10.0.2.15` using UDP (single `@`) on port 5544.

---

## 7) What is the difference between `@` and `@@` in rsyslog forwarding?
- `@` = UDP forwarding  
- `@@` = TCP forwarding (more reliable delivery)

---

## 8) How did you verify your rsyslog config changes were applied?
By using:
```bash
sudo grep -nE 'imudp|port="514"|\*\.\* @' /etc/rsyslog.conf
````

This confirmed the listener and forwarding rule were present.

---

## 9) Why restart rsyslog after editing the config?

Restarting applies configuration changes. Without restart/reload, the forwarding rule and listener changes may not take effect.

---

## 10) What does the `logger` command do?

`logger` writes a message into syslog/journald. It’s commonly used to generate test log events to validate pipelines.

---

## 11) How did you confirm the test message was logged locally?

By checking `/var/log/syslog`:

```bash
sudo tail -n 8 /var/log/syslog
```

---

## 12) How do you confirm the SIEM is receiving logs?

In the SIEM dashboard/search:

* search for unique message text (e.g., “Test log message”)
* filter by hostname to confirm source

---

## 13) What kinds of security detections can syslog support?

* SSH brute-force attempts (auth logs)
* suspicious sudo usage
* service failures/restarts
* new user creation or privilege changes
* abnormal firewall or kernel warnings

---

