# 💾 Lab 33: Backup & Restore of SIEM Data

## 🧾 Lab Summary
This lab demonstrated a practical **backup and restore workflow** for SIEM data using an open-source ELK-based approach. I identified the SIEM indices that should be protected, configured an Elasticsearch filesystem snapshot repository, created an index snapshot backup, exported Kibana saved objects (dashboards/visualizations/data views) as a baseline “rules/config” backup, then simulated a restore by deleting an index and recovering it from the snapshot. Finally, I validated data integrity by confirming index health and document counts after restore.

---

## 🎯 Objectives
- Understand backup options and processes in a SIEM environment
- Perform a manual backup of SIEM data:
  - Elasticsearch indices (logs)
  - SIEM configurations (Kibana saved objects baseline)
- Simulate a restore process in a test scenario
- Validate integrity and reliability of restored data

---

## ✅ Prerequisites
- Basic understanding of SIEM systems
- Access to an open-source SIEM tool (ELK stack used here)
- Admin/root access to the SIEM environment
- Comfort with command-line operations

---

## 🧰 Tools Used
- **Elasticsearch Snapshot API** (`/_snapshot/...`) for index backups
- **Kibana Saved Objects Export API** for dashboards/visualizations/data views export
- CLI utilities:
  - `curl`
  - `systemctl`
  - `ss`

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Hostname | ip-REDACTED |
| User | toor |
| Elasticsearch | 7.15.2 |
| Kibana | 7.15.2 |
| Elasticsearch URL | http://localhost:9200 |
| Kibana URL | http://localhost:5601 |
| Snapshot repo type | `fs` (filesystem) |
| Snapshot repo path | `/var/backups/elasticsearch` |
| Repository name | `my_backup` |
| Snapshot name | `snapshot_1` |
| Index backed up | `filebeat-7.15.2-2025.08.18` |

---

## 🗂️ Repository Structure
```text
lab33-backup-restore-siem-data/
├── README.md
├── commands.sh
├── output.txt
├── configs/
│   └── elasticsearch.yml.snippet
├── artifacts/
│   └── kibana_saved_objects_backup.ndjson
├── interview_qna.md
└── troubleshooting.md
````

---

## ✅ Tasks Overview (No Commands Here)

### ✅ Task 1: Locate Backup Options in the SIEM

* Logged into Kibana and reviewed relevant management areas:

  * Stack Management → Index Management
  * Stack Management → Snapshot and Restore (if visible)
  * Stack Management → Saved Objects (export for dashboards/config baseline)
* Reviewed:

  * existing indices (Filebeat/Auditbeat + Kibana internal indices)
  * retention/ILM notes (where applicable)

---

### ✅ Task 2: Perform Manual Backup of Indices and Rules/Configurations

#### 2.1 Identify components for backup

* Elasticsearch indices:

  * Filebeat index selected as the primary SIEM data source in this lab:

    * `filebeat-7.15.2-2025.08.18`
* Kibana “config/rules baseline” backup:

  * exported saved objects (`dashboard`, `visualization`, `search`, `index-pattern`)
  * saved to `kibana_saved_objects_backup.ndjson`

#### 2.2 Configure snapshot prerequisites

Elasticsearch snapshots require:

* A filesystem repository directory
* `path.repo` configured in `elasticsearch.yml`
* Repository registered via the Snapshot API

Steps performed:

* Created repository directory: `/var/backups/elasticsearch`
* Applied secure permissions for the elasticsearch service user
* Updated `elasticsearch.yml` with:

  * `path.repo: ["/var/backups/elasticsearch"]`
* Restarted Elasticsearch and verified health
* Registered the snapshot repository (`my_backup`)

#### 2.3 Create snapshot backup

* Created `snapshot_1` for the selected index
* Verified snapshot state returned `SUCCESS`

#### 2.4 Export Kibana saved objects

* Exported saved objects via Kibana API to:

  * `kibana_saved_objects_backup.ndjson`
* Verified file exists and is non-empty

#### 2.5 Verify backup completion

* Listed snapshots and confirmed `snapshot_1` exists
* Verified repository directory contains snapshot metadata and index files

---

### ✅ Task 3: Simulate Restore in a Test Scenario

Since a second SIEM instance wasn’t available in this lab VM, a safe restore simulation was performed:

* Verified snapshot exists
* Deleted the target index (simulate data loss)
* Restored the index from snapshot
* Verified recovery status and data integrity

Integrity checks:

* Confirmed index exists again in `_cat/indices`
* Confirmed document count matches expected (`214`)
* Confirmed Kibana saved objects backup file is present and line-counted

---

## ✅ Results

✔ Snapshot repository configured and registered
✔ Index snapshot created successfully (`state: SUCCESS`)
✔ Kibana saved objects exported successfully (baseline config backup)
✔ Test restore simulation completed:

* index deleted
* index restored from snapshot
* recovery reached 100%
  ✔ Data integrity validated by index presence and document count

---

## 🌍 Why This Matters

Backup and restore capability is essential in SIEM operations because:

* SIEM data is often required for investigations, audits, and compliance
* Index corruption or accidental deletion can destroy evidence
* Restores validate that backups are actually usable—not just “created”

---

## 🧩 Real-World Applications

* Disaster recovery planning for SOC platforms
* Regular index snapshot schedules (daily/weekly)
* Retention compliance and evidence preservation
* Migration planning (restore snapshots into new clusters)
* Incident response readiness (restoring historical evidence)

---

## 🧠 What I Learned

* How Elasticsearch filesystem snapshots work and the prerequisites (`path.repo`)
* How to register a repository and create snapshots via REST API
* How to verify snapshots and repository file contents
* How to perform a controlled restore test and validate data integrity
* How Kibana saved objects export can serve as a baseline backup for dashboards/data views

---

## ✅ Conclusion

This lab successfully demonstrated a full SIEM backup/restore workflow: identifying SIEM indices, configuring snapshot infrastructure, creating backups, exporting Kibana saved objects, simulating data loss, restoring from snapshot, and validating integrity. Practicing these steps builds confidence for real SOC recovery scenarios.

---
