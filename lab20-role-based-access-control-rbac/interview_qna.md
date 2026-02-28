# 🎤 Interview Q&A — Lab 20: Role-Based Access Control (RBAC)

## 1) What is RBAC and why is it used?
RBAC (Role-Based Access Control) is an access control model where permissions are assigned to roles, and users get access based on their role membership. It’s used to enforce least privilege, simplify access management, and reduce risk.

---

## 2) How did you implement RBAC in this lab on Linux?
I implemented RBAC using:
- Linux groups as “roles” (`analyst`, `admin`)
- users mapped to roles (`analyst_user`, `admin_user`)
- file ownership and permission bits (`chown`, `chmod`)
- ACLs (`setfacl`, `getfacl`) for precise read-only behavior

---

## 3) Why isn’t `usermod` installed as a separate package on Ubuntu?
`usermod` is provided by the `passwd` package (as a system utility under `/usr/sbin/usermod`). It’s not distributed as its own standalone package.

---

## 4) What does `chmod 750` mean, and how did it affect the analyst role?
`750` means:
- owner: `rwx`
- group: `r-x` (read/execute)
- others: `---`

When `/var/restricted` was owned by `root` and grouped to `analyst`, the analyst user could enter/list but could not create or modify files (no write permission).

---

## 5) What does `chmod 770` mean, and why did it block analyst access?
`770` means:
- owner: `rwx`
- group: `rwx`
- others: `---`

After changing owner/group to `admin_user:admin`, only the admin owner/group had access. Since analyst_user is not in admin group, analyst_user had **no read access** (permission denied).

---

## 6) Why did you introduce ACLs in this lab?
Basic UNIX permissions (owner/group/other) were not enough to match the intent:
- Admin needed full access
- Analyst needed read-only access  
ACLs allow fine-grained permission grants per user without changing ownership or weakening admin controls.

---

## 7) What ACL changes did you apply?
- Directory access:
  - `setfacl -m u:analyst_user:rx /var/restricted`
- File read access:
  - `setfacl -m u:analyst_user:r /var/restricted/admin_test.txt`

This allowed analyst_user to traverse the directory and read the file, but not modify it.

---

## 8) How did you verify the ACL was applied?
I used:
- `getfacl /var/restricted`
It showed `user:analyst_user:r-x` which confirms the per-user ACL entry is in effect.

---

## 9) How did you validate role behavior?
By switching users with `su -` and attempting real actions:
- analyst_user:
  - write attempt → permission denied
  - read attempt before ACL → permission denied
  - read after ACL → allowed
  - append after ACL → denied
- admin_user:
  - write to directory → success

---

## 10) What is the security benefit of read-only access for analysts?
It enforces least privilege. Analysts can view evidence/logs without being able to alter data, reducing risk of:
- accidental modifications
- malicious tampering
- integrity loss during investigations

---

## 11) In a SOC environment, where would RBAC apply?
Examples:
- SIEM dashboards: analysts view alerts; admins manage integrations/rules
- log servers: analysts read evidence; admins manage pipeline configs
- incident response tooling: role-based approvals for containment actions

---

## 12) What risks exist if RBAC is not implemented properly?
- privilege creep (users keep access they don’t need)
- higher blast radius if accounts are compromised
- accidental misconfiguration by users who shouldn’t have write access
- audit/compliance failures

---

## 13) When should you prefer ACLs over group permissions?
Use ACLs when:
- multiple roles need different permission levels on the same resource
- you need per-user exceptions without changing ownership
- group-based model becomes too rigid or forces insecure workarounds

---

## 14) How does PAM relate to RBAC?
PAM is a framework for authentication and authorization policies on Linux (login rules, access controls, MFA integration, restrictions). RBAC can be enforced at multiple layers; PAM can help restrict *who can log in / how* while filesystem permissions/ACLs restrict *what they can access*.

---

## 15) What production hardening would you add to this RBAC setup?
- enforce sudo policies via `/etc/sudoers.d/`
- limit shell access for some roles
- audit file access attempts (auditd)
- use centralized identity (LDAP/IdM)
- add MFA / strong authentication controls via PAM modules
- define and document access policies with periodic review
