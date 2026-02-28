# 🛠️ Troubleshooting Guide — Lab 36: Automating Simple Responses (SOAR Lite)

> This guide covers common issues installing osquery, using iptables safely, testing with nmap, and integrating/validating StackStorm triggers.

---

## 1) osquery install fails (package not found)

### ❗ Problem
`sudo apt-get install osquery` fails in default repos.

### ✅ Cause
On Ubuntu 24.04, osquery is commonly installed via the official osquery repository.

### ✅ Resolution (Lab approach)
```bash
sudo apt-get update
sudo apt-get install -y curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkg.osquery.io/deb/pubkey.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/osquery.gpg
echo "deb [signed-by=/etc/apt/keyrings/osquery.gpg] https://pkg.osquery.io/deb deb main" | sudo tee /etc/apt/sources.list.d/osquery.list
sudo apt-get update
sudo apt-get install -y osquery
````

### ✅ Prevention

Verify repo support for your OS version before installing security tooling.

---

## 2) `osqueryd` service not running

### ❗ Problem

`systemctl status osqueryd` shows inactive/failed.

### ✅ Resolution

Enable and start:

```bash
sudo systemctl enable --now osqueryd
systemctl status osqueryd --no-pager
```

Check logs:

```bash
sudo journalctl -u osqueryd --no-pager | tail -n 80
```

### ✅ Prevention

Always validate agent services are running before testing detection workflows.

---

## 3) iptables command fails or rules don’t apply

### ❗ Problem

`iptables` errors or rules not shown.

### ✅ Possible Causes

* Not running as root
* nftables backend differences
* iptables not installed

### ✅ Resolution

Run with sudo:

```bash
sudo iptables -L
```

Install iptables tools if missing:

```bash
sudo apt-get update
sudo apt-get install -y iptables
```

### ✅ Prevention

Use `sudo` and confirm firewall tooling exists before scripting.

---

## 4) Blocking rule works but you accidentally lock yourself out (real remote servers)

### ❗ Problem

Blocking the wrong IP may cut off SSH access.

### ✅ Prevention (IMPORTANT)

* Test using loopback (like this lab) or a non-critical test subnet.
* Add rules carefully and document changes.
* Prefer safer firewall tooling (e.g., ufw/firewalld) in production environments.
* Use “temporary rules” first when possible.

### ✅ Recovery

If you still have console access, remove the rule:

```bash
sudo iptables -D INPUT -s <IP> -j DROP
sudo iptables -L
```

---

## 5) Script doesn’t run (`Permission denied`)

### ❗ Problem

Running `./auto_block.sh` fails.

### ✅ Resolution

Make executable:

```bash
chmod +x auto_block.sh
```

Run with sudo (iptables needs root):

```bash
sudo ./auto_block.sh 127.0.0.2
```

### ✅ Prevention

Always verify script permissions and privileges before integrating automation.

---

## 6) nmap scan doesn’t reflect “filtered” after blocking

### ❗ Problem

After blocking, nmap still shows open/closed.

### ✅ Possible Causes

* Rule applied to wrong chain (INPUT vs OUTPUT)
* Wrong IP used
* Localhost testing nuance (loopback)
* Caching / scan type differences

### ✅ Resolution

Confirm rule exists:

```bash
sudo iptables -L -n
```

Ensure the correct source IP is blocked:

```bash
sudo iptables -L INPUT -n --line-numbers
```

Repeat scan using the same source IP:

```bash
sudo nmap -sS -p 22 -S 127.0.0.2 127.0.0.1
```

### ✅ Prevention

Use `-n` and verify exact IP matches before re-testing.

---

## 7) Loopback alias already exists (`File exists`) or causes confusion

### ❗ Problem

`ip addr add 127.0.0.2/8 dev lo` fails or duplicates.

### ✅ Resolution

Check existing loopback addresses:

```bash
ip a show lo
```

If needed, delete it:

```bash
sudo ip addr del 127.0.0.2/8 dev lo
```

### ✅ Prevention

Use a consistent test IP and verify interface config before running scans.

---

## 8) StackStorm `st2` command not found

### ❗ Problem

`st2 rule create ...` fails because StackStorm isn’t installed.

### ✅ Cause

StackStorm is heavy and often pre-installed only in training images. Some labs assume it exists.

### ✅ Resolution (Lab-safe approach)

* Keep the YAML rule file as the integration artifact.
* Validate the automation by running the script manually (as done in this lab).

### ✅ Prevention

If you want full orchestration testing, prepare a StackStorm-enabled lab VM or container.

---

## 9) Rule created but it never triggers

### ❗ Problem

StackStorm rule exists but action doesn’t run.

### ✅ Possible Causes

* Trigger event not emitted
* Criteria field mismatch (payload key names differ)
* Action path incorrect

### ✅ Resolution

Verify the action command path is correct and executable:

```bash
ls -l /home/toor/Lab36_SOAR_Lite/auto_block.sh
```

Validate rule details:

```bash
st2 rule get auto_block_on_portscan
```

### ✅ Prevention

Standardize alert payload format and test with a known trigger event.

---

## 10) No audit trail for automation actions

### ❗ Problem

You can’t prove what automation changed.

### ✅ Resolution

Log actions:

```bash
echo "$(date -u) - Auto-block executed for IP <IP>" | tee -a soar_actions.log
```

### ✅ Prevention

Always store response actions in a local log file or forward to SIEM.

---
