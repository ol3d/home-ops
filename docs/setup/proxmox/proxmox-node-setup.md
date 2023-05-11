# Installing Proxmox VE Using ISO image

The goal of this guide is to provide step-by-step instructions on how to install [Proxmox VE](https://www.proxmox.com/en/proxmox-ve), as well as how to prepare the system to be integrated into a Proxmox Cluster.

To install Proxmox Virtual Environment, first download an **.iso** image from the Proxmox [download](https://www.proxmox.com/en/downloads/category/iso-images-pve) page.
*(Version proxmox-ve_7.4-1.iso as of this documentation)*

After downloading the ISO image, a bootable drive must be created. There are many tools available such as [Rufus](https://rufus.ie/en/), [balenaEtcher](https://www.balena.io/etcher), and [Ventoy](https://www.ventoy.net/en/index.html). Once a bootable drive has been created, the installation process can begin.

## Step 1: Select the Default Installation Option

1. Turn on the computer after inserting the Proxmox VE installation media.
2. On the initial Proxmox menu, select the `Install Proxmox VE` option.
3. This will start the installation process for Proxmox Virtual Environment.

## Step 2: Modify System OS Drive and Basic System Configuration

1. On the next screen, select the harddisk option to install the OS.
2. Advanced options can be selected to set up a ZFS drive if required.
3. After a drive has been selected, continue and select the Country, Time Zone, and keyboard layout.

## Step 3: Create Root User Password and Configure Email

1. Create a new password for the Root user of the Proxmox node.
2. Along with the password, supply an email address for notifications.

## Step 4: Set up the Network Connection

1. The installation process will automatically detect physical network interfaces. If there are multiple network interfaces, select the interface to be used as the Management Interface.
2. If available, ipv4/6 DHCP autoconfiguration will begin. Otherwise manual network setup will need to be completed.

## Step 5: Review Configuration and Finish Installation

1. After all steps have been completed, review the information shown in the configuration summary.
2. Continue and wait until the installation has completed.
3. After the installation has completed, remove the ISO media drive and wait for the system to reboot.
