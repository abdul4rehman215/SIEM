# 💬 Interview Q&A — Lab 12: Custom Field Extraction

---

## 1) What is custom field extraction in SIEM?
Custom field extraction is the process of converting raw/unstructured logs into structured fields (IP, username, program, event type) so they can be searched, correlated, and alerted on.

---

## 2) Why do some logs appear only as a `message` field?
Because the SIEM may not have a default parser for that log format, or the logs are plain text without structured fields like JSON.

---

## 3) What regex did you use to locate IPv4-like patterns?
```text
(\d{1,3}\.){3}\d{1,3}
````

It matches IPv4-like strings such as `203.0.113.55`.

---

## 4) What limitation does that regex have?

It can match invalid IPs like `999.999.999.999`. Data validation must be enforced separately (mapping, script, or downstream checks).

---

## 5) What is Grok and why is it useful?

Grok is a pattern-based parsing system (built on regex) that simplifies extracting fields from unstructured logs using readable patterns.

---

## 6) What fields did the first Grok extract from syslog?

* `logdate`
* `logsource`
* `program`
* `pid`
* `logmessage`

---

## 7) What fields did the second Grok extract?

* `src_ip`
* `src_port`

---

## 8) Why use two Grok stages?

First stage normalizes the syslog wrapper. Second stage extracts deeper values from the remaining message (e.g., IP/port).

---

## 9) How did you test Grok extraction safely?

By using Logstash stdin input and piping a sample log message into Logstash, printing structured output using `rubydebug`.

---

## 10) What proves extraction worked in the output?

The output showed:

* `src_ip: 203.0.113.55`
* `src_port: 51244`
* `program: sshd`
  along with the other extracted fields.

---

## 11) How do extracted fields help SOC detections?

They allow rules like:

* alert if `src_ip` repeats across many failed logons
* track brute force patterns by `program=sshd` and `event category`
* correlate firewall logs with endpoint authentication events

---

## 12) What is a next step after extraction works in a test pipeline?

Deploy the grok filter into a production Logstash pipeline (beats/syslog input) and index structured fields into Elasticsearch for dashboards and alerts.

---
