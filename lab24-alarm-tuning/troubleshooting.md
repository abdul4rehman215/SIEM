# 🛠️ Troubleshooting Guide — Lab 24: Alarm Tuning (ElastAlert)

> This guide covers common issues when installing ElastAlert, validating rules, running `elastalert-test-rule`, and tuning alerts with exception filters.

---

## 1) `pip install elastalert` fails (build/dependency issues)

### ✅ Symptoms
- pip errors during wheel build
- missing compiler/tools
- SSL/cert errors

### ✅ Fix Checklist
1) Update pip and build deps:
```bash
python3 -m pip install --upgrade pip setuptools wheel
sudo apt update
sudo apt install -y build-essential python3-dev libffi-dev libssl-dev
````

2. Re-try:

```bash
pip install elastalert
```

---

## 2) Virtual environment not activating

### ✅ Symptoms

* `source ~/elastalert-venv/bin/activate` not found
* prompt doesn’t change to `(elastalert-venv)`

### ✅ Fix

Recreate venv:

```bash
python3 -m venv ~/elastalert-venv
source ~/elastalert-venv/bin/activate
python --version
```

---

## 3) Permission denied writing `/etc/elastalert` or `/var/log/elastalert`

### ✅ Symptoms

* `nano /etc/elastalert/...` permission errors

### ✅ Fix

Create dirs and assign ownership:

```bash
sudo mkdir -p /etc/elastalert/rules /var/log/elastalert
sudo chown -R toor:toor /etc/elastalert /var/log/elastalert
```

(Or keep root-owned and edit with sudo—either is fine for labs.)

---

## 4) Elasticsearch not reachable from ElastAlert

### ✅ Symptoms

* `elastalert-test-rule` errors: connection refused / timeout
* curl to `localhost:9200` fails

### ✅ Fix Checklist

1. Confirm Elasticsearch is up:

```bash
curl -s http://localhost:9200 | head
sudo systemctl status elasticsearch --no-pager | head
```

2. If down:

```bash
sudo systemctl enable --now elasticsearch
```

3. Confirm port:

```bash
sudo ss -lntp | grep 9200
```

---

## 5) `elastalert-test-rule` says 0 hits but you inserted data

### ✅ Symptoms

* output shows `Got 0 hits`

### ✅ Fix Checklist

1. Refresh index:

```bash
curl -s -X POST "http://localhost:9200/inbound-logs/_refresh"
```

2. Check data exists:

```bash
curl -s "http://localhost:9200/inbound-logs/_count" | jq .
curl -s "http://localhost:9200/inbound-logs/_search?size=5&pretty"
```

3. Confirm rule index pattern matches:

* rule uses: `index: inbound-logs*`
  Ensure your index name matches that pattern.

4. Check time window:

* ElastAlert uses `buffer_time` + "last X minutes"
  Make sure inserted docs timestamps fall inside test window.

---

## 6) YAML parse errors in rule file

### ✅ Symptoms

* `elastalert-test-rule` fails with YAML error
* Python YAML load fails

### ✅ Fix

Validate YAML:

```bash
python3 -c "import yaml; yaml.safe_load(open('/etc/elastalert/rules/http_404_spike.yaml')); print('YAML OK')"
```

Common YAML mistakes:

* wrong indentation
* missing colon
* tabs instead of spaces
* unquoted strings containing special characters

---

## 7) Exceptions not working (benign traffic still triggers)

### ✅ Symptoms

* ElastAlert still triggers on whitelisted IP/path

### ✅ Fix Checklist

1. Confirm field names match actual document structure:

* inbound docs store IP under `source.ip`
* ElastAlert uses `source.ip` in `must_not`

2. Verify documents structure:

```bash
curl -s "http://localhost:9200/inbound-logs/_search?size=1&pretty"
```

3. Ensure `must_not` is inside the `bool` block and not mis-indented:

```yaml
- bool:
    must:
      - query_string:
          query: "..."
    must_not:
      - term:
          source.ip: "192.168.0.10"
```

4. If you used a `term` query on a text field, it might not match.
   For IPs (`ip` type) term works well.

---

## 8) `query_string` matches too broadly (too many false positives)

### ✅ Symptoms

* the rule matches unexpected content

### ✅ Fix

* tighten query_string patterns
* prefer structured fields (e.g., `http.response.status_code:404`) if available
* add more conditions (method, path prefix, destination service)
* add a `query_key` to group events properly (already used in this lab)

---

## 9) ElastAlert test shows “would have sent alert” but you didn’t receive anything

### ✅ Symptoms

* test shows match, but no email/slack/etc.

### ✅ Explanation

`elastalert-test-rule` is a simulation tool. It typically prints “Would have sent alert” and may show “0 alerts sent” depending on alert type and test mode.

### ✅ Fix (if you want real alerts)

* configure an alert type (email, slack, webhook)
* run ElastAlert daemon continuously:

```bash
elastalert --config /etc/elastalert/elastalert.yaml
```

---

## ✅ Quick Validation Checklist (After Fixes)

```bash
# 1) Elasticsearch reachable
curl -s http://localhost:9200 | head

# 2) Data exists in inbound-logs
curl -s "http://localhost:9200/inbound-logs/_count" | jq .

# 3) YAML valid
python3 -c "import yaml; yaml.safe_load(open('/etc/elastalert/rules/http_404_spike.yaml')); print('YAML OK')"

# 4) Rule test
elastalert-test-rule --config /etc/elastalert/elastalert.yaml --rule /etc/elastalert/rules/http_404_spike.yaml

# 5) Noise reduction counts
curl -s "http://localhost:9200/inbound-logs/_search" -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "filter": [
        { "term": { "event_type": "http" } },
        { "query_string": { "query": "message:*404* OR message:*wp-login.php* OR message:*robots.txt* OR message:*favicon.ico*" } }
      ]
    }
  }
}' | jq '.hits.total'

curl -s "http://localhost:9200/inbound-logs/_search" -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "filter": [
        { "term": { "event_type": "http" } },
        { "query_string": { "query": "message:*404* OR message:*wp-login.php* OR message:*robots.txt* OR message:*favicon.ico*" } }
      ],
      "must_not": [
        { "term": { "source.ip": "192.168.0.10" } },
        { "query_string": { "query": "message:*GET /health*" } }
      ]
    }
  }
}' | jq '.hits.total'
```

Expected:

* YAML OK
* Test rule finds match for suspicious IP
* Count drops after exceptions (noise reduced)

---
