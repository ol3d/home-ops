resource "proxmox_virtual_environment_vm" "docker-swarm" {
    for_each    = var.docker-nodes

    name        = each.key
    tags        = ["docker-swarm"]
    node_name   = each.value.node_name
    description = "Docker Swarm Node: ${each.key}"
    vm_id       = each.value.vm_id

    acpi = true

    agent {
        enabled = true
        timeout = "10m"
        trim = false
        type = "virtio"
    }

    bios        = "seabios"

    clone {
        datastore_id = "pve-ceph"
        node_name = "pve-01"
        retries = 3
        vm_id = var.common.clone_vmid
    }

    initialization {
        datastore_id = "pve-ceph"
        ip_config {
            ipv4 {
                address = "dhcp"
            }
        }
    }

    cpu {
        architecture = "x86_64"
        cores = 2
        numa = false
        type = "kvm64"
    }

    disk {
        datastore_id = "pve-ceph"
        file_format = "raw"
        interface = "scsi0"
        iothread = true
        size = 128
        # discard = "on"
        # ssd = true
    }

    memory {
        dedicated = 8192
    }

    network_device {
        bridge = "vmbr0"
        enabled = true
        firewall = true
        model = "virtio"
        mtu = 1
        vlan_id = 30
        mac_address = each.value.macaddr
    }

    on_boot = true

    operating_system {
        type = "l26"
    }

    reboot = false
    scsi_hardware = "virtio-scsi-single"
    started = false

    tablet_device = true
    vga {
        type = "qxl"
        memory = 16
        enabled = true
    }
}
