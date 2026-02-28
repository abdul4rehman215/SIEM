-- Lab 22 schema setup: database objects used for index maintenance + retention tests

-- Create database (run as postgres superuser):
-- CREATE DATABASE labdb;

-- Connect to labdb and create a sample log table:
CREATE TABLE app_logs (
  id BIGSERIAL PRIMARY KEY,
  ts TIMESTAMPTZ NOT NULL DEFAULT now(),
  severity TEXT NOT NULL,
  message TEXT
);

-- Create indexes to demonstrate listing + usage stats:
CREATE INDEX idx_app_logs_ts ON app_logs(ts);
CREATE INDEX idx_app_logs_severity ON app_logs(severity);
