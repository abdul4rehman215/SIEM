#!/bin/bash
# Lab 27 - Utilizing Dashboards for Executive Reporting
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Environment Verification
# =========================
cat /etc/os-release

# =========================
# System Update + Prereqs
# =========================
sudo apt update
sudo apt install -y apt-transport-https software-properties-common wget gpg

# =========================
# Install Grafana (APT repo)
# =========================
sudo mkdir -p /etc/apt/keyrings
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

sudo apt update
sudo apt install -y grafana

# =========================
# Start + Enable Grafana
# =========================
sudo systemctl enable --now grafana-server
systemctl status grafana-server --no-pager

# =========================
# Verify Grafana Port/HTTP
# =========================
sudo ss -lntp | grep 3000
curl -I http://localhost:3000 | head

# =========================
# Install MariaDB + Start
# =========================
sudo apt install -y mariadb-server
sudo systemctl enable --now mariadb
systemctl status mariadb --no-pager | head -n 12

# =========================
# Create Dataset (MariaDB)
# =========================
sudo mariadb
# Inside MariaDB prompt (entered interactively):
# CREATE DATABASE exec_reporting;
# USE exec_reporting;
# CREATE TABLE incidents (incident_id INT AUTO_INCREMENT PRIMARY KEY, date DATE NOT NULL);
# CREATE TABLE events (event_id INT AUTO_INCREMENT PRIMARY KEY, event_type VARCHAR(100) NOT NULL, event_time DATETIME NOT NULL);
# INSERT INTO incidents (date) VALUES
# ('2025-08-12'),('2025-08-12'),('2025-08-12'),
# ('2025-08-13'),('2025-08-13'),
# ('2025-08-14'),('2025-08-14'),('2025-08-14'),('2025-08-14'),
# ('2025-08-15'),
# ('2025-08-16'),('2025-08-16'),
# ('2025-08-17'),('2025-08-17'),('2025-08-17'),('2025-08-17');
# INSERT INTO events (event_type, event_time) VALUES
# ('Phishing Email', '2025-08-12 09:10:00'),
# ('Phishing Email', '2025-08-12 10:22:00'),
# ('Malware Detection', '2025-08-12 11:05:00'),
# ('Failed Login', '2025-08-13 08:18:00'),
# ('Failed Login', '2025-08-13 08:22:00'),
# ('Failed Login', '2025-08-13 09:01:00'),
# ('Suspicious DNS', '2025-08-14 12:44:00'),
# ('Phishing Email', '2025-08-14 14:21:00'),
# ('Malware Detection', '2025-08-14 17:02:00'),
# ('Port Scan', '2025-08-15 03:17:00'),
# ('Port Scan', '2025-08-15 03:19:00'),
# ('Phishing Email', '2025-08-16 15:33:00'),
# ('Suspicious DNS', '2025-08-16 16:11:00'),
# ('Failed Login', '2025-08-17 10:01:00'),
# ('Failed Login', '2025-08-17 10:02:00');
# SELECT date, COUNT(incident_id) AS incident_count FROM incidents GROUP BY date;
# SELECT event_type, COUNT(*) AS event_count FROM events GROUP BY event_type;
# CREATE USER 'grafana'@'localhost' IDENTIFIED BY 'REDACTED_PASSWORD';
# GRANT SELECT ON exec_reporting.* TO 'grafana'@'localhost';
# FLUSH PRIVILEGES;
# EXIT;

# =========================
# Notes (UI-performed steps)
# =========================
# Grafana UI:
# - Opened http://localhost:3000
# - Logged in (admin/admin) and changed password at first login prompt
# - Connections -> Data sources -> Add data source -> MySQL
#   Host: 127.0.0.1:3306
#   Database: exec_reporting
#   User: grafana
#   Password: REDACTED
# - Save & Test

# Dashboard Panels (Grafana UI queries used):
# Daily Incidents (Time Series):
# SELECT
#   date AS time,
#   COUNT(incident_id) AS incident_count
# FROM incidents
# GROUP BY date
# ORDER BY date;

# Top Event Types (Pie Chart):
# SELECT
#   event_type,
#   COUNT(*) AS event_count
# FROM events
# GROUP BY event_type
# ORDER BY event_count DESC;

# Share/Export (Grafana UI):
# - Dashboard -> Share -> Link
# - Dashboard -> Share -> Snapshot (expiry 1 hour, local lab snapshot URL)
