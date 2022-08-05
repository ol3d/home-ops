# Management Node Server Setup

## Download and Install Ubuntu

Download [Ubuntu Server 22.04 ISO](https://ubuntu.com/download/server) and flash it to a bootable drive using a tool such as [Rufus](https://rufus.ie/en/) or [Balena Etcher](https://www.balena.io/etcher/).

On the management node, boot from the newly created boot drive, and install Ubuntu onto the system.

## Update and Install Packages

Once Ubuntu has been successfully installed on the machine, update and upgrade package repositories using the following:

```text
sudo apt-get update
sudo apt-get upgrade
```

Once the existing packages for Ubuntu have been upgraded, it is now possible to install Ansible. Documentation for Ansible can be found [here](https://docs.ansible.com/).

To install Ansible run the following:

```text
sudo apt install ansible
```

For Ansible to work properly, OpenSSH needs to be installed on the system. Ubuntu typically comes with OpenSSH pre-installed, however if it is not installed run the following:

```text
sudo apt install openssh-server
```

After installing the needed packages, modify the sudoers list in /etc/sudoers to allow passwordless sudo.

Modify to include:

```text
%admin ALL=(ALL) NOPASSWD:ALL
```

## Clone Git Repository

Once the Ansible and OpenSSH have been installed, the Git repository must be cloned to run the existing Ansible playbooks.

### Generate SSH Key

To clone the repository, first an SSH Key must be created. Per Gitlab's [documentation](https://docs.gitlab.com/ee/user/ssh.html), the recommended keygen algorithm is ED25519.

Run the following to generate an SSH Key:

```text
sudo ssh-keygen -t ed25519
```

Once the key has been generated, modify the ssh configuration file by running the following:

```text
sudo nano ~/.ssh/config
```

Add the following to the file:

```text
# GitLab.com
Host gitlab.com
  PreferredAuthentications publickey
  IdentityFile ${KEY_LOCAITON}
```

### Add SSH Key to Gitlab

Select the user icon in the top right of the screen and select 'Edit profile' from the dropdown menu. On the left hand side of the screen, select SSH Keys and insert the public key generated previously.

Now that the key has been inserted into Gitlab, the repository can be cloned.

Run the following to clone the respository from Gitlab:

```text
sudo git clone git@gitlab.com:${REPOSITORY_NAME}.git
```

## Run Management Server Setup Playbook

Once the respository has been cloned, run the following to execute the Ansible Playbook command:

```text
sudo ansible-playbook ${REPOSITORY_PATH}/provision/ansible/mgmt-node/playbooks/setup-mgmt.yaml --ask-become-pass
```

Let the Ansible playbook run until completion. Once completed, the given node should be entirely set up to perform all needed tasks as a management server.
