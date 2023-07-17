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
variable "pm_url" {
    type        = string
    description = "Proxmox API URL"
    default     = "https://10.23.20.11:8006/api2/json"
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
# variable "nodes" {
#     type = list(string)
#     description = "PVE Nodes List"
#     default = ["pve-01", "pve-02", "pve-03"]
# }
# variable "k3s-master" {
#     type = map(map(string))
#     default = {
#         k3s-master-01 = {
#             tags        ="k3s;master"
#             node_name = "pve-01"
#             vm_id        = 2011
#             sockets     = 1
#             vcpus       = 2
#             cores       = 2
#             memory      = 4096
#         }
#         k3s-master-02 = {
#             tags        ="k3s;master"
#             node_name = "pve-02"
#             vm_id        = 2012
#             sockets     = 1
#             vcpus       = 2
#             cores       = 2
#             memory      = 4096
#         }
#         k3s-master-03 = {
#             tags        ="k3s;master"
#             node_name = "pve-03"
#             vm_id        = 2013
#             sockets     = 1
#             vcpus       = 2
#             cores       = 2
#             memory      = 4096
#         }
#     }
# }
