terraform {
    required_version = ">= 0.13.0"

    required_providers {
        proxmox = {
            source = "Telmate/proxmox"
            version = "2.9.14"
        }
        sops = {
            source = "carlpett/sops"
            version = "0.7.2"
        }
    }
}

data "sops_file" "proxmox_secrets" {
    source_file = "secret.sops.yaml"
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = data.sops_file.proxmox_secrets.data["proxmox.pm_api_url"]
    pm_parallel = 4
    pm_user = data.sops_file.proxmox_secrets.data["proxmox.pm_user"]
    pm_password = data.sops_file.proxmox_secrets.data["proxmox.pm_password"]
    pm_log_enable = true
    pm_log_file = "terraform-plugin-proxmox.log"
    pm_debug = true
    pm_log_levels = {
        _default = "debug"
        _capturelog = ""
    }
}
