# 🛠️ Troubleshooting Guide — Lab 19: Creating a Real-Time Dashboard

> This guide covers common issues when installing Docker on Ubuntu 24.04, running Prometheus/Grafana containers, connecting Grafana to Prometheus, and fixing “No data” dashboard queries.

---

## 1) Docker install fails: `Package 'docker-ce' has no installation candidate`

### ✅ Symptoms
- `sudo apt-get install docker-ce docker-ce-cli containerd.io` fails with:
  - `docker-ce has no installation candidate`
  - `Unable to locate package ...`

### ✅ Cause
Docker CE is not available from default Ubuntu repositories.

### ✅ Fix
Add Docker’s official APT repository and install Docker CE:
```bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
docker --version
````

---

## 2) Docker daemon not running / permission denied

### ✅ Symptoms

* `docker ps` returns:

  * `Cannot connect to the Docker daemon`
* or permission issues like:

  * `permission denied while trying to connect to the Docker daemon socket`

### ✅ Fix

Check service:

```bash id="66hhi6"
sudo systemctl status docker --no-pager
sudo systemctl enable --now docker
```

Run Docker commands with sudo (lab-safe):

```bash id="ezp260"
sudo docker ps
```

(Production approach: add user to docker group and re-login)

---

## 3) Prometheus container not running / port 9090 not reachable

### ✅ Symptoms

* `docker ps` does not show Prometheus container
* `curl http://localhost:9090/-/ready` fails

### ✅ Fix Checklist

1. Confirm container exists:

```bash id="6nvb63"
docker ps -a | grep prometheus || true
```

2. Check logs:

```bash id="j8p3bm"
docker logs prometheus --tail 100
```

3. Re-run container:

```bash id="k3g0ik"
docker run -d --name=prometheus -p 9090:9090 prom/prometheus
```

4. Confirm port:

```bash id="k9d9oj"
sudo ss -lntp | grep 9090
curl -s http://localhost:9090/-/ready
```

---

## 4) Grafana container not running / port 3000 not reachable

### ✅ Symptoms

* `curl -I http://localhost:3000` fails
* `docker ps` does not show Grafana container

### ✅ Fix

1. Check container:

```bash id="z4m18v"
docker ps -a | grep grafana || true
docker logs grafana --tail 100
```

2. Start container again:

```bash id="6wu2dw"
docker run -d --name=grafana -p 3000:3000 grafana/grafana
```

3. Confirm port:

```bash id="z5zrv3"
sudo ss -lntp | grep 3000
curl -I http://localhost:3000 | head -n 5
```

---

## 5) Grafana cannot connect to Prometheus (`Save & Test` fails)

### ✅ Symptoms

* Grafana data source test fails
* Using URL `http://prometheus:9090` does not resolve

### ✅ Cause

Container name resolution requires both containers to share a user-defined Docker network.

### ✅ Fix

Create a network and connect both containers:

```bash id="vdbp5y"
docker network create monitoring
docker network connect monitoring prometheus
docker network connect monitoring grafana
docker network inspect monitoring | grep -E '"Name"|"prometheus"|"grafana"' -n
```

Then in Grafana, set data source URL:

* `http://prometheus:9090`

Alternative quick fallback (host-based):

* Use `http://localhost:9090` (depending on Grafana networking mode)

---

## 6) Dashboard query shows “No data”

### ✅ Symptoms

* Grafana panel is empty
* Query like:

```promql
rate(http_requests_total[1m])
```

returns no results

### ✅ Cause

`http_requests_total` usually comes from application exporters. Default Prometheus alone may not have it.

### ✅ Fix

Use Prometheus internal metrics that always exist, e.g.:

```promql
rate(prometheus_http_requests_total[1m])
```

---

## 7) Query works but graph looks flat / not changing

### ✅ Symptoms

* Panel shows data but no visible changes

### ✅ Fix

Generate traffic to increase metrics:

```bash
for i in {1..20}; do curl -s http://localhost:9090/-/healthy >/dev/null; sleep 0.2; done
```

Verify metric exists:

```bash id="t5mzu9"
curl -s "http://localhost:9090/api/v1/query?query=prometheus_http_requests_total" | head -n 20
```

---

## 8) Refresh interval doesn’t update quickly

### ✅ Symptoms

* Dashboard updates slowly

### ✅ Fix

In Grafana time controls (top-right):

* Set refresh interval to **5s** (or similar)
* Confirm dashboard is not paused

---

## ✅ Quick Validation Checklist (After Fixes)

Run:

```bash id="d9rdlq"
docker --version
docker ps
curl -s http://localhost:9090/-/ready
curl -I http://localhost:3000 | head -n 5
curl -s "http://localhost:9090/api/v1/query?query=prometheus_http_requests_total" | head -n 20
```

If containers are running, endpoints respond, and the metric query returns results, the real-time dashboard stack is functioning.

---
