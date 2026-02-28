#!/bin/bash
# Lab 34 - Creating a Test Incident Response Plan (IRP)
# Commands Executed During Lab (sequential, no explanations)

# =========================
# Create Lab Folder
# =========================
mkdir -p Lab34_IRP
cd Lab34_IRP

# =========================
# Create IR Plan (Markdown)
# =========================
nano Incident_Response_Plan.md

# =========================
# Confirm File Created
# =========================
ls -lh

# =========================
# Preview IR Plan (verify formatting)
# =========================
sed -n '1,40p' Incident_Response_Plan.md

# =========================
# Create Tabletop Exercise Notes
# =========================
nano Tabletop_Exercise_Notes.txt

# =========================
# Verify Both Files Exist
# =========================
ls -lh
