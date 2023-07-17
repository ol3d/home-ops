variable "common" {
    type = map(string)
    default = {
        clone_vmid = 1000
    }
}

variable "docker-nodes" {
    type = map(map(string))
    default = {
        docker-01 = {
            tags        = "docker-swarm"
            node_name   = "pve-01"
            vm_id       = 3001
            sockets     = 1
            vcpus       = 2
            cores       = 2
            memory      = 8192
            # Must be a valid Unicast MAC Address
            macaddr     = "0E:19:07:AF:75:DF"
        }
    }
}

variable "k3s-master" {
    type = map(map(string))
    default = {
        # k3s-master-01 = {
        #     tags        ="k3s;master"
        #     node_name = "pve-01"
        #     vm_id        = 2011
        #     sockets     = 1
        #     vcpus       = 2
        #     cores       = 2
        #     memory      = 4096
        #     macaddr     = "8a:e5:9e:a5:bb:b4"
        # }
        # k3s-master-02 = {
        #     tags        ="k3s;master"
        #     node_name = "pve-02"
        #     vm_id        = 2012
        #     sockets     = 1
        #     vcpus       = 2
        #     cores       = 2
        #     memory      = 4096
        #     macaddr     = "4a:f8:e0:36:5d:ce"
        # }
        # k3s-master-03 = {
        #     tags        ="k3s;master"
        #     node_name = "pve-03"
        #     vm_id        = 2013
        #     sockets     = 1
        #     vcpus       = 2
        #     cores       = 2
        #     memory      = 4096
        #     macaddr     = "4e:78:a1:1b:a2:75"
        # }
    }
}

variable "k3s-agent" {
    type = map(map(string))
    default = {
        # k3s-agent-01 = {
        #     tags        ="k3s;agent"
        #     node_name = "pve-01"
        #     vm_id        = 2021
        #     sockets     = 1
        #     vcpus       = 4
        #     cores       = 4
        #     memory      = 16384
        #     macaddr     = "92:c0:f5:ca:85:26"
        # }
        # k3s-agent-02 = {
        #     tags        ="k3s;agent"
        #     node_name = "pve-02"
        #     vm_id        = 2022
        #     sockets     = 1
        #     vcpus       = 4
        #     cores       = 4
        #     memory      = 16384
        #     macaddr     = "02:ee:4a:15:b5:af"
        # }
        # k3s-agent-03 = {
        #     tags        ="k3s;agent"
        #     node_name = "pve-03"
        #     vm_id        = 2023
        #     sockets     = 1
        #     vcpus       = 4
        #     cores       = 4
        #     memory      = 16384
        #     macaddr     = "f2:88:dd:49:28:2c"
        # }
    }
}
