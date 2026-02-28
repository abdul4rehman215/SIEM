#!/bin/bash
# Lab 03 - Preparing the Lab Environment
# Commands executed during lab (sequential, no explanations)

# Task 1: Install VirtualBox (Linux evidence)
cat /etc/os-release
sudo apt update
sudo apt install -y virtualbox
vboxmanage --version

# Task 2: Create SIEM VM (headless)
mkdir -p ~/SIEM_VM_Lab && cd ~/SIEM_VM_Lab
VBoxManage createvm --name "SIEM-VM" --ostype "Ubuntu_64" --register
VBoxManage modifyvm "SIEM-VM" --memory 2048 --cpus 2
VBoxManage createhd --filename "$HOME/VirtualBox VMs/SIEM-VM/SIEM-VM.vdi" --size 20480 --format VDI
VBoxManage storagectl "SIEM-VM" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "SIEM-VM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/SIEM-VM/SIEM-VM.vdi"

# Task 2 (continued): Network configuration
VBoxManage modifyvm "SIEM-VM" --nic1 nat
VBoxManage showvminfo "SIEM-VM" | grep -i "NIC 1"

# Task 3: ISO note + attach attempt + start VM
ls -lh
echo "Ubuntu ISO downloaded separately and stored as: ubuntu-24.04.1-live-server-amd64.iso" > vm_install_notes.txt
cat vm_install_notes.txt
VBoxManage storageattach "SIEM-VM" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium ubuntu-24.04.1-live-server-amd64.iso
VBoxManage startvm "SIEM-VM" --type headless
VBoxManage list runningvms

# Task 3 (continued): Document network settings (host + expected VM NAT)
ip addr show ens5
ip route
nano vm_network_documentation.md
cat vm_network_documentation.md
