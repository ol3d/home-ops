# Installing Proxmox on top of Debian

The goal of this guide is to install Proxmox VE (PVE) on top of the Debian nodes created in the previous step ([Creating Debian Nodes](debian-setup.md)). Each of the nodes will be configured using [Ansible](https://www.ansible.com/).

Before configuring and running our Ansible Playbook, we first need to test that the management server is able to ssh into each Debian node. If a successful connection is established, the Ansible environment can be set up.

Since Ansible is being used, it is required that the group_vars and host_vars within the inventory directory are set before running the playbook.

To set up Proxmox, I am using the ansible role [lae.proxmox](https://github.com/lae/ansible-role-proxmox). Currently there are a few things that are not entirely working from the ansible-galaxy version, instead, I am using a fork of lae.proxmox.

Once the group_vars and host_vars are all set up, make sure that ansible control node is able to ping each of the Debian nodes from the created `hosts.yml` file within the inventory directory. Run the ansible playbook as follows once in the proxmox directory.

```text
ansible-playbook playbooks/test-nodes.yml
```

If a successful result is given, the intialization of the proxmox cluster can continue. There may be some warnings if BIOS versions are not the same.

Before running the ansible-playbook of configure_nodes.yml, it is recommended to run the playbook purge_ceph_disks.yml to remove all references to previous ceph instances.
