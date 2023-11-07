resource "b2_bucket" "b2_bucket" {
    for_each = var.b2_buckets

    bucket_name = each.key
    bucket_type = each.value.bucket_type

    file_lock_configuration {
        default_retention {
            mode = each.value.file_lock_configuration.default_retention.mode
            period {
                duration = each.value.file_lock_configuration.default_retention.period.duration
                unit = each.value.file_lock_configuration.default_retention.period.unit
            }
        }
        is_file_lock_enabled = each.value.file_lock_configuration.is_file_lock_enabled
    }

    lifecycle_rules {
        file_name_prefix = each.value.lifecycle_rules.file_name_prefix
        days_from_hiding_to_deleting = each.value.lifecycle_rules.days_from_hiding_to_deleting
    }

    lifecycle {
        prevent_destroy = true
    }
}
