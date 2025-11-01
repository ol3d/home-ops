terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.7.5"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
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
