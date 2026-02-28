# 🛠️ Troubleshooting Guide — Lab 30: Analyzing Trends Over Time

> This guide covers common issues with Python environments, package installation, plotting in headless servers, and exporting charts.

---

## 1) `python3: command not found`

### ❗ Problem
Running:
```bash
python3 --version
````

returns:

* `command not found`

### ✅ Possible Causes

* Python not installed
* PATH not configured
* Minimal OS image without Python

### ✅ Resolution

Install Python:

```bash id="l30tsp1"
sudo apt update
sudo apt install -y python3 python3-venv python3-pip
python3 --version
```

### ✅ Prevention

Confirm Python availability before starting lab tasks.

---

## 2) Virtual environment fails (`No module named venv`)

### ❗ Problem

Running:

```bash
python3 -m venv venv
```

fails with:

* `No module named venv`

### ✅ Possible Causes

* `python3-venv` not installed on Ubuntu

### ✅ Resolution

```bash id="l30tsp2"
sudo apt update
sudo apt install -y python3-venv
python3 -m venv venv
```

### ✅ Prevention

Install `python3-venv` in lab environments where venv is required.

---

## 3) `pip: command not found` inside venv

### ❗ Problem

After activating venv, `pip` is missing.

### ✅ Possible Causes

* `python3-pip` not installed system-wide
* venv created without pip

### ✅ Resolution

Install pip and recreate venv if needed:

```bash id="l30tsp3"
sudo apt update
sudo apt install -y python3-pip
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip --version
```

### ✅ Prevention

Confirm pip works before installing packages.

---

## 4) `pip install` fails (network or permissions)

### ❗ Problem

`pip install pandas matplotlib seaborn` fails with errors like:

* network timeouts
* DNS issues
* permission denied

### ✅ Possible Causes

* Restricted network in lab environment
* Proxy requirements
* pip trying to install globally (venv not active)

### ✅ Resolution

1. Ensure venv is active:

```bash id="l30tsp4"
source venv/bin/activate
which python
which pip
```

2. Retry install (sometimes transient):

```bash id="l30tsp5"
pip install --upgrade pip
pip install pandas matplotlib seaborn
```

3. If proxy required, configure proxy variables (environment-specific).

### ✅ Prevention

Use venv and install dependencies at the beginning of the lab.

---

## 5) `ModuleNotFoundError: No module named pandas/matplotlib/seaborn`

### ❗ Problem

Script fails due to missing modules.

### ✅ Possible Causes

* Packages installed outside venv
* venv not activated when running script
* wrong Python interpreter used

### ✅ Resolution

Activate venv and reinstall:

```bash id="l30tsp6"
source venv/bin/activate
pip install pandas matplotlib seaborn
python3 analyze_trends.py
```

### ✅ Prevention

Run scripts using the same interpreter where packages were installed.

---

## 6) Matplotlib message: “non-GUI backend, cannot show the figure”

### ❗ Problem

Output shows:

* `Matplotlib is currently using agg, which is a non-GUI backend, so cannot show the figure.`

### ✅ Cause

The lab ran in a headless CLI environment without a GUI display. `plt.show()` cannot open windows.

### ✅ Resolution

Export plots using `savefig`:

```python id="l30tsp7"
plt.savefig('weekly_attempts_snapshot.pdf')
```

Optionally remove/disable `plt.show()` in headless environments (not required for the lab, but practical).

### ✅ Prevention

Always export plot artifacts when working on remote servers.

---

## 7) `weekly_attempts_snapshot.pdf` not created

### ❗ Problem

After running script, the output PDF is missing.

### ✅ Possible Causes

* Script terminated early due to errors
* No write permission in directory
* `savefig` not executed (code path not reached)

### ✅ Resolution

1. Re-run and watch for errors:

```bash id="l30tsp8"
python3 analyze_trends.py
echo $?
```

2. Confirm you can write to directory:

```bash id="l30tsp9"
touch test_write.txt
ls -l test_write.txt
rm test_write.txt
```

3. Confirm the save line exists in script:

```bash id="l30tsp10"
grep -n "savefig" -n analyze_trends.py
```

### ✅ Prevention

Verify artifacts with `ls -lh` at the end of the lab.

---

## 8) Date parsing issues (`parse_dates` not working)

### ❗ Problem

Pandas treats the `date` column as text instead of datetime.

### ✅ Possible Causes

* Wrong column name
* Invalid date format
* CSV contains extra spaces

### ✅ Resolution

Confirm the header matches exactly:

```csv
date,attempts
```

Force conversion:

```python id="l30tsp11"
data['date'] = pd.to_datetime(data['date'], errors='coerce')
print(data.dtypes)
```

### ✅ Prevention

Keep date column clean in CSV and verify with `print(data.head())`.

---

## 9) Weekly averages look “wrong” or not aligned to expected week boundaries

### ❗ Problem

Weekly buckets may not match expected week start/end assumptions.

### ✅ Cause

`resample('W')` uses pandas default weekly frequency (typically week ending Sunday).

### ✅ Resolution

If needed, specify week start (example):

```python id="l30tsp12"
data_weekly = data.resample('W-MON').mean()
```

### ✅ Prevention

Document which weekly boundary is used when reporting to stakeholders.

---
