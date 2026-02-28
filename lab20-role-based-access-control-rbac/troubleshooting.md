# 🛠️ Troubleshooting Guide — Lab 20: Role-Based Access Control (RBAC)

> This guide covers common issues when implementing RBAC on Linux using users, groups, permissions, and ACLs.

---

## 1) `apt install usermod` fails: "no installation candidate"

### ✅ Symptoms
- `sudo apt install usermod ...` returns:
  - `Package usermod is not available...`
  - `E: Package 'usermod' has no installation candidate`

### ✅ Explanation
`usermod` is not a standalone package on Ubuntu. It is provided by the `passwd` package and exists as `/usr/sbin/usermod`.

### ✅ Fix
Install/pass verify:
```bash
sudo apt install passwd -y
which usermod
usermod --help | head
````

---

## 2) `groupadd` fails: group already exists

### ✅ Symptoms

* `sudo groupadd analyst` returns:

  * `groupadd: group 'analyst' already exists`

### ✅ Fix

This is not an error if the role already exists. Verify:

```bash id="5sxx6v"
getent group analyst
getent group admin
```

If you need to delete/recreate (lab only, careful):

```bash
sudo groupdel analyst
sudo groupdel admin
```

---

## 3) `useradd` fails: user already exists

### ✅ Symptoms

* `sudo useradd ... analyst_user` returns:

  * `useradd: user 'analyst_user' already exists`

### ✅ Fix

Verify user:

```bash
id analyst_user
id admin_user
```

If you need to recreate (lab-only cleanup):

```bash
sudo userdel -r analyst_user
sudo userdel -r admin_user
```

---

## 4) `su - analyst_user` fails (authentication failure)

### ✅ Symptoms

* `su` prompts for password, then:

  * `su: Authentication failure`

### ✅ Fix

Set/reset the user password:

```bash id="okx4h3"
sudo passwd analyst_user
sudo passwd admin_user
```

Ensure you type it correctly during `su`.

---

## 5) Analyst can still write to restricted directory (unexpected)

### ✅ Symptoms

* `echo "Test" > /var/restricted/test_file.txt` succeeds for `analyst_user`

### ✅ Cause

Directory permissions are too permissive (e.g., group has write) or ownership/group not as intended.

### ✅ Fix

Check current ownership and permissions:

```bash id="twg5sx"
ls -ld /var/restricted
```

Reset to intended “analyst read-only (no write)” setup:

```bash
sudo chown root:analyst /var/restricted
sudo chmod 750 /var/restricted
ls -ld /var/restricted
```

---

## 6) Analyst cannot even read (but lab expects read-only)

### ✅ Symptoms

* `cat /var/restricted/admin_test.txt` returns:

  * `Permission denied`

### ✅ Explanation (Important Linux behavior)

If directory is `770` and owned by `admin_user:admin`, then:

* only admin owner/group can access
* analyst role has **zero** access
  This is correct, but it doesn’t match the lab’s read-only intent.

### ✅ Fix (Use ACLs for fine-grained RBAC)

Install ACL tools:

```bash
sudo apt install acl -y
```

Grant analyst_user read-only access:

```bash
sudo setfacl -m u:analyst_user:rx /var/restricted
sudo setfacl -m u:analyst_user:r /var/restricted/admin_test.txt
```

Verify ACL:

```bash
getfacl /var/restricted | head -n 20
```

---

## 7) ACL changes don't seem to work

### ✅ Symptoms

* `getfacl` shows entries, but access still denied

### ✅ Fix Checklist

1. Ensure directory traversal is allowed (`x`) at directory level:

* `u:analyst_user:rx` is required, not just `r`

2. Ensure file has read permission for analyst:

* `u:analyst_user:r`

3. Check “mask” is not restricting permissions:

```bash id="wd4n6a"
getfacl /var/restricted
```

If mask is too restrictive, set it:

```bash
sudo setfacl -m m::rx /var/restricted
```

---

## 8) “Permission denied” when using `setfacl` / `getfacl`

### ✅ Symptoms

* Running `setfacl` without sudo fails

### ✅ Fix

ACL changes require privileged access on protected paths:

```bash
sudo setfacl -m u:analyst_user:rx /var/restricted
sudo getfacl /var/restricted
```

---

## 9) Admin can’t write even though it should

### ✅ Symptoms

* `admin_user` cannot create files in `/var/restricted`

### ✅ Fix

Verify owner/group and permissions:

```bash
ls -ld /var/restricted
```

Reset admin ownership + perms:

```bash id="d1y1am"
sudo chown admin_user:admin /var/restricted
sudo chmod 770 /var/restricted
ls -ld /var/restricted
```

---

## ✅ Quick Validation Checklist (After Fixes)

Run:

```bash id="1ft7oy"
ls -ld /var/restricted
getfacl /var/restricted | head -n 20

# Admin test
su - admin_user -c 'echo "Admin Test" > /var/restricted/admin_test.txt && ls -l /var/restricted'

# Analyst tests
su - analyst_user -c 'cat /var/restricted/admin_test.txt'
su - analyst_user -c 'echo "Hacked" >> /var/restricted/admin_test.txt'
```

Expected:

* Admin can write
* Analyst can read
* Analyst cannot modify

---
