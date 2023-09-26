variable "b2_buckets" {
    type = map(map(string))
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
                file_name_preflix = ""
                days_from_hiding_to_deleting = 28
            }
        }
    }
}
