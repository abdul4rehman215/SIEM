#!/usr/bin/env bash
# Lab 20 - Role-Based Access Control (RBAC)
# Commands Executed During Lab (sequential, copy/paste-ready)

# -------------------------------
# Task 1: Setup the Environment
# -------------------------------
sudo apt update && sudo apt upgrade -y

# Attempt (as written in lab; expected failure for usermod package name)
sudo apt install sudo usermod libpam0g-dev -y

# Corrected install command (usermod is part of passwd package on Ubuntu)
sudo apt install sudo passwd libpam0g-dev -y

# Verify usermod exists
which usermod

# -------------------------------
# Task 2: Create User Roles (Groups + Users)
# -------------------------------

# Create analyst role
sudo groupadd analyst
sudo useradd -m -s /bin/bash -g analyst analyst_user
sudo passwd analyst_user

# Create admin role
sudo groupadd admin
sudo useradd -m -s /bin/bash -g admin admin_user
sudo passwd admin_user

# Verify users and groups
id analyst_user
id admin_user

# -------------------------------
# Task 3: Implement Access Controls
# -------------------------------

# Create restricted directory
sudo mkdir /var/restricted

# Set analyst read-only style permissions initially
sudo chown root:analyst /var/restricted
sudo chmod 750 /var/restricted
ls -ld /var/restricted

# Switch to analyst role and test write (should fail)
su - analyst_user
echo "Test" > /var/restricted/test_file.txt
exit

# Grant full access to admin role
sudo chown admin_user:admin /var/restricted
sudo chmod 770 /var/restricted
ls -ld /var/restricted

# -------------------------------
# Task 4: Test Role Switching and Access
# -------------------------------

# Switch to admin role and test write (should succeed)
su - admin_user
echo "Admin Test" > /var/restricted/admin_test.txt
ls -l /var/restricted
exit

# Switch to analyst and test read (initially should fail under 770 admin-only perms)
su - analyst_user
cat /var/restricted/admin_test.txt
exit

# -------------------------------
# RBAC adjustment using ACLs (match lab intent: analyst read-only)
# -------------------------------
sudo apt install acl -y

# Grant analyst_user read/execute on directory and read on file
sudo setfacl -m u:analyst_user:rx /var/restricted
sudo setfacl -m u:analyst_user:r /var/restricted/admin_test.txt

# Verify ACL state
getfacl /var/restricted | head -n 12

# Re-test as analyst: read allowed, write denied
su - analyst_user
cat /var/restricted/admin_test.txt
echo "Hacked" >> /var/restricted/admin_test.txt
exit
