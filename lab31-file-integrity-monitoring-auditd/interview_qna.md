# 🧠 Interview Q&A — Lab 31: File Integrity Monitoring (FIM) with auditd

---

## 1) What is File Integrity Monitoring (FIM)?
FIM is a security practice that detects and records changes to files and directories, helping identify unauthorized modifications to critical system data and configurations.

---

## 2) Why is FIM important in cybersecurity?
FIM helps detect:
- unauthorized persistence attempts
- privilege escalation via config tampering
- malware modifying system files
- accidental changes that weaken security
It also supports auditing and compliance requirements.

---

## 3) What tool was used for FIM in this lab?
This lab used **auditd** (Linux Audit Daemon) and related tools:
- `auditctl` (manage rules)
- `ausearch` (search events)
- `aureport` (report summaries)

---

## 4) What file was monitored in this lab and why?
`/etc/passwd` was monitored because it’s a sensitive system file related to user accounts. Unexpected modifications could indicate account manipulation or persistence.

---

## 5) What does this command do?
```bash
sudo auditctl -w /etc/passwd -p wa -k passwd_changes
````

It adds a watch rule on `/etc/passwd` to monitor:

* `w` = writes
* `a` = attribute changes
  and labels events with the key `passwd_changes`.

---

## 6) What is the purpose of the `-k` key in audit rules?

The key is a label that makes searching and reporting easier. You can quickly find related events by searching for the key in audit logs and reports.

---

## 7) How did you verify that the rule was applied?

By listing active rules:

```bash
sudo auditctl -l
```

---

## 8) Why did you make a “safe and insignificant” change to `/etc/passwd`?

To trigger an audit event without risking system breakage. `/etc/passwd` is sensitive, so even a small mistake could affect user logins. A trailing space is low-risk but still produces a change event.

---

## 9) How did you confirm the change was logged?

Using:

```bash
sudo ausearch -f /etc/passwd
```

This searches audit logs for events related to `/etc/passwd`.

---

## 10) What does `aureport -f --summary` show?

It produces a summary report of file-related audit events. Filtering with the key confirms how many events matched the watched rule.

---

## 11) What is the difference between `uid` and `auid` in audit logs?

* `uid` shows the effective user that performed the action (root when using sudo)
* `auid` shows the original authenticated user who started the session (the real actor)

This is important for attribution.

---

## 12) What key forensic details were visible in the audit event?

* timestamp (when)
* target file `/etc/passwd` (what)
* process `nano` (how)
* `uid=0` (executed as root)
* `auid=1001` (original user session)
* audit key `passwd_changes` (grouping label)

---

## 13) What other files are commonly monitored with FIM in real environments?

Examples include:

* `/etc/shadow`
* `/etc/sudoers`
* `/etc/ssh/sshd_config`
* `/etc/hosts`
* critical application configs and policy files

---

## 14) How does auditd-based FIM help incident response?

It provides evidence of:

* which file changed
* which process changed it
* who initiated the change (auid)
* when the change happened
  This supports rapid triage and containment.

---

## 15) What is the main takeaway from this lab?

Auditd can be used to implement a lightweight FIM capability on Linux by watching critical files and validating that changes are recorded for investigation and reporting.

---
