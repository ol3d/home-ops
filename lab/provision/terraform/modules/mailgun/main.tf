terraform {
  required_providers {
    mailgun = {
      source  = "wgebis/mailgun"
      version = "0.7.7"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.2.1"
    }
  }
}

data "sops_file" "mailgun_secrets" {
  source_file = "secret.sops.yaml"
}

provider "mailgun" {
  api_key = data.sops_file.mailgun_secrets.data["key"]
}
