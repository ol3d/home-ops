# Obtain current home IP address
data "http" "ipv4" {
  url = "http://ipv4.icanhazip.com"
}

# # #
# # # Base records
# # #

# Record which will be updated by DDNS
resource "cloudflare_dns_record" "apex_ipv4" {
  name    = data.sops_file.cloudflare_secrets.data["public_domain"]
  zone_id = data.cloudflare_zone.zone.id
  content = chomp(data.http.ipv4.response_body)
  proxied = true
  type    = "A"
  ttl     = 1
  comment = "Dynamic home IP (DDNS); updated by terraform runs"
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = cloudflare_dns_record.apex_ipv4
  id = "${data.cloudflare_zone.zone.id}/4fa17005beec452815b6b64d75a75a50"
}

# CNAME 'www' Record
resource "cloudflare_dns_record" "base_cname_www" {
  name    = "www"
  zone_id = data.cloudflare_zone.zone.id
  content = data.sops_file.cloudflare_secrets.data["cloudflare_domain"]
  proxied = true
  type    = "CNAME"
  ttl     = 1
  comment = "www alias to the zone apex"
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = cloudflare_dns_record.base_cname_www
  id = "${data.cloudflare_zone.zone.id}/e43515fab603cee79b31ad1e88b5660d"
}

# # #
# # # Proton Mail Records
# # #

# Proton Mail TXT '@' Record
resource "cloudflare_dns_record" "pm_txt" {
  name    = "@"
  zone_id = data.cloudflare_zone.zone.id
  content = data.sops_file.cloudflare_secrets.data["dns_records.pm.txt"]
  proxied = false
  type    = "TXT"
  ttl     = 1
  comment = "Required by Proton Mail to verify domain owner"
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = cloudflare_dns_record.pm_txt
  id = "${data.cloudflare_zone.zone.id}/7670a70e07b65e22e33c73ca0374c0ac"
}

# Proton Mail MX '@' Record 1
resource "cloudflare_dns_record" "pm_mx_mx_1" {
  name     = "@"
  zone_id  = data.cloudflare_zone.zone.id
  content  = data.sops_file.cloudflare_secrets.data["dns_records.pm.mx_1"]
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 10
  comment  = "Required by Proton Mail to recieve emails for all custom domains"
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = cloudflare_dns_record.pm_mx_mx_1
  id = "${data.cloudflare_zone.zone.id}/9fc9cc5bd51d09b6f9c575428eee28a9"
}

# Proton Mail MX '@' Record 2
resource "cloudflare_dns_record" "pm_mx_mx_2" {
  name     = "@"
  zone_id  = data.cloudflare_zone.zone.id
  content  = data.sops_file.cloudflare_secrets.data["dns_records.pm.mx_2"]
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 20
  comment  = "Required by Proton Mail to recieve emails for all custom domains"
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = cloudflare_dns_record.pm_mx_mx_2
  id = "${data.cloudflare_zone.zone.id}/d594c851d8557912dcca77eff0bcfeaa"
}

# Proton Mail TXT '@' SPF Record
resource "cloudflare_dns_record" "pm_txt_spf" {
  name    = "@"
  zone_id = data.cloudflare_zone.zone.id
  content = data.sops_file.cloudflare_secrets.data["dns_records.pm.txt_spf"]
  proxied = false
  type    = "TXT"
  ttl     = 1
  comment = "Required by Proton Mail to prevent sent email rejection and spam filtering"
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = cloudflare_dns_record.pm_txt_spf
  id = "${data.cloudflare_zone.zone.id}/851697cb0dd4e94583d9eafe597d3fdb"
}

# Proton Mail CNAME 'protonmail._domainkey' Record
resource "cloudflare_dns_record" "pm_cname_1" {
  name    = "protonmail._domainkey"
  zone_id = data.cloudflare_zone.zone.id
  content = data.sops_file.cloudflare_secrets.data["dns_records.pm.cname_pm1"]
  proxied = false
  type    = "CNAME"
  ttl     = 1
  comment = "Required by Proton Mail to prevent malicious email tampering"
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = cloudflare_dns_record.pm_cname_1
  id = "${data.cloudflare_zone.zone.id}/992496bcf305ec76a3c97f7a31b0a0fc"
}

