resource "proxmox_virtual_environment_vm" "k3s-masters" {
    for_each    = var.k3s-master

    name        = each.key
    tags        = ["k3s", "master"]
    node_name = each.value.node_name
    description = "K3s Master Node: ${each.key}"
    vm_id        = each.value.vm_id

    acpi = true

    agent {
        enabled = true
        timeout = "10m"
        trim = false
        type = "virtio"
    }

    bios        = "seabios"

    clone {
        datastore_id = each.value.datastore_id
        node_name = each.value.node_name
        retries = 3
        vm_id = each.value.clone_vmid
    }

    initialization {
        datastore_id = each.value.datastore_id
        ip_config {
            ipv4 {
                address = "dhcp"
            }
        }
    }

    cpu {
        architecture = "x86_64"
        sockets = each.value.sockets
        cores = each.value.cores
        numa = false
        type = "kvm64"
    }

    disk {
        datastore_id = each.value.datastore_id
        file_format = "raw"
        interface = "scsi0"
        iothread = true
        size = 128
        # discard = "on"
        # ssd = true
    }

    memory {
        dedicated = each.value.memory
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
