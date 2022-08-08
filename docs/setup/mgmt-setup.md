# Management Server Setup

## Download and Install Ubuntu

Download [Ubuntu Server 22.04 ISO](https://ubuntu.com/download/server) and flash it to a bootable drive using a tool such as [Rufus](https://rufus.ie/en/) or [Balena Etcher](https://www.balena.io/etcher/).

On the management node, boot from the newly created boot drive, and install Ubuntu onto the system.

## Update and Install Packages

Once Ubuntu has been successfully installed on the machine, update and upgrade package repositories using the following:

```text
sudo apt-get update
sudo apt-get upgrade
```

For Ansible to work properly, OpenSSH needs to be installed on the system. Ubuntu typically comes with OpenSSH pre-installed, to check if it is installed run the following:

```text
ssh -V
```

This should output the current version of OpenSSH installed on the system. If a version is not displayed, then OpenSSH must be installed on the system by running the following:

```text
sudo apt install openssh-server
```

Once confirmed that OpenSSH is installed on the system, it is now possible to install Ansible by running the following:

```text
sudo apt install ansible
```

## Clone Git Repository

Once the Ansible has been installed, the Git repository must be cloned to run the existing Ansible playbooks.

### Generate SSH Key

To clone the repository, first an SSH Key must be created. Per Gitlab's [documentation](https://docs.gitlab.com/ee/user/ssh.html), the recommended keygen algorithm is ED25519.

Run the following to generate an SSH Key:

```text
sudo mkdir -p ~/.ssh/gitlab_keystore
ssh-keygen -t ed25519
```

During the ssh-keygen command, enter the location as the new directory that was just created ~/.ssh/gitlab_keystore/gitlab. It is recommended to enter a passphrase for the new key.

Once the key has been generated, modify the ssh configuration file by running the following:

```text
sudo nano ~/.ssh/config
```

Add the following to the file:

```text
# GitLab.com
Host gitlab.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/gitlab_keystore/gitlab
```

### Add SSH Key to Gitlab

Select the user icon in the top right of the screen and select 'Edit profile' from the dropdown menu. On the left hand side of the screen, select SSH Keys and insert the public key generated previously.

Now that the key has been inserted into Gitlab, the repository can be cloned.

Run the following to clone the respository from Gitlab:

```text
sudo git clone git@gitlab.com:${REPOSITORY_NAME}.git
```

## Run Management Server Setup Playbook

Update Ansible by installing all needed components and roles by running the following:

```text
ansible-galaxy install -r requirements.yml
```

Once the respository has been cloned, run the following to execute the Ansible Playbook command:

```text
sudo ansible-playbook ${REPOSITORY_PATH}/provision/ansible/mgmt/playbooks/mgmt-setup.yml
```

Let the Ansible playbook run until completion. Once completed, the current system should be set up to perform all needed tasks as a management server.
