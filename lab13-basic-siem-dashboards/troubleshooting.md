# 🛠️ Troubleshooting Guide — Lab 13: Basic SIEM Dashboards

---

## Issue 1: Kibana dashboard shows “No data”

### ❌ Problem
Visualizations appear empty.

### ✅ Causes
- index pattern not created or wrong (e.g., siem-auth-* not selected)
- time range mismatch (dashboard time picker not covering event time)
- Logstash not ingesting new data

### ✅ Resolution
- confirm indices exist:
```bash
curl -s "http://localhost:9200/_cat/indices?v" | head
````

* adjust Kibana time picker (e.g., “Last 24 hours”)
* check Logstash status/logs:

```bash id="5ukj68"
sudo systemctl status logstash --no-pager
sudo journalctl -u logstash -xe --no-pager | tail -50
```

---

## Issue 2: Logstash config test warning about logstash.yml

### ⚠️ Symptom

```text
WARNING: Could not find logstash.yml...
```

### ✅ Explanation

The command used `--path.settings /etc/logstash`, which is correct for many installs. The warning can appear depending on packaging/layout. The key result is: **Configuration OK**.

---

## Issue 3: Logstash not ingesting /var/log/auth.log

### ❌ Causes

* file permissions prevent logstash user from reading
* sincedb position already past the new line
* pipeline not reloaded after config update

### ✅ Resolution

* restart Logstash:

```bash id="lo7e0j"
sudo systemctl restart logstash
```

* ensure file readable (lab-dependent):

```bash id="vug2a3"
ls -l /var/log/auth.log
```

* optionally reset sincedb (careful in real envs):

```bash id="4lvp4r"
sudo rm -f /var/lib/logstash/sincedb-auth
sudo systemctl restart logstash
```

---

## Issue 4: Elasticsearch index not created

### ❌ Causes

* Elasticsearch down/unreachable
* Logstash output misconfigured
* authentication/security enabled without credentials

### ✅ Resolution

* verify Elasticsearch:

```bash id="31o0nq"
curl -s http://localhost:9200 | head
```

* check Logstash logs for output errors:

```bash id="kldd0h"
sudo journalctl -u logstash -xe --no-pager | tail -80
```

---

## Issue 5: Kibana not accessible on browser

### ❌ Causes

* Kibana not running
* firewall/security group blocks port 5601
* bound to localhost only

### ✅ Resolution

* verify service:

```bash id="8ol7lg"
sudo systemctl status kibana --no-pager
```

* confirm port:

```bash id="g7h6m7"
ss -lntp | grep :5601
```

* check kibana.yml binding (`server.host`)

---
