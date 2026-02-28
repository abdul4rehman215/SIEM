#!/bin/bash
# Lab 04 - Selecting a SIEM Platform
# Commands executed during lab (sequential, no explanations)

# Docs: SIEM options + evaluation
mkdir -p ~/SIEM_Platform_Selection_Lab && cd ~/SIEM_Platform_Selection_Lab
nano siem_options.md
nano siem_evaluation.md

# Environment verification + system updates
cat /etc/os-release
sudo apt-get update && sudo apt-get upgrade -y

# Java install (OpenJDK 11 not available -> install OpenJDK 17)
sudo apt-get install -y openjdk-11-jdk
sudo apt-get install -y openjdk-17-jdk
java -version

# Elasticsearch install + config + verification
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
sudo apt-get update && sudo apt-get install -y elasticsearch
sudo nano /etc/elasticsearch/elasticsearch.yml
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
sudo systemctl status elasticsearch --no-pager
curl -s http://localhost:9200 | head

# Logstash install + config + verification
sudo apt-get install -y logstash
sudo nano /etc/logstash/conf.d/logstash.conf
sudo systemctl start logstash
sudo systemctl enable logstash
sudo systemctl status logstash --no-pager

# Kibana install + config + verification
sudo apt-get install -y kibana
sudo nano /etc/kibana/kibana.yml
sudo systemctl start kibana
sudo systemctl enable kibana
sudo systemctl status kibana --no-pager

# Validate open ports (Elasticsearch, Kibana, Logstash Beats input)
ss -lntp | grep -E '(:9200|:5601|:5044)'
