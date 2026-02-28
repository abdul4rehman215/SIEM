# 🛠️ Troubleshooting Guide — Lab 22: Index Maintenance & Data Retention

> This guide covers common issues when installing PostgreSQL, creating indexes, collecting index usage stats, implementing retention, and simulating file retention cleanup.

---

## 1) PostgreSQL service shows `active (exited)` — is that a problem?

### ✅ Symptoms
- `systemctl status postgresql` shows:
  - `Active: active (exited)`

### ✅ Explanation
On Ubuntu, `postgresql.service` can show `active (exited)` because it acts as a meta-service controlling cluster services. The actual cluster is still running.

### ✅ Verify cluster status
```bash
sudo pg_lsclusters
sudo systemctl status postgresql@16-main --no-pager
````

---

## 2) `psql` connection fails (peer auth / permission issues)

### ✅ Symptoms

* `psql: FATAL:  Peer authentication failed for user "postgres"`
* or permission denied when connecting as postgres

### ✅ Fix

Run psql as postgres user:

```bash
sudo -u postgres psql
sudo -u postgres psql -d labdb
```

---

## 3) Database already exists / table already exists

### ✅ Symptoms

* `CREATE DATABASE` → `already exists`
* `CREATE TABLE` → `relation already exists`

### ✅ Fix

This is safe if rerunning the lab. Options:

* Use `IF NOT EXISTS` patterns (where supported), or
* Drop and recreate (lab cleanup only):

```bash id="6c7k7k"
sudo -u postgres psql -c "DROP DATABASE labdb;"
sudo -u postgres psql -c "CREATE DATABASE labdb;"
```

---

## 4) Index creation fails

### ✅ Symptoms

* `CREATE INDEX` errors (relation not found, permission issues)

### ✅ Fix Checklist

1. Confirm table exists:

```bash id="j4x0dq"
sudo -u postgres psql -d labdb -c "\dt"
```

2. Re-run table creation if needed.
3. Ensure you are in the correct database (`labdb`).

---

## 5) `pg_indexes` shows no indexes (unexpected)

### ✅ Symptoms

* Query returns 0 rows

### ✅ Fix Checklist

1. Ensure you’re querying the correct schema:

* lab uses `public`

2. Confirm indexes exist:

```bash id="jx30p3"
sudo -u postgres psql -d labdb -c "\di"
```

3. If indexes are in a different schema, adjust `schemaname`.

---

## 6) `pg_stat_user_indexes` shows `idx_scan = 0` even after queries

### ✅ Symptoms

* Usage stats remain 0

### ✅ Causes

* Queries didn’t use the index (planner chose sequential scan)
* Table is too small; seq scan is cheaper
* Stats reset recently

### ✅ Fix / Validate

1. Check query plan:

```bash id="p7e42d"
sudo -u postgres psql -d labdb -c "EXPLAIN (ANALYZE, BUFFERS) SELECT count(*) FROM app_logs WHERE severity='error';"
```

2. Increase data volume (more rows) so index becomes beneficial.
3. Ensure you are viewing user index stats (correct view).

---

## 7) Retention SQL deletes nothing (`DELETE 0`)

### ✅ Symptoms

* `DELETE 0` returned

### ✅ Explanation

This means no rows were older than the retention cutoff. In the lab, inserted rows were recent, so nothing qualified as older than 30 days.

### ✅ Optional test to see deletion happen

Insert a backdated row:

```sql
INSERT INTO app_logs(ts,severity,message)
VALUES (now()-interval '45 days','info','Old log entry test');
```

Then run:

```sql id="a5q9p8"
DELETE FROM app_logs WHERE ts < now() - interval '30 days';
```

---

## 8) Lab text uses non-existent `log_retention` parameter

### ✅ Symptoms

* If you attempt the lab text SQL:

  * `ALTER DATABASE ... SET log_retention = '30 days';`
    PostgreSQL returns parameter error.

### ✅ Fix

Implement retention as data lifecycle logic:

* SQL delete old rows
* scheduled job (cron/pg_cron)
* partitioning for faster drops

---

## 9) `touch -d "35 days ago"` fails

### ✅ Symptoms

* `touch: invalid date format`

### ✅ Fix

Ensure GNU coreutils `touch` date format supported. Try:

```bash
sudo touch -d "35 days ago" /var/log/demo-retention/log_35_days.log
```

Alternative:

```bash id="7xp7qk"
sudo touch -t 202601240000 /var/log/demo-retention/log_35_days.log
```

---

## 10) `find -mtime +30` deletes the wrong files

### ✅ Symptoms

* Deletes files you didn’t intend to delete

### ✅ Fix / Safety Practices

1. Always dry-run first:

```bash id="q1x6vm"
sudo find /var/log/demo-retention -mtime +30 -print
```

2. Then delete with `-exec rm -v`:

```bash id="3m4q3p"
sudo find /var/log/demo-retention -mtime +30 -exec rm -v {} \;
```

3. Limit scope to a specific directory (avoid wildcards unless needed).

---

## ✅ Quick Validation Checklist (After Fixes)

Run:

```bash id="vfa9a4"
# Postgres running
sudo systemctl status postgresql --no-pager | head -n 12
sudo -u postgres psql -c "SELECT version();"

# Index listing and usage
sudo -u postgres psql -d labdb -c "SELECT tablename, indexname FROM pg_indexes WHERE schemaname='public';"
sudo -u postgres psql -d labdb -c "SELECT relname, indexrelname, idx_scan FROM pg_stat_user_indexes ORDER BY idx_scan DESC;"

# Retention logic
sudo -u postgres psql -d labdb -c "DELETE FROM app_logs WHERE ts < now() - interval '30 days';"

# File retention logic (safe dry-run + cleanup)
sudo find /var/log/demo-retention -mtime +30 -print
sudo find /var/log/demo-retention -mtime +30 -exec rm -v {} \;
sudo ls -l /var/log/demo-retention
```

If Postgres queries work and the old log file is deleted while recent remains, your retention workflow is functioning correctly.

---
