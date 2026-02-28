#!/bin/bash
# Lab 29 - Regular Expressions in Log Searches
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Environment Setup
# =========================
cat /etc/os-release
mkdir -p Lab_Regex_LogSearch
cd Lab_Regex_LogSearch

# =========================
# Verify Python
# =========================
python3 --version

# =========================
# Create Sample Log File
# =========================
nano sample.log

# =========================
# Confirm File Exists
# =========================
ls -l sample.log

# =========================
# Task 1: Test IPv4 Regex Pattern (PCRE)
# =========================
grep -oP '\b(?:\d{1,3}\.){3}\d{1,3}\b' sample.log

# =========================
# Task 2.1: Extract User IDs (user-123 / ID-456)
# =========================
grep -oP '\b(user|ID)-\d+\b' sample.log
grep -oP '\b(user|ID)-\d+\b' sample.log | sort -u

# =========================
# Task 2.2: Extract Error Codes ([error code: XYZ])
# =========================
grep -oP '\[error code:\s*[A-Z]+\]' sample.log
grep -oP '\[error code:\s*[A-Z]+\]' sample.log | sort -u

# =========================
# Task 3.1: Create Python Extraction Script
# =========================
nano extract_error_lines.py

# =========================
# Run Python Script
# =========================
python3 extract_error_lines.py

# =========================
# Task 3.2: Editor Regex Highlighting (manual)
# =========================
# Open sample.log in editor (e.g., VS Code)
# Ctrl+F -> enable regex mode (.*)
# Patterns tested:
#   \b(?:\d{1,3}\.){3}\d{1,3}\b
#   \b(user|ID)-\d+\b
#   \[error code:\s*[A-Z]+\]
