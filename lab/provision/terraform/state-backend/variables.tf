variable "aws_region" {
  description = "AWS region holding the homelab state bucket"
  type        = string
  default     = "us-east-1"
}

variable "import_existing" {
  description = "Adopt pre-existing resources instead of creating them (first apply only)"
  type        = bool
  default     = false
}
