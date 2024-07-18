variable "pm_user" {
    type        = string
    description = "Proxmox Packer Default User"
    default     = "packer@pve"
}
variable "pm_pass" {
    type        = string
    description = "Proxmox Packer User Password"
    default     = "packer"
    sensitive = true
}
variable "ssh_user" {
    type        = string
    description = "SSH User"
    default     = "packer"
}
variable "ssh_pass" {
    type        = string
    description = "SSH Password"
    default     = "packer"
    sensitive = true
}
variable "nodes" {
    type = map(map(string))
    default = {
        "pve-01" = {
            vm_id  = 1001
            pm_url = "https://10.10.20.11:8006/api2/json"
        }
        "pve-02" = {
            vm_id = 1002
            pm_url = "https://10.10.20.12:8006/api2/json"
        }
        "pve-03" = {
            vm_id = 1003
            pm_url = "https://10.10.20.13:8006/api2/json"
        }
    }
}
