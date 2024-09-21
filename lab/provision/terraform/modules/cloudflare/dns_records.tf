# Obtain current home IP address
data "http" "ipv4" {
    url = "http://ipv4.icanhazip.com"
}

# # #
# # # Base records
# # #

# Record which will be updated by DDNS
resource "cloudflare_record" "apex_ipv4" {
    name    = data.sops_file.cloudflare_secrets.data["public_domain"]
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    content   = chomp(data.http.ipv4.response_body)
    proxied = true
    type    = "A"
    ttl     = 1
}

resource "cloudflare_record" "dns_record" {
    for_each = var.dns_records

    # Required values
    name    = each.value.name
    type    = each.value.type
    zone_id = data.sops_file.cloudflare_secrets.data["zone_id"]

    # Optional values
    content   = each.value.content
    proxied = each.value.proxied
    ttl     = each.value.ttl
    comment = each.value.comment
}

# CNAME 'www' Record
resource "cloudflare_record" "base_cname_www" {
    name    = "www"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    content   = "${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
    proxied = true
    type    = "CNAME"
    ttl     = 1
}

# # #
# # # Mailgun Records
# # #

# Mailgun CNAME 'email.mailgun' Record
resource "cloudflare_record" "mg_cname_email" {
    name    = "email.mailgun"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    content   = data.sops_file.cloudflare_secrets.data["dns_records.mg.cname"]
    proxied = false
    type    = "CNAME"
    ttl     = 1
    comment = "Required by Mailgun to track opens, clicks, and unsubscribes"
}

# Mailgun MX 'mxa.mailgun' Record
resource "cloudflare_record" "mg_mx_mxa" {
    name    = "mailgun"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    content   = data.sops_file.cloudflare_secrets.data["dns_records.mg.mx_mxa"]
    proxied = false
    type    = "MX"
    ttl     = 1
    priority = 10
    comment = "Recommended by Mailgun for all domains"
}

# Mailgun MX 'mxb.mailgun' Record
resource "cloudflare_record" "mg_mx_mxb" {
    name    = "mailgun"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    content   = data.sops_file.cloudflare_secrets.data["dns_records.mg.mx_mxb"]
    proxied = false
    type    = "MX"
    ttl     = 1
    priority = 10
    comment = "Recommended by Mailgun for all domains"
}

# Mailgun TXT 'krs._domainkey.mailgun' Record
resource "cloudflare_record" "mg_txt_domainkey" {
    name    = "krs._domainkey.mailgun"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    content   = data.sops_file.cloudflare_secrets.data["dns_records.mg.txt_key"]
    proxied = false
    type    = "TXT"
    ttl     = 1
    comment = "Required by Mailgun to send and receive emails"
}

# Mailgun TXT 'mailgun' Record
resource "cloudflare_record" "mg_txt" {
    name    = "mailgun"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    content   = data.sops_file.cloudflare_secrets.data["dns_records.mg.txt"]
    proxied = false
    type    = "TXT"
    ttl     = 1
    comment = "Required by Mailgun to send and receive emails"
}

# # #
# # # Fastmail Records
# # #

# Fastmail MX '@' Record
resource "cloudflare_record" "fm_mx_mxa" {
    name    = "@"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    content   = data.sops_file.cloudflare_secrets.data["dns_records.fm.mx_1"]
    proxied = false
    type    = "MX"
    ttl     = 1
    priority = 10
    comment = "Required by Fastmail for all custom domain"
}

# Fastmail MX '@' Record
resource "cloudflare_record" "fm_mx_mxb" {
    name    = "@"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    content   = data.sops_file.cloudflare_secrets.data["dns_records.fm.mx_2"]
    proxied = false
    type    = "MX"
    ttl     = 1
    priority = 20
    comment = "Required by Fastmail for all custom domain"
}

# Fastmail CNAME 'fm1._domainkey' Record
resource "cloudflare_record" "fm_cname_1" {
    name    = "fm1._domainkey"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    content   = data.sops_file.cloudflare_secrets.data["dns_records.fm.fm1"]
    proxied = false
    type    = "CNAME"
    ttl     = 1
    comment = "Required by Fastmail to track opens, clicks, and unsubscribes"
}

# Fastmail CNAME 'fm2._domainkey' Record
resource "cloudflare_record" "fm_cname_2" {
    name    = "fm2._domainkey"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    content   = data.sops_file.cloudflare_secrets.data["dns_records.fm.fm2"]
    proxied = false
    type    = "CNAME"
    ttl     = 1
    comment = "Required by Fastmail to track opens, clicks, and unsubscribes"
}

# Fastmail CNAME 'fm3._domainkey' Record
resource "cloudflare_record" "fm_cname_3" {
    name    = "fm3._domainkey"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    content   = data.sops_file.cloudflare_secrets.data["dns_records.fm.fm3"]
    proxied = false
    type    = "CNAME"
    ttl     = 1
    comment = "Required by Fastmail to track opens, clicks, and unsubscribes"
}

# Fastmail TXT '@' Record
resource "cloudflare_record" "fm_txt" {
    name    = "@"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    content   = data.sops_file.cloudflare_secrets.data["dns_records.fm.txt"]
    proxied = false
    type    = "TXT"
    ttl     = 1
    comment = "Required by Fastmail to send and receive emails"
}
