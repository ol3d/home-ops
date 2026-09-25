terraform {
  required_version = "1.16.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
  }
}

# This stack owns the state backend itself - the S3 bucket every other module
# uses for remote state. It deliberately keeps LOCAL state - there is no
# backend block. See docs/architecture.md "The state backend" for the full
# rationale, lifecycle, and tradeoffs. The KMS keys live in
# modules/aws, on this bucket's remote backend.

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  tfstate_bucket_name = "ol3d-dev.homelab.tfstate"
}
