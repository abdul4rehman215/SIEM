from datetime import datetime, timedelta

LOG_FILE = "failed_login_logs.log"
FAIL_THRESHOLD = 5
WINDOW_MINUTES = 10

# In real SIEM, we'd use timestamps. Our simulated logs do not contain timestamps,
# so for this lab we treat all generated events as happening "within the window".

failed_count = 0
success_seen = False

with open(LOG_FILE, "r") as f:
    lines = f.readlines()

for line in lines:
    if "Failed login attempt" in line:
        failed_count += 1
    if "Successful login attempt" in line:
        success_seen = True

print("=== Correlation Rule Evaluation ===")
print(f"Rule: >= {FAIL_THRESHOLD} failed logins within {WINDOW_MINUTES} minutes + success login")
print(f"Failed attempts detected: {failed_count}")
print(f"Successful login detected: {success_seen}")

if failed_count >= FAIL_THRESHOLD and success_seen:
    print("\n[ALERT TRIGGERED] Possible brute-force attack detected!")
else:
    print("\n[OK] Rule not triggered.")
