# 🧠 Interview Q&A — Lab 36: Automating Simple Responses (SOAR Lite)

---

## 1) What is SOAR?
SOAR stands for **Security Orchestration, Automation, and Response**. It helps security teams automate repetitive tasks, orchestrate workflows across tools, and standardize incident response actions.

---

## 2) What does “SOAR Lite” mean in this lab?
It means using lightweight automation for a single, simple playbook (detect → block IP) instead of a full enterprise SOC automation program.

---

## 3) What alert scenario was chosen for automation?
A **port scan detection** scenario where a scanning IP should be automatically blocked.

---

## 4) What tool was used for endpoint monitoring/detection?
**osquery** was used to detect suspicious activity on the host. In this lab, detection was simplified to checking for **nmap execution**.

---

## 5) Why use osquery for detection?
osquery allows querying system state like a database (processes, sockets, users, etc.). It’s lightweight and flexible, which works well for simple detection logic.

---

## 6) What response action was automated?
A firewall rule was added to drop traffic from the attacker IP using:
- `iptables -A INPUT -s <IP> -j DROP`

---

## 7) What does the script `auto_block.sh` do?
It accepts an IP address as an argument and appends a DROP rule to the INPUT chain, then prints confirmation:
- “Blocked IP: <IP>”

---

## 8) How was the attack simulated in a single-host lab?
A loopback alias was added:
- `127.0.0.2`
Then `nmap` was run using that source IP to scan localhost.

---

## 9) Why was a smaller port range used instead of 1–65535?
Scanning all 65,535 ports is time-consuming and noisy in lab environments. A reduced range (1–2000) is realistic for demonstration while still showing the detection/response workflow.

---

## 10) How was the detection verified?
By querying osquery for the running process:
```sql
SELECT pid, name, path, cmdline, uid FROM processes WHERE name='nmap';
````

---

## 11) How did you verify the firewall rule was added?

By listing iptables rules:

```bash
sudo iptables -L
```

The INPUT chain showed a DROP rule for `127.0.0.2`.

---

## 12) How did you verify the block was effective?

A follow-up nmap scan showed the port changed to **filtered**, indicating packets were being dropped:

* `22/tcp filtered ssh`

---

## 13) What is the role of StackStorm in this lab?

StackStorm acts as the orchestration layer that connects an alert trigger event to an automated action (running `auto_block.sh` with the attacker IP).

---

## 14) Why is logging the automation action important?

It creates an audit trail for:

* accountability (what was done and when)
* incident documentation
* post-incident review and tuning

---

## 15) What is the main takeaway from this lab?

Even simple automation—like blocking a scanning IP—can significantly reduce response time and standardize first-response containment actions, which is the core value of SOAR.

---
