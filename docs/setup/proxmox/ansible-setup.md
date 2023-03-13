# Preparing for Proxmox

The goal of this guide is to prepare the systems created in the previous step ([Creating a Debian System](debian-setup.md)) for Proxmox. Each of the Debian systems will be transformed into a Proxmox node using [Ansible](https://www.ansible.com/).

Before using Ansible, test that the management server is able to SSH into each Debian system. If a successful SSH connection is established, the Ansible environment can be set up.

Since Ansible is being used, it is required that the group_vars and host_vars are properly filled out for the proxmox setup.
