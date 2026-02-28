#!/bin/bash
# Lab 28 - Simple Log Forensics
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Environment Check
# =========================
cat /etc/os-release
pwd

# =========================
# Verify Required Tools
# =========================
which grep awk sed

# =========================
# Check Auth Log Availability
# =========================
ls -l /var/log/auth.log
head -n 5 /var/log/auth.log

# =========================
# Create Working Directory
# =========================
mkdir -p Lab28_LogForensics
cd Lab28_LogForensics

# =========================
# Create Sample Log File (editor step)
# =========================
nano auth_sample.log

# =========================
# Confirm File Saved
# =========================
wc -l auth_sample.log

# =========================
# Filter Logs by Time Window (Jul 15 10:00–12:59)
# =========================
grep 'Jul 15 10:' auth_sample.log > filtered_logs.txt
grep 'Jul 15 11:' auth_sample.log >> filtered_logs.txt
grep 'Jul 15 12:' auth_sample.log | head -n 30 >> filtered_logs.txt

# =========================
# Verify Extracted Content
# =========================
echo "Filtered lines:" && wc -l filtered_logs.txt
head -n 8 filtered_logs.txt

# =========================
# Identify Suspicious Patterns (failed/error/unauthorized)
# =========================
grep -E 'failed|error|unauthorized' filtered_logs.txt > suspicious_activity.txt

# =========================
# Validate Suspicious Activity Results
# =========================
wc -l suspicious_activity.txt
head -n 10 suspicious_activity.txt

# =========================
# Analyze Failed Login Attempts by Source IP
# =========================
awk '/Failed password/ {print $(NF-3)}' filtered_logs.txt | sort | uniq -c | sort -nr

# =========================
# Evidence Extraction (as written in lab)
# =========================
awk '{print $1, $2, $3, $11, $13}' suspicious_activity.txt > evidence.txt

# =========================
# Practical Parsing Fix (keyword-based extraction)
# =========================
awk '{
  ts=$1" "$2" "$3
  user="-"
  ip="-"
  for (i=1;i<=NF;i++){
    if($i=="for" && (i+1)<=NF) user=$(i+1)
    if($i=="from" && (i+1)<=NF) ip=$(i+1)
  }
  print ts, user, ip
}' suspicious_activity.txt > evidence_clean.txt

# =========================
# View Evidence Outputs
# =========================
head -n 12 evidence.txt
column -t evidence_clean.txt | head -n 15
