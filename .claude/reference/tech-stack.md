# Homelab Technology Stack

This document lists the core technologies used in this homelab infrastructure.

## Virtualization & Orchestration

- **Hypervisor**: Proxmox VE cluster
- **Kubernetes**: K3s (multi-master HA setup)

## Networking

- **Firewall**: OPNSense
- **Switches**: Cisco managed switches
- **Remote Management**: PiKVM

## Cloud Services

- **AWS**: S3, DynamoDB, KMS (Terraform state backend)
- **Backblaze**: B2 object storage (backups)
- **Cloudflare**: DNS and zone management

## Security & Secrets

- **Secrets Management**: SOPS with age encryption
- **Key Storage**: age keys for SOPS decryption

## Development & Documentation

- **Documentation**: MkDocs with Material theme
- **Development Environment**: Devbox with Nix packages

## Automation & IaC

- **Task Automation**: Taskfile (go-task)
- **Configuration Management**: Ansible
- **Infrastructure Provisioning**: Terraform
- **Image Building**: Packer

## CI/CD

- **Version Control**: GitHub
- **Continuous Integration**: GitHub Actions
- **Dependency Management**: Renovate bot
- **Pre-commit Hooks**: pre-commit framework

## Linting & Validation

- **Terraform**: tflint, terraform fmt
- **Ansible**: ansible-lint
- **Markdown**: markdownlint
- **YAML**: yamllint
- **General**: pre-commit hooks for all formats
