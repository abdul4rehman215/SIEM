# 🛠️ Troubleshooting Guide — Lab 12: Custom Field Extraction

---

## Issue 1: Regex query returns zero results

### ❌ Problem
Regex search does not find logs with IP-like patterns.

### ✅ Causes
- wrong index pattern (logs-* may not exist)
- field name different (not `message`)
- logs are stored in different indices

### ✅ Resolution
- confirm indices:
```bash
curl -s "http://localhost:9200/_cat/indices?v"
````

* confirm field exists in documents
* broaden query or adjust index pattern

---

## Issue 2: Logstash not found or wrong version

### ❌ Problem

`logstash --version` fails.

### ✅ Resolution

Install Logstash (lab dependent) or ensure PATH includes Logstash binary.
Also confirm Java available (Logstash requires JVM).

---

## Issue 3: Grok parsing fails (`_grokparsefailure`)

### ❌ Problem

Fields not extracted; grok fails.

### ✅ Causes

* pattern mismatch with log format
* extra spaces or unexpected tokens
* incorrect grok pattern

### ✅ Resolution

* print raw message and adjust pattern incrementally
* add tags on failure (already included for second grok)
* test only first grok first, then add second grok

---

## Issue 4: Second grok fails to extract IP/port

### ❌ Problem

`src_ip` and `src_port` missing, `_grok_ip_extract_failed` tag appears.

### ✅ Causes

Message format doesn't contain `"from <ip> port <port>"`

### ✅ Resolution

Adjust second grok match to the actual message style, e.g.:

```conf
match => { "logmessage" => "from %{IP:src_ip} port %{INT:src_port}" }
```

---

## Issue 5: Logstash pipeline exits too quickly

### ✅ Explanation

When using stdin input and a single echo pipe, Logstash will read the line, output parsed event, then terminate. This is expected for quick pipeline tests.

---
