# Setting Up PiKVM

The goal of this guide is to provide step-by-step instructions on how to install and configure [PiKVM](https://pikvm.org/) onto a Rasberry Pi.

To install PiKVM first download an **.img.xz** image from the PiKVM [download](https://pikvm.org/download/) page. The download will depend on the model of PiKVM hardware you are using. For this guide, the technology referenced will be the PiKVM HAT V3.3.
*(Version v3-hdmi-rpi4-latest.img.xz)*

## Step 1: Flashing the Micro SD Card

After downloading the latest **.img.xz** file, the Raspberry Pi Micro SD card must be erased and flashed. To flash the Micro SD, use the [Raspberry Pi Imager](https://www.raspberrypi.com/software/) software from the official Raspberry Pi site *(Version imager_1.8.5.exe)*. To flash the card using the imager software, follow the [Flashing PiKVM OS image](https://docs.pikvm.org/flashing_os/#download-the-image) guide from the PiKVM site. Once the Micro SD card has been fully flashed, insert it into the Raspberry Pi and turn it on.

## Step 2: Finding the PiKVM

Before we can use ansible to configure the PiKVM we need to make sure it is accessible on the network. From the management node running the ansible playbook, attempt to SSH into the PiKVM. You can attempt to log into the PiKVM WebGUI, but may only continue if successfully able to log in and access the PiKVM with SSH root user.

```yaml
PiKVM Default Login Information

# SSH
Username: root
Password: root

# WebGUI
Username: admin
Password: admin
```

## Step 3: Running Ansible Setup Playbooks

Since the PiKVM was able to be accessed using the root user, the PiKVM can now be fully configured using Ansible.
