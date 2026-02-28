#!/bin/bash
# Lab 09 - Gathering Linux Syslogs
# Commands executed during lab (sequential, no explanations)

# Check rsyslog status
systemctl status rsyslog

# Checklist start/enable (even if already running)
sudo systemctl start rsyslog
sudo systemctl enable rsyslog

# Edit rsyslog configuration
sudo nano /etc/rsyslog.conf

# Verify edits applied
sudo grep -nE 'imudp|port="514"|\*\.\* @' /etc/rsyslog.conf

# Restart and verify status
sudo systemctl restart rsyslog
systemctl status rsyslog --no-pager -l

# Generate test syslog message
logger "Test log message from $(hostname)"

# Confirm locally logged
sudo tail -n 8 /var/log/syslog
