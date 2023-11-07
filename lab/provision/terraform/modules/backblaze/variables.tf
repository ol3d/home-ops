variable "b2_buckets" {
    type = map(object({
        bucket_type = string
        file_lock_configuration = object({
            is_file_lock_enabled = bool
            default_retention = object({
                mode = string
                period = object({
                    duration = number
                    unit = string
                })
            })
        })
        lifecycle_rules = object({
            file_name_prefix = string
            days_from_hiding_to_deleting = number
        })
    }))
    default = {
        homeops-backups = {
            bucket_type = "allPrivate"
            file_lock_configuration = {
                default_retention = {
                    mode = "governance"
                    period = {
                        duration = 7
                        unit = "days"
                    }
                }
                is_file_lock_enabled = true
            }
            lifecycle_rules = {
                file_name_prefix = ""
                days_from_hiding_to_deleting = 28
            }
        }
    }
}
