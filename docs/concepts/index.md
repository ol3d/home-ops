# Concepts

This section covers fundamental concepts, design patterns, and organizational conventions used throughout the homelab infrastructure. These documents explain the "why" and "how" behind architectural decisions.

---

## Infrastructure Organization

### [Naming Conventions](naming-conventions.md)

Standardized naming patterns, ID ranges, and organizational conventions for VMs, networks, and infrastructure components.

**Topics covered:**

- VM naming patterns (`<service>-<role>-<number>`)
- VM ID ranges and allocation (1000-1099 for templates, 2000-2099 for K3s, etc.)
- VLAN assignments and network segmentation
- Proxmox node naming and VM placement strategy
- Storage datastore conventions
- DNS and FQDN patterns
- Tagging strategy for automation
- Resource allocation standards (CPU, memory, GPU)

**Use this when:**

- Creating new VMs or expanding infrastructure
- Understanding why VMs have specific IDs or names
- Planning network or storage changes
- Onboarding new team members

---

## Coming Soon

Additional concept documentation planned:

- **Architecture Overview** - High-level infrastructure design and topology
- **Security Model** - Network segmentation, access control, and secrets management
- **High Availability Design** - How HA is achieved across K3s and Proxmox
- **Backup and Disaster Recovery** - Strategy and procedures
- **GitOps Workflow** - How infrastructure changes flow from code to production
