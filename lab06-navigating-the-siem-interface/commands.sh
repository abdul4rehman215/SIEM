#!/bin/bash
# Lab 06 - Navigating the SIEM Interface
# Commands executed during lab (sequential, no explanations)

# Task 1: Verify Kibana service + port + HTTP behavior
sudo systemctl status kibana --no-pager
ss -lntp | grep ':5601'
curl -I http://localhost:5601 | head -n 10
sudo tail -n 15 /var/log/kibana/kibana.log

# Task 1/3: Setup lab workspace for scripts + configs
mkdir -p ~/Navigating_SIEM_Interface_Lab/scripts && cd ~/Navigating_SIEM_Interface_Lab
python3 --version
pip3 --version
pip3 install selenium

# Create automation script + execute
nano scripts/selenium_login.py
python3 scripts/selenium_login.py

# Theme config file creation
nano theme_config.json
cat theme_config.json
