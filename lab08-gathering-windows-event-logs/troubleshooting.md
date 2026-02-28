# 🛠️ Troubleshooting Guide — Lab 08: Gathering Windows Event Logs

---

## Issue 1: Winlogbeat download fails (Invoke-WebRequest)

### ❌ Problem
Download fails due to TLS/network restrictions.

### ✅ Resolution
- Confirm internet access
- Try PowerShell with explicit TLS settings (if required by environment)
- Use browser download as fallback

---

## Issue 2: Winlogbeat extraction shows no output

### ✅ Explanation
`Expand-Archive` often shows no output when successful.

### ✅ Validation
```powershell
Get-ChildItem "C:\Program Files\Winlogbeat" | Select-Object -First 10
````

---

## Issue 3: Service install script fails

### ❌ Problem

`install-service-winlogbeat.ps1` fails.

### ✅ Causes

* not running PowerShell as Administrator
* blocked script execution policy

### ✅ Resolution

Run PowerShell as Admin and (if needed) allow script execution:

```powershell id="vsvz6g"
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
.\install-service-winlogbeat.ps1
```

---

## Issue 4: `Start-Service winlogbeat` fails

### ❌ Problem

Cannot start service / already running / service control error.

### ✅ Resolution

Check status:

```powershell id="7zyo6q"
Get-Service winlogbeat
```

If running and config changed:

```powershell id="dyvvt8"
Restart-Service winlogbeat
```

---

## Issue 5: No events appear in Kibana

### ❌ Problem

Winlogbeat runs, but SIEM shows no Windows events.

### ✅ Causes

* output.elasticsearch host unreachable
* firewall/port blocked
* incorrect credentials
* wrong index pattern in Kibana

### ✅ Resolution

* Validate output section:

```powershell id="x10x8p"
Select-String -Path .\winlogbeat.yml -Pattern "output\." -Context 0,6
```

* Confirm Elasticsearch reachable from Windows host
* Check Winlogbeat logs in `.\logs`
* Ensure Kibana index pattern includes winlogbeat indices (e.g., `winlogbeat-*`)

---

## Issue 6: Storing credentials in winlogbeat.yml is unsafe

### ✅ Note

For labs it may be shown for realism, but for production:

* use Elastic keystore
* enforce TLS
* avoid committing real passwords to repositories

---
