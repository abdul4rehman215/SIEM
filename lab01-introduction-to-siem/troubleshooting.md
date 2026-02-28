# 🛠️ Troubleshooting Guide — Lab 01: Introduction to SIEM

---

## Issue 1: `docker: command not found`

### ❌ Problem
Running `docker --version` returns:
- `Command 'docker' not found`

### ✅ Cause
Docker is not installed on the system.

### ✅ Resolution
Install Docker package:
```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable --now docker
````

---

## Issue 2: Docker service not running

### ❌ Problem

`docker ps` fails or the daemon is not responding.

### ✅ Cause

Docker service is stopped or not enabled.

### ✅ Resolution

Start and enable Docker:

```bash
sudo systemctl enable --now docker
sudo systemctl status docker
```

---

## Issue 3: Wazuh container not visible in `docker ps`

### ❌ Problem

Container does not appear after running `docker run`.

### ✅ Cause

* Container failed to start
* Image pull failed
* Port/network conflict

### ✅ Resolution

Check container list and logs:

```bash
sudo docker ps -a
sudo docker logs wazuh --tail 50
```

Remove and redeploy if needed:

```bash
sudo docker rm -f wazuh
sudo docker run -d --name wazuh --network host wazuh/wazuh
```

---

## Issue 4: Wazuh logcollector not monitoring configured files

### ❌ Problem

No lines such as:

* `Monitoring file: '/var/log/ufw.log'`

### ✅ Cause

* File path doesn’t exist
* Incorrect `<localfile>` entry
* Manager not restarted after config changes

### ✅ Resolution

Ensure files exist:

```bash
mkdir -p /var/log/nginx
touch /var/log/ufw.log /var/log/nginx/access.log /var/log/nginx/error.log
```

Restart Wazuh manager:

```bash
/var/ossec/bin/wazuh-control restart
```

Validate monitoring in logs:

```bash
tail -n 50 /var/ossec/logs/ossec.log
```

---

## Issue 5: Custom correlation rule does not trigger

### ❌ Problem

After writing JSON log line, no alert appears in `alerts.json`.

### ✅ Causes

* JSON log file not configured in `ossec.conf`
* Rule file not loaded or syntax issue
* Manager not restarted

### ✅ Resolution

1. Ensure JSON log file is monitored:

```xml
<localfile>
  <log_format>json</log_format>
  <location>/var/log/custom_app.json</location>
</localfile>
```

2. Restart Wazuh manager:

```bash
/var/ossec/bin/wazuh-control restart
```

3. Append test event again:

```bash
echo '{"action":"login","status":"failure","user":"hoa-admin","src_ip":"192.168.10.77"}' >> /var/log/custom_app.json
```

4. Verify alerts:

```bash
tail -n 5 /var/ossec/logs/alerts/alerts.json
```

---

## Issue 6: Email alerting configured but no email logs

### ❌ Problem

`grep -i email` shows no results in `ossec.log`.

### ✅ Cause

SMTP server is not running or reachable (common in cloud labs).

### ✅ Resolution

For lab validation, verify the alert pipeline:

* Rule matches event
* Alert written to `alerts.json`

Optional (if SMTP required later):

* Install and configure a mail service (postfix) or use a relay.

---

