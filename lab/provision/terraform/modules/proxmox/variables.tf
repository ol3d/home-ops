variable "k3s-master" {
    type = map(map(string))
    default = {
        k3s-master-01 = {
            node_name   = "pve-01"
            vm_id       = 2011
            sockets     = 1
            cores       = 2
            memory      = 4096
            macaddr     = "8A:E5:9E:A5:BB:B4"
            clone_vmid  = 1001
            datastore_id = "pve-ceph"
        }
        k3s-master-02 = {
            node_name   = "pve-02"
            vm_id       = 2012
            sockets     = 1
            cores       = 2
            memory      = 4096
            macaddr     = "4A:F8:E0:36:5D:CE"
            clone_vmid  = 1002
            datastore_id = "pve-ceph"
        }
        k3s-master-03 = {
            node_name   = "pve-03"
            vm_id       = 2013
            sockets     = 1
            cores       = 2
            memory      = 4096
            macaddr     = "4E:78:A1:1B:A2:75"
            clone_vmid  = 1003
            datastore_id = "pve-ceph"
        }
    }
}

variable "k3s-agent" {
    type = map(map(string))
    default = {
        k3s-agent-01 = {
            node_name   = "pve-01"
            vm_id       = 2021
            sockets     = 1
            cores       = 4
            memory      = 16384
            macaddr     = "92:C0:F5:CA:85:26"
            clone_vmid  = 1001
            datastore_id = "pve-ceph"
        }
        k3s-agent-02 = {
            node_name   = "pve-02"
            vm_id       = 2022
            sockets     = 1
            cores       = 4
            memory      = 16384
            macaddr     = "02:EE:4A:15:B5:AF"
            clone_vmid  = 1002
            datastore_id = "pve-ceph"
        }
        k3s-agent-03 = {
            node_name   = "pve-03"
            vm_id       = 2023
            sockets     = 1
            cores       = 4
            memory      = 16384
            macaddr     = "F2:88:DD:49:28:2C"
            clone_vmid  = 1003
            datastore_id = "pve-ceph"
        }
    }
}
