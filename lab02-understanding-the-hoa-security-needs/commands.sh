#!/bin/bash
# Lab 02 - Understanding the HOA Security Needs
# Commands executed during lab (sequential, no explanations)

# Task 1: Create workspace + document assets + classify data
mkdir -p HOA_Security_Lab/{assets,data_classification,threat_modeling,vulnerability_assessment,security_policy}
cd HOA_Security_Lab
pwd
nano assets/hoa_assets.md
nano data_classification/data_types.md

# Task 2: Threat modeling tool install + threat notes
sudo apt update
sudo apt install -y snapd
sudo systemctl enable --now snapd
sudo snap install threat-dragon
snap list | grep threat-dragon
nano threat_modeling/threats_notes.md

# Task 2: Vulnerability assessment tool install (OpenVAS -> GVM)
sudo apt install -y openvas
sudo apt install -y gvm
sudo greenbone-feed-sync
sudo gvm-setup
sudo gvm-check-setup
nano vulnerability_assessment/vuln_assessment_notes.md

# Task 3: Security goals + policy draft
nano security_policy/security_goals.md
nano security_policy/hoa_security_policy.md
tree
