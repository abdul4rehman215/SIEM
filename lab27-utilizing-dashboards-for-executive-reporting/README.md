# 📊 Lab 27: Utilizing Dashboards for Executive Reporting

## 🧾 Lab Summary
This lab focused on building an **executive-friendly security reporting dashboard** using **Grafana** on **Ubuntu 24.04.1 LTS**, backed by a small **MariaDB** dataset. The goal was to translate technical security signals into **clear, non-technical visual reporting** (daily incidents + top event types) that can be shared with leadership.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Create dashboards for **executive reporting**
- Generate easy-to-read charts for:
  - **Daily incidents**
  - **Top event types**
- Apply **clear labels** and reduce technical jargon
- Export/share dashboards using Grafana sharing features (link/snapshot)

---

## ✅ Prerequisites
- Basic data visualization concepts
- Familiarity with dashboard tools (Grafana/Kibana)
- A dataset containing:
  - daily incidents
  - event types
- Grafana or Kibana installed and configured

---

## 🧠 Key Concepts
- **Dashboards**: Visual reporting surface used to summarize data for decision-makers
- **Charts**: Time series, bar charts, pie charts, etc.
- **Labels**: Human-readable chart naming (avoid heavy SOC jargon for executives)
- **Export/Share**: Dashboard sharing via links, snapshots, images, or PDFs

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Hostname | ip-REDACTED |
| User | toor |
| Dashboard Tool | Grafana |
| Database | MariaDB (MySQL-compatible) |
| Grafana URL | http://localhost:3000 |
| Dataset | Local MariaDB database (`exec_reporting`) |

> 🔐 **Security note (relevant here):** For the Grafana DB user, a strong password was used during the lab. Any credentials shown in logs are **redacted** in this repository and replaced with placeholders.

---

## 🗂️ Repository Structure
```text
lab27-utilizing-dashboards-for-executive-reporting/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
└── troubleshooting.md
````

---

## ✅ Tasks Overview (High-Level)

### ✅ Task 1: Setting Up the Dashboard Environment

* Verified OS version (Ubuntu 24.04.1 LTS)
* Installed Grafana using official repository + GPG key
* Enabled and started Grafana service
* Confirmed Grafana is listening on port **3000**
* Verified access via `curl` and browser login on `localhost`

### ✅ Task 2: Creating Charts for Daily Incidents

* Installed and started MariaDB server
* Created a small dataset for reporting:

  * `incidents` table (daily incident rows)
  * `events` table (event types + timestamps)
* Created a **read-only MariaDB user** for Grafana dashboard queries (safer reporting access)
* Connected Grafana to MariaDB using the MySQL datasource in the UI
* Built a **Time Series panel**:

  * Title: **Daily Incidents**
  * Clear axis labels and executive-friendly thresholds

### ✅ Task 3: Visualizing Top Event Types

* Added a **Pie Chart panel**:

  * Title: **Top Event Types**
  * Segment labels: **Name + Value**
  * Legend shows event type and count
* Dashboard layout optimized for readability:

  * Daily Incidents chart on top (wide)
  * Top Event Types below (compact/centered)

### ✅ Task 4: Exporting or Sharing the Dashboard

* Used Grafana dashboard **Share** features:

  * Link sharing (internal lab access)
  * Snapshot sharing (time-limited)
* Verified access behavior:

  * Login required unless snapshot is enabled
* Documented snapshot behavior and risks for real enterprise usage

---

## ✅ Verification & Validation

* Verified Grafana service status (active/running)
* Confirmed port **3000** listening
* Confirmed HTTP redirect to `/login` via curl check
* Verified MariaDB is running and accessible
* Validated dataset queries return expected results:

  * daily incident counts grouped by date
  * event type counts grouped by type
* Grafana datasource test result:

  * ✅ **Database Connection OK**
* Dashboard panels populated and rendering correctly

---

## 📌 Result

✔ Grafana installed and running
✔ MariaDB dataset created successfully
✔ Data source connected in Grafana
✔ Executive dashboard created:

* **Daily Incidents** (Time Series)
* **Top Event Types** (Pie Chart)
  ✔ Dashboard sharing/export options tested (link + snapshot)

---

## 🌍 Why This Matters

Executive stakeholders typically need:

* **trends**, not raw logs
* **clear visuals**, not alerts in SOC language
* **risk signals**, not deep technical detail

Dashboards bridge the gap between technical teams and leadership by turning incident data into **decision-ready reporting**.

---

## 🧩 Real-World Applications

* Executive incident reporting (daily/weekly summaries)
* KPI dashboards for SOC leadership
* Board-level security briefings (non-technical view)
* Security program metrics (incident volume + event type trends)
* Security maturity progress tracking over time

---

## 🧠 What I Learned

* How to build a reporting-ready dashboard pipeline:

  * data → queries → panels → executive presentation
* How to keep labels and chart design **executive-friendly**
* How to structure datasets for reporting (incidents + event types)
* How to use Grafana sharing safely and responsibly

---

## ✅ Conclusion

This lab demonstrated how to create an executive-focused security dashboard using **Grafana + MariaDB**, including data source setup, meaningful chart design, and safe sharing/export practices. The final dashboard presented daily incident trends and top event categories in a way that supports leadership visibility and decision-making.

✅ **Lab completed successfully (Grafana + MariaDB on Ubuntu 24.04.1 LTS)**

---
