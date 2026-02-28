# 🛠️ Troubleshooting Guide — Lab 33: Backup & Restore of SIEM Data (Elasticsearch Snapshots + Kibana Export)

> This guide covers common problems when configuring snapshot repositories, creating snapshots, exporting Kibana saved objects, and restoring indices.

---

## 1) Snapshot repository registration fails (`path.repo` not configured)

### ❗ Problem
Registering the repository returns an error like:
- repository path is not accessible
- `path.repo` is not set
- `location` is not allowed

### ✅ Possible Causes
- `path.repo` not added to `/etc/elasticsearch/elasticsearch.yml`
- Elasticsearch not restarted after config change

### ✅ Resolution
1) Add to `elasticsearch.yml`:
```yaml
path.repo: ["/var/backups/elasticsearch"]
````

2. Restart Elasticsearch:

```bash
sudo systemctl restart elasticsearch
```

3. Retry repository registration:

```bash id="r1u3ld"
curl -s -X PUT "http://localhost:9200/_snapshot/my_backup" \
  -H 'Content-Type: application/json' -d '{
    "type": "fs",
    "settings": {
      "location": "/var/backups/elasticsearch",
      "compress": true
    }
  }'
```

### ✅ Prevention

Always restart Elasticsearch after changing config files.

---

## 2) Snapshot fails due to permissions on repository directory

### ❗ Problem

Snapshot creation fails with access errors.

### ✅ Possible Causes

* Elasticsearch service user cannot write to `/var/backups/elasticsearch`
* Incorrect owner/group or restrictive permissions

### ✅ Resolution

Set correct ownership and permissions:

```bash id="vhhpsb"
sudo chown -R elasticsearch:elasticsearch /var/backups/elasticsearch
sudo chmod 750 /var/backups/elasticsearch
```

### ✅ Prevention

Use the elasticsearch service user as owner for snapshot repository paths.

---

## 3) Elasticsearch doesn't start after editing `elasticsearch.yml`

### ❗ Problem

After editing the config, Elasticsearch fails to start.

### ✅ Possible Causes

* YAML formatting error
* invalid setting key or indentation
* unsupported configuration options

### ✅ Resolution

Check status and logs:

```bash id="k3o5dp"
systemctl status elasticsearch --no-pager
sudo journalctl -u elasticsearch --no-pager | tail -n 80
```

Fix config formatting, then restart:

```bash id="x15krp"
sudo systemctl restart elasticsearch
```

### ✅ Prevention

Make small changes and validate service health after each modification.

---

## 4) Snapshot request returns `{"accepted":true}` but you expected `SUCCESS`

### ❗ Problem

Snapshot restore returns accepted, snapshot creation returns quickly without showing completion.

### ✅ Cause

The request might not have `wait_for_completion=true` or the operation is asynchronous.

### ✅ Resolution

* Use `wait_for_completion=true` for snapshot creation:

```bash id="7d0sbf"
curl -X PUT "http://localhost:9200/_snapshot/my_backup/snapshot_1?wait_for_completion=true" \
 -H 'Content-Type: application/json' -d'{
 "indices": "your_index",
 "ignore_unavailable": true,
 "include_global_state": false
 }'
```

* Or check snapshot status later:

```bash id="4aijx7"
curl -s "http://localhost:9200/_snapshot/my_backup/snapshot_1?pretty"
```

### ✅ Prevention

Use completion flags or always check snapshot state after starting a job.

---

## 5) Snapshot creation fails due to wrong index name

### ❗ Problem

Snapshot fails or produces empty snapshot because index doesn’t exist.

### ✅ Resolution

List indices and use the real index name:

```bash id="sqh7iu"
curl -s "http://localhost:9200/_cat/indices?v"
```

### ✅ Prevention

Copy the index name from `_cat/indices` output to avoid typos.

---

## 6) Restore fails because index already exists

### ❗ Problem

Restore API fails or skips restore because the target index exists.

### ✅ Resolution Options

* Delete the index first (test restore scenario):

```bash id="c19xax"
curl -X DELETE "http://localhost:9200/index_name?pretty"
```

* Or restore under a renamed index (advanced option):

```bash
# Uses rename_pattern/rename_replacement (optional advanced restore)
```

### ✅ Prevention

Decide restore strategy before execution: replace existing vs restore to new name.

---

## 7) Restore accepted but index doesn’t appear immediately

### ❗ Problem

Restore returns `{"accepted":true}` but index isn't visible yet.

### ✅ Cause

Restore runs asynchronously.

### ✅ Resolution

Check recovery progress:

```bash id="1sdlk2"
curl -s "http://localhost:9200/_cat/recovery/index_name?v"
```

Check shard health:

```bash id="m6b12o"
curl -s "http://localhost:9200/_cat/shards/index_name?v"
```

### ✅ Prevention

Always verify restore completion using `_cat/recovery`.

---

## 8) Kibana saved objects export fails (HTTP 400/401/403)

### ❗ Problem

Export API returns errors or produces an empty file.

### ✅ Possible Causes

* Kibana requires `kbn-xsrf` header
* Wrong URL/port
* Kibana not running
* Authentication required (in secured environments)

### ✅ Resolution

Ensure Kibana is running:

```bash id="b0a7od"
systemctl status kibana --no-pager | head -n 15
```

Use required headers:

```bash id="o31v9e"
curl -s -X POST "http://localhost:5601/api/saved_objects/_export" \
  -H "kbn-xsrf: true" -H "Content-Type: application/json" \
  -d '{"type":["dashboard","visualization","search","index-pattern"],"includeReferencesDeep":true}' \
  -o kibana_saved_objects_backup.ndjson
```

### ✅ Prevention

Always include `kbn-xsrf: true` in Kibana API calls.

---

## 9) Snapshot repository folder exists but looks empty

### ❗ Problem

You don’t see snapshot files in the repository path.

### ✅ Possible Causes

* Snapshot didn’t run or failed
* Wrong repository location configured
* Permission issues prevented writes

### ✅ Resolution

Check snapshots list:

```bash id="2l7t5b"
curl -s "http://localhost:9200/_snapshot/my_backup/_all?pretty"
```

Check repository directory:

```bash id="w3e2mi"
sudo ls -lah /var/backups/elasticsearch
```

### ✅ Prevention

Validate snapshot state is SUCCESS and verify folder contents after completion.

---

## 10) Data integrity mismatch after restore

### ❗ Problem

Document counts differ or data seems incomplete.

### ✅ Possible Causes

* Snapshot taken at different time than expected
* Writes occurred after snapshot and before delete
* Partial snapshot failures (shards)

### ✅ Resolution

* Compare doc counts before delete vs after restore
* Validate snapshot shard status in response (failed vs successful)
* For active clusters, schedule maintenance window or use ILM rollovers to snapshot stable indices

### ✅ Prevention

Take snapshots during controlled windows for clean integrity validation, especially in production.

---
