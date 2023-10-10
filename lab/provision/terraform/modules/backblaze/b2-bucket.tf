resource "b2_bucket" "b2_bucket" {
    # for_each = var.b2_buckets

    bucket_name = data.sops_file.backblaze_secrets.data["b2.bucket_name"]
    bucket_type = "allPrivate"

    file_lock_configuration {
        default_retention {
            mode = "governance"
            period {
                duration = 7
                unit = "days"
            }
        }
        is_file_lock_enabled = true
    }

    lifecycle_rules {
        file_name_prefix = ""
        days_from_hiding_to_deleting = 28
    }

    lifecycle {
        prevent_destroy = true
    }
}
