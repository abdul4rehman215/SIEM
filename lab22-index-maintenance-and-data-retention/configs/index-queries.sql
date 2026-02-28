-- List indexes in public schema
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public';

-- Insert sample logs to generate index scans (example dataset)
INSERT INTO app_logs(ts,severity,message)
VALUES
  (now()-interval '2 hours','error','Failed login attempt'),
  (now()-interval '50 minutes','info','User logged in'),
  (now()-interval '10 minutes','warning','High CPU usage'),
  (now(),'error','App exception stacktrace');

-- Run queries that should use indexes
SELECT count(*) FROM app_logs WHERE severity='error';
SELECT * FROM app_logs
WHERE ts > now()-interval '1 hour'
ORDER BY ts DESC
LIMIT 5;

-- Index usage stats
SELECT relname AS table_name,
       indexrelname AS index_name,
       idx_scan AS times_index_used
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
