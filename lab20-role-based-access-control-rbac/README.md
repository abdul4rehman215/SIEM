# 🧪 Lab 20: Role-Based Access Control (RBAC)

## 🧾 Lab Summary
This lab implements **Role-Based Access Control (RBAC)** on a Linux system by creating two roles:

- **Analyst role** → intended to have **read-only** access to a protected directory/file
- **Admin role** → intended to have **full access** (read/write) to the same protected directory/file

I implemented access control using:
- Linux **users + groups** (foundational RBAC building blocks)
- Linux **file permissions (chmod/chown)**
- Linux **ACLs (setfacl/getfacl)** to achieve the lab’s intended "read-only" access for the analyst role without breaking admin ownership

This mirrors real RBAC design in security operations:
✅ define roles → ✅ assign identities → ✅ apply controls → ✅ test role behavior → ✅ adjust to meet least privilege.

---

## 🎯 Objectives
By the end of this lab, I was able to:

- Understand RBAC concepts and why they matter in secure environments
- Create and manage user roles using Linux groups
- Implement read-only restrictions for an Analyst role
- Provide full access to an Admin role
- Validate access control by switching roles and testing real operations
- Use ACLs for precise permission management when basic group permissions are not sufficient

---

## 📌 Prerequisites
- Basic Linux CLI knowledge
- Understanding of users, groups, and permissions
- Admin privileges on the system

---

## 🧪 Lab Environment
| Component | Details |
|---|---|
| OS | Ubuntu 24.04.1 LTS |
| Environment | Cloud Lab Environment |
| User | `toor` |
| Roles Created | `analyst_user`, `admin_user` |
| Access Control Methods | chmod/chown + ACL (setfacl/getfacl) |

---

## 🗂️ Repository Structure
```text
lab20-role-based-access-control-rbac/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
├── configs/
│   ├── permissions-plan.md
│   └── acl-state.txt
└── artifacts/
    ├── users-and-groups.txt
    ├── restricted-dir-perms-before.txt
    ├── restricted-dir-perms-after.txt
    └── admin-file-test-results.txt
````

> Notes:
>
> * `configs/` captures the final permission model (including ACL state).
> * `artifacts/` captures evidence outputs validating RBAC behavior.

---

## 🧩 Tasks Overview (What I Performed)

### ✅ Task 1: Setup Environment

* Updated package lists and upgraded system packages
* Installed required packages

  * Noted: `usermod` is not a standalone package on Ubuntu (provided by `passwd`)
  * Installed `libpam0g-dev` as requested for PAM-related tooling readiness
* Verified that `usermod` exists on the system

### ✅ Task 2: Create User Roles (Groups + Users)

Created two RBAC roles using Linux groups:

#### Analyst role

* Group: `analyst`
* User: `analyst_user` (primary group: analyst)
* Password set to support role switching (`su - analyst_user`)

#### Admin role

* Group: `admin`
* User: `admin_user` (primary group: admin)
* Password set to support role switching (`su - admin_user`)

Validated membership using `id`.

---

### ✅ Task 3: Implement Access Controls

#### 3.1 Create protected directory

* Created: `/var/restricted`

#### 3.2 Initial setup for analyst read-only intent (group permissions)

Initial configuration:

* owner: `root`
* group: `analyst`
* permissions: `750`

Meaning:

* root: full access
* analyst group: read + execute
* others: no access

This allowed the analyst role to enter/list, but not write.

Validated by switching to `analyst_user` and attempting to create a file (permission denied).

#### 3.3 Admin full access

Updated directory to:

* owner: `admin_user`
* group: `admin`
* permissions: `770`

Meaning:

* admin user/group: full access
* others: no access

Validated by switching to `admin_user` and creating a file successfully.

---

### ✅ Task 4: Test Role Switching + Adjust to Match Read-Only Requirement

#### 4.1 Observed real Linux behavior (important)

After setting `/var/restricted` to `770` and group `admin`, the analyst role had **no access**, including read access.
This is correct under standard Linux permissions (least privilege).

#### 4.2 Implemented precise RBAC intent using ACLs

To achieve the lab’s intended model:

* Admin keeps full control
* Analyst gets **read-only** access

I applied ACLs:

* granted `analyst_user` **rx** on the directory
* granted `analyst_user` **r** on the file `admin_test.txt`

Then retested:

* `analyst_user` could **read** the file
* `analyst_user` could **not modify** the file (permission denied)

This matches real-world RBAC/least privilege more accurately.

---

## 🔍 Verification & Validation

This lab is successful when:

* ✅ `analyst_user` exists and belongs to `analyst`
* ✅ `admin_user` exists and belongs to `admin`
* ✅ `admin_user` can write to `/var/restricted`
* ✅ `analyst_user` cannot write to protected resources
* ✅ With ACLs applied:

  * `analyst_user` can read required content
  * `analyst_user` cannot modify it
* ✅ ACL state can be verified using:

  * `getfacl /var/restricted`

---

## 🧠 What I Learned

* Linux groups + permissions provide a strong baseline RBAC model.
* Real RBAC requirements often exceed basic UNIX permission bits (owner/group/other).
* ACLs allow **fine-grained control** without changing ownership models or weakening admin controls.
* Always validate role behavior with real tests (`su`, create, read, append) rather than assuming a permission design works.

---

## 🌍 Why This Matters (Real-World Relevance)

RBAC is essential for:

* SOC environments (analysts vs admins vs engineers)
* limiting blast radius during compromise
* meeting compliance requirements (least privilege)
* preventing unauthorized changes to critical systems and evidence

In SIEM/SOC workflows:

* Analysts often need **read-only** access to logs/evidence
* Admins need **write/admin** access for configuration and response actions

---

## ✅ Result

* ✅ RBAC roles created: Analyst + Admin
* ✅ Access controls implemented using Linux permissions
* ✅ Admin full access validated
* ✅ Analyst write denied validated
* ✅ Read-only intent achieved precisely using ACLs
* ✅ Evidence collected for GitHub upload

---

## 🏁 Conclusion

This lab successfully implemented RBAC on Ubuntu using standard Linux security controls. By combining groups/permissions with ACLs, I achieved a realistic “Analyst read-only vs Admin full access” design and validated it through role switching and real access tests—demonstrating least privilege in a practical system administration and security context.

---
