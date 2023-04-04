terraform {

    backend "s3" {
        bucket = "homeops-tf-state"
        key = "cloudflare/terraform.tfstate"
        region = "us-east-1"
        shared_credentials_file = "~/.aws/credentials"
        profile = "terraform"
        encrypt = true
    }

    required_providers {
        cloudflare = {
            source  = "cloudflare/cloudflare"
            version = "4.3.0"
        }
        http = {
            source  = "hashicorp/http"
            version = "3.2.1"
        }
        sops = {
            source  = "carlpett/sops"
            version = "0.7.2"
        }
    }
}

data "sops_file" "cloudflare_secrets" {
    source_file = "secret.sops.yaml"
}

data "cloudflare_zones" "domain" {
    filter {
        name = data.sops_file.cloudflare_secrets.data["cloudflare_domain"]
    }
}

provider "cloudflare" {
    email   = data.sops_file.cloudflare_secrets.data["cloudflare_email"]
    api_key = data.sops_file.cloudflare_secrets.data["cloudflare_apikey"]
}
