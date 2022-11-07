terraform {

    backend "s3" {
        bucket = "homeops-tf-state"
        key = "backblaze/terraform.tfstate"
        region = "us-east-1"
        shared_credentials_file = "~/.aws/credentials"
        profile = "terraform"
        encrypt = true
    }

    required_providers {
        backblaze = {
            source  = "Backblaze/b2"
            version = "0.8.1"
        }
        http = {
            source  = "hashicorp/http"
            version = "3.2.1"
        }
        sops = {
            source  = "carlpett/sops"
            version = "0.7.1"
        }
    }
}

data "sops_file" "backblaze_secrets" {
    source_file = "secret.sops.yaml"
}

provider "b2" {
    application_key = data.sops_file.backblaze_secrets.data["b2.application_key"]
    application_key_id = data.sops_file.backblaze_secrets.data["b2.application_key_id"]
}
