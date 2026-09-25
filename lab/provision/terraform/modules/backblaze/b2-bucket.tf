resource "b2_bucket" "homeops-backups" {
  bucket_name = "homeops-backups"
  bucket_type = "allPrivate"

  file_lock_configuration {
    default_retention {
      mode = "governance"
      period {
        duration = 7
        unit     = "days"
      }
    }
    is_file_lock_enabled = true
  }
  lifecycle_rules {
    file_name_prefix             = ""
    days_from_hiding_to_deleting = 28
  }
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = b2_bucket.homeops-backups
  id = "dd3572a27cb1e39481b4041b"
}
