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
  content = chomp(data.http.ipv4.response_body)
  proxied = true
  type    = "A"
  ttl     = 1
}

# CNAME 'www' Record
resource "cloudflare_record" "base_cname_www" {
  name    = "www"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = data.sops_file.cloudflare_secrets.data["cloudflare_domain"]
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
  content = data.sops_file.cloudflare_secrets.data["dns_records.mg.cname"]
  proxied = false
  type    = "CNAME"
  ttl     = 1
  comment = "Required by Mailgun to track opens, clicks, and unsubscribes"
}

# Mailgun MX 'mxa.mailgun' Record
resource "cloudflare_record" "mg_mx_mxa" {
  name     = "mailgun"
  zone_id  = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content  = data.sops_file.cloudflare_secrets.data["dns_records.mg.mx_mxa"]
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 10
  comment  = "Recommended by Mailgun for all domains"
}

# Mailgun MX 'mxb.mailgun' Record
resource "cloudflare_record" "mg_mx_mxb" {
  name     = "mailgun"
  zone_id  = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content  = data.sops_file.cloudflare_secrets.data["dns_records.mg.mx_mxb"]
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 10
  comment  = "Recommended by Mailgun for all domains"
}

# Mailgun TXT 'krs._domainkey.mailgun' Record
resource "cloudflare_record" "mg_txt_domainkey" {
  name    = "krs._domainkey.mailgun"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = data.sops_file.cloudflare_secrets.data["dns_records.mg.txt_key"]
  proxied = false
  type    = "TXT"
  ttl     = 1
  comment = "Required by Mailgun to send and receive emails"
}

# Mailgun TXT 'mailgun' Record
resource "cloudflare_record" "mg_txt" {
  name    = "mailgun"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = data.sops_file.cloudflare_secrets.data["dns_records.mg.txt"]
  proxied = false
  type    = "TXT"
  ttl     = 1
  comment = "Required by Mailgun to send and receive emails"
}

# # #
# # # Proton Mail Records
# # #

# Proton Mail TXT '@' Record
resource "cloudflare_record" "pm_txt" {
  name    = "@"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = data.sops_file.cloudflare_secrets.data["dns_records.pm.txt"]
  proxied = false
  type    = "TXT"
  ttl     = 1
  comment = "Required by Proton Mail to verify domain owner"
}

# Proton Mail MX '@' Record 1
resource "cloudflare_record" "pm_mx_mx_1" {
  name     = "@"
  zone_id  = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content  = data.sops_file.cloudflare_secrets.data["dns_records.pm.mx_1"]
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 10
  comment  = "Required by Proton Mail to recieve emails for all custom domains"
}

# Proton Mail MX '@' Record 2
resource "cloudflare_record" "pm_mx_mx_2" {
  name     = "@"
  zone_id  = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content  = data.sops_file.cloudflare_secrets.data["dns_records.pm.mx_2"]
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 20
  comment  = "Required by Proton Mail to recieve emails for all custom domains"
}

# Proton Mail TXT '@' SPF Record
resource "cloudflare_record" "pm_txt_spf" {
  name    = "@"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = data.sops_file.cloudflare_secrets.data["dns_records.pm.txt_spf"]
  proxied = false
  type    = "TXT"
  ttl     = 1
  comment = "Required by Proton Mail to prevent sent email rejection and spam filtering"
}

# Proton Mail CNAME 'protonmail._domainkey' Record
resource "cloudflare_record" "pm_cname_1" {
  name    = "protonmail._domainkey"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = data.sops_file.cloudflare_secrets.data["dns_records.pm.cname_pm1"]
  proxied = false
  type    = "CNAME"
  ttl     = 1
  comment = "Required by Proton Mail to prevent malicious email tampering"
}

# Proton Mail CNAME 'protonmail2._domainkey' Record
resource "cloudflare_record" "pm_cname_2" {
  name    = "protonmail2._domainkey"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = data.sops_file.cloudflare_secrets.data["dns_records.pm.cname_pm2"]
  proxied = false
  type    = "CNAME"
  ttl     = 1
  comment = "Required by Proton Mail to prevent malicious email tampering"
}

# Proton Mail CNAME 'protonmail3._domainkey' Record
resource "cloudflare_record" "pm_cname_3" {
  name    = "protonmail3._domainkey"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = data.sops_file.cloudflare_secrets.data["dns_records.pm.cname_pm3"]
  proxied = false
  type    = "CNAME"
  ttl     = 1
  comment = "Required by Proton Mail to prevent malicious email tampering"
}

# Proton Mail TXT '_dmarc' Record
resource "cloudflare_record" "pm_txt_dmarc" {
  name    = "_dmarc"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  content = data.sops_file.cloudflare_secrets.data["dns_records.pm.txt_dmarc"]
  proxied = false
  type    = "TXT"
  ttl     = 1
  comment = "Required by Proton Mail to verify SPF and DKIM against custom domain"
}
