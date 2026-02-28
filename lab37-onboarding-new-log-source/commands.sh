#!/bin/bash
# Lab 37 - Onboarding a New Log Source (Wazuh Agent + Simulated IoT JSON logs)
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Step 0: Create working directory
# =========================
mkdir -p Lab37_New_Log_Source
cd Lab37_New_Log_Source

# =========================
# Step 1: Update package list
# =========================
sudo apt-get update

# =========================
# Step 2: Install wazuh-agent (as in lab)
# =========================
sudo apt-get install wazuh-agent

# =========================
# Fix: Add Wazuh repo and install agent
# =========================
sudo apt-get install -y curl gnupg apt-transport-https

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo gpg --dearmor -o /etc/apt/keyrings/wazuh.gpg
echo "deb [signed-by=/etc/apt/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list

sudo apt-get update
sudo apt-get install -y wazuh-agent

# =========================
# Step 3: Configure the agent + create simulated IoT log source
# =========================
sudo ls -l /var/ossec/etc/ossec.conf

sudo mkdir -p /var/log/iot_device
sudo nano /var/log/iot_device/iot_events.log

sudo head -n 5 /var/log/iot_device/iot_events.log

# Edit agent config to monitor IoT log and set manager connection
sudo nano /var/ossec/etc/ossec.conf

# =========================
# Step 4: Start + enable the agent
# =========================
sudo systemctl start wazuh-agent
sudo systemctl enable wazuh-agent
systemctl status wazuh-agent --no-pager | head -n 14

# =========================
# Task 3: Validate collection + parsing
# =========================
sudo tail -f /var/ossec/logs/ossec.log

# Validate JSON structure locally
sudo apt-get install -y jq
sudo cat /var/log/iot_device/iot_events.log | jq -c '.' | head -n 3
