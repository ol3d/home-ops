terraform {

    backend "s3" {
        bucket = "homeops-tf-state"
        key = "aws/terraform.tfstate"
        region = "us-east-1"
        shared_credentials_file = "~/.aws/credentials"
        profile = "terraform"
        encrypt = true
    }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "4.34.0"
        }
        http = {
            source = "hashicorp/http"
            version = "3.1.0"
        }
        sops = {
            source = "carlpett/sops"
            version = "0.7.1"
        }
    }
}

data "sops_file" "aws_secrets" {
    source_file = "secret.sops.yaml"
}

provider "aws" {
    shared_config_files = ["~/.aws/config"]
    shared_credentials_files = ["~/.aws/credentials"]
    profile = "terraform"
}
