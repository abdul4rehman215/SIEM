# 💬 Interview Q&A — Lab 08: Gathering Windows Event Logs

---

## 1) Why are Windows Event Logs important for SIEM?
They provide high-value security telemetry such as logon activity, policy changes, service creation, and authentication failures/success—critical for detection and investigations.

---

## 2) What is Winlogbeat?
Winlogbeat is a lightweight Elastic Beat that collects Windows Event Logs and forwards them to Elasticsearch or Logstash for centralized analysis.

---

## 3) Which Windows channels were collected in this lab?
- Application
- Security
- System

---

## 4) Why collect the Security log specifically?
Security logs contain authentication and authorization events, including failed logons and account changes, which are core signals for detecting attacks.

---

## 5) What is the purpose of installing Winlogbeat as a Windows service?
Running as a service ensures Winlogbeat starts reliably, runs in the background, and continuously ships events without requiring a user session.

---

## 6) Why did `Start-Service winlogbeat` fail in this case?
It failed because the service was already running. Attempting to start an already-running service can produce an error depending on the service/controller state.

---

## 7) What is the correct way to apply configuration changes?
Restart the service:
- `Restart-Service winlogbeat`
This reloads `winlogbeat.yml`.

---

## 8) How did you verify Winlogbeat was reading logs?
- `Get-EventLog -LogName Application -Newest 5` showed fresh events
- Winlogbeat itself wrote service start messages into the Application log

---

## 9) How did you verify Winlogbeat was producing its own logs?
By checking the Winlogbeat logs directory:
- `Get-ChildItem .\logs`

---

## 10) What does the output.elasticsearch section define?
It defines where Winlogbeat sends events (Elasticsearch hosts) and optionally authentication credentials.

---

## 11) How did you confirm logs were ingested in the SIEM dashboard?
In Kibana Discover:
- filtered on `event.code:*`
- filtered on `winlog.channel` values
- observed new events arriving with updated timestamps

---

## 12) What is one security improvement for production configurations?
Use strong secrets management:
- avoid plaintext passwords in config
- use secure keystores or environment-based secret injection
- enforce TLS and authenticated outputs

---

## 13) What is a realistic next step after onboarding Windows logs?
Create detections and dashboards for:
- failed logons (4625)
- suspicious logon types
- service creation events
- privilege escalation indicators

---
