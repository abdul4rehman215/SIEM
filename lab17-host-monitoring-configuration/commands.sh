#!/usr/bin/env bash
# Lab 17 - Host Monitoring Configuration
# Commands Executed During Lab (sequential, copy/paste-ready)

# -------------------------------
# Step 0: Confirm OS + start directory
# -------------------------------
cat /etc/os-release
pwd

# -------------------------------
# Task 1: Install Host Intrusion Detection Agent (OSSEC)
# -------------------------------
sudo apt-get update
sudo apt-get install wget -y

# Download OSSEC installer (Atomicorp)
wget -U ossec https://updates.atomicorp.com/installers/ossec-installer.sh
ls -l ossec-installer.sh

# Run installer (interactive prompts occur)
sudo sh ossec-installer.sh

# Verify OSSEC service + components
sudo systemctl status ossec --no-pager
sudo /var/ossec/bin/ossec-control status

# -------------------------------
# Task 2: Enable Active Monitoring (Syscheck + Local Rules)
# -------------------------------

# Edit OSSEC config to monitor directories
sudo nano /var/ossec/etc/ossec.conf

# Verify syscheck block exists
sudo grep -n "syscheck" -n /var/ossec/etc/ossec.conf | head
sudo sed -n '90,105p' /var/ossec/etc/ossec.conf

# Add local rules placeholder
sudo nano /var/ossec/rules/local_rules.xml
sudo tail -n 25 /var/ossec/rules/local_rules.xml

# Restart OSSEC and verify status
sudo systemctl restart ossec
sudo systemctl status ossec --no-pager

# -------------------------------
# Task 3: Confirm Alerts (local validation simulating SIEM ingestion)
# -------------------------------

# Trigger a file integrity event
sudo touch /etc/monitored_file
ls -l /etc/monitored_file

# Force/accelerate scan by restarting OSSEC
sudo /var/ossec/bin/ossec-control restart

# Verify syscheck scan activity
sudo tail -n 30 /var/ossec/logs/ossec.log

# Check syscheck alert in alerts log
sudo tail -n 60 /var/ossec/logs/alerts/alerts.log
sudo grep -n "monitored_file" /var/ossec/logs/alerts/alerts.log | tail -n 5

# Export latest alert block excerpt (simulated SIEM verification)
sudo awk 'BEGIN{p=0} /\*\* Alert/{p=1} p{print}' /var/ossec/logs/alerts/alerts.log | tail -n 25
