#!/bin/bash
# Lab 13 - Basic SIEM Dashboards
# Commands executed during lab (sequential, no explanations)

# Task 1: Verify ELK services
sudo systemctl status elasticsearch
sudo systemctl status logstash
sudo systemctl status kibana

# Task 1: Feed test log entry into auth.log
echo "Aug 29 01:00:00 mymachine auth: user root logged in" | sudo tee -a /var/log/auth.log

# Task 1: Configure Logstash pipeline
sudo nano /etc/logstash/conf.d/logstash.conf

# Task 1: Validate Logstash config
sudo /usr/share/logstash/bin/logstash --path.settings /etc/logstash -t

# Task 1: Restart Logstash to apply config
sudo systemctl restart logstash

# Task 1: Verify Elasticsearch index created
curl -s "http://localhost:9200/_cat/indices?v" | head
