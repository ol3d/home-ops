variable "dns_records" {
    type = map(object({
        name    = string
        value   = string
        proxied = bool
        ttl     = number
        type    = string
        comment = string
    }))
    default = {
        dns1 = {
            name    = "_domainconnect"
            value   = "connect.domains.google.com"
            proxied = true
            ttl     = 1
            type    = "CNAME"
            comment = ""
        }
    }
}
