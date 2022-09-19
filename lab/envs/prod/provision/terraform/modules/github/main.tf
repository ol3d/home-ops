terraform {

    backend "s3" {
        bucket = "homeops-tf-state"
        key = "github/terraform.tfstate"
        region = "us-east-1"
        shared_credentials_file = "~/.aws/credentials"
        profile = "terraform"
        encrypt = true
    }

    required_providers {
        github = {
            source  = "integrations/github"
            version = "5.1.0"
        }
        http = {
            source  = "hashicorp/http"
            version = "3.1.0"
        }
        sops = {
            source  = "carlpett/sops"
            version = "0.7.1"
        }
    }
}

data "sops_file" "github_secrets" {
    source_file = "secret.sops.yaml"
}

provider "github" {
    alias = "beelze-bot"
    app_auth {
        id = data.sops_file.github_secrets.data["beelze-bot.id"]
        installation_id = data.sops_file.github_secrets.data["beelze-bot.installation_id"]
        pem_file = data.sops_file.github_secrets.data["beelze-bot.pem_file"]
    }
}

provider "github" {
    alias = "token"
    token = data.sops_file.github_secrets.data["github.token"]
}
