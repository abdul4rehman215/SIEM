#!/usr/bin/env bash
# Lab 19 - Creating a Real-Time Dashboard
# Commands Executed During Lab (sequential, copy/paste-ready)

# -------------------------------
# Task 1: Install Docker (Ubuntu 24.04)
# -------------------------------
sudo apt-get update

# Attempt (expected failure before adding Docker repo)
sudo apt-get install docker-ce docker-ce-cli containerd.io

# Install prerequisites for Docker APT repo
sudo apt-get install ca-certificates curl gnupg -y

# Setup keyrings directory + import Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository (noble)
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update and install Docker CE
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Verify Docker
docker --version

# -------------------------------
# Task 1.2: Run Prometheus using Docker
# -------------------------------
docker pull prom/prometheus
docker run -d --name=prometheus -p 9090:9090 prom/prometheus

# Verify Prometheus container is running
docker ps

# Prometheus readiness check
curl -s http://localhost:9090/-/ready

# -------------------------------
# Task 2: Run Grafana using Docker
# -------------------------------
docker pull grafana/grafana
docker run -d --name=grafana -p 3000:3000 grafana/grafana

# Verify Grafana container is running
docker ps

# Grafana basic HTTP check (expects redirect to /login)
curl -I http://localhost:3000 | head -n 5

# -------------------------------
# Task 2.2: Docker networking fix (so http://prometheus:9090 resolves in Grafana)
# -------------------------------
docker network create monitoring
docker network connect monitoring prometheus
docker network connect monitoring grafana
docker network inspect monitoring | grep -E '"Name"|"prometheus"|"grafana"' -n

# -------------------------------
# Task 3: Generate real-time activity for dashboard visibility
# -------------------------------
for i in {1..20}; do
  curl -s http://localhost:9090/-/healthy >/dev/null
  sleep 0.2
done

# Verify built-in Prometheus metric exists via API query
curl -s "http://localhost:9090/api/v1/query?query=prometheus_http_requests_total" | head -n 15
