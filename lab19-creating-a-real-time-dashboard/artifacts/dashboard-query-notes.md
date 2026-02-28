# Dashboard Query Notes (Grafana Panel)

Lab-suggested query:
```promql
rate(http_requests_total[1m])
````

Observation:

* The default Prometheus container does not provide `http_requests_total` unless it scrapes
  an application/exporter that exposes this metric.
* Result in Grafana: No data / empty graph (expected).

Working real-time query used (Prometheus internal metric):

```promql
rate(prometheus_http_requests_total[1m])
```

Why it works:

* Prometheus always exposes its own internal metrics.
* Hitting Prometheus endpoints (UI/API/health) increases request counters.
* With a refresh interval of 5s, the dashboard updates continuously in real time.

---
