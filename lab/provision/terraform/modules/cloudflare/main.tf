terraform {
  required_version = "1.16.2"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.25.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.6.2"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.4.1"
    }
  }

  backend "s3" {
    bucket       = "ol3d-dev.homelab.tfstate"
    key          = "cloudflare/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

data "sops_file" "cloudflare_secrets" {
  source_file = "${path.module}/../../../../../config/cloudflare.sops.yaml"
}

data "cloudflare_zone" "zone" {
  zone_id = data.sops_file.cloudflare_secrets.data["zone_id"]
}

data "terraform_remote_state" "aws" {
  backend = "s3"

  config = {
    bucket       = "ol3d-dev.homelab.tfstate"
    key          = "aws/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "cloudflare" {
  email   = data.sops_file.cloudflare_secrets.data["cloudflare_email"]
  api_key = data.sops_file.cloudflare_secrets.data["cloudflare_apikey"]
}
