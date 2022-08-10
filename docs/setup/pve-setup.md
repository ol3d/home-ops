# PVE Setup

## Download and Install Proxmox

Download [Proxmox VE 7.2](https://www.proxmox.com/en/downloads) and flash it to a bootable drive using a tool such as [Rufus](https://rufus.ie/en/) or [Balena Etcher](https://www.balena.io/etcher/).

On the Proxmox system, boot from the newly created boot drive, and install Proxmox VE onto the system.

## Authoize Management Server SSH Key

On the Management server, run the mgmt-pve-keys.yml file to create and distribute SSH keys to all proxmox hosts.

Within the provision/ansible/mgmt directory run the following:

```text
ansible-playbook playbooks/mgmt-pve-keys.yml
```

Once completed, the generated SSH keys will be added to their respective pve server authorized_keys file.
