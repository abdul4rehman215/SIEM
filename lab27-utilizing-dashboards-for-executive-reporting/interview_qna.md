# 🧠 Interview Q&A — Lab 27: Utilizing Dashboards for Executive Reporting

---

## 1) Why are dashboards important for executive reporting?
Dashboards provide a **high-level summary** of security and operational trends in a way that executives can quickly understand. They reduce the need to read raw logs and help leadership make decisions based on **visual trends and key metrics**.

---

## 2) What is the main difference between a SOC dashboard and an executive dashboard?
A SOC dashboard is **technical and operational**, showing alerts, logs, and detection details.  
An executive dashboard focuses on **outcomes and trends**, using simplified language and emphasizing:
- incident volume trends
- common event categories
- priority/risk indicators

---

## 3) Why should technical jargon be minimized in executive dashboards?
Executives may not work directly with technical tools daily. Avoiding jargon ensures:
- faster understanding
- fewer misunderstandings
- better decision-making based on the charts shown

---

## 4) Why did you create a database dataset for this lab?
The lab requires data to visualize:
- daily incident counts
- top event types  
Creating a MariaDB dataset provides **real queryable data** for Grafana panels and makes the dashboard behave like a real reporting environment.

---

## 5) What kind of charts are best for daily incident reporting?
Common effective choices are:
- **Time series chart** (best for trends over time)
- **Bar chart** (best for day-by-day comparison)
Time series is often preferred for leadership because it clearly shows whether things are improving or getting worse.

---

## 6) Why did you use `date AS time` in the Grafana query?
Grafana time series panels typically expect a time-based column named **time**.  
Using:
```sql
SELECT date AS time, COUNT(*) ...
````

is a practical adjustment that keeps the query logic the same while meeting Grafana’s expected format.

---

## 7) Why is a pie chart useful for “Top Event Types”?

A pie chart is simple for executives because it quickly shows **distribution**:

* which event categories take the largest share
* how the event mix changes over time
  It works best when the number of categories is not too large.

---

## 8) Why did you create a read-only database user for Grafana?

A read-only user follows the principle of **least privilege**:

* Grafana can only query data
* it cannot modify tables or delete records
  This reduces the risk of accidental changes or misuse.

---

## 9) What does “Save & Test” confirm when adding a Grafana data source?

It confirms:

* connectivity to the host (DB reachable)
* credentials are valid
* the database exists and can be queried
  A successful test indicates the dashboard panels should be able to load real data.

---

## 10) Why are clear axis labels important for leadership reporting?

Labels remove ambiguity. For example:

* X-axis: “Date”
* Y-axis: “Number of Incidents”
  This ensures anyone viewing the chart can interpret it correctly without needing technical context.

---

## 11) What is the difference between sharing a dashboard link and sharing a snapshot in Grafana?

* **Link sharing:** Usually requires Grafana login access (internal users).
* **Snapshot:** Creates a static copy that can be viewed without login depending on configuration and link exposure.

Snapshots can be useful for quick reporting, but they must be handled carefully.

---

## 12) Why should snapshot links be used cautiously in real environments?

Depending on settings, anyone with the snapshot URL might access it. This may expose:

* incident trends
* operational patterns
* business security posture signals
  In real enterprises, snapshots should be controlled and time-limited.

---

## 13) What is one best practice for making dashboards “executive-friendly”?

Use:

* short titles
* minimal technical acronyms
* simple thresholds (normal / attention / high)
* only the most important KPIs on screen
  Executives want summaries, not raw data.

---

## 14) How does this lab connect to real SOC operations?

SOC teams generate large amounts of data. Executive dashboards help:

* communicate SOC performance to leadership
* show incident volumes and top drivers
* support budgeting and staffing decisions
* track progress over time

---

## 15) What was the final outcome of this lab?

A working dashboard on Grafana that included:

* a **Daily Incidents** time series chart
* a **Top Event Types** pie chart
  with readable labels, validated queries, and tested sharing options.

---

