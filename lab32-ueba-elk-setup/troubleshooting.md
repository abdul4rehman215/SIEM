# 🛠️ Troubleshooting Guide — Lab 32: Setting Up UEBA (Optional) with ELK + Beats

> This guide covers common issues when installing Elasticsearch/Kibana/Beats via `.deb`, starting services, configuring outputs, and validating ingestion.

---

## 1) `dpkg -i` fails due to missing dependencies

### ❗ Problem
Installing `.deb` packages returns:
- dependency errors
- “package is not configured”

### ✅ Possible Causes
- Missing required system libraries
- dpkg does not resolve dependencies automatically

### ✅ Resolution
Run:
```bash
sudo apt-get -f install -y
````

Then retry install if needed:

```bash
sudo dpkg -i <package>.deb
```

### ✅ Prevention

Keep system packages updated before installing:

```bash
sudo apt-get update
```

---

## 2) Elasticsearch service fails to start

### ❗ Problem

`systemctl start elasticsearch` fails or status shows `failed`.

### ✅ Possible Causes

* Memory pressure / insufficient RAM
* Java runtime issues
* Bad configuration in `/etc/elasticsearch/elasticsearch.yml`
* File permissions
* Port already in use

### ✅ Resolution

Check status and logs:

```bash
systemctl status elasticsearch --no-pager
sudo journalctl -u elasticsearch --no-pager | tail -n 80
```

Check port:

```bash
sudo ss -lntp | grep 9200
```

### ✅ Prevention

Use a VM size that can handle Elasticsearch (it can be memory-heavy).

---

## 3) Elasticsearch is running but `curl http://localhost:9200` fails

### ❗ Problem

`curl` returns connection refused / timeout.

### ✅ Possible Causes

* Elasticsearch bound to a different interface
* Service not fully started yet
* Firewall restrictions (less likely for localhost)

### ✅ Resolution

Confirm listening sockets:

```bash
sudo ss -lntp | grep 9200
```

Retry after short wait (ES can take time to start), and check logs:

```bash
sudo journalctl -u elasticsearch --no-pager | tail -n 40
```

### ✅ Prevention

Validate binding and startup logs after installation.

---

## 4) Kibana service fails to start

### ❗ Problem

`systemctl start kibana` shows failed.

### ✅ Possible Causes

* Elasticsearch not running (Kibana depends on it)
* Port 5601 in use
* Config issues in `/etc/kibana/kibana.yml`

### ✅ Resolution

Check dependencies first:

```bash
systemctl status elasticsearch --no-pager | head -n 20
```

Check Kibana status/logs:

```bash
systemctl status kibana --no-pager
sudo journalctl -u kibana --no-pager | tail -n 80
```

### ✅ Prevention

Start Elasticsearch first, confirm 9200 OK, then start Kibana.

---

## 5) Kibana returns 302 but UI doesn’t load in browser

### ❗ Problem

`curl -I http://localhost:5601` shows 302 redirect, but browser cannot open UI.

### ✅ Possible Causes

* Kibana bound only to localhost (expected here)
* You are accessing from another machine without port forwarding
* Cloud security group/firewall blocking external access

### ✅ Resolution

If on remote server:

* Use SSH port forwarding:

```bash
ssh -L 5601:localhost:5601 user@server
```

Then open: `http://localhost:5601` on your local machine.

### ✅ Prevention

Confirm whether your lab environment is local or remote and plan access accordingly.

---

## 6) Filebeat/Auditbeat service starts but no indices appear

### ❗ Problem

`_cat/indices` does not show `filebeat-*` or `auditbeat-*`.

### ✅ Possible Causes

* Output not configured correctly (wrong host/port)
* Elasticsearch not reachable
* Modules not enabled (Filebeat)
* Permissions or setup not done

### ✅ Resolution

1. Validate Elasticsearch:

```bash
curl -s http://localhost:9200 | head
```

2. Validate output config:

```bash
sudo grep -n "output.elasticsearch" -n /etc/filebeat/filebeat.yml
sudo grep -n "output.elasticsearch" -n /etc/auditbeat/auditbeat.yml
```

3. Run setup and restart:

```bash
sudo filebeat setup -e
sudo systemctl restart filebeat

sudo auditbeat setup -e
sudo systemctl restart auditbeat
```

4. Check logs:

```bash
sudo journalctl -u filebeat --no-pager | tail -n 80
sudo journalctl -u auditbeat --no-pager | tail -n 80
```

### ✅ Prevention

Always run `setup -e` and confirm services are running before checking indices.

---

## 7) Filebeat system module enabled but no auth logs visible

### ❗ Problem

Filebeat is running, but Discover shows little/no auth activity.

### ✅ Possible Causes

* No recent auth events occurred
* Wrong Data View selected
* Time range in Kibana not covering recent events

### ✅ Resolution

* Generate a test auth event (example: a sudo command)
* In Kibana, expand time range to “Last 24 hours”
* Ensure Data View is `filebeat-*`

### ✅ Prevention

During labs, generate small test events to confirm pipeline is working.

---

## 8) Kibana “Data View” not found / Discover empty

### ❗ Problem

Discover shows no data even though indices exist.

### ✅ Possible Causes

* Data View not created
* Time field not set properly
* Wrong time window

### ✅ Resolution

* Create Data Views:

  * `filebeat-*`
  * `auditbeat-*`
* Ensure time field is configured (usually `@timestamp`)
* Set a larger time range in Kibana (Last 7 days)

### ✅ Prevention

Create Data Views immediately after ingestion verification.

---

## 9) Memory usage is high (Elasticsearch ~1GB+)

### ❗ Problem

Elasticsearch consumes significant RAM.

### ✅ Cause

Elasticsearch is designed for indexing/search; JVM memory footprint can be large.

### ✅ Resolution (Lab-safe)

Use a machine with more RAM, or adjust JVM heap in lab if necessary (advanced).

### ✅ Prevention

Plan capacity for ELK even in labs; avoid running too many heavy services on small VMs.

---
