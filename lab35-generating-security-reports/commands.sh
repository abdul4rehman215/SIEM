#!/bin/bash
# Lab 35 - Generating Security Reports
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Create Working Directory
# =========================
mkdir -p Lab35_Security_Reports
cd Lab35_Security_Reports

# =========================
# Update Package List
# =========================
sudo apt-get update

# =========================
# Attempt OSSEC install (as in lab)
# =========================
sudo apt-get install ossec-hids

# =========================
# Fix: Install OSSEC from source (dependencies)
# =========================
sudo apt-get install -y build-essential zlib1g-dev libpcre2-dev curl

# Download + extract OSSEC source
wget -O ossec-hids.tar.gz https://github.com/ossec/ossec-hids/archive/refs/tags/3.7.0.tar.gz
tar -xzf ossec-hids.tar.gz
cd ossec-hids-3.7.0

# Install OSSEC (interactive installer)
sudo ./install.sh

# Start OSSEC
sudo /var/ossec/bin/ossec-control start

# Configure OSSEC
sudo nano /var/ossec/etc/ossec.conf

# Restart OSSEC
sudo /var/ossec/bin/ossec-control restart

# =========================
# Install Zeek (Bro)
# =========================
sudo apt-get install zeek

# Fix: Add Zeek repo + install
sudo apt-get install -y gnupg apt-transport-https
echo "deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_24.04/ /" | sudo tee /etc/apt/sources.list.d/zeek.list
curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_24.04/Release.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/zeek.gpg
sudo apt-get update
sudo apt-get install -y zeek

# Start capturing (deploy)
sudo zeekctl deploy

# Confirm Zeek status
sudo zeekctl status

# =========================
# Monitor Zeek Logs
# =========================
cd /opt/zeek/logs/current
ls -lh
head -n 8 notice.log

# =========================
# Extract CRITICAL events
# =========================
grep "CRITICAL" /opt/zeek/logs/current/*.log
echo $?

# =========================
# Create report generation script
# =========================
nano generate_report.sh
chmod +x generate_report.sh
./generate_report.sh

# Verify summary.log
ls -lh summary.log
head -n 20 summary.log

# =========================
# Export report to PDF (pandoc)
# =========================
pandoc --version
sudo apt-get install -y pandoc
pandoc summary.log -o security_report.pdf
ls -lh security_report.pdf

# =========================
# Convert report to CSV (Python)
# =========================
nano convert_to_csv.py
python3 convert_to_csv.py
ls -lh report.csv
head -n 10 report.csv
