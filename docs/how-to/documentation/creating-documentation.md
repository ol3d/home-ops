# Material for MkDocs Basics

This website and all of my technical documentation for my homelab is generated using [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/). Material for MkDocs is a modern theme designed to enhance the appearance and functionality of documentation sites built with MkDocs. It is a great tool to help create documentation quickly.

---

## Installation

Everything should already be installed from the management node setup process. But if the management node has not yet been configured, run the ansible playbook found in the guide [here](Link goes here) to install the needed resources for Material for MkDocs and set up the management node.

If unable to use ansible to insitall Material for MkDocs, the current installation instructions can be found [here](https://squidfunk.github.io/mkdocs-material/getting-started/#installation) *(As of 2024-03-25)*.

---

## Local Development

To edit and view changes real-time to the site, you need to run the site locally on the management node. Navigate to the root directory of this repository and run the following:

```yaml
mkdocs serve
```

After the local server of the current repository is running, the site can be accessed on port 8000 on [localhost](http://127.0.0.1:8000/) (127.0.0.1:8000).

---