# Proton Mail CNAME 'protonmail2._domainkey' Record
resource "cloudflare_dns_record" "pm_cname_2" {
  name    = "protonmail2._domainkey"
  zone_id = data.cloudflare_zone.zone.id
  content = data.sops_file.cloudflare_secrets.data["dns_records.pm.cname_pm2"]
  proxied = false
  type    = "CNAME"
  ttl     = 1
  comment = "Required by Proton Mail to prevent malicious email tampering"
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = cloudflare_dns_record.pm_cname_2
  id = "${data.cloudflare_zone.zone.id}/911b9fd6eb449bd2409ad4218c4244b3"
}

# Proton Mail CNAME 'protonmail3._domainkey' Record
resource "cloudflare_dns_record" "pm_cname_3" {
  name    = "protonmail3._domainkey"
  zone_id = data.cloudflare_zone.zone.id
  content = data.sops_file.cloudflare_secrets.data["dns_records.pm.cname_pm3"]
  proxied = false
  type    = "CNAME"
  ttl     = 1
  comment = "Required by Proton Mail to prevent malicious email tampering"
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = cloudflare_dns_record.pm_cname_3
  id = "${data.cloudflare_zone.zone.id}/388318779a50ad6dde16f84bcbd94586"
}

# Proton Mail TXT '_dmarc' Record
resource "cloudflare_dns_record" "pm_txt_dmarc" {
  name    = "_dmarc"
  zone_id = data.cloudflare_zone.zone.id
  content = data.sops_file.cloudflare_secrets.data["dns_records.pm.txt_dmarc"]
  proxied = false
  type    = "TXT"
  ttl     = 1
  comment = "Required by Proton Mail to verify SPF and DKIM against custom domain"
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = cloudflare_dns_record.pm_txt_dmarc
  id = "${data.cloudflare_zone.zone.id}/22ab931825c7259a27f8f4ade06c732c"
}

# # #
# # # AWS SES Records
# # #

# SES DKIM CNAME Records (one per Easy DKIM token from the AWS module)
resource "cloudflare_dns_record" "ses_dkim" {
  for_each = toset(data.terraform_remote_state.aws.outputs.ses_dkim_tokens)

  name    = "${each.value}._domainkey.ses"
  zone_id = data.cloudflare_zone.zone.id
  content = "${each.value}.dkim.amazonses.com"
  proxied = false
  type    = "CNAME"
  ttl     = 1
  comment = "AWS SES Easy DKIM verification for ses.ol3d.dev"
}

# SES TXT 'ses' SPF Record
resource "cloudflare_dns_record" "ses_spf" {
  name    = "ses"
  zone_id = data.cloudflare_zone.zone.id
  content = "v=spf1 include:amazonses.com ~all"
  proxied = false
  type    = "TXT"
  ttl     = 1
  comment = "AWS SES-only SPF for ses.ol3d.dev"
}

resource "cloudflare_dns_record" "ses_dmarc" {
  name    = "_dmarc.ses"
  zone_id = data.cloudflare_zone.zone.id
  content = "v=DMARC1; p=none;"
  proxied = false
  type    = "TXT"
  ttl     = 1
  comment = "AWS SES subdomain DMARC (monitor-only, explicit instead of inherited)"
}

# SES MX 'mail.ses' Record (custom MAIL FROM bounce routing)
resource "cloudflare_dns_record" "ses_mailfrom_mx" {
  name     = "mail.ses"
  zone_id  = data.cloudflare_zone.zone.id
  content  = "feedback-smtp.us-east-1.amazonses.com"
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 10
  comment  = "AWS SES custom MAIL FROM bounce MX for mail.ses.ol3d.dev"
}

# SES TXT 'mail.ses' SPF Record
resource "cloudflare_dns_record" "ses_mailfrom_spf" {
  name    = "mail.ses"
  zone_id = data.cloudflare_zone.zone.id
  content = "v=spf1 include:amazonses.com ~all"
  proxied = false
  type    = "TXT"
  ttl     = 1
  comment = "AWS SES custom MAIL FROM SPF for mail.ses.ol3d.dev"
}
