# 💬 Interview Q&A — Lab 03: Preparing the Lab Environment

---

## 1) Why do security labs commonly use virtualization?
Virtualization enables safe testing by isolating lab systems from the host environment. It reduces risk when experimenting with monitoring agents, misconfigurations, and simulated attacks.

---

## 2) What is the main purpose of building a SIEM-dedicated VM?
A SIEM-dedicated VM provides a controlled system where SIEM components, agents, and test log sources can be deployed consistently without affecting the host machine.

---

## 3) Why use VirtualBox CLI (VBoxManage) instead of the GUI?
In headless or cloud environments there is no GUI. VBoxManage allows:
- automated provisioning
- scripting and repeatable builds
- server-side VM administration

---

## 4) What does NAT networking provide for a VM?
NAT allows the VM to access the internet through the host’s network connection while keeping the VM private and not directly reachable from outside networks by default.

---

## 5) What are typical IP settings for VirtualBox NAT inside a VM?
Common defaults:
- VM IP: `10.0.2.15/24`
- Gateway: `10.0.2.2`
- DNS: `10.0.2.3` or inherited host DNS

---

## 6) What does `VBoxManage createvm` do?
It creates and registers a new VM definition (name, OS type, configuration file path) with VirtualBox.

---

## 7) Why allocate 2048 MB memory and 2 CPUs for the SIEM VM?
SIEM services can be resource-heavy. 2 GB RAM and 2 CPUs is a realistic baseline to run logging agents, dashboards, and analysis workloads.

---

## 8) What is a VDI disk?
VDI is VirtualBox’s disk image format. A dynamically allocated VDI grows as data is written, which saves space compared to fixed allocation.

---

## 9) Why create a SATA controller and attach a disk?
The VM needs a storage controller and a disk device to install an operating system and store SIEM data/logs.

---

## 10) What did the ISO attachment error indicate?
It showed the ISO file was not present locally. This is common in cloud labs where the ISO is not downloaded to the filesystem, so the attach command fails correctly.

---

## 11) What is the value of documenting network settings early?
It prevents confusion later, especially when troubleshooting:
- agent communication issues
- NAT routing problems
- firewall restrictions
- log forwarding connectivity

---

## 12) Why was the host interface `ens5` documented?
Because it shows the hypervisor host’s IP and routing, which matters for:
- outbound connectivity
- access to external repositories
- understanding upstream gateways in a cloud environment

---

## 13) How does this lab connect to SIEM deployment work later?
Once the VM exists and networking is documented, it becomes easier to:
- install SIEM tools inside the VM
- deploy agents on test endpoints
- test log forwarding and alerting pipelines

---
