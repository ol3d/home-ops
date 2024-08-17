terraform {

    required_providers {
        b2 = {
            source  = "Backblaze/b2"
            version = "0.8.12"
        }
        http = {
            source  = "hashicorp/http"
            version = "3.4.4"
        }
        sops = {
            source  = "carlpett/sops"
            version = "1.1.1"
        }
    }
}

data "sops_file" "backblaze_secrets" {
    source_file = "secret.sops.yaml"
}

provider "b2" {
    application_key = data.sops_file.backblaze_secrets.data["b2.application_keys.master-key.application_key"]
    application_key_id = data.sops_file.backblaze_secrets.data["b2.application_keys.master-key.application_key_id"]
}
