# SMTP credentials for device notification senders (duplicacy, proxmox,
# truenas). The SMTP password is derived from the IAM secret key by the
# provider (ses_smtp_password_v4) - it lands in state, same trust boundary
# as the mailgun smtp_password it replaces.

data "sops_file" "homelab_secrets" {
  source_file = "${path.module}/../../../../../config/homelab.sops.yaml"
}

resource "aws_iam_user" "ses_smtp" {
  name = "homelab-ses-smtp"
}

resource "aws_iam_access_key" "ses_smtp" {
  user = aws_iam_user.ses_smtp.name
}

resource "aws_iam_user_policy" "ses_smtp" {
  user = aws_iam_user.ses_smtp.name
  name = "homelab-ses-smtp-send"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "ses:SendRawEmail"
        Resource = [
          aws_sesv2_email_identity.ses.arn,
          "arn:aws:ses:us-east-1:869935076354:identity/${data.sops_file.homelab_secrets.data["email"]}",
          "arn:aws:ses:us-east-1:869935076354:configuration-set/homelab-notifications"
        ]
      }
    ]
  })
}

output "ses_smtp_host" {
  description = "SMTP endpoint for devices (port 587, STARTTLS)"
  value       = "email-smtp.us-east-1.amazonaws.com"
}

output "ses_smtp_username" {
  description = "SMTP username (IAM access key ID)"
  value       = aws_iam_access_key.ses_smtp.id
  sensitive   = true
}

output "ses_smtp_password" {
  description = "SMTP password (derived from the IAM secret key)"
  value       = aws_iam_access_key.ses_smtp.ses_smtp_password_v4
  sensitive   = true
}
