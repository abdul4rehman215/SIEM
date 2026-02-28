# scripts/auto_block.sh
#!/bin/bash
IP_ADDRESS=$1

iptables -A INPUT -s "$IP_ADDRESS" -j DROP
echo "Blocked IP: $IP_ADDRESS"
