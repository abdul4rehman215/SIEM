#!/bin/bash
# Lab 31 - File Integrity Monitoring (FIM) with auditd
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Environment Check
# =========================
cat /etc/os-release

# =========================
# Install auditd + plugins
# =========================
sudo apt-get update
sudo apt-get install auditd audispd-plugins

# =========================
# Start + Enable auditd
# =========================
sudo systemctl start auditd
sudo systemctl enable auditd

# =========================
# Quick Status Check
# =========================
systemctl status auditd --no-pager | head -n 12

# =========================
# Verify auditctl Version
# =========================
auditctl -v

# =========================
# Identify Target File
# =========================
ls -l /etc/passwd

# =========================
# Configure Audit Rule (watch /etc/passwd)
# =========================
sudo auditctl -w /etc/passwd -p wa -k passwd_changes

# =========================
# List Current Rules
# =========================
sudo auditctl -l

# =========================
# Generate Change Event (safe edit)
# =========================
sudo nano /etc/passwd

# =========================
# Verify Alert Generation
# =========================
sudo ausearch -f /etc/passwd
sudo aureport -f --summary | grep passwd_changes
