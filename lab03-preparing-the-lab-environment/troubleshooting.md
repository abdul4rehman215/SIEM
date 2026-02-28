# 🛠️ Troubleshooting Guide — Lab 03: Preparing the Lab Environment

---

## Issue 1: `virtualbox` installation fails or dependencies missing

### ❌ Problem
`sudo apt install virtualbox` fails with dependency errors.

### ✅ Causes
- Package lists outdated
- Repository connectivity issues
- Partial upgrades

### ✅ Resolution
```bash
sudo apt update
sudo apt -f install
sudo apt install -y virtualbox
````

---

## Issue 2: `VBoxManage` command not found

### ❌ Problem

Running `VBoxManage` returns command not found.

### ✅ Cause

VirtualBox not installed or not in PATH.

### ✅ Resolution

Install VirtualBox:

```bash
sudo apt update
sudo apt install -y virtualbox
```

Verify:

```bash
vboxmanage --version
```

---

## Issue 3: ISO attachment fails (file not found)

### ❌ Problem

```text
VBoxManage: error: Could not find file for the medium 'ubuntu-24.04.1-live-server-amd64.iso'
```

### ✅ Cause

ISO file does not exist in the current directory or path referenced.

### ✅ Resolution

Confirm the ISO file exists:

```bash
ls -lh
```

If not present:

* Download ISO and store it locally (desktop/lab dependent)
* Or update command to correct path:

```bash
VBoxManage storageattach "SIEM-VM" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium /path/to/ubuntu.iso
```

---

## Issue 4: VM starts but OS is not installed

### ❌ Problem

VM starts headless but cannot install OS.

### ✅ Cause

No bootable ISO attached.

### ✅ Resolution

Attach ISO correctly (ensure file exists):

```bash
VBoxManage storageattach "SIEM-VM" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium ubuntu.iso
```

Then restart VM:

```bash
VBoxManage controlvm "SIEM-VM" poweroff
VBoxManage startvm "SIEM-VM" --type headless
```

---

## Issue 5: Network issues inside VM (NAT)

### ❌ Problem

VM has no internet access.

### ✅ Causes

* Incorrect NIC mode
* Host network restrictions
* VM interface down

### ✅ Resolution

Verify NIC mode:

```bash
VBoxManage showvminfo "SIEM-VM" | grep -i "NIC 1"
```

Ensure NAT:

```bash
VBoxManage modifyvm "SIEM-VM" --nic1 nat
```

Inside VM (after OS install):

```bash
ip addr show
ip route
cat /etc/resolv.conf
```

---

