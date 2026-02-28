# 🧪 Lab 03: Preparing the Lab Environment

## 🧾 Lab Summary
This lab focuses on preparing a **virtualization-based lab environment** suitable for SIEM experiments. The lab covers:
- Installing and verifying virtualization software (VirtualBox)
- Creating a SIEM-dedicated virtual machine using **VBoxManage** (headless CLI workflow)
- Configuring VM networking (NAT)
- Documenting host and expected VM network settings for operational tracking

Because this was performed in a cloud-based Linux terminal environment (no GUI), the VM creation was demonstrated using **VirtualBox CLI**, which is a realistic method used in headless servers and automation workflows.

---

## 🎯 Objectives
By the end of this lab, I was able to:
- Understand the essentials of setting up a virtual environment
- Install and configure virtualization software
- Create and configure a VM dedicated to SIEM tasks
- Configure and validate VM network settings (NAT)
- Document host IP, routing, and expected VM NAT settings for later troubleshooting and reference

---

## ✅ Prerequisites
- Basic understanding of computer networking
- Administrative privileges on the system
- Internet connectivity for downloading and installing packages

---

## 🧪 Lab Environment
- **Platform:** Cloud Lab (Ubuntu/Debian environment)
- **OS:** Ubuntu 24.04.1 LTS
- **User:** `toor`
- **Prompt style:** `toor@ip-172-31-10-241:~$` (IP tail may vary)
- **Virtualization Tool:** VirtualBox (installed via `apt`)
- **VM Type:** Ubuntu 64-bit (VirtualBox `Ubuntu_64`)

---

## 🛠️ Tasks Overview (What I Did)

### ✅ Task 1 — Install Virtualization Software (VirtualBox)
- Verified OS version
- Updated package lists
- Installed VirtualBox using `apt`
- Verified installation using `vboxmanage --version`

> 📌 Note: VMware Player was documented as an alternative hypervisor, but VirtualBox was used in this environment.

---

### ✅ Task 2 — Create a Virtual Machine for SIEM (Headless)
Since this lab was executed in a terminal environment without GUI access:
- Created a VM named **SIEM-VM** using `VBoxManage createvm`
- Allocated:
  - **RAM:** 2048 MB
  - **CPU:** 2 cores
- Created a **20 GB VDI** disk
- Created a SATA storage controller and attached the VDI

---

### ✅ Task 3 — Configure and Document Network Settings
- Configured **NIC 1 = NAT** for basic internet access
- Verified NIC configuration using `VBoxManage showvminfo`
- Documented:
  - Host network interface (`ens5`) IP details
  - Host routing table
  - Expected VirtualBox NAT addressing inside the VM (typical `10.0.2.15/24`)
- Attempted to attach Ubuntu ISO (not present locally in cloud instance), documented the failure reason, and still started the VM headless for verification

---

## ✅ Verification & Validation
- Verified VirtualBox installation:
  - `vboxmanage --version`
- Verified VM creation and registration:
  - `VBoxManage showvminfo "SIEM-VM"`
- Verified NIC configuration:
  - `grep -i "NIC 1"`
- Verified VM started:
  - `VBoxManage list runningvms`
- Documented host network settings:
  - `ip addr show ens5`
  - `ip route`
- Created and validated documentation artifacts:
  - `cat vm_network_documentation.md`

---

## 📁 Repository Structure
```text
lab03-preparing-the-lab-environment/
├── README.md
├── commands.sh
├── output.txt
├── interview_qna.md
├── troubleshooting.md
└── evidence/
    └── SIEM_VM_Lab/
        ├── vm_install_notes.txt
        └── vm_network_documentation.md
````

---

## 🌍 Why This Matters

A stable lab environment is the foundation for reliable SIEM learning:

* Virtual machines allow safe testing of monitoring agents, log pipelines, and attacks
* Network documentation prevents confusion later during troubleshooting
* Headless VM workflows are common in cloud labs and DevOps/SRE automation environments

---

## 🧩 Real-World Applications

* Building isolated labs for SOC/SIEM practice
* Reproducible testing environments for incident response simulations
* Automated VM provisioning using CLI (useful in enterprise lab setups)
* Network baseline documentation for troubleshooting connectivity and log flow issues

---

## ✅ Result

* VirtualBox installed and verified successfully (`7.0.14_Ubuntu`)
* SIEM-VM created using VBoxManage
* Disk and storage controller configured successfully
* NAT networking enabled and validated
* VM started in headless mode and confirmed running
* Host network settings and expected VM NAT settings documented for future reference
* ISO attachment attempt documented (failed due to missing ISO file in cloud instance)

---

## 🏁 Conclusion

This lab established a virtualization environment ready for SIEM labs by installing VirtualBox, creating a SIEM-focused VM via CLI, configuring NAT networking, and recording essential network documentation. This provides a robust baseline for future SIEM deployments and network-based monitoring experiments.

✅ Lab completed successfully on a cloud Ubuntu environment
✅ VM created + NAT configured + network documentation recorded

----
