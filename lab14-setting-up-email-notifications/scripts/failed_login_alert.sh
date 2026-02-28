#!/usr/bin/env bash

# Simple alert checker:
# Trigger if there are 5 "Failed password" entries in the last 1 minute.

LOG_FILE="/var/log/auth.log"
THRESHOLD=5
WINDOW_SECONDS=60
RECIPIENT="admin"
SUBJECT="Alert: Failed Login Attempts"
MESSAGE="There have been 5 failed login attempts in the last minute."

# Find entries within the last 60 seconds (approximate using journalctl time window)
# Ubuntu auth logs can be handled via journalctl; auth.log may exist depending on rsyslog.
# We'll support both.

count=0

if command -v journalctl >/dev/null 2>&1; then
  count=$(journalctl --since "1 minute ago" | grep -c "Failed password" || true)
fi

# Fallback if auth.log exists and has content
if [ -f "$LOG_FILE" ]; then
  recent_lines=$(tail -n 500 "$LOG_FILE" 2>/dev/null || true)
  # Approximate: count "Failed password" in recent tail
  count2=$(echo "$recent_lines" | grep -c "Failed password" || true)
  if [ "$count2" -gt "$count" ]; then
    count="$count2"
  fi
fi

if [ "$count" -ge "$THRESHOLD" ]; then
  echo "$MESSAGE" | mail -s "$SUBJECT" "$RECIPIENT"
  echo "[INFO] Alert sent to $RECIPIENT (count=$count)"
else
  echo "[INFO] No alert triggered (count=$count, threshold=$THRESHOLD)"
fi
