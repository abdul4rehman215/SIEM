#!/bin/bash
# Lab 01 - Introduction to SIEM
# Commands executed during lab (sequential, no explanations)

# Task 1: Environment verification + Docker install + Wazuh deployment
cat /etc/os-release
docker --version
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo docker run -d --name wazuh -p 55000:55000 -p 1514:1514/udp -p 514:514/udp --network host wazuh/wazuh
sudo docker ps

# Task 2: Log Collection configuration
sudo docker exec -it wazuh bash
ls -l /var/ossec/etc/ossec.conf
nano /var/ossec/etc/ossec.conf
mkdir -p /var/log/nginx
touch /var/log/ufw.log /var/log/nginx/access.log /var/log/nginx/error.log
/var/ossec/bin/wazuh-control restart
tail -f /var/ossec/logs/ossec.log

# Task 3: Correlation rules + test event
cd /var/ossec/etc/rules
ls
nano custom_rules.xml
/var/ossec/bin/wazuh-control restart
nano /var/ossec/etc/ossec.conf
touch /var/log/custom_app.json
/var/ossec/bin/wazuh-control restart
echo '{"action":"login","status":"failure","user":"hoa-admin","src_ip":"192.168.10.77"}' >> /var/log/custom_app.json
tail -n 5 /var/ossec/logs/alerts/alerts.json

# Task 4: Alerting configuration + validation
nano /var/ossec/etc/ossec.conf
/var/ossec/bin/wazuh-control restart
echo '{"action":"login","status":"failure","user":"unknown","src_ip":"10.10.10.50"}' >> /var/log/custom_app.json
tail -n 3 /var/ossec/logs/alerts/alerts.json
tail -n 10 /var/ossec/logs/ossec.log | grep -i email
exit
