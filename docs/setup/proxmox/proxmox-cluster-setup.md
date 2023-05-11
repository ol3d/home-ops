# Preparing the Proxmox Cluster

The goal of this guide is to prepare each node created in the previous step ([Installing Proxmox VE Using ISO image](proxmox-node-setup.md)) to be accessible by the Ansible Management Server. Each of the Proxmox nodes will be configured by using [Ansible](https://www.ansible.com/).

Before using Ansible, test that the management server is able to ssh into each Proxmox node. If a successful connection is established, the Ansible environment can be set up.

Since Ansible is being used, it is required that the group_vars and host_vars are properly filled out for the proxmox setup.
