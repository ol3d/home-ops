resource "mailgun_domain" "domain" {
    name = "mailgun.ol3d.dev"
    region = "us"
    smtp_password = ""
    spam_action = "disabled"
    wildcard = false
    dkim_key_size = "2048"
    dkim_selector = ""
    force_dkim_authority = false
    open_tracking = "no"
}
