resource "proxmox_virtual_environment_vm" "k3s-agent" {
  for_each = var.k3s-agents

  name = each.key
  tags = ["k3s", "agent"]
  node_name = each.value.node_name
  description = "K3s Agent Node: ${each.key}"
  vm_id = each.value.vm_id

  acpi = true

  agent {
    enabled = true
    timeout = "10m"
    trim = false
    type = "virtio"
  }

  bios = "seabios"

  clone {
    datastore_id = each.value.datastore_id
    node_name = each.value.node_name
    retries = 3
    vm_id = each.value.clone_vmid
    full = true
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
    size = 256
    discard = "on"
    ssd = true
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
  timeout_reboot = 1800
  scsi_hardware = "virtio-scsi-single"
  started = true
  migrate = false
  timeout_migrate = 1800

  # startup {
  #   order = 0
  #   up = 60
  #   down = 60
  # }

  tablet_device = true
  vga {
    type = "qxl"
    memory = 16
  }

  # hostpci {
  #   device = each.value.hostpci_device
  #   id = each.value.hostpci_id
  #   pcie = false
  #   rombar = true
  #   xvga = false
  # }

  # provisioner "local-exec" {
  #   command = "cd ~/buildworkspace/home-ops/lab/provision/ansible/kubernetes/ && ansible-playbook playbooks/check-status.yml"
  # }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = data.sops_file.proxmox_secrets.data["ssh.username"]
      host     = "${each.key}.${data.sops_file.proxmox_secrets.data["public_domain"]}"
      port     = 22
      password = data.sops_file.proxmox_secrets.data["ssh.password"]
    }
    # Waits for cloud-init to finish initializing and prevent output
    inline = [
      "cloud-init status --wait > /dev/null 2>&1"
    ]
  }

  # Prevents recreate
  lifecycle {
    ignore_changes = [started]
  }
}
