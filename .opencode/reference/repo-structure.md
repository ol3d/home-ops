# Repository Structure Reference

This document provides detailed information about the home-ops monorepo structure.

## Infrastructure as Code

### Terraform Modules

`lab/provision/terraform/modules/` – Terraform modules for cloud services

- `aws/` – S3, DynamoDB, KMS for remote state
- `backblaze/` – B2 backup storage
- `cloudflare/` – DNS and zone settings
- `github/` – Repository and user management
- `mailgun/` – Email domain configuration
- `proxmox/` – VM provisioning

### Ansible

`lab/provision/ansible/` – Ansible playbooks and inventories

- `kubernetes/` – K3s cluster configuration
- `proxmox/` – Proxmox VE cluster management
- `home-auto/` – Home automation systems
- `pikvm/` – PiKVM remote management
- `opnsense/` – OPNSense router configuration
- `switch/` – Cisco switch management

### Packer

`lab/provision/packer/` – Packer templates

- `proxmox/ubuntu-server-noble/` – Ubuntu Server 24.04 LTS VM templates

## Documentation

`docs/` – MkDocs-based documentation

- `concepts/` – Conceptual explanations
- `how-to/` – Step-by-step guides
- `reference/` – Hardware and service references
- `setup/` – Initial setup documentation
- `src/assets/` – Images and diagrams

## Automation & Tooling

- `.taskfiles/` – Taskfile automation scripts (ansible, sops, bootstrap, pre-commit, lint)
- `Taskfile.yml` – Main Taskfile entry point
- `.github/workflows/` – GitHub Actions (label-sync, labeler, renovate)
- `.github/renovate/` – Renovate bot configuration for dependency updates
- `.pre-commit-config.yaml` – Pre-commit hooks
- `mkdocs.yml` – MkDocs site configuration
- `devbox.json` – Devbox development environment

## OpenCode Configuration

- `.opencode/agent/` – Specialized agent definitions
- `.opencode/sessions/` – Session history and CURRENT.md state tracking
- `.opencode/reference/` – Reference documentation (this file)
- `.opencode/.opencodeignore` – Protected paths and sensitive files
- `OPENCODE.md` – Main orchestrator instructions
