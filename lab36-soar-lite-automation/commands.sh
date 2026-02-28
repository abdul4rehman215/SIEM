#!/bin/bash
# Lab 36 - Automating Simple Responses (SOAR Lite)
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Step 0: Create working directory
# =========================
mkdir -p Lab36_SOAR_Lite
cd Lab36_SOAR_Lite

# =========================
# Step 1: Update package list
# =========================
sudo apt-get update

# =========================
# Task 1.2: Install and configure osquery (official repo)
# =========================
sudo apt-get install -y curl gnupg

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkg.osquery.io/deb/pubkey.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/osquery.gpg
echo "deb [signed-by=/etc/apt/keyrings/osquery.gpg] https://pkg.osquery.io/deb deb main" | sudo tee /etc/apt/sources.list.d/osquery.list

sudo apt-get update
sudo apt-get install -y osquery

# Verify osquery works
osqueryi --version

# Start and enable osquery daemon
sudo systemctl enable --now osqueryd
systemctl status osqueryd --no-pager | head -n 12

# =========================
# Task 1.3: Create automated response script
# =========================
nano auto_block.sh
chmod +x auto_block.sh

# =========================
# Task 1.5: StackStorm rule (assumed available)
# =========================
nano auto-block-rule.yaml
st2 rule create auto-block-rule.yaml

# =========================
# Task 2: Test condition (simulate scan)
# =========================
sudo apt-get install -y nmap

# Identify target IP (ens5)
ip a show ens5 | sed -n '1,25p'

# Simulate attacker IP using loopback alias
sudo ip addr add 127.0.0.2/8 dev lo

# Run scan (fast range)
sudo nmap -sS -p 1-2000 -S 127.0.0.2 127.0.0.1

# Monitor alerts (osquery detection - nmap execution)
osqueryi --json "SELECT pid, name, path, cmdline, uid FROM processes WHERE name='nmap';"

# =========================
# Task 3: Verify response action executed
# =========================
sudo ./auto_block.sh 127.0.0.2

# Check firewall rules
sudo iptables -L

# Confirm scan is blocked (port becomes filtered)
sudo nmap -sS -p 22 -S 127.0.0.2 127.0.0.1

# =========================
# Extra: Write response log (audit trail)
# =========================
echo "$(date -u) - Auto-block executed for IP 127.0.0.2" | tee -a soar_actions.log
cat soar_actions.log
