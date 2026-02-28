# VM Network Documentation (SIEM-VM)

## Host (Lab Machine) Network Settings
- Interface: ens5
- Host IP: 172.31.10.241/20
- Default Gateway: 172.31.0.1
- Notes: Cloud instance networking (EC2-style). Used as the hypervisor host in this lab.

## SIEM-VM Network Settings (VirtualBox NAT)
- Adapter 1: NAT (VirtualBox default NAT)
- Expected VM IP format (inside VM after install): 10.0.2.15/24
- Expected NAT gateway (inside VM): 10.0.2.2
- Expected DNS (inside VM): 10.0.2.3 or inherited host DNS

## What to capture after OS install
Run inside the VM:
- ip addr show
- ip route

Record:
- VM IP address and CIDR prefix (subnet mask)
- Default gateway
- DNS servers (from /etc/resolv.conf)
