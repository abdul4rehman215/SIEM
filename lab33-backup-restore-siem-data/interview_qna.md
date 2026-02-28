# 🧠 Interview Q&A — Lab 33: Backup & Restore of SIEM Data

---

## 1) Why are backups critical in a SIEM environment?
SIEM data is often needed for investigations, audits, and compliance. Without backups, accidental deletion, corruption, or system failure can destroy evidence and reduce incident response capability.

---

## 2) What SIEM components usually need backups?
Common components include:
- log indices (event data)
- detection rules and configurations
- dashboards/visualizations
- data views / index patterns
- alerting configurations
- retention/ILM policies and templates (depending on environment)

---

## 3) What backup method was used in this lab for Elasticsearch indices?
Elasticsearch **snapshots** using the Snapshot API and a filesystem (`fs`) repository.

---

## 4) Why did you configure `path.repo` in `elasticsearch.yml`?
Elasticsearch snapshots require an approved repository path. `path.repo` explicitly allows Elasticsearch to read/write snapshots to the specified directory.

---

## 5) What repository type was used and why?
Type: **fs** (filesystem).  
It’s simple for lab environments because it stores snapshot files locally on disk, making it easy to verify contents.

---

## 6) What index was selected for backup in this lab?
`filebeat-7.15.2-2025.08.18`  
It represented a real SIEM log index present in the environment.

---

## 7) What does `wait_for_completion=true` do in the snapshot request?
It makes the API call wait until the snapshot finishes, so the response returns the snapshot status (e.g., SUCCESS) rather than returning immediately.

---

## 8) What does `include_global_state: false` mean?
It excludes cluster-level state (like templates and persistent settings) from the snapshot. This is useful when you want to back up only specific indices and avoid overwriting cluster-wide settings during restores.

---

## 9) How did you back up dashboards and configurations in Kibana?
By exporting **Saved Objects** via Kibana’s export API, producing an `.ndjson` file containing dashboards, visualizations, searches, and index patterns.

---

## 10) Why is exporting Kibana Saved Objects useful?
It provides a portable backup of:
- dashboards
- visualizations
- data views  
This allows you to rebuild reporting capabilities after a restore or migration.

---

## 11) How did you verify snapshot creation was successful?
The snapshot API response returned:
- `state: "SUCCESS"`
and snapshots were listed via:
- `/_snapshot/my_backup/_all`

---

## 12) How did you validate the snapshot repository stored files correctly?
By checking the repository path:
```bash
sudo ls -lah /var/backups/elasticsearch
````

This showed snapshot metadata and index files inside the repository.

---

## 13) Why did you delete the index before restoring it?

To simulate a “data loss” scenario. Deleting the index makes the restore test meaningful because it proves the snapshot can recover missing data.

---

## 14) How did you validate the restore worked?

By checking:

* index exists again in `_cat/indices`
* index health is green/open
* document count matches expected (`214`)
* recovery status shows 100%

---

## 15) What is the main takeaway from this lab?

A backup is only valuable if it can be restored. This lab validated both backup creation and restore reliability, which is essential for SIEM disaster recovery and evidence preservation.

---
