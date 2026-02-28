# 🎤 Interview Q&A — Lab 24: Alarm Tuning (ElastAlert)

## 1) What is alarm tuning and why is it important?
Alarm tuning is improving detection rules to reduce false positives (noise) while preserving true positives (real threats). It prevents alert fatigue, improves SOC efficiency, and helps analysts focus on high-value signals.

---

## 2) What is a false positive vs a false negative?
- **False positive:** alert triggers but activity is benign (noise).
- **False negative:** real malicious activity occurs but no alert triggers (missed detection).
Good tuning reduces false positives without increasing false negatives.

---

## 3) How did you identify noisy alerts in this lab?
I reviewed ElastAlert-style logs (`/var/log/elastalert/alerts.log`) and counted repeated alert types by extracting rule names and using `sort | uniq -c` to find the most frequent triggers.

---

## 4) Which alert was most noisy and why?
`HTTP_404_Spike` was the noisiest. It can trigger on common benign requests like:
- `/favicon.ico`
- `/robots.txt`
- monitoring endpoints like `/health`
These often generate 404s without being malicious.

---

## 5) What is the tuning strategy you applied?
I implemented **exception conditions** using `must_not` filters in the ElastAlert rule to exclude known benign sources and patterns:
- whitelisted IP: `192.168.0.10`
- ignored monitoring path: `GET /health`

---

## 6) Why is using exceptions safer than simply increasing thresholds?
Threshold-only tuning can reduce noise but may also suppress real attacks (increasing false negatives). Exceptions let you reduce noise for known benign patterns while still detecting suspicious sources.

---

## 7) How does ElastAlert apply filters and exceptions?
ElastAlert rule filters are built into the Elasticsearch query. A `bool` filter can include:
- `must`: conditions that must match
- `must_not`: conditions that exclude events (exceptions/whitelist)

---

## 8) What type of ElastAlert rule did you use and why?
I used a `frequency` rule:
- triggers when at least `num_events` occur in a timeframe
This is effective for detecting bursts like 404 spikes, brute-force attempts, and scans.

---

## 9) What is `query_key` and how did it help?
`query_key: source.ip` groups events by IP address. This ensures the spike detection triggers per-source rather than across the entire dataset.

---

## 10) How did you validate that tuning didn’t break detection?
I inserted controlled test events:
- 3 from benign IP `192.168.0.10` (should be excluded)
- 3 from suspicious IP `185.220.101.4` (should still trigger)

Then used `elastalert-test-rule` to confirm:
- 6 hits initially
- 3 remained after exceptions
- rule triggered only for suspicious IP

---

## 11) What is `elastalert-test-rule` used for?
It tests a rule against recent data without running ElastAlert continuously. It shows:
- how many hits matched
- whether a match would trigger
- what alert payload would be sent

---

## 12) How did you prove noise reduction quantitatively?
I ran Elasticsearch queries:
- before exceptions: 6 matching events
- after exceptions: 3 matching events
That showed clear noise reduction while keeping detection intact.

---

## 13) What are risks of over-tuning (too many exceptions)?
- attackers could abuse whitelisted IP ranges or paths
- missed detections (false negatives) increase
- blind spots develop over time
Tuning must be reviewed periodically and based on evidence.

---

## 14) How would you tune alarms in a real SOC environment?
- start with baselining and alert volume metrics
- identify top noisy rules and root cause patterns
- tune with exceptions, better context, or better parsing
- validate with test scenarios and retrospective review
- document all changes and monitor impact over time

---

## 15) What are best practices for whitelisting?
- whitelist the **minimum** required scope
- prefer whitelisting by specific attributes (exact IP, exact path, known user-agent)
- add expiration/review process for whitelists
- keep an audit trail of “why this was whitelisted”
