<!-- cspell:ignore Protectli OPNSense Proxmox VLANs hostpci -->

# Network Topology

This page provides a visual representation of the homelab network infrastructure, showing the hierarchical relationship between network devices, physical hosts, and virtual machines.

## Infrastructure Overview

The homelab uses a layered architecture with dedicated VLANs for traffic segmentation. The core infrastructure includes:

- **Edge**: OPNSense firewall (Protectli FW4C) providing routing and security
- **Distribution**: Cisco switches for VLAN management and connectivity
- **Compute**: Proxmox VE cluster (3 nodes) hosting virtual machines
- **Workload**: K3s Kubernetes cluster (HA configuration with 3 masters + 3 agents)

## Network Topology Diagram

```mermaid
graph TD
    Internet[Internet] --> FW[OPNSense Firewall<br/>Protectli FW4C]
    
    FW --> SW_CTRL[Cisco WS-2960L-48TS-LL<br/>Control Switch]
    FW --> SW_POE[Cisco WS-2960L-24PS-LL<br/>PoE Access Switch]
    
    SW_CTRL --> VLAN30[VLAN 30: K3s Cluster<br/>10.10.30.0/24]
    
    VLAN30 --> PVE1[pve-01<br/>Supermicro X11SCL-iF]
    VLAN30 --> PVE2[pve-02<br/>Supermicro X11SCL-iF]
    VLAN30 --> PVE3[pve-03<br/>Supermicro X11SCL-iF]
    
    PVE1 --> M1[k3s-master-01<br/>VMID: 2011<br/>10.10.30.11<br/>2C/4GB]
    PVE1 --> A1[k3s-agent-01<br/>VMID: 2021<br/>10.10.30.21<br/>8C/16GB+GPU]
    
    PVE2 --> M2[k3s-master-02<br/>VMID: 2012<br/>10.10.30.12<br/>2C/4GB]
    PVE2 --> A2[k3s-agent-02<br/>VMID: 2022<br/>10.10.30.22<br/>8C/16GB+GPU]
    
    PVE3 --> M3[k3s-master-03<br/>VMID: 2013<br/>10.10.30.13<br/>2C/4GB]
    PVE3 --> A3[k3s-agent-03<br/>VMID: 2023<br/>10.10.30.23<br/>8C/16GB+GPU]
    
    M1 -.HA Cluster.-> M2
    M2 -.HA Cluster.-> M3
    M3 -.HA Cluster.-> M1
    
    M1 -.Workloads.-> A1
    M1 -.Workloads.-> A2
    M1 -.Workloads.-> A3
    M2 -.Workloads.-> A1
    M2 -.Workloads.-> A2
    M2 -.Workloads.-> A3
    M3 -.Workloads.-> A1
    M3 -.Workloads.-> A2
    M3 -.Workloads.-> A3
    
    style FW fill:#ff6b6b,stroke:#c92a2a,color:#fff
    style SW_CTRL fill:#4dabf7,stroke:#1971c2,color:#fff
    style SW_POE fill:#4dabf7,stroke:#1971c2,color:#fff
    style VLAN30 fill:#ffd43b,stroke:#fab005,color:#000
    style PVE1 fill:#20c997,stroke:#087f5b,color:#fff
    style PVE2 fill:#20c997,stroke:#087f5b,color:#fff
    style PVE3 fill:#20c997,stroke:#087f5b,color:#fff
    style M1 fill:#845ef7,stroke:#5f3dc4,color:#fff
    style M2 fill:#845ef7,stroke:#5f3dc4,color:#fff
    style M3 fill:#845ef7,stroke:#5f3dc4,color:#fff
    style A1 fill:#fa5252,stroke:#c92a2a,color:#fff
    style A2 fill:#fa5252,stroke:#c92a2a,color:#fff
    style A3 fill:#fa5252,stroke:#c92a2a,color:#fff
```

## Key Components

### Edge Security

- **OPNSense Firewall (Protectli FW4C)**: Provides network edge security, routing between VLANs, and internet connectivity

### Network Distribution

- **Cisco WS-2960L-48TS-LL**: Primary control switch for inter-VLAN routing and trunk connections
- **Cisco WS-2960L-24PS-LL**: PoE-capable access switch for powered devices

### VLAN Segmentation

- **VLAN 30 (10.10.30.0/24)**: Dedicated network for Kubernetes cluster traffic, isolated from other homelab VLANs

### Compute Layer (Proxmox VE)

- **pve-01, pve-02, pve-03**: Three-node Proxmox cluster providing high availability and distributed compute resources
- Each node runs:
  - 1x K3s master (control plane)
  - 1x K3s agent (worker node with GPU passthrough)

### Kubernetes Cluster (K3s)

**Control Plane (Masters):**

- **k3s-master-01** (VMID 2011): Control plane node on pve-01
- **k3s-master-02** (VMID 2012): Control plane node on pve-02
- **k3s-master-03** (VMID 2013): Control plane node on pve-03

**Worker Nodes (Agents):**

- **k3s-agent-01** (VMID 2021): Worker node on pve-01 with GPU passthrough (hostpci0)
- **k3s-agent-02** (VMID 2022): Worker node on pve-02 with GPU passthrough (hostpci0)
- **k3s-agent-03** (VMID 2023): Worker node on pve-03 with GPU passthrough (hostpci0)

## High Availability Design

The infrastructure is designed for high availability:

1. **Distributed Masters**: K3s control plane nodes are spread across all three Proxmox hosts
2. **Distributed Workers**: K3s agents are evenly distributed to balance workload
3. **Node Failure Tolerance**: Loss of any single Proxmox node leaves cluster operational with 2/3 masters and 2/3 agents
4. **Network Redundancy**: Multiple switches provide failover capability

## GPU Passthrough

All K3s agent nodes have Intel integrated GPUs passed through via PCI passthrough (hostpci0 = 0000:00:02.0). This enables:

- Hardware-accelerated media transcoding
- ML/AI workloads
- Video processing applications

## Related Documentation

- [Network Reference](network-reference.md) - Detailed VLAN and network configuration
- [Naming Conventions](../../../concepts/naming-conventions.md) - VM naming, ID ranges, and resource allocation
- [Hardware Reference](../hardware/hardware-reference.md) - Physical server specifications
- [Proxmox Cluster Setup](../../../setup/proxmox/proxmox-cluster-setup.md) - Cluster installation guide
