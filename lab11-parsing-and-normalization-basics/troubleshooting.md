# 🛠️ Troubleshooting Guide — Lab 11: Parsing & Normalization Basics

---

## Issue 1: Elasticsearch not reachable on localhost

### ❌ Problem
`curl http://localhost:9200` fails.

### ✅ Resolution
- verify service is running:
```bash
sudo systemctl status elasticsearch --no-pager
````

* check port:

```bash id="ssz9bp"
ss -lntp | grep :9200
```

---

## Issue 2: Pipeline creation fails

### ❌ Problem

`PUT _ingest/pipeline/...` returns an error.

### ✅ Causes

* invalid JSON
* missing Content-Type header
* Elasticsearch security/auth blocking requests

### ✅ Resolution

Validate JSON:

```bash id="v5h6pm"
cat pipeline.json
```

Use correct headers:

```bash id="g7b3xe"
curl -X PUT "http://localhost:9200/_ingest/pipeline/logdata_pipeline" \
-H "Content-Type: application/json" \
-d @pipeline.json
```

---

## Issue 3: Date parsing not working

### ❌ Problem

Timestamp not normalized.

### ✅ Causes

* non-ISO timestamp format
* wrong field name

### ✅ Resolution

* ensure field is `timestamp`
* ensure formats includes ISO8601
* test with `_simulate` first

---

## Issue 4: Pipeline fails on bad data

### ❌ Problem

Pipeline stops when timestamp is malformed.

### ✅ Resolution

Use:

```json
"ignore_failure": true
```

This prevents pipeline errors and preserves the original value.

---

## Issue 5: `index_not_found_exception` while querying

### ❌ Problem

Querying an index that doesn’t exist returns 404.

### ✅ Resolution

Create index first:

```bash id="4o2hjj"
curl -X PUT "http://localhost:9200/logs-test?pretty"
```

---

## Issue 6: Aggregation fails because field is not keyword

### ❌ Problem

Aggregation on `event_id` fails if field isn't aggregatable.

### ✅ Resolution

Use `event_id.keyword` (or define mapping) to ensure aggregations work:

```json
"field": "event_id.keyword"
```

---

