# 🧪 Lab 22: Index Maintenance & Data Retention

## 🧾 Lab Summary
This lab covers two core data-management concepts used in SIEMs and log platforms:

1) **Index maintenance** (in databases: identifying indexes and checking whether they are used)
2) **Data retention** (automating lifecycle cleanup to control storage and support compliance)

✅ Practical lab choice:
The lab includes PostgreSQL SQL queries, so I used **PostgreSQL** to execute them directly.  
Where the lab text referenced a non-standard PostgreSQL setting (`log_retention`), I kept the intent and implemented retention realistically:
- **Row retention** via SQL (delete rows older than 30 days)
- **File retention** via `find -mtime +30` (cron-style cleanup simulation)

This matches how many real environments work:
- database retention is often query/scheduled-job based
- filesystem retention is often cron/logrotate based

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Install and run PostgreSQL to execute index and maintenance queries
- List indexes using `pg_indexes`
- Analyze index usage using `pg_stat_user_indexes`
- Implement a 30-day data retention policy for log rows (SQL delete)
- Build a reusable retention function (`enforce_log_retention(days_to_keep)`)
- Simulate retention of filesystem logs using `find -mtime +30`
- Verify old data/logs are removed while recent ones are retained

---

## 📌 Prerequisites
- Basic understanding of databases, indexes, and query performance concepts
- Comfort using Linux terminal
- Access to an open-source DBMS (PostgreSQL used here)
- Tools: `psql`, `find`, and basic shell utilities

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Environment | Cloud Lab Environment |
| User | `toor` |
| DBMS | PostgreSQL 16 |
| Lab DB | `labdb` |
| Lab Table | `app_logs` |
| File retention test dir | `/var/log/demo-retention` |

---

## 🗂️ Repository Structure
```text
lab22-index-maintenance-and-data-retention/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── configs/
│   ├── schema-app-logs.sql
│   ├── index-queries.sql
│   ├── retention-queries.sql
│   └── retention-cron-example.txt
└── artifacts/
    ├── postgres-service-status.txt
    ├── indexes-listing.txt
    ├── index-usage-stats.txt
    ├── retention-delete-result.txt
    ├── retention-function.sql
    ├── demo-retention-ls-before.txt
    ├── demo-retention-cleanup.txt
    └── demo-retention-ls-after.txt
````

> Notes:
>
> * `configs/` contains reusable SQL scripts and cron-style retention logic.
> * `artifacts/` contains evidence outputs validating index listings, usage stats, and retention behavior.

---

## 🧩 Tasks Overview (What I Performed)

### ✅ Task 1: Understanding Index Maintenance

#### 1.0 Setup PostgreSQL (required for lab SQL)

* Installed PostgreSQL + contrib packages
* Confirmed service status

#### 1.1 Identify existing indexes

To ensure index queries return meaningful results, I created:

* database: `labdb`
* table: `app_logs`
* indexes:

  * primary key index on `id`
  * `idx_app_logs_ts` on `ts`
  * `idx_app_logs_severity` on `severity`

Then listed indexes using:

```sql
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public';
```

#### 1.2 Analyze index usage

To produce usage stats:

* inserted sample log rows
* executed queries filtering by `severity` and by recent `ts`

Then checked usage with:

```sql
SELECT relname AS table_name,
       indexrelname AS index_name,
       idx_scan AS times_index_used
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

This helps identify:

* actively used indexes (keep/optimize)
* unused indexes (candidate for removal if truly redundant)

---

### ✅ Task 2: Configuring Data Retention

#### 2.1 Identify retention-related config location

* located `postgresql.conf`
* reviewed logging settings
* noted: PostgreSQL does not have a single universal “retention” parameter for table rows

Retention is usually implemented via:

* SQL cleanup jobs for table data
* logrotate policies for PostgreSQL log files (if logging_collector is used)

#### 2.2 Adjust retention policy (30 days)

The lab suggested:

```sql
ALTER DATABASE ... SET log_retention = '30 days';
```

But `log_retention` is not a standard PostgreSQL parameter.

✅ Realistic retention implementation:

* delete application log rows older than 30 days:

```sql
DELETE FROM app_logs WHERE ts < now() - interval '30 days';
```

✅ Added a reusable function:

```sql
CREATE OR REPLACE FUNCTION enforce_log_retention(days_to_keep INT) RETURNS VOID ...
```

This mirrors real setups where retention is scheduled via cron/pg_cron.

---

### ✅ Task 3: Verify Data Handling Post-Retention

#### 3.1 Simulate retention deletion via filesystem (cron-style)

The lab includes a cron example:

```bash
0 0 * * * find /path/to/logs* -mtime +30 -exec rm {} \;
```

Instead of changing system time, I simulated old logs safely by:

* creating two files:

  * one “recent”
  * one “35 days old” using `touch -d "35 days ago"`

Then ran the cleanup command:

```bash
find /var/log/demo-retention* -mtime +30 -exec rm -v {} \;
```

✅ Verified only the old file was deleted.

---

## 🔍 Verification & Validation

This lab is successful when:

* ✅ PostgreSQL is installed and reachable (`psql` works)
* ✅ Index listing shows created indexes (`pg_indexes`)
* ✅ Index usage stats show scans after running queries (`pg_stat_user_indexes`)
* ✅ SQL retention delete runs successfully (even if 0 rows deleted)
* ✅ Retention function exists and executes
* ✅ Files older than 30 days are removed by `find -mtime +30`
* ✅ Recent log files remain

---

## 🧠 What I Learned

* Index maintenance includes both:

  * knowing what indexes exist
  * measuring whether they are actually used
* Unused indexes can increase write cost and storage without benefit.
* Retention is a lifecycle control:

  * supports cost control (storage)
  * supports compliance (keeping only required data)
  * reduces query noise on older datasets
* In real environments, retention is often automated:

  * SQL jobs for row retention
  * cron/logrotate for file retention

---

## 🌍 Why This Matters (Real-World Relevance)

SIEM and logging platforms grow quickly. Without retention and maintenance:

* storage costs escalate
* query performance degrades
* compliance risks increase (keeping data longer than allowed)

Index usage reviews and retention policies are foundational for:

* SOC log pipelines
* audit readiness
* scalable monitoring architecture

---

## ✅ Result

* ✅ PostgreSQL installed and running
* ✅ Indexes created, listed, and usage analyzed
* ✅ Data retention implemented (30-day row retention + reusable function)
* ✅ File retention simulated and verified using mtime cleanup
* ✅ Ready for GitHub upload with reproducible configs and evidence

---

## 🏁 Conclusion

This lab successfully demonstrated index visibility and usage analysis in PostgreSQL, plus realistic retention enforcement for both database rows and log files. These skills directly translate to maintaining performance, controlling storage growth, and meeting retention/compliance requirements in real security monitoring and logging environments.

----
