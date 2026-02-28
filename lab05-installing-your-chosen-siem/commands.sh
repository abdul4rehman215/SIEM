#!/bin/bash
# Lab 05 - Installing Your Chosen SIEM
# Commands executed during lab (sequential, no explanations)

# 1. System update
sudo apt update && sudo apt upgrade -y

# 1.2 Java dependency (OpenJDK 11 not available -> install OpenJDK 17)
sudo apt install openjdk-11-jdk -y
sudo apt install openjdk-17-jdk -y
java -version

# 2. Elasticsearch 8.8.0 download + install
mkdir -p ~/ELK_8_8_0 && cd ~/ELK_8_8_0
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.8.0-amd64.deb
sudo dpkg -i elasticsearch-8.8.0-amd64.deb
sudo nano /etc/elasticsearch/elasticsearch.yml
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
sudo systemctl status elasticsearch --no-pager

# 3. Kibana 8.8.0 download + install
wget https://artifacts.elastic.co/downloads/kibana/kibana-8.8.0-amd64.deb
sudo dpkg -i kibana-8.8.0-amd64.deb
sudo nano /etc/kibana/kibana.yml
sudo systemctl start kibana
sudo systemctl enable kibana
sudo systemctl status kibana --no-pager

# 4. Logstash 8.8.0 download + install
wget https://artifacts.elastic.co/downloads/logstash/logstash-8.8.0-amd64.deb
sudo dpkg -i logstash-8.8.0-amd64.deb

# 5. Verification
curl -X GET "localhost:9200/"
ss -lntp | grep -E '(:9200|:5601)'
curl -I http://localhost:5601 | head -n 5
