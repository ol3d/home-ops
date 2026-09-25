resource "aws_s3_bucket" "tfstate" {
  bucket              = local.tfstate_bucket_name
  force_destroy       = false
  object_lock_enabled = true
}

# Adopt pre-existing resources on the first apply of a machine: the toggle
# is armed automatically by aws:apply when no local state file exists yet.
# Once state exists it stays false - the blocks go inert and applies
# reconcile normally. The plan must show ONLY imports, never replacements
# or destruction.

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = aws_s3_bucket.tfstate
  id = local.tfstate_bucket_name
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = aws_s3_bucket_versioning.tfstate
  id = local.tfstate_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = aws_s3_bucket_server_side_encryption_configuration.tfstate
  id = local.tfstate_bucket_name
}

resource "aws_s3_bucket_request_payment_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  payer  = "BucketOwner"
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = aws_s3_bucket_request_payment_configuration.tfstate
  id = local.tfstate_bucket_name
}

resource "aws_s3_bucket_object_lock_configuration" "tfstate" {
  bucket              = aws_s3_bucket.tfstate.id
  object_lock_enabled = "Enabled"

  rule {
    default_retention {
      days = 14
      mode = "COMPLIANCE"
    }
  }
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = aws_s3_bucket_object_lock_configuration.tfstate
  id = local.tfstate_bucket_name
}

resource "aws_s3_bucket_lifecycle_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    id     = "terraform-state-lifecycle"
    status = "Enabled"

    expiration {
      days = 14
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    noncurrent_version_expiration {
      newer_noncurrent_versions = 3
      noncurrent_days           = 7
    }
  }
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = aws_s3_bucket_lifecycle_configuration.tfstate
  id = local.tfstate_bucket_name
}
