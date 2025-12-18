terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
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

data "sops_file" "aws_secrets" {
  source_file = "secret.sops.yaml"
}

provider "aws" {
  region     = data.sops_file.aws_secrets.data["aws.provider.region"]
  access_key = data.sops_file.aws_secrets.data["aws.provider.access_key"]
  secret_key = data.sops_file.aws_secrets.data["aws.provider.secret_key"]
}
