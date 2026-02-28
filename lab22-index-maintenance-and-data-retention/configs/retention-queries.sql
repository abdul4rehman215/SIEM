-- Row retention policy (keep last N days)
-- NOTE: The lab text referenced "log_retention" which is not a standard PostgreSQL parameter.
-- Practical approach: delete rows older than X days in log tables.

-- One-time enforcement (keep 30 days)
DELETE FROM app_logs
WHERE ts < now() - interval '30 days';

-- Reusable function for retention enforcement
CREATE OR REPLACE FUNCTION enforce_log_retention(days_to_keep INT)
RETURNS VOID AS $$
BEGIN
  DELETE FROM app_logs
  WHERE ts < now() - (days_to_keep || ' days')::interval;
END;
$$ LANGUAGE plpgsql;

-- Run function
SELECT enforce_log_retention(30);
