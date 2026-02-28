# 🎤 Interview Q&A — Lab 22: Index Maintenance & Data Retention

## 1) What is an index in a database, and why is it important?
An index is a data structure that speeds up lookups and filtering by allowing the database to find rows without scanning the entire table. It improves query performance, especially on large datasets.

---

## 2) What is “index maintenance”?
Index maintenance involves monitoring and managing indexes to keep performance healthy. It includes:
- identifying existing indexes
- checking whether indexes are used
- removing redundant indexes
- rebuilding or reindexing when necessary
- vacuum/analyze tuning (PostgreSQL) for planner accuracy

---

## 3) How did you list indexes in PostgreSQL?
I used `pg_indexes` to list index definitions in the public schema:
```sql
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public';
````

---

## 4) What is `pg_stat_user_indexes` used for?

It provides usage statistics for indexes on user tables, including how many times an index was scanned (`idx_scan`). This helps identify unused or underused indexes.

---

## 5) Why did you insert data and run queries before checking index usage?

Index usage stats change only when queries execute. I ran queries filtering by `severity` and time (`ts`) so PostgreSQL would use the relevant indexes and register scans.

---

## 6) What does `idx_scan` represent?

`idx_scan` indicates how many times PostgreSQL used an index scan for that index since stats were last reset. Higher values generally mean the index is useful.

---

## 7) Is an unused index always safe to drop?

Not always. It could be used by:

* infrequent but critical queries
* background jobs
* different query patterns not tested yet
  Before dropping, you should confirm workload patterns, consider monitoring over time, and evaluate impact.

---

## 8) What is data retention and why does it matter?

Data retention defines how long data is kept before deletion or archiving. It matters for:

* storage cost control
* performance (smaller datasets query faster)
* compliance requirements (keep only as long as necessary)
* reducing risk from retaining sensitive logs too long

---

## 9) The lab suggested `ALTER DATABASE ... SET log_retention = '30 days';` — why didn’t you use it?

`log_retention` is not a standard PostgreSQL database parameter, so it would fail. To keep the lab’s intent, I implemented retention realistically using SQL deletion for old rows.

---

## 10) How did you implement a “keep 30 days” retention policy for table logs?

I used a delete rule:

```sql
DELETE FROM app_logs
WHERE ts < now() - interval '30 days';
```

This enforces retention at the data level.

---

## 11) Why did you create a retention function?

A function makes retention reusable and automatable:

```sql
SELECT enforce_log_retention(30);
```

In production, this can be scheduled via cron/pg_cron to run periodically.

---

## 12) How did you verify retention behavior without changing system time?

Changing system time is risky in shared environments. Instead, I simulated old files using:

* `touch -d "35 days ago" file`
  Then verified cleanup with:
* `find ... -mtime +30 -exec rm ...`

---

## 13) How does file retention relate to log management in real systems?

Many systems write logs to disk, and retention is enforced by:

* `logrotate` policies
* cron jobs running find/cleanup
* centralized logging pipelines that age out indices (ELK/Opensearch ILM)

---

## 14) How does this lab relate to SIEM or SOC operations?

SIEM platforms generate large volumes of logs. Without retention:

* storage grows rapidly
* searches slow down
* compliance risks increase
  Index usage and retention policies are core operational controls for scalable SOC monitoring.

---

## 15) What production improvements would you add beyond this lab?

* schedule retention automatically (cron/pg_cron)
* partition logs by time (daily/weekly partitions) for faster deletes
* use VACUUM/ANALYZE regularly for planner accuracy
* archive older logs to cheaper storage instead of deleting (if required)
* implement role-based access + auditing around retention actions

---
