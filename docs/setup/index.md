# Setup

To begin utilizing this repository for a homelab setup, the following setup guides need to be followed and completed. Most of these guides are specific to my own homelab setup and are set up for my own use case, however, they can be modified as needed to better fit your own environment.

---

## Management Node Setup

The management node is used _solely_ to manage and configure my entire homelab; It only runs services used for homelab management and configuration. The management node utilizes ansible, terraform, packer, and other tools to help setup, teardown, and modify various components within the homelab. By separating the management node from other devices, it allows me to remotely connect to the node from any device to be able to perform tasks consistently and repeatably.

Since this node will not have many services running on it, the compute power can remain less than the other nodes within the homelab. A less powerful device such as a Raspberry Pi will suffice.

The initial setup of the management node is mostly automated, however, there are a few preliminary steps that need to be completed before the automation can begin. Follow each step below to begin setting up the management node.

- [Git Repository Setup](mgmt/git-repository-setup.md)

---

## PiKVM Setup

### - [Setting Up PiKVM](pikvm/pikvm-setup.md)

## Proxmox Cluster Setup

### - [Creating Debian Nodes](proxmox/debian-setup.md)

### - [Installing Proxmox on top of Debian](proxmox/proxmox-cluster-setup.md)
