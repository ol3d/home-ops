resource "aws_s3_bucket" "tfstate-s3-bucket" {
    bucket = "home-ops.tfstate"
    force_destroy = false
    object_lock_enabled = true

    timeouts {
        create = "20m"
        read = "10m"
        update = "10m"
        delete = "20m"
    }
}

resource "aws_s3_bucket_versioning" "tfstate-s3-bucket-aws_s3_bucket_versioning" {
    bucket = "home-ops.tfstate"
    versioning_configuration {
        status = "Enabled"
        mfa_delete = "Disabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate-s3-bucket-aws_server_side_encryption_configuration" {
    bucket = "home-ops.tfstate"
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

resource "aws_s3_bucket_request_payment_configuration" "tfstate-s3-bucket-aws_s3_bucket_request_payment_configuration" {
    bucket = "home-ops.tfstate"
    payer  = "BucketOwner"
}

resource "aws_s3_bucket_object_lock_configuration" "tfstate-s3-bucket-aws_s3_bucket_object_lock_configuration" {
    bucket = "home-ops.tfstate"
    object_lock_enabled = "Enabled"
    rule {
        default_retention {
            days = 14
            mode = "COMPLIANCE"
        }
    }
}

resource "aws_s3_bucket_lifecycle_configuration" "tfstate-s3-bucket-aws_s3_bucket_lifecycle_configuration" {
    bucket = "home-ops.tfstate"
    rule {
        id = "home-ops-tfstate-lifecycle_rule-01"
        status = "Enabled"

        expiration {
            days = 14
        }

        abort_incomplete_multipart_upload {
            days_after_initiation = 7
        }

        noncurrent_version_expiration {
            newer_noncurrent_versions = 3
            noncurrent_days = 7
        }
    }
}
