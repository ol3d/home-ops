# Debian Installation

Debian is a good choice for an operating system within a homelab due to its stability, security, and extensive software repository. It's known for its conservative approach to updates, prioritizing reliability over bleeding-edge features, which is ideal for a homelab environment where consistency is crucial. Additionally, Debian has robust community support and thorough documentation, making it easier to troubleshoot and customize your homelab setup.

*This reference assumes that a boot drive with [Debian](https://www.debian.org/intro/about) has already been created.*

---

## Installation Configuration

To being the installation configuration, choose the **graphical installation** option out of the list. Other options are permitted, however, this guide follows the graphical installation process.

![Debian Installation Options](../../src/assets/debian/debian_base_installation_choices.jpg)

---

### Select a Language

During this step, select which language you would like to use for the installation process. The chosen language will also be used as the default language for the installed sytem.

![Select a Languae](../../src/assets/debian/base-installation/debian_base-installation_1.png)

---

### Select your Location

During this step, select the location of the server. This location will be used to set the timezone.

![Select your Location](../../src/assets/debian/base-installation/debian_base-installation_2.png)

---

### Configure your Keyboard

During this step, select the keymapping to use on the system.

![Configure your Keyboard](../../src/assets/debian/base-installation/debian_base-installation_3.png)

---

### Configure the Network

During this step, the system will attempt to identify all usable Network Interface Controllers (NICs). Select which NIC you would like to use as the primry interface for the system.

![Configure the Network](../../src/assets/debian/base-installation/debian_base-installation_4.png)

---

### Configure System Hostname

After selecting the primary NIC, the system will attempt to use DHCP to configure the system hostname. Enter the hostname you would like to use or hit continue if it was properly found during DHCP.

![Configure System Hostname](../../src/assets/debian/base-installation/debian_base-installation_5.png)

---

### Configure System Domain Name

After selecting the primary NIC, the system will attempt to use DHCP to configure the system domain name. Enter the domain name you would like to use or hit continue if it was properly found during DHCP.

![Configure System Domain Name](../../src/assets/debian/base-installation/debian_base-installation_6.png)

---

### Configure Root User Password

For the purposes of following other guides within this repository. It is recommended to NOT set the root user password. This will disable root login and will instead allow other users sudo privilege. To skip setting the root password, simply do not fill in the fields and hit continue.

![Configure Root User Password](../../src/assets/debian/base-installation/debian_base-installation_7.png)

---
