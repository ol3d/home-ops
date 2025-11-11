# Github Respository Setup

Since this repository is the source of truth for my homelab, it is required to
fork/download the repository and set up all required components. My repository
is hosted on [Github](https://github.com/) but can be hosted on other version
control platforms such as [Gitlab](https://about.gitlab.com/),
[Bitbucket](https://bitbucket.org/product/),
[AWS CodeCommit](https://aws.amazon.com/codecommit/), etc. Some of the
functionality within my homelab relies on
[Github Actions](https://docs.github.com/en/actions), so be aware that by
utilizing a different hosting platform, some functionality may be different or
may not be possible.

Note that this guide will use Github as the version control platform since that
is what I am currently using. Other platforms may be slightly different so it is
impossible to document for all scenarios. It is recommended to follow along by
using Github to avoid any issues.

[Github](https://github.com/) is a powerful version control platform which
allows for the management and modification of Git repositories. To begin the
setup, fork from the [home-ops](https://github.com/ol3d/home-ops) repository.

---

## Install Git onto Management Node

To continue with the rest of the management node setup, it is recommended to
install git onto the system to be able to pull down the newly forked repository.

`sudo apt install git`

Create a folder with all of the repositories that you wish the management node
has access to.

`mkdir -p ~/buildworkspace` to allow root access in the case that a root account
is created and managed.

You will need to generate a new SSH key to be able to interact with the forked
Github repository.

`ssh-keygen -t ed25519 -C "Management Node"`

- Store the ssh key in the default location (/root/.ssh/id_ed25519)
- I did not create a passphrase for the certificate

Get the management node public key by using

`cat ~/.ssh/id_ed25519.pub`

Take this public key and add it to the verified SSH Keys list on github.

[Generating and SSH Key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

[Adding the SSH Key to account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

Clone into the git repository in the newly created directory

`cd /buildworkspace`

`git clone git@github.com:ol3d/home-ops.git`

Navigate to the repository directory

`cd home-ops`

Run the task for management initialization

`task mgmt:init`
