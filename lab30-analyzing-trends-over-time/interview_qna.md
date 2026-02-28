# 🧠 Interview Q&A — Lab 30: Analyzing Trends Over Time

---

## 1) What is time-series data?
Time-series data is a dataset where each record is tied to a time value (date/time). The time order matters because it helps you analyze trends, patterns, and changes over time.

---

## 2) Why is trend analysis useful in security monitoring?
Trend analysis helps detect:
- spikes in login attempts (possible brute force/credential stuffing)
- unusual patterns across weeks/months
- gradual increases that may indicate emerging threats or misconfigurations
It supports early detection and better reporting.

---

## 3) Why did you set the `date` column as the index in pandas?
Setting `date` as the index makes time-series operations easier, especially:
- resampling (`resample('W')`)
- plotting with the time axis
- slicing by date ranges

---

## 4) What does `resample('W')` do?
It groups daily records into weekly buckets and allows aggregations like:
- mean (weekly average)
- sum (weekly total)
- max/min (weekly peak/low)

---

## 5) Why did you calculate weekly averages instead of using only daily values?
Weekly averages smooth daily noise and make long-term patterns easier to interpret for reporting. It helps highlight trend changes without being distracted by day-to-day fluctuations.

---

## 6) How did you define the anomaly threshold in this lab?
The threshold was:
- `mean + 2 * standard_deviation`
Anything above this threshold was considered an anomaly.

---

## 7) Why is `mean + 2*std` a reasonable anomaly detection method?
It’s a simple statistical approach that flags values significantly above normal variation. It’s not perfect, but it works well as a first baseline for detecting spikes.

---

## 8) What anomaly was detected in the dataset?
The week ending **2025-07-13** had a weekly average around **160**, which was far higher than surrounding weeks and exceeded the anomaly threshold.

---

## 9) Why might a spike in login attempts be important to investigate?
A spike could indicate:
- brute-force attacks
- credential stuffing
- bot-driven scanning
- unusual user behavior (e.g., major event)
It requires contextual investigation to confirm if it’s malicious.

---

## 10) Why did matplotlib print “non-GUI backend” messages?
The lab ran on a headless server environment. `plt.show()` requires a GUI display, but the system used a non-GUI backend (`agg`), so plots could not pop up interactively.

---

## 11) How did you still capture results if plots couldn’t display?
By exporting plots to files using:
```python
plt.savefig('weekly_attempts_snapshot.pdf')
````

This creates a shareable artifact even in headless environments.

---

## 12) What is the benefit of exporting analysis snapshots (PDF/PNG)?

Exporting allows:

* sharing results with stakeholders
* attaching evidence to reports
* documenting trend findings for audits or incident tickets

---

## 13) What role does seaborn play compared to matplotlib?

Matplotlib provides core plotting. Seaborn builds on it to create cleaner statistical visualizations with simpler syntax, especially for trend lines and comparisons.

---

## 14) What is one improvement you could make for production anomaly detection?

Possible improvements:

* rolling averages
* seasonal decomposition
* robust z-scores or MAD (median absolute deviation)
* alerting thresholds tuned to baseline behavior
* integrating with SIEM alerting pipelines

---

## 15) What is the main takeaway from this lab?

Time-series analysis helps transform raw event counts into actionable insights, enabling trend detection, anomaly identification, and reporting-ready outputs for security decision-making.

---
