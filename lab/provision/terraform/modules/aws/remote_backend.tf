resource "aws_s3_bucket" "terraform_state" {
    bucket = "homeops-tf-state"
    force_destroy = true
    object_lock_enabled = false
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
    bucket = aws_s3_bucket.terraform_state.bucket

    versioning_configuration {
        status = "Enabled"
        mfa_delete = "Disabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
    bucket = aws_s3_bucket.terraform_state.bucket

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-state-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}
