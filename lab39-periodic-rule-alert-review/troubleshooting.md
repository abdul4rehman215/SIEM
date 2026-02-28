# 🛠️ Troubleshooting Guide — Lab 39: Periodic Rule & Alert Review (Prometheus)

> This guide covers issues when listing rules, adding rule files, reloading Prometheus, and validating rule behavior.

---

## 1) `jq: command not found`

### ❗ Problem
Running `jq --version` fails.

### ✅ Resolution
```bash
sudo apt-get update
sudo apt-get install -y jq
````

### ✅ Prevention

Install baseline tooling (jq, curl) for API-driven monitoring workflows.

---

## 2) Prometheus rules API returns empty rules

### ❗ Problem

`/api/v1/rules` shows no custom rules.

### ✅ Cause

Fresh Prometheus installs often ship without user-defined alert rules.

### ✅ Resolution

Create a rules file and ensure Prometheus loads it via `rule_files`.

Example rules file location used:

* `/etc/prometheus/rules.d/*.yml`

Then reload Prometheus:

```bash id="4qg6q2"
sudo systemctl reload prometheus
```

### ✅ Prevention

Keep rules in a dedicated directory and version-control them.

---

## 3) Prometheus does not load the new rules file

### ❗ Problem

Rule file exists but does not appear in `/api/v1/rules`.

### ✅ Possible Causes

* `rule_files` not set in `/etc/prometheus/prometheus.yml`
* bad YAML indentation
* invalid PromQL expression
* Prometheus reload failed

### ✅ Resolution

Confirm `rule_files` exists:

```bash id="ruv3lb"
sudo grep -n "rule_files" -A3 /etc/prometheus/prometheus.yml
```

Validate YAML formatting (common mistakes are indentation and hyphen placement).

Check Prometheus service logs:

```bash id="2i8m55"
sudo journalctl -u prometheus --no-pager | tail -n 120
```

Reload again:

```bash id="krvbj4"
sudo systemctl reload prometheus
```

### ✅ Prevention

Use small incremental edits and re-check `/api/v1/rules` after each change.

---

## 4) `systemctl reload prometheus` fails

### ❗ Problem

Reload does not work (or Prometheus becomes unhealthy).

### ✅ Possible Causes

* invalid config or invalid rules file
* permission issues

### ✅ Resolution

Check status/logs:

```bash id="t5fkly"
systemctl status prometheus --no-pager
sudo journalctl -u prometheus --no-pager | tail -n 120
```

If reload fails, restart (lab-safe):

```bash id="v3o5rr"
sudo systemctl restart prometheus
```

### ✅ Prevention

Validate configs before reload when possible.

---

## 5) Rule health shows `error`

### ❗ Problem

The rule appears but `health` is not `ok`.

### ✅ Causes

* bad PromQL expression
* missing metric (e.g., node exporter not scraped)
* wrong label filters in the query

### ✅ Resolution

Run the expression without threshold to confirm it returns data:

```bash
curl -sG "http://localhost:9090/api/v1/query" \
  --data-urlencode 'query=100 - (avg by(instance)(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)' | jq
```

If it returns empty, verify Node Exporter is running and scraped.

---

## 6) Rule never triggers (possible false negatives)

### ❗ Problem

A rule is valid but never triggers.

### ✅ Likely Causes

* threshold too high or duration too long
* environment doesn’t reach those conditions
* alert is not aligned with operational impact

### ✅ Resolution

Review actual metric values and adjust threshold/duration:

* lower threshold (e.g., 95% → 85%)
* keep `for:` duration to reduce noise (e.g., 10m)

### ✅ Prevention

Use historical baselines and realistic thresholds tied to user impact.

---

## 7) Rule triggers too often (false positives / alert fatigue)

### ❗ Problem

Rule fires frequently with minimal impact.

### ✅ Likely Causes

* threshold too low
* duration too short
* short spikes triggering alerts

### ✅ Resolution

* increase duration (`for: 10m`)
* raise threshold
* add alert inhibition/silencing strategies
* create multi-tier alerts (warning vs critical)

### ✅ Prevention

Test rules using realistic workloads and monitor alert volume.

---

## 8) No documentation trail for rule changes

### ❗ Problem

Team doesn’t know why thresholds changed.

### ✅ Resolution

Maintain a rule review log (as in lab):

* Rule ID
* Description
* Last Triggered
* Decision (Retire/Revise/Retain)
* Comments + what changed

### ✅ Prevention

Store rule files + review logs in Git for version history and accountability.

---
