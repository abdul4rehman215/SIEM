from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import time

# NOTE:
# - This script is for practice. It requires Chrome/Chromium + a compatible chromedriver.
# - In many cloud labs, GUI browsers/drivers are not installed, so the script may fail unless configured.

SIEM_URL = "http://siem.example.com/login"
USERNAME = "your_username"
PASSWORD = "your_password"

options = Options()
# comment this if you want full GUI mode (requires desktop environment)
options.add_argument("--headless=new")
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")

driver = webdriver.Chrome(options=options)
driver.get(SIEM_URL)

username = driver.find_element(By.ID, "username")
password = driver.find_element(By.ID, "password")

username.send_keys(USERNAME)
password.send_keys(PASSWORD)

driver.find_element(By.NAME, "login").click()
time.sleep(2)

print("[+] Login automation attempted. Check browser/session for result.")
driver.quit()
