#!/usr/bin/env bash
# Lab 14 - Setting Up Email Notifications
# Commands Executed During Lab (sequential, copy/paste-ready)

# -------------------------------
# Step 1: Check OS + location
# -------------------------------
cat /etc/os-release
pwd

# -------------------------------
# Step 2: Install mail tools + Postfix
# -------------------------------
sudo apt update
sudo apt install -y postfix mailutils
systemctl status postfix --no-pager

# -------------------------------
# Step 3: Create /etc/alert_system.conf
# -------------------------------
sudo nano /etc/alert_system.conf
sudo cat /etc/alert_system.conf

# -------------------------------
# Step 4: Create alert rule config
# -------------------------------
sudo nano /etc/alert_rules.conf
sudo cat /etc/alert_rules.conf

# -------------------------------
# Step 5: Create local recipient user
# -------------------------------
sudo adduser --disabled-password --gecos "" admin

# -------------------------------
# Step 6: Create alert checker script
# -------------------------------
sudo nano /usr/local/bin/failed_login_alert.sh
sudo chmod +x /usr/local/bin/failed_login_alert.sh
/usr/local/bin/failed_login_alert.sh

# -------------------------------
# Step 7: Simulate failed login attempts
# -------------------------------
for i in {1..5}; do
  logger -t sshd "Failed password for invalid user testuser from 203.0.113.25 port 552$i ssh2"
done

journalctl --since "2 minutes ago" | grep "Failed password" | tail -n 5

# -------------------------------
# Step 8: Trigger alert + verify mailbox
# -------------------------------
/usr/local/bin/failed_login_alert.sh
sudo -u admin mail
# inside mail client:
#   & 1
#   & q
