# 🧪 Lab 24: Alarm Tuning

## 🧾 Lab Summary
Alarm tuning is the process of reducing alert noise (false positives) while keeping detections effective. In a SOC/SIEM environment, excessive false alerts can overwhelm analysts, hide real incidents, and slow response time.

✅ Tool used in this lab: **ElastAlert** (open-source alerting tool for Elasticsearch).  
Because the lab referenced ElastAlert workflows (`/var/log/elastalert/` and `elastalert-test-rule`), I followed the ElastAlert approach end-to-end:

- Installed ElastAlert in a Python virtual environment
- Created realistic alert log entries to identify noisy rules
- Built a sample noisy rule (`HTTP_404_Spike`)
- Tuned the rule using **exception conditions** (`must_not`) to suppress known benign traffic
- Tested the tuned rule using `elastalert-test-rule`
- Verified that alerts still trigger for suspicious sources while benign sources are excluded

Result: ✅ improved signal-to-noise ratio without breaking detection.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Identify alerts that trigger too frequently
- Determine likely false-positive sources/patterns
- Apply exception/whitelist logic to suppress benign traffic
- Validate tuning changes through controlled test events
- Measure “before vs after” noise reduction using Elasticsearch queries

---

## 📌 Prerequisites
- Basic cybersecurity concepts (false positives/false negatives, alert fatigue)
- Familiarity with monitoring/alerting tools
- Elasticsearch reachable (used as ElastAlert data source)
- Tools: Python 3, pip, venv, curl, jq

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Environment | Cloud Lab Environment |
| User | `toor` |
| Python | 3.12.3 |
| Tool | ElastAlert 0.2.4 (venv install) |
| ElastAlert config dir | `/etc/elastalert/` |
| Rules folder | `/etc/elastalert/rules/` |
| Logs folder | `/var/log/elastalert/` |
| Elasticsearch | `http://localhost:9200` |
| Test index | `inbound-logs` |

---

## 🗂️ Repository Structure
```text
lab24-alarm-tuning/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── configs/
│   ├── elastalert.yaml
│   ├── rules/
│   │   ├── http_404_spike_before.yaml
│   │   └── http_404_spike_after_tuned.yaml
│   └── sample-alerts.log
└── artifacts/
    ├── alert-frequency-count.txt
    ├── yaml-validate.txt
    ├── bulk-insert-result.json
    ├── elastalert-test-rule-output.txt
    ├── es-count-before.json
    └── es-count-after.json
````

> Notes:
>
> * `configs/` stores the ElastAlert config and both rule versions (before/after tuning).
> * `artifacts/` stores evidence showing noise identification, tuning validation, and before/after counts.

---

## 🧩 Tasks Overview (What I Performed)

### ✅ Task 0: Setup ElastAlert (required on fresh Ubuntu VM)

Installed prerequisites and ElastAlert using a Python venv:

* created venv: `~/elastalert-venv`
* installed ElastAlert via pip
* created directories:

  * `/etc/elastalert/rules`
  * `/var/log/elastalert`
* ensured user ownership for writing configs and logs

---

### ✅ Task 1: Identify Frequent False Positive Alerts

#### 1.1 Review alert logs

* navigated to `/var/log/elastalert/`
* created a realistic `alerts.log` with repeated triggers:

  * `HTTP_404_Spike`
  * `Port_Scan`
  * `SSH_BruteForce`

#### 1.2 Identify “noisiest” rule

Used a practical extraction to count alert types:

```bash
grep -oP 'ALERT:\s+\K[^ ]+' alerts.log | sort | uniq -c | sort -nr
```

Result:

* `HTTP_404_Spike` triggered most frequently → best tuning target

---

### ✅ Task 2: Add Exception Conditions (Alarm Tuning)

Because the lab’s Suricata-style YAML snippet is pseudo-format, the ElastAlert equivalent is:

* **exception filters** using `must_not`

#### 2.1 Create ElastAlert base config

Created `/etc/elastalert/elastalert.yaml` pointing to:

* rules folder
* Elasticsearch host/port
* writeback index

#### 2.2 Create a noisy rule (before tuning)

Created rule: `HTTP_404_Spike`

* triggers when ≥ 3 events in 5 minutes per `source.ip`
* matches “404-ish” web paths via query_string
* can produce false positives for benign scanners and health checks

#### 2.3 Tune with exceptions (must_not)

Added exceptions to reduce false positives:

* exclude known benign IP:

  * `source.ip: 192.168.0.10`
* exclude known benign monitoring endpoint:

  * `GET /health`

Validated YAML correctness.

---

### ✅ Task 3: Test and Validate Changes

#### 3.1 Insert controlled test events into Elasticsearch

Inserted 6 test HTTP events into `inbound-logs`:

* 3 from benign IP `192.168.0.10` (should be filtered out)
* 3 from suspicious IP `185.220.101.4` (should still trigger)

#### 3.2 Run ElastAlert rule test

Executed:

```bash
elastalert-test-rule --config /etc/elastalert/elastalert.yaml --rule /etc/elastalert/rules/http_404_spike.yaml
```

Observed:

* 6 hits initially
* after exceptions: 3 hits remain
* rule triggered only for `185.220.101.4`

#### 3.3 Before vs After noise measurement

Confirmed via Elasticsearch queries:

* before exceptions: 6 matching events
* after exceptions: 3 matching events

Noise reduced while detection remains effective.

---

## 🔍 Verification & Validation

This lab is successful when:

* ✅ ElastAlert installed and config directories exist
* ✅ Frequent/noisy alerts identified (counts show top talkers)
* ✅ Tuned rule includes `must_not` exceptions
* ✅ YAML validates correctly
* ✅ ElastAlert test-run still triggers for suspicious source IPs
* ✅ Benign sources are suppressed (not triggering alerts)
* ✅ Before/after counts show noise reduction

---

## 🧠 What I Learned

* Alarm tuning is a balancing act between:

  * reducing false positives (noise)
  * preserving true positives (detection)
* Whitelisting should be **precise** (specific IPs, paths, known monitoring patterns)
* Testing after tuning is essential to avoid breaking detection logic
* Measuring before/after impact improves tuning decisions and documentation quality

---

## 🌍 Why This Matters (Real-World Relevance)

In real SOC operations:

* noisy rules cause alert fatigue
* analysts may ignore alerts if volume is too high
* real incidents can be missed due to noise

Alarm tuning helps:

* improve triage speed
* increase confidence in alerts
* reduce cost and operational load
* enable better automation (SOAR workflows depend on reliable alerts)

---

## ✅ Result

* ✅ Noisy alert identified: `HTTP_404_Spike`
* ✅ Exception conditions implemented (must_not)
* ✅ Benign traffic excluded (192.168.0.10 + /health)
* ✅ Suspicious traffic still detected (185.220.101.4)
* ✅ Noise reduced from 6 → 3 matching events in test dataset
* ✅ Ready for GitHub upload with reproducible configs and validation artifacts

---

## 🏁 Conclusion

This lab successfully demonstrated practical alarm tuning using ElastAlert. By identifying noisy alerts, applying exception conditions, and validating outcomes with controlled test data and ElastAlert rule testing, I improved alert accuracy while maintaining detection effectiveness—an essential SOC skill for managing SIEM signal-to-noise.

---
