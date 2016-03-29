# A Collection of scripts for RHEL7/CentOS7
***Created by: William Thomas Bland***<br>
<br>

nw_bridge.sh
---
* **Description:** Configure a bridged network interface.<br>
* **Usage:** Edit variables with desired network configuration and execute.

nw_static.sh
---
* **Description:** Configure a static IP.<br>
* **Usage:** Edit variables with desired network configuration and execute.

pk_install.sh
---
* **Description:** Perform full update and install essential packages.<br>
* **Usage:** No variables to edit, simply execute script.

sv_dhcpd.sh
---
* **Description:** Configure a dhcp server.<br>
* **Usage:** Edit variables with desired configuration and execute.

sv_dns.sh
---
* **Description:** Configure a dns server.<br>
* **Usage:** Edit variables with desired configuration and execute.

sv_kvm.sh
---
* **Description:** Configure a KVM hypervisor.<br>
* **Usage:** Edit variables with desired network configuration.

sv_localrepo.sh
---
* **Description:** Configure and sync a local repository and set sync schedule.<br>
* **Usage:** Edit variables with desired configuration and execute.

sv_nat.sh
---
* **Description:** Configure a NAT Gateway.<br>
* **Usage:** Edit variables with desired configuration and execute.

sv_ntpd.sh
---
* **Description:** Configure Network Time Protocol.<br>
* **Usage:** Edit variables with desired configuration and execute.

sv_pxeboot.sh
---
* **Description:** configure network booting from local repository.<br>
* **Usage:** Edit the variables with desired configuration and execute.

sv_sshd.sh
---
* **Description:** Configure hardened SSH service.<br>
* **Usage:** Edit variables with desired configuration and execute.

vm_create.ks
---
* **Description:** A kickstart file for an unattended installation of a virtual machine.<br>
* **Usage:** Edit settings to change installation instructions. Root password set to "temp".

vm_create.sh
---
* **Description:** Configure new virtual machine on a KVM hypervisor.<br>
* **Usage:** Edit the variables with desired VM settings and execute.

vm_delete.sh
---
* **Description:** Completely remove a selected virtual machine on a KVM hypervisor.<br>
* **Usage:** Edit variables with desired VM settings and execute.
