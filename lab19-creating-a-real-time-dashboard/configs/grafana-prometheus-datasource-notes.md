# Grafana → Prometheus Data Source Setup (UI Notes)

Grafana URL:
- http://localhost:3000

Default credentials (first login):
- username: admin
- password: admin
(Changed password when prompted)

Steps performed:
1. Open Grafana in browser
2. Go to: ⚙️ Configuration → Data sources
3. Click: Add data source
4. Select: Prometheus
5. Set URL:
   - http://prometheus:9090
6. Click: Save & Test
7. Result:
   - Data source is working ✅

Note:
- The URL `http://prometheus:9090` works because both containers were attached
  to the same Docker network (`monitoring`).
