# 🛠️ Troubleshooting Guide — Lab 26: HOA-Focused Use Case (ELK + Docker)

> This guide covers common issues when running ELK in Docker, ingesting HOA gate logs via Logstash, tagging after-hours events, and verifying results in Elasticsearch/Kibana.

---

## 1) `docker-compose: command not found`

### ✅ Symptoms
- Running `docker-compose up -d` returns:
  - `command not found`

### ✅ Fix
Modern Docker uses the Compose plugin:
```bash
docker compose version
docker compose up -d
````

---

## 2) Containers start but Elasticsearch is not reachable on `localhost:9200`

### ✅ Symptoms

* `curl http://localhost:9200` fails or hangs

### ✅ Fix Checklist

1. Confirm containers:

```bash
docker ps
```

2. Check Elasticsearch logs:

```bash id="0yqj4a"
docker logs elasticsearch --tail 80
```

3. Verify port mapping exists:

* compose should map `9200:9200`

4. If memory-related errors occur (common for Elasticsearch):

* increase available memory or add JVM options (lab-only improvement):

```yaml
environment:
  - discovery.type=single-node
  - ES_JAVA_OPTS=-Xms512m -Xmx512m
```

Then restart:

```bash id="5r3w9t"
docker compose down
docker compose up -d
```

---

## 3) Logstash is running but no events are ingested

### ✅ Symptoms

* `docker logs logstash` shows pipeline started but no parsed events

### ✅ Fix Checklist

1. Confirm the log file exists on host:

```bash id="b6l3p1"
ls -l gate_logs.log
cat gate_logs.log
```

2. Confirm volumes are mounted correctly in `docker-compose.yml`:

```yaml
volumes:
  - ./logstash-gate.conf:/usr/share/logstash/pipeline/logstash.conf:ro
  - ./gate_logs.log:/data/gate_logs.log:ro
```

3. Confirm Logstash sees the file inside the container:

```bash id="w1j7m8"
docker exec -it logstash ls -l /data/gate_logs.log
docker exec -it logstash head -n 5 /data/gate_logs.log
```

4. Restart Logstash:

```bash id="d4u0k2"
docker restart logstash
docker logs logstash --tail 80
```

---

## 4) Grok parsing failures (fields not extracted)

### ✅ Symptoms

* Events appear but only contain raw `message`
* `_grokparsefailure` tag appears

### ✅ Fix

1. Check log format matches grok pattern:
   Expected line format:

```text
2023-09-15T00:45:00 Security Gate1 User123 Entry
```

2. Confirm grok pattern:

```conf
%{TIMESTAMP_ISO8601:log_time} %{WORD:event_type} %{WORD:gate} %{WORD:user} %{WORD:direction}
```

3. If gate/user values can include special chars or spaces, widen pattern:

* use `%{DATA:gate}` or `%{DATA:user}` carefully, but keep structure predictable.

---

## 5) After-hours tagging not working (no `unusual_activity` tag)

### ✅ Symptoms

* Events indexed but not tagged

### ✅ Fix Checklist

1. Confirm `@timestamp` is being set properly (date filter works):

* If `@timestamp` isn’t parsed, hour extraction won’t work.

2. Confirm date pattern:

```conf
date {
  match => [ "log_time", "YYYY-MM-dd'T'HH:mm:ss" ]
  target => "@timestamp"
}
```

3. Confirm Ruby logic:

```ruby
hour = t.time.hour
if hour >= 0 && hour < 5
  event.tag("unusual_activity")
end
```

4. Check Logstash output in logs:

```bash
docker logs logstash --tail 120
```

Look for `hour` and `tags` fields.

---

## 6) Elasticsearch index `hoa-gate-*` not found

### ✅ Symptoms

* Searches return index not found
* `/_cat/indices` doesn't show `hoa-gate-*`

### ✅ Fix Checklist

1. Confirm Logstash output hosts points to container network:

```conf
hosts => ["http://elasticsearch:9200"]
```

(Inside Docker network, `localhost:9200` would refer to Logstash container itself.)

2. Confirm Elasticsearch is reachable from Logstash container:

```bash id="9j1l0s"
docker exec -it logstash bash -lc 'curl -s http://elasticsearch:9200 | head'
```

3. List indices:

```bash id="3f7q0v"
curl -s "http://localhost:9200/_cat/indices?v" | head -n 40
```

4. Refresh:

```bash id="t0f4r2"
curl -s -X POST "http://localhost:9200/hoa-gate-*/_refresh"
```

---

## 7) Appended log entry not appearing (file tailing behavior)

### ✅ Symptoms

* You append a new line to `gate_logs.log`, but no new event shows up

### ✅ Fix

Because the file is mounted read-only and Logstash file input behavior may cache offsets:

* Restart Logstash (fastest lab method), since `sincedb_path => /dev/null` forces re-read:

```bash
docker restart logstash
docker logs logstash --tail 60
```

(Production approach would use persistent sincedb and correct tailing behavior.)

---

## 8) Kibana shows no data in Discover

### ✅ Symptoms

* Data exists in Elasticsearch, but Kibana Discover shows “No results”

### ✅ Fix Checklist

1. Create correct Data View:

* `hoa-gate-*`

2. Set correct time range:

* logs have timestamps in 2023 (sample data)
* If Kibana time picker is set to “Last 15 minutes”, it will show nothing.
  ✅ Fix: widen time range (e.g., “Last 5 years”) or set absolute date range around 2023-09.

3. Verify data exists in Elasticsearch:

```bash
curl -s "http://localhost:9200/hoa-gate-*/_search?size=1&pretty"
```

---

## 9) Kibana alerts/rules not triggering

### ✅ Symptoms

* Rule created but no alerts fire

### ✅ Fix Checklist

1. Ensure rule query matches:

* `tags:"unusual_activity"`

2. Ensure time window includes event timestamps:

* sample events are in 2023
* set rule time window accordingly, or generate fresh events with current timestamps for live testing

3. If email actions are required:

* SMTP must be configured (Lab 14 covers email notifications)

---

## ✅ Quick Validation Checklist (After Fixes)

```bash
# Containers running
docker ps

# Elasticsearch reachable
curl -s http://localhost:9200 | head

# Logstash sees the file inside container
docker exec -it logstash ls -l /data/gate_logs.log
docker exec -it logstash head -n 5 /data/gate_logs.log

# Logstash parsed output shows tags/hour
docker logs logstash --tail 80

# Index exists and has tagged docs
curl -s "http://localhost:9200/_cat/indices?v" | grep hoa-gate || true

curl -s "http://localhost:9200/hoa-gate-*/_search?pretty" \
-H 'Content-Type: application/json' \
-d '{
  "query": { "term": { "tags": "unusual_activity" } },
  "_source": ["@timestamp","gate","user","direction","hour","tags"],
  "sort": [{ "@timestamp": "desc" }]
}'
```

Expected:

* Events present
* `tags` includes `unusual_activity`
* `hour` field is between 0 and 4 for tagged events

---
