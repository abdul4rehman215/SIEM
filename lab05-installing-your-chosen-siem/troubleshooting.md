# 🛠️ Troubleshooting Guide — Lab 05: Installing Your Chosen SIEM

---

## Issue 1: OpenJDK 11 package not available

### ❌ Problem
```text
E: Package 'openjdk-11-jdk' has no installation candidate
````

### ✅ Cause

Ubuntu 24.04 does not include OpenJDK 11 in default repositories.

### ✅ Resolution

Install OpenJDK 17 instead:

```bash
sudo apt update
sudo apt install -y openjdk-17-jdk
java -version
```

---

## Issue 2: Elasticsearch 8.x blocks curl verification (security enabled by default)

### ❌ Problem

`curl localhost:9200` fails or requires authentication.

### ✅ Cause

Elasticsearch 8.x enables security features by default.

### ✅ Resolution (Lab verification approach)

Disable security in `elasticsearch.yml` for simple lab testing:

```yaml
xpack.security.enabled: false
```

Restart:

```bash
sudo systemctl restart elasticsearch
```

---

## Issue 3: Elasticsearch service fails to start

### ❌ Problem

`systemctl status elasticsearch` shows failed.

### ✅ Causes

* Invalid YAML formatting
* Memory constraints
* Port conflicts
* JVM startup issues

### ✅ Resolution

Check logs:

```bash
sudo journalctl -u elasticsearch -xe --no-pager | tail -50
```

Validate config:

* confirm proper indentation
* confirm `cluster.name` and `network.host` lines are correct

Restart:

```bash
sudo systemctl restart elasticsearch
```

---

## Issue 4: Kibana not reachable or not responding

### ❌ Problem

`curl -I http://localhost:5601` fails.

### ✅ Causes

* Kibana not started
* Misconfigured kibana.yml
* Elasticsearch not reachable

### ✅ Resolution

Check status:

```bash
sudo systemctl status kibana --no-pager
sudo journalctl -u kibana -xe --no-pager | tail -50
```

Verify Elasticsearch:

```bash
curl -s http://localhost:9200 | head
```

Verify port:

```bash
ss -lntp | grep :5601
```

---

## Issue 5: `.deb` installation fails due to missing dependencies

### ❌ Problem

`dpkg -i <package>.deb` fails with dependency errors.

### ✅ Cause

dpkg does not automatically resolve dependencies.

### ✅ Resolution

Fix dependencies:

```bash
sudo apt -f install -y
```

Then re-run dpkg install if needed.

---
