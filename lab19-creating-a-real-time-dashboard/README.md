# 🧪 Lab 19: Creating a Real-Time Dashboard

## 🧾 Lab Summary
This lab demonstrates the fundamentals of **real-time monitoring** by building a working dashboard using:
- **Prometheus** (metrics collection / time-series database)
- **Grafana** (visualization + dashboarding)
- **Docker** (fast deployment of both services)

Because this is a cloud lab environment, the lab includes realistic “real-world fixes” to ensure the tooling works end-to-end:
- Installing **Docker CE** by adding Docker’s official APT repository (Ubuntu 24.04 default repos do not provide `docker-ce`)
- Creating a Docker network so Grafana can resolve `http://prometheus:9090` by container name
- Using a Prometheus **built-in metric** (`prometheus_http_requests_total`) instead of `http_requests_total` (not present unless an exporter/app provides it)
- Generating live Prometheus endpoint hits to make the graph visibly update in real time

✅ Prometheus running → ✅ Grafana running → ✅ data source connected → ✅ dashboard panel query → ✅ refresh interval → ✅ real-time changes observed.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand real-time data monitoring concepts
- Deploy Prometheus and Grafana using Docker containers
- Connect Grafana to Prometheus as a data source
- Build a dashboard panel with a query that updates in real time
- Configure the dashboard refresh interval (5 seconds)
- Generate live activity to observe real-time updates

---

## 📌 Prerequisites
- Basic Linux CLI skills
- Basic understanding of web dashboards and time-series data
- Internet access for downloading Docker images
- Optional: basic familiarity with PromQL (Prometheus query language)

---

## 🧰 Tools Used
| Tool | Purpose |
|---|---|
| Docker | Run Prometheus and Grafana as containers |
| Prometheus | Metrics store + API |
| Grafana | Dashboard visualization |
| curl | Generate traffic and verify endpoints |

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Environment | Cloud Lab Environment |
| User | `toor` |
| Prometheus Port | `9090` |
| Grafana Port | `3000` |
| Docker Network | `monitoring` (user-defined) |

---

## 🗂️ Repository Structure
```text
lab19-creating-a-real-time-dashboard/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── configs/
│   ├── docker-apt-repo-setup.txt
│   ├── docker-network-steps.txt
│   └── grafana-prometheus-datasource-notes.md
└── artifacts/
    ├── docker-version.txt
    ├── docker-ps-after-prometheus.txt
    ├── docker-ps-after-grafana.txt
    ├── prometheus-ready.txt
    ├── grafana-http-headers.txt
    ├── prometheus-metric-query.json
    └── dashboard-query-notes.md
````

> Notes:
>
> * `configs/` captures setup notes and the decisions needed to make the lab work in a real cloud VM.
> * `artifacts/` contains evidence outputs proving the services and metrics are working.

---

## 🧩 Tasks Overview (What I Performed)

### ✅ Task 1: Set Up Prometheus

#### 1.1 Install Docker (Ubuntu 24.04 real-world method)

* Updated package lists
* Attempted Docker CE install using default repos → not found
* Added Docker’s official APT repo (keyrings + repo list)
* Installed:

  * `docker-ce`
  * `docker-ce-cli`
  * `containerd.io`
  * `docker-compose-plugin`
* Verified installation via `docker --version`

#### 1.2 Run Prometheus Container

* Pulled Prometheus image: `prom/prometheus`
* Started container:

  * published port `9090:9090`
* Verified container is running using `docker ps`
* Verified readiness using:

  * `curl http://localhost:9090/-/ready`

---

### ✅ Task 2: Set Up Grafana

#### 2.1 Run Grafana Container

* Pulled image: `grafana/grafana`
* Started container:

  * published port `3000:3000`
* Verified container is running using `docker ps`
* Verified Grafana responds via HTTP (302 redirect to `/login`)

#### 2.2 Configure Grafana Data Source (Prometheus)

Lab reference says to use:

* `http://prometheus:9090`

⚠️ Real-world Docker networking note:

* Container hostname resolution works reliably only when both containers share a **user-defined Docker network**.

✅ Solution implemented:

* Created network: `monitoring`
* Connected both containers to it:

  * `docker network connect monitoring prometheus`
  * `docker network connect monitoring grafana`

✅ Grafana UI steps performed:

* Opened: `http://localhost:3000`
* Logged in: `admin / admin` (changed password when prompted)
* Added data source:

  * Type: Prometheus
  * URL: `http://prometheus:9090`
* Clicked **Save & Test** → successful

---

### ✅ Task 3: Create a Real-Time Dashboard in Grafana

#### 3.1 Create New Dashboard + Panel

* Created a new dashboard
* Added a new panel and query

#### 3.2 Query Choice (Metric Availability Fix)

Lab suggests:

* `rate(http_requests_total[1m])`

⚠️ Realistic note:

* `http_requests_total` usually requires an application/exporter producing that metric.

✅ Working query used (Prometheus internal metric that always exists):

* `rate(prometheus_http_requests_total[1m])`

This displays changes driven by Prometheus web/API traffic.

#### 3.3 Set Refresh Interval

* Dashboard refresh interval set to **5 seconds**
* Grafana re-runs the query and updates the panel automatically

#### 3.4 Generate Activity to Observe Live Updates

To make the rate line visibly move in real time, I generated repeated requests:

* hit Prometheus health endpoint in a loop:

  * `curl http://localhost:9090/-/healthy`
* Verified the metric exists and returns values using Prometheus API query endpoint

---

## 🔍 Verification & Validation

This lab is successful when:

* ✅ Docker is installed and functioning: `docker --version`
* ✅ Prometheus container is running and ready:

  * `curl http://localhost:9090/-/ready` returns **Prometheus is Ready.**
* ✅ Grafana container is running and serving on port 3000
* ✅ Grafana can reach Prometheus via data source URL `http://prometheus:9090`
* ✅ Dashboard panel displays data using:

  * `rate(prometheus_http_requests_total[1m])`
* ✅ Graph updates at refresh interval (5s)
* ✅ Prometheus metric increases when generating traffic (curl loop)

---

## 🧠 What I Learned

* Real-time dashboards require:

  * a working data source (Prometheus)
  * visualization layer (Grafana)
  * correct metric/query selection
  * refresh interval tuning
* Container networking matters: service discovery by name needs a shared Docker network.
* Prometheus always provides internal metrics that are useful for validating dashboards even without external exporters.
* A good verification method is to generate controlled activity and observe real-time changes.

---

## 🌍 Why This Matters (Real-World Relevance)

Real-time dashboards are a key part of:

* SOC monitoring (security metrics + alert volumes)
* infrastructure observability (CPU/memory/network/service health)
* incident response (spikes, anomalies, baseline drift)
* operational decision-making (fast visibility into impact)

---

## ✅ Result

* ✅ Docker installed via official repo
* ✅ Prometheus running on **9090**
* ✅ Grafana running on **3000**
* ✅ Containers connected on a shared Docker network (`monitoring`)
* ✅ Grafana successfully connected to Prometheus data source
* ✅ Real-time panel created with **5s refresh**
* ✅ Live traffic generated and metric verified via Prometheus API
* ✅ Ready for GitHub upload

---

## 🏁 Conclusion

This lab successfully delivered a working real-time monitoring stack using open-source tools. By deploying Prometheus and Grafana in Docker, configuring a data source, selecting an always-available Prometheus metric, and enabling a refresh interval, I created a dashboard that updates continuously and reflects real-time system activity.

---
