resource "b2_bucket" "b2_bucket" {
    for_each = var.b2_buckets

    bucket_name = each.key
    bucket_type = each.value.bucket_type

    file_lock_configuration {
        default_retention {
            mode = each.value.bucket_type.file_lock_configuration.default_retention.mode
            period {
                duration = each.value.bucket_type.file_lock_configuration.default_retention.period.duration
                unit = each.value.bucket_type.file_lock_configuration.default_retention.period.unit
            }
        }
    }

    lifecycle {
        prevent_destroy = true
    }
}
