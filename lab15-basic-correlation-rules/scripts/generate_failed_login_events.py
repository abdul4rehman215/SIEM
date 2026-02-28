import logging
import time

logging.basicConfig(filename='failed_login_logs.log', level=logging.INFO)

# Simulate failed logins
for i in range(6):
    logging.info(f"Failed login attempt {i+1}")
    time.sleep(2)

# Simulate a successful login
logging.info("Successful login attempt")
