resource "proxmox_vm_qemu" "k3s-master-01" {
    name        = "k3s-master-01"
    target_node = "pve-02"
    vmid = 2001

    clone = "test"
}

# resource "proxmox_vm_qemu" "k3s-master-02" {
#     name        = "k3s-master-02"
#     target_node = "pve-02"
#     vmid = 2002

#     # clone = "template to clone"
# }

# resource "proxmox_vm_qemu" "k3s-master-03" {
#     name        = "k3s-master-03"
#     target_node = "pve-03"
#     vmid = 2003

#     # clone = "template to clone"
# }

# resource "proxmox_vm_qemu" "k3s-worker-01" {
#     name        = "k3s-worker-01"
#     target_node = "pve-01"
#     vmid = 2011

#     # clone = "template to clone"
# }

# resource "proxmox_vm_qemu" "k3s-worker-02" {
#     name        = "k3s-worker-02"
#     target_node = "pve-02"
#     vmid = 2012

#     # clone = "template to clone"
# }

# resource "proxmox_vm_qemu" "k3s-worker-03" {
#     name        = "k3s-worker-03"
#     target_node = "pve-03"
#     vmid = 2013

#     # clone = "template to clone"
# }
