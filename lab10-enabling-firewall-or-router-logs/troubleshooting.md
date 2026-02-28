# 🛠️ Troubleshooting Guide — Lab 10: Enabling Firewall or Router Logs

---

## Issue 1: SSH connection fails to router/firewall

### ❌ Problem
Cannot connect to `ssh admin@192.168.1.1`.

### ✅ Causes
- incorrect IP
- network path not available
- firewall blocks SSH
- wrong credentials

### ✅ Resolution
- verify reachability:
```bash
ping -c 3 192.168.1.1
````

* ensure SSH enabled on router
* confirm correct username/password

---

## Issue 2: Router supports syslog but logs not forwarding

### ❌ Problem

`log_ip` set but SIEM receives nothing.

### ✅ Causes

* wrong SIEM IP
* port blocked (UDP/514)
* wrong protocol
* SIEM receiver not listening

### ✅ Resolution

On router:

* verify UCI fields:

```sh id="gpew4k"
uci show system.@system[0] | grep -E "log_ip|log_port|log_proto"
```

On SIEM receiver:

* verify listening on UDP/514:

```bash id="aq2oj0"
sudo ss -lunp | grep ':514'
```

---

## Issue 3: No packets seen in tcpdump

### ❌ Problem

tcpdump shows no syslog traffic.

### ✅ Causes

* router not sending
* wrong interface selected
* filter incorrect (wrong router IP)
* upstream network restrictions

### ✅ Resolution

* confirm SIEM interface name (e.g., `eth0`) and IP
* loosen filter temporarily:

```bash id="pu8x5h"
sudo tcpdump -i eth0 udp port 514 -nn
```

* generate a test log on router:

```sh id="dn9dq6"
logger -p local0.notice "Firewall/Router syslog test from $(hostname)"
```

---

## Issue 4: Logs received but not written to /var/log/messages

### ❌ Problem

Packets arrive, but file shows no entries.

### ✅ Causes

* rsyslog not configured to accept UDP syslog
* rsyslog service down
* SELinux policy (depending on system)

### ✅ Resolution

* check rsyslog:

```bash id="4h9m0e"
sudo systemctl status rsyslog --no-pager
```

* verify imudp enabled (receiver-side):

```bash id="vd1xg1"
sudo grep -n "imudp" /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null
```

* restart:

```bash id="c7c4u3"
sudo systemctl restart rsyslog
```

---

