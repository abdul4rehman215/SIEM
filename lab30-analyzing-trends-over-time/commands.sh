#!/bin/bash
# Lab 30 - Analyzing Trends Over Time
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Create Working Directory
# =========================
mkdir -p Lab_TimeSeries_Trends
cd Lab_TimeSeries_Trends

# =========================
# Confirm Python
# =========================
python3 --version

# =========================
# Setup Virtual Environment
# =========================
python3 -m venv venv
source venv/bin/activate

# =========================
# Install Required Packages
# =========================
pip install pandas matplotlib seaborn

# =========================
# Create Dataset CSV
# =========================
nano login_attempts.csv
head login_attempts.csv

# =========================
# Create Analysis Script
# =========================
nano analyze_trends.py

# =========================
# Run Analysis Script
# =========================
python3 analyze_trends.py

# =========================
# Optional Sanity Check: Print Threshold + Anomalies
# =========================
python3 -c "import pandas as pd; d=pd.read_csv('login_attempts.csv',parse_dates=['date']).set_index('date'); w=d.resample('W').mean(); thr=w['attempts'].mean()+2*w['attempts'].std(); print('Threshold:',thr); print('Anomalies:'); print(w[w['attempts']>thr])"

# =========================
# Confirm Snapshot Export Exists
# =========================
ls -lh
