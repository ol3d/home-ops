# SES sending-only setup for device notifications (duplicacy, proxmox,
# truenas) on a dedicated subdomain, isolated from the Proton Mail records
# at the zone root. The DKIM CNAME tokens surfaced here are consumed by the
# Cloudflare module (via remote state) to publish the DNS records that
# verify the identity.

# Account-level VDM master switch. The configuration set's vdm_options
# below are overlays; without this, they do nothing.
resource "aws_sesv2_account_vdm_attributes" "ses" {
  vdm_enabled = "ENABLED"
}

resource "aws_sesv2_configuration_set" "notifications" {
  configuration_set_name = "homelab-notifications"

  delivery_options {
    max_delivery_seconds = 3600
    tls_policy           = "REQUIRE"
  }

  reputation_options {
    reputation_metrics_enabled = true
  }

  sending_options {
    sending_enabled = true
  }

  suppression_options {
    suppressed_reasons = ["BOUNCE", "COMPLAINT"]
  }

  vdm_options {
    dashboard_options {
      engagement_metrics = "ENABLED"
    }

    guardian_options {
      optimized_shared_delivery = "ENABLED"
    }
  }
}

resource "aws_sesv2_email_identity" "ses" {
  email_identity         = "ses.ol3d.dev"
  configuration_set_name = aws_sesv2_configuration_set.notifications.configuration_set_name

  dkim_signing_attributes {
    next_signing_key_length = "RSA_2048_BIT"
  }
}

resource "aws_sesv2_email_identity_mail_from_attributes" "ses" {
  email_identity         = aws_sesv2_email_identity.ses.email_identity
  mail_from_domain       = "mail.ses.ol3d.dev"
  behavior_on_mx_failure = "USE_DEFAULT_VALUE"
}

output "ses_dkim_tokens" {
  description = "Easy DKIM tokens for the ses.ol3d.dev identity; Cloudflare module publishes these as CNAMEs"
  value       = aws_sesv2_email_identity.ses.dkim_signing_attributes[0].tokens
}

output "ses_identity_arn" {
  description = "ARN of the SES email identity (for any future cross-references)"
  value       = aws_sesv2_email_identity.ses.arn
}

output "ses_mail_from_domain" {
  description = "Custom MAIL FROM domain; Cloudflare module publishes its MX and SPF records"
  value       = aws_sesv2_email_identity_mail_from_attributes.ses.mail_from_domain
}
