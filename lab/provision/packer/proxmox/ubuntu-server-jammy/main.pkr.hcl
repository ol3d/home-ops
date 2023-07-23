packer {
    required_plugins {
        proxmox = {
            version = "1.1.3"
            source  = "github.com/hashicorp/proxmox"
        }
    }
}

source "proxmox-iso" "ubuntu-server-jammy" {

    # Proxmox connection settings
    proxmox_url              = "${var.pm_url}"
    username                 = "${var.pm_user}"
    password                 = "${var.pm_pass}"
    insecure_skip_tls_verify = true

    # VM General Settings
    node                 = "pve-01"
    vm_id                = "1000"
    vm_name              = "ubuntu-server-jammy"
    template_description = "Ubuntu Server 22.04.2 (Jammy Jellyfish)"

    iso_url          = "https://releases.ubuntu.com/jammy/ubuntu-22.04.2-live-server-amd64.iso"
    iso_checksum     = "5e38b55d57d94ff029719342357325ed3bda38fa80054f9330dc789cd2d43931"
    iso_storage_pool = "local"
    unmount_iso      = true

    # VM System Settings
    qemu_agent  = true
    onboot      = false
    disable_kvm = false

    bios        = "seabios"

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-single"

    disks {
        disk_size    = "32G"
        format       = "raw"
        storage_pool = "pve-ceph"
        type         = "scsi"
        cache_mode   = "none"
        io_thread    = true
        # TODO toggle on once release has been cut to include
        # ssd = true
        # discard = "on"
    }

    # VM CPU Settings
    cores    = "2"
    sockets  = "1"
    cpu_type = "kvm64"
    os = "l26"

    # VM Memory Settings
    memory = "4096"

    # VM Network Settings
    network_adapters {
        model    = "virtio"
        bridge   = "vmbr0"
        # vlan_tag = "30"
        # firewall = "true"
        # mtu      = 1
    }

    # VM Cloud-Init Settings
    cloud_init              = false
    # cloud_init_storage_pool = "pve-ceph"

    # PACKER Boot Commands
    boot_command = [
        "<esc><wait>",
        "e<down><down><down><end>",
        "<bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
        "<f10><wait>"
    ]
    # boot      = "c"
    boot_wait = "5s"

    vga {
        type = "qxl"
        memory = 16
    }

    # PACKER Autoinstall Settings
    http_directory = "http"

    # SSH Communicator Settings
    ssh_username = "${var.ssh_user}"
    ssh_password = "${var.ssh_pass}"
    ssh_timeout = "15m"
    ssh_port = 22
    ssh_pty = false
}

build {
    name    = "ubuntu-server-jammy"
    sources = ["source.proxmox-iso.ubuntu-server-jammy"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source      = "files/ubuntu-server-jammy.cfg"
        destination = "/tmp/ubuntu-server-jammy.cfg"
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    provisioner "shell" {
        inline = ["sudo cp /tmp/ubuntu-server-jammy.cfg /etc/cloud/cloud.cfg.d/ubuntu-server-jammy.cfg"]
    }
}