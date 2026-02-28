# scripts/extract_error_lines.py
import re

log_file_path = 'sample.log'  # Replace with actual log file path

with open(log_file_path, 'r') as file:
    logs = file.readlines()

error_code_pattern = re.compile(r'\[error code:\s*[A-Z]+\]')

for line in logs:
    if error_code_pattern.search(line):
        print(line.strip())
