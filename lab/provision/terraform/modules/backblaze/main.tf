terraform {
  required_version = "1.16.2"

  required_providers {
    b2 = {
      source  = "Backblaze/b2"
      version = "0.14.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.4.1"
    }
  }

  backend "s3" {
    bucket       = "ol3d-dev.homelab.tfstate"
    key          = "backblaze/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

data "sops_file" "backblaze_secrets" {
  source_file = "${path.module}/../../../../../config/backblaze.sops.yaml"
}

provider "b2" {
  application_key    = data.sops_file.backblaze_secrets.data["b2.application_keys.master-key.application_key"]
  application_key_id = data.sops_file.backblaze_secrets.data["b2.application_keys.master-key.application_key_id"]
}
