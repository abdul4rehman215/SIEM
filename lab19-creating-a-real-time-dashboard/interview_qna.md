# 🎤 Interview Q&A — Lab 19: Creating a Real-Time Dashboard

## 1) What does “real-time monitoring” mean in practice?
Real-time monitoring means collecting and visualizing data continuously with minimal delay, so changes in system behavior (traffic spikes, failures, resource changes) appear quickly and can be acted on fast.

---

## 2) What roles do Prometheus and Grafana play in an observability stack?
- **Prometheus**: scrapes/collects metrics and stores time-series data, exposes a query API (PromQL).
- **Grafana**: visualizes data from Prometheus and other sources, builds dashboards, supports alerts.

---

## 3) Why did you use Docker for this lab?
Docker provides fast deployment with consistent environments. Running Prometheus and Grafana as containers avoids manual dependency setup and makes the lab repeatable.

---

## 4) Why did `apt-get install docker-ce ...` fail initially on Ubuntu 24.04?
Docker CE packages are not available in the default Ubuntu repositories. The fix is to add Docker’s official APT repository and install from there.

---

## 5) How did you verify Prometheus was actually running?
Two checks:
- `docker ps` to confirm the container is running and ports are exposed.
- `curl http://localhost:9090/-/ready` to confirm readiness (`Prometheus is Ready.`).

---

## 6) How did you verify Grafana was running?
- `docker ps` shows the Grafana container running with port 3000 published.
- `curl -I http://localhost:3000` returned a **302 redirect** to `/login`, confirming the web server is responding.

---

## 7) Why did you create a user-defined Docker network?
The lab suggests Grafana should connect to Prometheus using:
- `http://prometheus:9090`

That hostname resolves reliably only when containers share a user-defined network. By creating the `monitoring` network and connecting both containers, Grafana can resolve the Prometheus container by name.

---

## 8) What is a “data source” in Grafana?
A data source is the backend system Grafana queries for data (Prometheus, Elasticsearch, Loki, etc.). Grafana dashboards depend on data sources to retrieve metrics/logs.

---

## 9) The lab suggested `rate(http_requests_total[1m])` — why did it show “No data”?
`http_requests_total` is typically produced by an application exporter (e.g., a web app exposing metrics). A default Prometheus container doesn’t automatically have that metric unless it scrapes a target that provides it.

---

## 10) What query did you use instead, and why did it work?
I used:
```promql
rate(prometheus_http_requests_total[1m])
````

This works because Prometheus always exposes its own internal metrics (including HTTP request counters), so the dashboard can show data without external exporters.

---

## 11) How did you generate activity to make the real-time graph visibly change?

I repeatedly called Prometheus’s health endpoint:

```bash
for i in {1..20}; do curl -s http://localhost:9090/-/healthy >/dev/null; sleep 0.2; done
```

This increases Prometheus’s HTTP request counters, so the rate metric changes and the Grafana panel updates.

---

## 12) What does the Grafana “refresh interval” do?

It controls how often Grafana re-runs dashboard queries and updates panels. In this lab, setting it to **5 seconds** made the visualization update continuously.

---

## 13) How would this apply to SIEM/SOC monitoring?

SOC dashboards often track:

* alert volumes per rule
* authentication failures
* ingestion rate
* detection latency
* endpoint health
  Real-time dashboards help spot spikes and anomalies quickly and support incident response.

---

## 14) What are typical production considerations for Prometheus and Grafana?

* persistent storage/volumes for data retention
* authentication and TLS for web endpoints
* resource limits for containers
* exporter deployment and scrape configurations
* dashboard versioning and access control
* alerting rules and on-call integrations

---

## 15) If you wanted “true real-time” beyond metrics, what would you add?

For logs/events:

* Grafana Loki (logs)
* Elasticsearch/OpenSearch (logs/search)
* Streaming pipelines (Kafka)
  For tracing:
* Jaeger/Tempo
  This creates a full observability stack: metrics + logs + traces.

---
