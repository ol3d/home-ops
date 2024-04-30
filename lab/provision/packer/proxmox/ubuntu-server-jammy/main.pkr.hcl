packer {
    required_plugins {
        proxmox = {
            version = "1.1.7"
            source  = "github.com/hashicorp/proxmox"
        }
    }
}

source "proxmox-iso" "ubuntu-server-jammy" {
    # Proxmox connection settings
    username                 = "${var.pm_user}"
    password                 = "${var.pm_pass}"
    insecure_skip_tls_verify = true

    # VM General Settings
    vm_name              = "ubuntu-server-jammy"
    template_description = "Ubuntu Server 22.04.4 (Jammy Jellyfish)"

    iso_url          = "https://releases.ubuntu.com/jammy/ubuntu-22.04.4-live-server-amd64.iso"
    iso_checksum     = "45f873de9f8cb637345d6e66a583762730bbea30277ef7b32c9c3bd6700a32b2"
    iso_storage_pool = "local"
    iso_download_pve = false
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
        ssd = true
        discard = true
    }

    # VM CPU Settings
    cores    = "1"
    sockets  = "1"
    cpu_type = "kvm64"
    os = "l26"

    # VM Memory Settings
    memory = "4096"
    numa = false

    # VM Network Settings
    network_adapters {
        model    = "virtio"
        bridge   = "vmbr0"
        firewall = "true"
        mtu      = 1
    }

    # VM Cloud-Init Settings
    cloud_init = false

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
        memory = 4
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
    dynamic "source" {
        for_each = "${var.nodes}"
        labels   = ["proxmox-iso.ubuntu-server-jammy"]
        content {
            node = source.key
            vm_id = source.value.vm_id
            proxmox_url = source.value.pm_url
        }
    }

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
