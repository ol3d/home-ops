# Naming Conventions

This document defines the standardized naming patterns, ID ranges, and
organizational conventions used throughout the homelab infrastructure. Following
these conventions ensures consistency, prevents conflicts, and enables
predictable infrastructure expansion.

---

## Table of Contents

- [VM Naming](#vm-naming)
- [VM ID Ranges](#vm-id-ranges)
- [Network Configuration](#network-configuration)
- [Proxmox Infrastructure](#proxmox-infrastructure)
- [Storage Naming](#storage-naming)
- [DNS and FQDN Conventions](#dns-and-fqdn-conventions)
- [Tagging Strategy](#tagging-strategy)

---

## VM Naming

### Pattern

All VMs follow the pattern: `<service>-<role>-<number>`

- **service**: The primary service or workload (e.g., `k3s`, `app`, `db`)
- **role**: The function within the service (e.g., `master`, `agent`, `worker`)
- **number**: Zero-padded sequential identifier (e.g., `01`, `02`, `03`)

### Examples

| VM Name         | Service    | Role          | Number |
| --------------- | ---------- | ------------- | ------ |
| `k3s-master-01` | Kubernetes | Control Plane | 01     |
| `k3s-master-02` | Kubernetes | Control Plane | 02     |
| `k3s-master-03` | Kubernetes | Control Plane | 03     |
| `k3s-agent-01`  | Kubernetes | Worker Node   | 01     |
| `k3s-agent-02`  | Kubernetes | Worker Node   | 02     |
| `k3s-agent-03`  | Kubernetes | Worker Node   | 03     |

### Rules

- **Always use lowercase** - VM names should be lowercase only
- **Use hyphens as separators** - No underscores or camelCase
- **Zero-pad numbers** - Use `01` instead of `1` for single digits
- **Start at 01** - Numbers begin at `01`, not `00` or `1`
- **Be consistent** - Once a naming pattern is established for a service,
  maintain it

---

## VM ID Ranges

Proxmox VM IDs (VMIDs) are organized into ranges based on function. This
prevents ID conflicts and makes the purpose of a VM immediately apparent.

### Reserved Ranges

| Range         | Purpose               | Example VMs                                                                                                               |
| ------------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **1000-1099** | VM Templates          | `1001`: Ubuntu Server template (pve-01), `1002`: Ubuntu Server template (pve-02), `1003`: Ubuntu Server template (pve-03) |
| **2000-2099** | Kubernetes Cluster    | `2011-2013`: K3s masters, `2021-2023`: K3s agents                                                                         |
| **3000-3099** | Application VMs       | Reserved for future app workloads                                                                                         |
| **4000-4099** | Database VMs          | Reserved for future database servers                                                                                      |
| **5000-5099** | Management/Monitoring | Reserved for observability stack                                                                                          |
| **9000-9999** | Special Purpose       | Reserved for one-off or test VMs                                                                                          |

### Current VM ID Assignments

#### K3s Masters (2011-2013)

| VM ID  | VM Name       | Proxmox Node | Purpose                  |
| ------ | ------------- | ------------ | ------------------------ |
| `2011` | k3s-master-01 | pve-01       | K3s control plane node 1 |
| `2012` | k3s-master-02 | pve-02       | K3s control plane node 2 |
| `2013` | k3s-master-03 | pve-03       | K3s control plane node 3 |

#### K3s Agents (2021-2023)

| VM ID  | VM Name      | Proxmox Node | Purpose                                  |
| ------ | ------------ | ------------ | ---------------------------------------- |
| `2021` | k3s-agent-01 | pve-01       | K3s worker node 1 (with GPU passthrough) |
| `2022` | k3s-agent-02 | pve-02       | K3s worker node 2 (with GPU passthrough) |
| `2023` | k3s-agent-03 | pve-03       | K3s worker node 3 (with GPU passthrough) |

#### VM Templates (1001-1003)

| VM ID  | Template Name       | Proxmox Node | OS                      |
| ------ | ------------------- | ------------ | ----------------------- |
| `1001` | ubuntu-server-noble | pve-01       | Ubuntu Server 24.04 LTS |
| `1002` | ubuntu-server-noble | pve-02       | Ubuntu Server 24.04 LTS |
| `1003` | ubuntu-server-noble | pve-03       | Ubuntu Server 24.04 LTS |

### Expansion Guidelines

When adding new VMs:

1. **Determine the appropriate range** based on workload type
2. **Use sequential IDs** within the range (e.g., 2014, 2015 for new K3s
   masters)
3. **Document the assignment** in this file and in Terraform/Ansible configs
4. **Distribute across nodes** - Balance VMs across pve-01, pve-02, pve-03

---

## Network Configuration

### VLAN Assignments

VLANs segment network traffic for security, performance, and organizational
purposes.

| VLAN ID  | Name                    | Purpose                                                                                            | Subnet (example)    |
| -------- | ----------------------- | -------------------------------------------------------------------------------------------------- | ------------------- |
| **30**   | K3s Cluster             | Kubernetes node-to-node traffic                                                                    | See network diagram |
| _Others_ | _See network reference_ | Various VLANs documented in [Network Reference](../reference/homelab/network/network-reference.md) | N/A                 |

**Reference:** Full VLAN documentation is maintained in
[`docs/reference/homelab/network/network-reference.md`](../reference/homelab/network/network-reference.md)

### MAC Address Management

MAC addresses are manually assigned to prevent conflicts and ensure predictable
network behavior.

#### Patterns

- **K3s Masters**: `XX:XX:XX:XX:XX:XX` (unique, randomly generated during
  provisioning)
- **K3s Agents**: `XX:XX:XX:XX:XX:XX` (unique, randomly generated during
  provisioning)

#### Current Assignments

| VM Name       | MAC Address         | VLAN | Notes              |
| ------------- | ------------------- | ---- | ------------------ |
| k3s-master-01 | `8A:E5:9E:A5:BB:B4` | 30   | Control plane node |
| k3s-master-02 | `4A:F8:E0:36:5D:CE` | 30   | Control plane node |
| k3s-master-03 | `4E:78:A1:1B:A2:75` | 30   | Control plane node |
| k3s-agent-01  | `92:C0:F5:CA:85:26` | 30   | Worker node (GPU)  |
| k3s-agent-02  | `02:EE:4A:15:B5:AF` | 30   | Worker node (GPU)  |
| k3s-agent-03  | `F2:88:DD:49:28:2C` | 30   | Worker node (GPU)  |

**Important:** When creating new VMs, generate unique MAC addresses to avoid
network conflicts. Use locally administered MAC address ranges (first octet has
2nd least significant bit set).

---

## Proxmox Infrastructure

### Node Naming

Proxmox VE cluster nodes follow the pattern: `pve-<number>`

| Node Name | Physical Server         | Management IP                                                                 | Role           |
| --------- | ----------------------- | ----------------------------------------------------------------------------- | -------------- |
| `pve-01`  | Supermicro X11SCL-iF #1 | See [Hardware Reference](../reference/homelab/hardware/hardware-reference.md) | Cluster node 1 |
| `pve-02`  | Supermicro X11SCL-iF #2 | See [Hardware Reference](../reference/homelab/hardware/hardware-reference.md) | Cluster node 2 |
| `pve-03`  | Supermicro X11SCL-iF #3 | See [Hardware Reference](../reference/homelab/hardware/hardware-reference.md) | Cluster node 3 |

### VM Placement Strategy

VMs are distributed across Proxmox nodes for high availability and load
balancing:

- **K3s Masters**: One per node (master-01 → pve-01, master-02 → pve-02,
  master-03 → pve-03)
- **K3s Agents**: One per node (agent-01 → pve-01, agent-02 → pve-02, agent-03 →
  pve-03)
- **Future VMs**: Distribute evenly across nodes to balance resource consumption

**Rationale:** This placement ensures that losing a single Proxmox node doesn't
take down the entire K3s cluster (HA design).

---

## Storage Naming

### Datastore Conventions

Proxmox datastores follow descriptive naming based on storage type and purpose:

| Datastore Name | Type      | Purpose                           | Backing Storage                 |
| -------------- | --------- | --------------------------------- | ------------------------------- |
| `pve-ceph`     | Ceph RBD  | VM disks and shared storage       | Ceph cluster across all 3 nodes |
| `local`        | Directory | Node-local storage (ISO, backups) | Local disk on each node         |
| `local-lvm`    | LVM       | Fast local storage (optional)     | Local disk LVM on each node     |

### Usage Guidelines

- **pve-ceph**: Primary storage for all production VMs (provides replication and
  HA)
- **local**: ISO images, container templates, node-specific files
- **local-lvm**: Fast scratch space or temporary VMs (no redundancy)

**Default:** Use `pve-ceph` for all VM disks unless there's a specific reason to
use local storage.

---

## DNS and FQDN Conventions

### Internal DNS

Internal hostnames resolve within the homelab network:

**Pattern:** `<vm-name>.<internal-domain>`

Example: `k3s-master-01.internal.example.com`

### External DNS (Public)

Public-facing services use a different domain managed via Cloudflare:

**Pattern:** `<service>.<public-domain>`

Example: `grafana.example.com`

**Note:** Public domain values are stored in SOPS-encrypted files and not
documented here for security.

### Hostname Configuration

VM hostnames should match their VM names:

| VM Name       | Hostname      | FQDN (internal)                   |
| ------------- | ------------- | --------------------------------- |
| k3s-master-01 | k3s-master-01 | k3s-master-01.`<internal-domain>` |
| k3s-master-02 | k3s-master-02 | k3s-master-02.`<internal-domain>` |
| k3s-agent-01  | k3s-agent-01  | k3s-agent-01.`<internal-domain>`  |

**Terraform Note:** Hostnames are configured via cloud-init during VM
provisioning.

---

## Tagging Strategy

Proxmox VM tags provide metadata for filtering, automation, and organization.

### Tag Format

Tags should be:

- **Lowercase**
- **Single-word** or **hyphenated**
- **Descriptive** of function or technology

### Current Tags

| Tag      | Purpose                             | Applied To                                  |
| -------- | ----------------------------------- | ------------------------------------------- |
| `k3s`    | Indicates Kubernetes cluster member | All K3s masters and agents                  |
| `master` | K3s control plane node              | k3s-master-01, k3s-master-02, k3s-master-03 |
| `agent`  | K3s worker node                     | k3s-agent-01, k3s-agent-02, k3s-agent-03    |

### Future Tag Ideas

Consider adding these tags as infrastructure grows:

- `production` / `staging` / `development` - Environment classification
- `monitoring` - Observability stack components
- `database` - Database VMs
- `gpu` - VMs with GPU passthrough (currently all K3s agents have GPUs)
- `backup-daily` / `backup-weekly` - Backup schedule classification

### Usage in Automation

Tags are used in:

- **Ansible dynamic inventory** - Target VMs by tag for playbook execution
- **Terraform** - Define VM characteristics and group related resources
- **Monitoring/Alerting** - Classify VMs for metric collection and alert routing

---

## Resource Allocation Standards

### CPU Allocation

| VM Type    | Sockets | Cores | Total vCPUs | Rationale                           |
| ---------- | ------- | ----- | ----------- | ----------------------------------- |
| K3s Master | 1       | 2     | 2           | Control plane needs moderate CPU    |
| K3s Agent  | 2       | 4     | 8           | Workers need more CPU for workloads |

### Memory Allocation

| VM Type    | Memory (MB) | Memory (GB) | Rationale                                |
| ---------- | ----------- | ----------- | ---------------------------------------- |
| K3s Master | 4096        | 4           | Sufficient for etcd and API server       |
| K3s Agent  | 16384       | 16          | Large memory for containerized workloads |

### GPU Passthrough

All K3s agents have GPU passthrough configured:

| VM           | PCI Device ID  | Proxmox Config | Purpose                         |
| ------------ | -------------- | -------------- | ------------------------------- |
| k3s-agent-01 | `0000:00:02.0` | `hostpci0`     | GPU workloads (media, ML, etc.) |
| k3s-agent-02 | `0000:00:02.0` | `hostpci0`     | GPU workloads (media, ML, etc.) |
| k3s-agent-03 | `0000:00:02.0` | `hostpci0`     | GPU workloads (media, ML, etc.) |

**Note:** GPU passthrough requires IOMMU enabled in BIOS and proper Proxmox
configuration.

---

## Quick Reference Card

Use this when creating new infrastructure:

```text
VM Naming:     <service>-<role>-<number>
               Example: k3s-agent-04

VM ID Ranges:  1000-1099: Templates
               2000-2099: Kubernetes
               3000-3099: Applications
               4000-4099: Databases
               5000-5099: Monitoring

VLAN:          30 for K3s cluster

Node Placement: Distribute across pve-01, pve-02, pve-03

Datastore:     pve-ceph (default for production VMs)

Tags:          k3s, master/agent, <workload-type>

Clone From:    1001 (pve-01), 1002 (pve-02), 1003 (pve-03)
```

---

## Change History

| Date       | Author      | Change                                               |
| ---------- | ----------- | ---------------------------------------------------- |
| 2025-11-06 | Claude Code | Initial creation of naming conventions documentation |

---

## Related Documentation

- [Network Reference](../reference/homelab/network/network-reference.md) - Full
  VLAN and network topology
- [Hardware Reference](../reference/homelab/hardware/hardware-reference.md) -
  Physical server specifications
- **Terraform Proxmox Module** - See `lab/provision/terraform/modules/proxmox/`
  for infrastructure as code
- **Ansible K3s Playbooks** - See `lab/provision/ansible/kubernetes/` for
  cluster configuration
