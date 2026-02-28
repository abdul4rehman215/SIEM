#!/bin/bash
# Lab 07 - Configuring Data Sources
# Commands executed during lab (sequential, no explanations)

# Task 1: Workspace + host network info + data source inventory
mkdir -p ~/SIEM_DataSources_Lab/{docs,configs,windows_router_samples} && cd ~/SIEM_DataSources_Lab
ip addr show ens5
nano docs/data_sources_inventory.md

# Task 2: Install syslog-ng + configure for local + remote ingestion
sudo apt-get update && sudo apt-get install -y syslog-ng
sudo nano /etc/syslog-ng/syslog-ng.conf
sudo systemctl restart syslog-ng
sudo systemctl enable syslog-ng
sudo systemctl status syslog-ng --no-pager
sudo ss -lunpt | grep ':514'

# Task 2: Router syslog documentation + Windows NXLog sample config
nano docs/router_syslog_settings.md
nano windows_router_samples/nxlog.conf

# Task 3: Verify ingestion (live tail + simulated events)
sudo touch /var/log/messages
sudo tail -f /var/log/messages
echo '<34>Aug 18 14:05:30 router01 firewall: DROP IN=eth0 OUT= MAC=aa:bb:cc:dd:ee:ff SRC=203.0.113.50 DST=192.168.1.10 LEN=60 TOS=0x00 PREC=0x00 TTL=50 ID=54321 DF PROTO=TCP SPT=443 DPT=53922 WINDOW=65535' | nc -u -w1 127.0.0.1 514
echo '<134>Aug 18 14:05:38 HOA-WIN10 Microsoft-Windows-Security-Auditing: EventID=4625 An account failed to log on. Account Name=hoa-admin Source Network Address=10.10.20.15 Logon Type=3' | nc -u -w1 127.0.0.1 514

# Task 3: Validation
sudo tail -n 20 /var/log/messages
nano docs/log_validation_checks.md
