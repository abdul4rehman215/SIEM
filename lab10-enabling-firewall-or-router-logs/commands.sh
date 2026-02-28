#!/bin/bash
# Lab 10 - Enabling Firewall or Router Logs
# Commands executed during lab (sequential, no explanations)

# --- Router/Firewall (OpenWrt) section ---
ssh admin@192.168.1.1

# On router after login:
ps | grep -E "logd|syslog"
uci show system.@system[0] | grep -E "log_|log"

uci set system.@system[0].log_ip='10.0.2.15'
uci set system.@system[0].log_port='514'
uci set system.@system[0].log_proto='udp'
uci commit system

uci set system.@system[0].conloglevel='8'
uci set system.@system[0].cronloglevel='8'
uci commit system

/etc/init.d/log restart
uci show system.@system[0] | grep -E "log_ip|log_port|log_proto|conloglevel|cronloglevel"

logger -p local0.notice "Firewall/Router syslog test from $(hostname)"

# --- SIEM Receiver (CentOS 7) section ---
ip a show eth0
sudo tcpdump -i eth0 'udp port 514 and host 192.168.1.1' -nn
sudo tail -n 10 /var/log/messages
