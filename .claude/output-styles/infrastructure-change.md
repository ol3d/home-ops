# Output Style: Infrastructure Change

## Purpose

Use when planning, reviewing, or documenting Infrastructure as Code (IaC) changes across Terraform, Ansible, Packer, or Kubernetes manifests.

## Template

```markdown
# Infrastructure Change Summary

## Overview

[One-line description of the change]

**Type**: [New Resource | Update | Deletion | Refactor]
**Scope**: [Terraform | Ansible | Packer | Kubernetes | Multiple]
**Risk Level**: [Low | Medium | High | Critical]
**Estimated Duration**: [Time estimate]

## Changes

### Resources Affected

- [Resource type and name]
- [Resource type and name]

### What's Changing

**Before**:
[Current state]

**After**:
[New state]

**Why**:
[Rationale for the change]

## Impact Analysis

### Services Affected

- [Service name] - [Impact description]

### Downtime Required

[Yes/No - with details if yes]

### Rollback Plan

[How to revert if needed]

## Dependencies

### Prerequisites

- [ ] [What must be done first]
- [ ] [Configuration needed]

### Affected Systems

- [System name] - [How it's affected]

## Testing Plan

### Pre-Deployment Tests

- [ ] [Test to run]
- [ ] [Validation step]

### Post-Deployment Verification

- [ ] [Check after deployment]
- [ ] [Monitoring to watch]

## Security Considerations

- [Security implication]
- [Access control changes]
- [Secret management]

## Deployment Steps

1. [Step with command]
2. [Step with command]
3. [Verification command]

## Checklist

- [ ] Changes reviewed by peer
- [ ] Terraform plan reviewed
- [ ] Secrets properly encrypted
- [ ] Documentation updated
- [ ] Monitoring configured
- [ ] Rollback plan tested
- [ ] Stakeholders notified

## Notes

[Any additional context, warnings, or important information]
```

## Guidelines

**Risk Levels**:

- **Low**: Non-breaking, easy rollback, no downtime
- **Medium**: Some impact, requires testing, minimal downtime
- **High**: Breaking changes, significant impact, planned downtime
- **Critical**: Production-critical, requires maintenance window

**Be Specific**:

- Include actual resource names
- Provide exact commands
- List specific files changed
- Reference line numbers when relevant

**Always Include**:

- Rollback plan (every change must be reversible)
- Testing steps (verify before and after)
- Security review (especially for access changes)

## Example

````markdown
# Infrastructure Change Summary

## Overview

Add new Kubernetes worker node to cluster for increased capacity

**Type**: New Resource
**Scope**: Terraform + Ansible
**Risk Level**: Medium
**Estimated Duration**: 45 minutes

## Changes

### Resources Affected

- Proxmox VM (k3s-agent-04)
- K3s cluster configuration
- Load balancer pool

### What's Changing

**Before**:

- 3 agent nodes in K3s cluster
- Total capacity: 96GB RAM, 24 cores

**After**:

- 4 agent nodes in K3s cluster
- Total capacity: 128GB RAM, 32 cores

**Why**:
Current resource utilization at 85%, need headroom for new workloads

## Impact Analysis

### Services Affected

- K3s cluster - Increased capacity, no disruption
- Load balancer - Updated pool membership

### Downtime Required

No - node will be added to existing cluster

### Rollback Plan

1. Drain workloads from new node: `kubectl drain k3s-agent-04`
2. Remove from cluster: `kubectl delete node k3s-agent-04`
3. Destroy VM: `terraform destroy -target=proxmox_vm_qemu.k3s_agent_04`

## Dependencies

### Prerequisites

- [x] Proxmox has available resources
- [ ] VM template ubuntu-server-noble exists
- [ ] VLAN 20 has available IPs

### Affected Systems

- Proxmox - Will provision new VM
- K3s cluster - Will add new agent

## Testing Plan

### Pre-Deployment Tests

- [ ] Verify Proxmox resource availability
- [ ] Test VM template provisioning
- [ ] Confirm network connectivity

### Post-Deployment Verification

- [ ] Node appears in kubectl get nodes
- [ ] Node status is Ready
- [ ] Pod scheduling works on new node
- [ ] Metrics appear in monitoring

## Security Considerations

- SSH keys deployed via Ansible
- Node uses SOPS-encrypted secrets
- Firewall rules apply automatically via K3s

## Deployment Steps

1. Create VM with Terraform:
   ```bash
   cd lab/provision/terraform/modules/proxmox
   terraform plan -target=proxmox_vm_qemu.k3s_agent_04
   terraform apply -target=proxmox_vm_qemu.k3s_agent_04
   ```
````

2. Configure node with Ansible:

   ```bash
   cd lab/provision/ansible/kubernetes
   ansible-playbook playbooks/configure-base-nodes.yml -l k3s-agent-04
   ```

3. Verify node joined cluster:
   ```bash
   kubectl get nodes
   kubectl describe node k3s-agent-04
   ```

## Checklist

- [ ] Changes reviewed by peer
- [ ] Terraform plan reviewed
- [ ] Secrets properly encrypted
- [x] Documentation updated
- [ ] Monitoring configured
- [ ] Rollback plan tested
- [ ] Stakeholders notified

## Notes

- Schedule during low-traffic window (2AM-4AM)
- Monitor cluster autoscaler behavior after adding node
- Update capacity planning docs after deployment

```

```
