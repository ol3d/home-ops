terraform {
  required_version = "1.16.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.4.1"
    }
  }

  backend "s3" {
    bucket       = "ol3d-dev.homelab.tfstate"
    key          = "aws/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}
