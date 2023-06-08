# Installing Proxmox on top of Debian

The goal of this guide is to install Proxmox VE on top of the Debian nodes created in the previous step ([Installing Debian Using ISO image](debian-setup.md)). Each of the nodes will be configured by using [Ansible](https://www.ansible.com/).

Before using Ansible, test that the management server is able to ssh into each node. If a successful connection is established, the Ansible environment can be set up.

Since Ansible is being used, it is required that the group_vars and host_vars are properly filled out for the Proxmox setup.

...

Once the group_vars and host_vars are all set up, make sure that ansible is able to ping each of the Debian nodes.
Run the ansible playbook as follows once in the proxmox directory.

```text
ansible-playbook playbooks/initialization-test.yml
```

If a successful result is given, the intialization of the proxmox cluster can continue.
