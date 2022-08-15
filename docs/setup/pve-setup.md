# Proxmox Install on top of Debian

## Download and Install Debian

Download [Debian 11](https://www.debian.org/distrib/netinst) and flash it to a bootable drive using a tool such as [Rufus](https://rufus.ie/en/) or [Balena Etcher](https://www.balena.io/etcher/).

On the Debian system, boot from the newly created boot drive, and install Debian 11 onto the system.

## Install OpenSSH

Once Debian has been installed, run the following to install OpenSSH onto the system:

```text
su -
sudo apt install openssh-server
```
