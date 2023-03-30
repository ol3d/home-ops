# [Management Server Setup](#management-server-setup)

## [Download and Install Debian](#download-and-install-debian)

Download [Debian 11](https://www.debian.org/distrib/netinst) and flash it to a bootable drive using a tool such as [Rufus](https://rufus.ie/en/) or [Balena Etcher](https://www.balena.io/etcher/).

On the management node, boot from the newly created boot drive, and install Debain onto the system.

## [Update and Install Packages](#update-and-install-packages)

To start the setup, run the [Task](https://taskfile.dev/) installation script from `hack/install-task.sh`:

```text
sudo bash hack/install-task.sh
```

Once Task has been installed run the management node initialization task from the base directory:

```text
sudo task mgmt:init
```

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