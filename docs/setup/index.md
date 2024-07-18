# Setup

To begin utilizing this repository for a homelab setup, the following guides need to be followed and completed. Most of these guides are specific to my own homelab setup and are set up for my own use case, however, they can be modified as needed to better fit your own environment.

---

## Configuring Git Repository

Since this repository is a source of truth for my homelab, it is required to fork/download the repository and set up all required components. My repository is hosted on [Github](https://github.com/) but can be hosted on other version control platforms such as [Gitlab](https://about.gitlab.com/), [Bitbucket](https://bitbucket.org/product/), [AWS CodeCommit](https://aws.amazon.com/codecommit/), etc. Some of the functionality within my homelab relies on [Github Actions](https://docs.github.com/en/actions), so be aware that by utilizing a different hosting platform, some functionality may be different or may not be possible at all.

Note that this guide will use Github as the version control platform. All other platforms may be slightly different and may require different solutions for the same result. It is recommended to follow along by using Github to avoid any issues.

### [Github Respository Setup](# TODO)

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
