# Obtain current home IP address
data "http" "ipv4" {
    url = "http://ipv4.icanhazip.com"
}

#
# Base records
#

# Record which will be updated by DDNS
resource "cloudflare_record" "apex_ipv4" {
    name    = data.sops_file.cloudflare_secrets.data["public_domain"]
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = chomp(data.http.ipv4.response_body)
    proxied = true
    type    = "A"
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

resource "cloudflare_record" "cname_wireguard" {
    name    = "wireguard"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = "${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
    proxied = false
    type    = "CNAME"
    ttl     = 1
}

resource "cloudflare_record" "cname_jellyfin" {
    name    = "jellyfin"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = "${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
    proxied = true
    type    = "CNAME"
    ttl     = 1
}

resource "cloudflare_record" "cname_bitwarden" {
    name    = "bitwarden"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = "${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
    proxied = true
    type    = "CNAME"
    ttl     = 1
}

resource "cloudflare_record" "cname_monitor" {
    name    = "monitor"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = "${data.sops_file.cloudflare_secrets.data["cloudflare_domain"]}"
    proxied = true
    type    = "CNAME"
    ttl     = 1
}


resource "cloudflare_record" "cname_domain-connect" {
    name    = "_domainconnect"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = "connect.domains.google.com"
    proxied = true
    type    = "CNAME"
    ttl     = 1
}

resource "cloudflare_record" "cname_aws-1" {
    name    = data.sops_file.cloudflare_secrets.data["cname_aws-1.name"]
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = data.sops_file.cloudflare_secrets.data["cname_aws-1.value"]
    proxied = false
    type    = "CNAME"
    ttl     = 1
}

resource "cloudflare_record" "cname_aws-2" {
    name    = data.sops_file.cloudflare_secrets.data["cname_aws-2.name"]
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = data.sops_file.cloudflare_secrets.data["cname_aws-2.value"]
    proxied = false
    type    = "CNAME"
    ttl     = 1
}

resource "cloudflare_record" "cname_aws-3" {
    name    = data.sops_file.cloudflare_secrets.data["cname_aws-3.name"]
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = data.sops_file.cloudflare_secrets.data["cname_aws-3.value"]
    proxied = false
    type    = "CNAME"
    ttl     = 1
}

resource "cloudflare_record" "mx_service" {
    name    = "service"
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = "feedback-smtp.us-east-2.amazonses.com"
    proxied = false
    type    = "MX"
    ttl     = 1
    priority = 10
}

resource "cloudflare_record" "txt_public-domain" {
    name    = data.sops_file.cloudflare_secrets.data["txt_public-domain.name"]
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = data.sops_file.cloudflare_secrets.data["txt_public-domain.value"]
    proxied = false
    type    = "TXT"
    ttl     = 1
}

resource "cloudflare_record" "txt_dmarc" {
    name    = data.sops_file.cloudflare_secrets.data["txt_dmarc.name"]
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = data.sops_file.cloudflare_secrets.data["txt_dmarc.value"]
    proxied = false
    type    = "TXT"
    ttl     = 1
}

resource "cloudflare_record" "txt_domainkey" {
    name    = data.sops_file.cloudflare_secrets.data["txt_domainkey.name"]
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = data.sops_file.cloudflare_secrets.data["txt_domainkey.value"]
    proxied = false
    type    = "TXT"
    ttl     = 1
}

resource "cloudflare_record" "txt_service" {
    name    = data.sops_file.cloudflare_secrets.data["txt_service.name"]
    zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
    value   = data.sops_file.cloudflare_secrets.data["txt_service.value"]
    proxied = false
    type    = "TXT"
    ttl     = 1
}
