#!/usr/bin/env bash
# Lab 15 - Basic Correlation Rules
# Commands Executed During Lab (sequential, copy/paste-ready)

# -------------------------------
# Step 1: Confirm environment
# -------------------------------
cat /etc/os-release
pwd

# -------------------------------
# Step 2: Create a working directory
# -------------------------------
mkdir -p lab15_correlation
cd lab15_correlation
pwd

# -------------------------------
# Step 3: Create Python event generator script
# -------------------------------
nano generate_failed_login_events.py
ls -l

# -------------------------------
# Step 4: Run the event generator
# -------------------------------
python3 generate_failed_login_events.py

# -------------------------------
# Step 5: Verify the generated log file
# -------------------------------
ls -l failed_login_logs.log
cat failed_login_logs.log

# -------------------------------
# Step 6: Create correlation rule checker
# -------------------------------
nano correlation_rule_checker.py
ls -l

# -------------------------------
# Step 7: Run correlation rule checker (simulate SIEM rule trigger)
# -------------------------------
python3 correlation_rule_checker.py

# -------------------------------
# Step 8: Optional - verify non-trigger scenario
# -------------------------------
head -n 3 failed_login_logs.log > failed_login_logs_small.log
cp failed_login_logs_small.log failed_login_logs.log
python3 correlation_rule_checker.py
