terraform {
  backend "s3" {
    bucket = "home-ops.tfstate"
    key = "mailgun/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "home-ops.tfstate.lock"
    encrypt = true
  }

  required_providers {
    mailgun = {
      source  = "wgebis/mailgun"
      version = "0.7.6"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.5"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.1.1"
    }
  }
}

data "sops_file" "mailgun_secrets" {
  source_file = "secret.sops.yaml"
}

provider "mailgun" {
  api_key = data.sops_file.mailgun_secrets.data["key"]
}
