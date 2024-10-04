terraform {
    backend "s3" {
        bucket = "home-ops.tfstate"
        key = "aws/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "home-ops.tfstate.lock"
        encrypt = true
    }

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "5.70.0"
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

data "sops_file" "aws_secrets" {
    source_file = "secret.sops.yaml"
}

provider "aws" {
    region = data.sops_file.aws_secrets.data["aws.provider.region"]
    access_key = data.sops_file.aws_secrets.data["aws.provider.access_key"]
    secret_key = data.sops_file.aws_secrets.data["aws.provider.secret_key"]
}
