CREATE OR REPLACE FUNCTION enforce_log_retention(days_to_keep INT)
RETURNS VOID AS $$
BEGIN
  DELETE FROM app_logs
  WHERE ts < now() - (days_to_keep || ' days')::interval;
END;
$$ LANGUAGE plpgsql;
