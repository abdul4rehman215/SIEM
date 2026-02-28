# 🛠️ Troubleshooting Guide — Lab 04: Selecting a SIEM Platform

---

## Issue 1: `openjdk-11-jdk` not available on Ubuntu 24.04

### ❌ Problem
```text
E: Package 'openjdk-11-jdk' has no installation candidate
````

### ✅ Cause

Ubuntu 24.04 repositories may not include OpenJDK 11 by default.

### ✅ Resolution

Install OpenJDK 17:

```bash
sudo apt-get install -y openjdk-17-jdk
java -version
```

---

## Issue 2: `apt-key` deprecation warning while adding Elastic key

### ⚠️ Problem

```text
Warning: apt-key is deprecated...
```

### ✅ Cause

`apt-key` is deprecated on modern Debian/Ubuntu.

### ✅ Resolution (Lab-safe)

The lab still succeeds, but modern best practice is to use a keyring in `/etc/apt/trusted.gpg.d/` or `/usr/share/keyrings/`.

---

## Issue 3: Elasticsearch not starting

### ❌ Problem

`systemctl status elasticsearch` shows failed.

### ✅ Causes

* memory constraints
* invalid YAML config
* port conflicts

### ✅ Resolution

Check logs:

```bash
sudo journalctl -u elasticsearch -xe --no-pager | tail -50
```

Validate config and ensure single-node:

```yaml
discovery.type: single-node
```

Restart:

```bash
sudo systemctl restart elasticsearch
```

---

## Issue 4: Kibana starts but UI not reachable

### ❌ Problem

Kibana runs but cannot be accessed remotely.

### ✅ Causes

* `server.host` not set to `0.0.0.0`
* cloud firewall/security group rules block port 5601

### ✅ Resolution

Update:

```yaml
server.host: "0.0.0.0"
```

Verify listening:

```bash
ss -lntp | grep :5601
```

---

## Issue 5: Logstash running but Beats ingestion not working

### ❌ Problem

No logs appear in Elasticsearch.

### ✅ Causes

* Beats not configured
* pipeline misconfigured
* grok parsing failures

### ✅ Resolution

Validate pipeline syntax and logs:

```bash
sudo journalctl -u logstash -xe --no-pager | tail -50
```

Verify Logstash port:

```bash
ss -lntp | grep :5044
```

---
