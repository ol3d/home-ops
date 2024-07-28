# Setup

To begin utilizing this repository for a homelab setup, the following setup guides need to be followed and completed. Most of these guides are specific to my own homelab setup and are set up for my own use case, however, they can be modified as needed to better fit your own environment.

---

## Management Node Setup

The management node is used *solely* to manage and configure my entire homelab. The management node utilizes ansible, terraform, packer, and other tools to help setup, teardown, and modify various components within the homelab. By separating the management node from other devices, it allows me to remotely connect to the node from any device to be able to perform tasks consistently.

### [Management Node Setup](mgmt/mgmt-setup.md)

---

## PiKVM Setup

### - [Setting Up PiKVM](pikvm/pikvm-setup.md)

## Proxmox Cluster Setup

### - [Creating Debian Nodes](proxmox/debian-setup.md)

### - [Installing Proxmox on top of Debian](proxmox/proxmox-cluster-setup.md)
