# 📈 Lab 30: Analyzing Trends Over Time

## 🧾 Lab Summary
This lab focused on working with **time-series data** to identify trends and anomalies in login activity. Using Python with `pandas`, `matplotlib`, and `seaborn`, I loaded a CSV dataset of login attempts, built trend visualizations, calculated weekly averages, flagged anomalies using a statistical threshold, and exported the analysis as a **PDF snapshot**.

---

## 🎯 Objectives
- Work with time-series data using open-source tools
- Build and interpret time-series charts
- Identify trends, patterns, and anomalies in data
- Export and present data analysis results

---

## ✅ Prerequisites
- Basic data analysis and visualization knowledge
- Familiarity with Python
- Python installed
- Jupyter Notebook or Python IDE (VS Code / PyCharm) OR CLI Python execution
- Required Python packages:
  - `pandas`
  - `matplotlib`
  - `seaborn`

---

## 🧠 Key Concepts
- **Time-series data:** Data points indexed by time (e.g., daily login attempts)
- **Resampling:** Converting daily data into weekly averages using `resample('W')`
- **Trend analysis:** Observing long-term changes or patterns
- **Anomaly detection:** Flagging values outside normal range (mean + 2×std threshold)
- **Export snapshot:** Saving analysis charts for sharing and reporting

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Hostname | ip-REDACTED |
| User | toor |
| Python | 3.12.3 |
| Execution Style | CLI (headless server) |
| Packages | pandas, matplotlib, seaborn |
| Workspace | `Lab_TimeSeries_Trends/` |
| Output Artifact | `weekly_attempts_snapshot.pdf` |

---

## 🗂️ Repository Structure
```text
lab30-analyzing-trends-over-time/
├── README.md
├── commands.sh
├── output.txt
├── scripts/
│   └── analyze_trends.py
├── data/
│   └── login_attempts.csv
├── artifacts/
│   └── weekly_attempts_snapshot.pdf
├── interview_qna.md
└── troubleshooting.md
````

> 📌 Note: In a real GitHub repo, large binary artifacts (like PDF exports) can be included in `artifacts/`.
> If size becomes an issue, they can be stored via Git LFS. For this lab, the PDF is small and kept in-repo.

---

## ✅ Tasks Overview (No Commands Here)

### ✅ Task 1: Import Libraries & Load Dataset

* Created the dataset file `login_attempts.csv` with:

  * `date`
  * `attempts`
* Loaded the dataset using pandas with `parse_dates=['date']`
* Previewed the data using `print(data.head())`

### ✅ Task 2: Build a Time-Series Chart

* Set `date` as the index for time-series analysis
* Generated a line plot of login attempts over time using matplotlib

### ✅ Task 3: Compare to Previous Weeks (Weekly Averages)

* Resampled daily data into weekly averages with:

  * `data.resample('W').mean()`
* Plotted weekly averages using seaborn line plot

### ✅ Task 4: Identify Patterns & Anomalies

* Calculated an anomaly threshold:

  * `mean + 2 * std`
* Flagged weeks exceeding the threshold as anomalies
* Plotted weekly averages and highlighted anomaly points

### ✅ Task 5: Export a Snapshot

* Exported weekly chart snapshot as:

  * `weekly_attempts_snapshot.pdf`

---

## 📌 Key Results & Interpretation

* Weekly averages showed steady growth from early June into early July.
* A strong spike appeared around **week ending 2025-07-13**, indicating unusually high login attempts.
* The anomaly detection threshold correctly flagged this week as anomalous.

---

## 🌍 Why This Matters

Trend analysis helps security and operations teams:

* detect brute-force campaigns and credential stuffing spikes
* identify changes in user behavior over time
* monitor authentication systems for abnormal load
* generate reporting artifacts for audits and leadership updates

---

## 🧩 Real-World Applications

* Monitoring login activity for spikes (possible brute-force attacks)
* Creating SOC weekly trend reports
* Alerting based on statistical thresholds
* Capacity planning for auth services during traffic surges
* Supporting incident response investigations with time-based evidence

---

## 🧠 What I Learned

* How to work with date-indexed datasets using pandas
* How to resample daily logs into weekly averages
* How to build time-series plots using matplotlib/seaborn
* How to apply a simple anomaly detection method
* How to export analysis outputs for sharing

---

## ✅ Conclusion

This lab demonstrated a complete time-series workflow: dataset creation, trend visualization, weekly aggregation, anomaly detection, and report export. These skills are useful for identifying suspicious patterns in authentication data and for generating evidence-based reports.

✅ **Lab completed successfully on Ubuntu 24.04.1 LTS**

---

