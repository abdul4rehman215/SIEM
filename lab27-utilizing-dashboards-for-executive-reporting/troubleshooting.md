# 🛠️ Troubleshooting Guide — Lab 27: Utilizing Dashboards for Executive Reporting

> This file documents common issues encountered while installing Grafana, configuring MariaDB, connecting a MySQL datasource in Grafana, and building dashboard panels.

---

## 1) Grafana service not running after installation

### ❗ Problem
`systemctl status grafana-server` shows:
- `inactive (dead)`
- or `failed`

### ✅ Possible Causes
- Service not enabled
- Systemd did not start the service automatically
- Port conflict or configuration error

### ✅ Resolution
```bash
sudo systemctl enable --now grafana-server
systemctl status grafana-server --no-pager
````

### ✅ Prevention

* Always verify service status immediately after installation.
* Keep system packages updated before installing Grafana.

---

## 2) Port 3000 not listening

### ❗ Problem

`ss -lntp | grep 3000` returns no output.

### ✅ Possible Causes

* Grafana service not started
* Firewall blocking access (less common for localhost)
* Grafana configured to bind only to localhost (or different port)

### ✅ Resolution

1. Check service:

```bash
systemctl status grafana-server --no-pager
```

2. Restart Grafana:

```bash
sudo systemctl restart grafana-server
```

3. Confirm listening:

```bash
sudo ss -lntp | grep 3000
```

### ✅ Prevention

* Keep Grafana on default port during labs unless specifically required to change.

---

## 3) Browser cannot access `http://localhost:3000`

### ❗ Problem

Browser shows:

* “This site can’t be reached”
* Connection refused / timeout

### ✅ Possible Causes

* Grafana service down
* Networking issue in VM/cloud lab (port not exposed externally)
* Using the wrong IP/interface

### ✅ Resolution

* Confirm locally:

```bash
curl -I http://localhost:3000 | head
```

* If running on a remote VM/cloud instance:

  * Use the server IP instead of localhost
  * Ensure port 3000 is allowed in security group/firewall rules:

    * Example: allow TCP/3000 from your IP (only if required)

### ✅ Prevention

* If on remote cloud lab: confirm whether the environment uses port forwarding or requires public access configuration.

---

## 4) Grafana login issues (default admin/admin)

### ❗ Problem

Cannot log in with default credentials.

### ✅ Possible Causes

* Password already changed previously
* Grafana provisioning config overrides defaults
* Existing Grafana database already initialized

### ✅ Resolution

* Reset admin password:

```bash
sudo grafana-cli admin reset-admin-password 'NEW_STRONG_PASSWORD'
sudo systemctl restart grafana-server
```

### ✅ Prevention

* Keep notes of credential changes in a secure place (do not commit passwords to GitHub).

---

## 5) MariaDB service not running

### ❗ Problem

`systemctl status mariadb` shows not running.

### ✅ Possible Causes

* Installation incomplete
* Service not started/enabled

### ✅ Resolution

```bash
sudo systemctl enable --now mariadb
systemctl status mariadb --no-pager | head -n 12
```

### ✅ Prevention

* Always confirm DB is active before attempting Grafana connection.

---

## 6) Cannot connect to MariaDB from Grafana ("Connection refused")

### ❗ Problem

Grafana datasource test fails with:

* connection refused
* database unreachable

### ✅ Possible Causes

* MariaDB not running
* Wrong host/port
* MySQL datasource configured incorrectly
* MariaDB bound to socket only (rare in default Ubuntu setup)
* Firewall rules (rare for localhost)

### ✅ Resolution

1. Verify MariaDB is listening:

```bash
sudo ss -lntp | grep 3306
```

2. Confirm DB status:

```bash
systemctl status mariadb --no-pager | head -n 12
```

3. Re-check datasource config:

* Host: `127.0.0.1:3306`
* Database: `exec_reporting`
* User: `grafana`
* Password: (correct)

### ✅ Prevention

* Use `127.0.0.1` rather than `localhost` if DNS resolution causes issues in some setups.

---

## 7) Grafana “Access denied” for DB user

### ❗ Problem

Datasource test fails with:

* `Access denied for user 'grafana'@'localhost'`
* or permission errors

### ✅ Possible Causes

* Wrong password entered in Grafana
* User not granted SELECT privileges
* User created with wrong host binding (e.g., not `localhost`)

### ✅ Resolution

Login to MariaDB and re-apply permissions:

```sql
CREATE USER 'grafana'@'localhost' IDENTIFIED BY 'REDACTED_PASSWORD';
GRANT SELECT ON exec_reporting.* TO 'grafana'@'localhost';
FLUSH PRIVILEGES;
```

If user already exists, reset password:

```sql
ALTER USER 'grafana'@'localhost' IDENTIFIED BY 'REDACTED_PASSWORD';
FLUSH PRIVILEGES;
```

### ✅ Prevention

* Always create **least-privilege** reporting users (SELECT only).
* Double-check the host portion (`'localhost'`) matches how Grafana connects.

---

## 8) Query panel shows “No data” in Grafana

### ❗ Problem

Dashboard panel renders with:

* “No data”
* blank chart

### ✅ Possible Causes

* Wrong query format for time series panels
* Missing required time column (`time`)
* Data outside selected time range
* Incorrect table/database selected

### ✅ Resolution

1. Ensure the time series query provides a valid time column:

```sql
SELECT
  date AS time,
  COUNT(incident_id) AS incident_count
FROM incidents
GROUP BY date
ORDER BY date;
```

2. Adjust dashboard time range (top-right in Grafana UI):

* Set to a range that includes `2025-08-12` to `2025-08-17`

3. Confirm data exists:

```sql
SELECT * FROM incidents LIMIT 5;
SELECT * FROM events LIMIT 5;
```

### ✅ Prevention

* Use known test data and confirm dataset queries work in MariaDB before building panels.

---

## 9) Pie chart not rendering correctly or labels missing

### ❗ Problem

Pie chart displays incorrectly or lacks segment labels.

### ✅ Possible Causes

* Visualization type not set to Pie Chart
* Labels/legend not enabled
* Query returns unexpected field names

### ✅ Resolution

* Ensure query returns:

  * `event_type` (label)
  * `event_count` (value)

Example:

```sql
SELECT
  event_type,
  COUNT(*) AS event_count
FROM events
GROUP BY event_type
ORDER BY event_count DESC;
```

* Enable in panel options:

  * Slice labels: Name + Value
  * Legend enabled

### ✅ Prevention

* Keep query field names simple and meaningful for chart mapping.

---

## 10) Snapshot link concerns (security relevance)

### ❗ Problem

Snapshot links may be accessible to anyone with the URL, depending on settings.

### ✅ Why It Matters

Snapshots can expose:

* incident volumes
* security trends
* operational patterns

### ✅ Safer Approach

* Keep sharing internal (login required)
* Use short snapshot expiry times
* Avoid including sensitive incident identifiers in executive dashboards

### ✅ Prevention

* In real environments, confirm governance rules and access control policies before using snapshots.

---
