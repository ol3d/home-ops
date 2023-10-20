# # # Obtain current home IP address
# # data "http" "ipv4" {
# #     url = "http://ipv4.icanhazip.com"
# # }

# # #
# # # Base records
# # #

# # # Record which will be updated by DDNS
# # resource "cloudflare_record" "apex_ipv4" {
# #     name    = data.sops_file.cloudflare_secrets.data["public_domain"]
# #     zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
# #     value   = chomp(data.http.ipv4.response_body)
# #     proxied = true
# #     type    = "A"
# #     ttl     = 1
# # }

resource "cloudflare_record" "dns_record" {
    for_each = var.dns_records

    # Required values
    name    = each.value.name
    type    = each.value.type
    zone_id = data.sops_file.cloudflare_secrets.data["zone_id"]

    # Optional values
    value   = each.value.value
    proxied = each.value.proxied
    ttl     = each.value.ttl
    comment = each.value.comment
}

resource "cloudflare_record" "cname_email-mailgun" {
    name    = "email.mailgun"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = "mailgun.org"
    proxied = false
    type    = "CNAME"
    ttl     = 1
    comment = "Required by Mailgun to track opens, clicks, and unsubscribes"
}

resource "cloudflare_record" "cname_mailgun" {
    name    = "mailgun"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = "${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
    proxied = true
    type    = "CNAME"
    ttl     = 1
}

resource "cloudflare_record" "cname_www" {
    name    = "www"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = "${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
    proxied = true
    type    = "CNAME"
    ttl     = 1
}

resource "cloudflare_record" "mx_mxa" {
    name    = "mailgun"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = data.sops_file.cloudflare_secrets.data["dns_records.mx_mxa"]
    proxied = false
    type    = "MX"
    ttl     = 1
    priority = 10
    comment = "Recommended by Mailgun for all domains"
}

resource "cloudflare_record" "mx_mxb" {
    name    = "mailgun"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = data.sops_file.cloudflare_secrets.data["dns_records.mx_mxb"]
    proxied = false
    type    = "MX"
    ttl     = 1
    priority = 10
    comment = "Recommended by Mailgun for all domains"
}

resource "cloudflare_record" "txt_domainkey" {
    name    = "krs._domainkey.mailgun"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = data.sops_file.cloudflare_secrets.data["dns_records.txt_mg-key"]
    proxied = false
    type    = "TXT"
    ttl     = 1
    comment = "Required by Mailgun to send and receive emails"
}

resource "cloudflare_record" "txt_mailgun" {
    name    = "mailgun"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = data.sops_file.cloudflare_secrets.data["dns_records.txt_mg"]
    proxied = false
    type    = "TXT"
    ttl     = 1
    comment = "Required by Mailgun to send and receive emails"
}
