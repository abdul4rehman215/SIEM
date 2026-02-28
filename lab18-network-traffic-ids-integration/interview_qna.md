# 🎤 Interview Q&A — Lab 18: Network Traffic & IDS Integration (Optional)

## 1) What is an Intrusion Detection System (IDS)?
An IDS monitors network or host activity to detect suspicious behavior or known attack patterns. It typically generates alerts based on signatures, anomalies, or behavior rules.

---

## 2) What is Snort and why is it commonly used?
Snort is an open-source, signature-based network IDS/IPS. It’s widely used because it’s mature, flexible, has a large rules ecosystem, and integrates well with monitoring and SIEM pipelines.

---

## 3) What is the difference between IDS and IPS?
- **IDS** detects and alerts (passive monitoring).
- **IPS** can actively block or drop malicious traffic (inline prevention).
Snort can be deployed in IDS mode or IPS mode depending on configuration.

---

## 4) Why is integrating IDS alerts into a SIEM important?
A SIEM centralizes alerts and logs from multiple sources and enables:
- correlation across host + network signals
- searching, dashboards, and reporting
- alert triage and incident response workflows
- long-term retention and investigations

---

## 5) What interface and HOME_NET did you configure Snort to use?
- Interface: `ens5`
- HOME_NET: `172.31.0.0/16`

These settings define where Snort listens and what it considers “internal network” traffic.

---

## 6) Your Snort service failed during installation—how did you still validate Snort worked?
I used Snort **test mode**:
- `sudo snort -T -c /etc/snort/snort.conf`
Test mode validates the configuration and loads rules without requiring the systemd service to be fully operational.

---

## 7) What are “community rules” in Snort?
Community rules are a set of public Snort rules that detect common known patterns (basic threats/signatures). Enabling them increases baseline detection coverage.

---

## 8) How did you enable community rules in this lab?
By ensuring the include line was enabled in `/etc/snort/snort.conf`:
- `include $RULE_PATH/community.rules`

---

## 9) Why did `apt install elasticsearch/logstash/kibana` fail initially on Ubuntu 24.04?
Elastic packages are not included in Ubuntu’s default repositories. On Ubuntu 24.04, you typically must add the official Elastic APT repository before installing.

---

## 10) What does Logstash do in this IDS → SIEM pipeline?
Logstash ingests logs (Snort alerts), optionally parses/transforms them, then forwards them into Elasticsearch for indexing. It acts as the log processing and shipping pipeline.

---

## 11) What Logstash input and output did you configure?
- Input: reads Snort alert file:
  - `/var/log/snort/alert`
- Output:
  - Elasticsearch index: `snort-alerts-%{+YYYY.MM.dd}`
  - stdout (rubydebug) for quick verification

---

## 12) How did you generate traffic to test IDS alerting?
I generated benign traffic:
- HTTP with `curl http://example.com`
- ICMP with `ping -c 4 example.com`
This produced real traffic on the network interface that Snort could observe.

---

## 13) How did you verify Snort produced alerts?
I confirmed:
- alert file exists: `sudo ls -l /var/log/snort/alert`
- viewed recent entries: `sudo tail -n 5 /var/log/snort/alert`
The alert lines indicated Snort logged the observed traffic patterns.

---

## 14) How do you confirm Elasticsearch and Kibana are running?
- Elasticsearch:
  - `curl -s http://localhost:9200 | head`
- Kibana:
  - `sudo ss -lntp | grep 5601`
These checks confirm services are responsive and ports are listening.

---

## 15) If you were improving this for production, what would you add?
- Use structured alert formats (e.g., JSON output via Snort plugins or Suricata EVE JSON)
- Parse fields in Logstash (timestamp, src/dst IP/port, signature ID)
- Add dashboards and alert rules in Kibana
- Secure Elastic stack (TLS, auth, firewall rules)
- Tune Snort rules to reduce noise and focus on relevant threats
- Use Filebeat for log shipping and reliable ingestion
