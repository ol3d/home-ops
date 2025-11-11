# Installing Proxmox on top of Debian

The goal of this guide is to install Proxmox VE (PVE) on top of the Debian nodes
created in the previous step ([Creating Debian Nodes](debian-setup.md)). Each of
the nodes will be configured using [Ansible](https://www.ansible.com/).

---

## Ansible Setup

Before fully configuring and running our Ansible Playbook, we first need to test
that the management server is able to ssh into each Debian node. If a successful
connection is established, the Ansible environment can be set up.

Run `ssh <username>@<ip_address>` from your management node to establish an SSH
connection with the newly created debian node. The first time attempting to
connect with SSH will prompt to accept the key fingerprint of the host. Once you
are able to successfully connect via SSH, repeat this step for all other debian
nodes.

Once all nodes have been confirmed able to connect via SSH, the Ansible playbook
variables can be configured. To set the required variables, navigate to the
group_vars and host_vars within the `lab/provision/ansible/proxmox` directory.
Set all required values before running the playbook.

To set up Proxmox, I am using the ansible role
[lae.proxmox](https://github.com/lae/ansible-role-proxmox). Currently there are
a few things that are not entirely working from the ansible-galaxy version,
instead, I am using a fork of lae.proxmox with some additional VFIO
functionality.

Once the group_vars and host_vars are all set up, make sure that ansible control
node is able to successfully run the `ansible-playbook playbooks/test-nodes.yml`
playbook. This playbook will verify that all nodes are running on the same BIOS
version and are able to connect to one another.

If a successful result is given, the intialization of the proxmox cluster can
continue. There may be some warnings if the nodes BIOS versions are not the
same. It is best practice to keep all nodes as similar as possible, including
all physical componenets, as well as keeping software and BIOS versions
consistent across all devices, however, it will most likely be fine to run the
setup playbook without matching BIOS versions.

If this is not your first time running the
`ansible-playbook playbooks/configure_nodes.yml` playbook, it is recommended to
run the playbook purge_ceph_disks.yml to remove all references to previous ceph
instances if a cluster had previously been set up.
