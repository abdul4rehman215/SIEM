# RBAC Permission Plan (Lab 20)

This lab implements two roles:
- **Admin role** (`admin_user`, group `admin`) → full access
- **Analyst role** (`analyst_user`, group `analyst`) → read-only access

## Phase 1: Basic UNIX Permissions (chmod/chown)

### Restricted directory created:
- `/var/restricted`

### Analyst read-only style (initial)
```text
owner: root
group: analyst
mode: 750  (rwxr-x---)
````

Meaning:

* root: rwx
* analyst group: r-x (read/list + enter, no write)
* others: no access

✅ Expected:

* analyst_user can access directory but cannot create/modify files.

### Admin full access (later)

```text
owner: admin_user
group: admin
mode: 770 (rwxrwx---)
```

Meaning:

* admin_user + admin group: full
* others: no access

✅ Expected:

* admin_user can create/modify files
* analyst_user has no access (not in admin group)

## Phase 2: Fine-Grained RBAC with ACLs (setfacl/getfacl)

Issue discovered (expected Linux behavior):

* With `770` and group `admin`, analyst_user cannot even read.
* But lab intent requires **analyst read-only access**.

Solution:

* Keep admin ownership and full access.
* Add ACL entries to grant analyst_user only the minimum required access.

Applied ACLs:

* Directory: allow analyst_user to traverse/list:

  * `u:analyst_user:rx`
* File: allow analyst_user to read:

  * `u:analyst_user:r`

✅ Final Result:

* admin_user: full control (read/write)
* analyst_user: read-only
* analyst_user cannot modify the admin file

---
