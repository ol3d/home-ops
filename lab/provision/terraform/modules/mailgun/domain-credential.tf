resource "mailgun_domain_credential" "domain-credential-duplicacy" {
    domain = "mailgun.ol3d.dev"
    login = "duplicacy"
    password = data.sops_file.mailgun_secrets.data["domain-credential.password"]
    region = "us"
}

resource "mailgun_domain_credential" "domain-credential-proxmox" {
    domain = "mailgun.ol3d.dev"
    login = "proxmox"
    password = data.sops_file.mailgun_secrets.data["domain-credential.password"]
    region = "us"
}
