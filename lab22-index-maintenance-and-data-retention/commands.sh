#!/usr/bin/env bash
# Lab 22 - Index Maintenance & Data Retention (PostgreSQL)
# Commands Executed During Lab (sequential, copy/paste-ready)

# -------------------------------
# Setup: Install and start PostgreSQL
# -------------------------------
sudo apt update
sudo apt install postgresql postgresql-contrib -y
sudo systemctl status postgresql --no-pager | head -n 12

# -------------------------------
# Create lab database + table (so we have indexes to view)
# -------------------------------
sudo -u postgres psql -c "CREATE DATABASE labdb;"

sudo -u postgres psql -d labdb -c "CREATE TABLE app_logs (id BIGSERIAL PRIMARY KEY, ts TIMESTAMPTZ NOT NULL DEFAULT now(), severity TEXT NOT NULL, message TEXT);"

sudo -u postgres psql -d labdb -c "CREATE INDEX idx_app_logs_ts ON app_logs(ts);"
sudo -u postgres psql -d labdb -c "CREATE INDEX idx_app_logs_severity ON app_logs(severity);"

# -------------------------------
# Task 1.1: Identify existing indexes
# -------------------------------
sudo -u postgres psql -d labdb -c "SELECT tablename, indexname, indexdef FROM pg_indexes WHERE schemaname = 'public';"

# -------------------------------
# Task 1.2: Analyze index usage (generate queries + check stats)
# -------------------------------
sudo -u postgres psql -d labdb -c "INSERT INTO app_logs(ts,severity,message) VALUES (now()-interval '2 hours','error','Failed login attempt'), (now()-interval '50 minutes','info','User logged in'), (now()-interval '10 minutes','warning','High CPU usage'), (now(),'error','App exception stacktrace');"

sudo -u postgres psql -d labdb -c "SELECT count(*) FROM app_logs WHERE severity='error';"
sudo -u postgres psql -d labdb -c "SELECT * FROM app_logs WHERE ts > now()-interval '1 hour' ORDER BY ts DESC LIMIT 5;"

sudo -u postgres psql -d labdb -c "SELECT relname AS table_name, indexrelname AS index_name, idx_scan AS times_index_used FROM pg_stat_user_indexes ORDER BY idx_scan DESC;"

# -------------------------------
# Task 2.1: Identify current retention-related settings (postgresql.conf)
# -------------------------------
sudo find /etc/postgresql -name postgresql.conf
sudo sed -n '1,35p' /etc/postgresql/16/main/postgresql.conf

# -------------------------------
# Task 2.2: Adjust retention policy (realistic row retention: keep 30 days)
# -------------------------------
sudo -u postgres psql -d labdb -c "DELETE FROM app_logs WHERE ts < now() - interval '30 days';"

# Optional: reusable retention function
sudo -u postgres psql -d labdb -c "CREATE OR REPLACE FUNCTION enforce_log_retention(days_to_keep INT) RETURNS VOID AS $$ BEGIN DELETE FROM app_logs WHERE ts < now() - (days_to_keep || ' days')::interval; END; $$ LANGUAGE plpgsql;"

sudo -u postgres psql -d labdb -c "SELECT enforce_log_retention(30);"

# -------------------------------
# Task 3.1: Verify retention (simulate file retention with find -mtime)
# -------------------------------
sudo mkdir -p /var/log/demo-retention
sudo touch /var/log/demo-retention/log_5_days.log
sudo touch -d "35 days ago" /var/log/demo-retention/log_35_days.log

sudo ls -l --time-style=long-iso /var/log/demo-retention

# Cleanup (same logic as cron example)
sudo find /var/log/demo-retention* -mtime +30 -exec rm -v {} \;

# Confirm remaining files
sudo ls -l /var/log/demo-retention
