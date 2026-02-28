#!/usr/bin/env bash
# Lab 25 - Basic Incident Response Workflow (Fail2Ban + ELK)
# Commands Executed During Lab (sequential, copy/paste-ready)

# -------------------------------
# Task 1: Configure Fail2Ban to simulate repeated failed login attempts
# -------------------------------
sudo apt update
sudo apt install fail2ban -y

# Configure Fail2Ban SSH jail
sudo nano /etc/fail2ban/jail.local

# Restart Fail2Ban and verify status
sudo systemctl restart fail2ban
sudo systemctl status fail2ban --no-pager | head -n 12

# Verify jail is enabled
sudo fail2ban-client status

# -------------------------------
# Simulate failed SSH login attempts to trigger ban
# -------------------------------
ssh wronguser@localhost
ssh admin@localhost

# Check jail status after failures (ban evidence)
sudo fail2ban-client status sshd

# View Fail2Ban logs (proof of detection + ban)
sudo tail -n 15 /var/log/fail2ban.log

# -------------------------------
# Task 2: Integrate Fail2Ban with ELK Stack (SIEM evidence)
# -------------------------------

# Verify Elasticsearch health and Logstash/Kibana services
curl -s http://localhost:9200 | head -n 5
sudo systemctl status logstash --no-pager | head -n 5
sudo systemctl status kibana --no-pager | head -n 5

# Configure Logstash pipeline for Fail2Ban logs
sudo nano /etc/logstash/conf.d/fail2ban.conf

# Restart Logstash to apply pipeline
sudo systemctl restart logstash
sudo systemctl status logstash --no-pager | head -n 10

# Verify Fail2Ban index is created in Elasticsearch
curl -s "http://localhost:9200/_cat/indices?v" | grep fail2ban | tail -n 3

# Peek ingested events
curl -s "http://localhost:9200/fail2ban-2026.02.28/_search?size=3&pretty"
