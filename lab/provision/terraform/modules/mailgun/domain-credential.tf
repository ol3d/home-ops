resource "mailgun_domain_credential" "domain-credential-duplicacy" {
  domain = mailgun_domain.domain.name
  login = "duplicacy"
  password = data.sops_file.mailgun_secrets.data["domain-credential.password"]
  region = "us"
}

resource "mailgun_domain_credential" "domain-credential-proxmox" {
  domain = mailgun_domain.domain.name
  login = "proxmox"
  password = data.sops_file.mailgun_secrets.data["domain-credential.password"]
  region = "us"
}
