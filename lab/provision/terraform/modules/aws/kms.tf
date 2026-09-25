# These two keys are the SOPS trust root: every secret in this repository
# is encrypted with them (.sops.yaml pins their ARNs). NEVER delete or
# recreate them - a recreated key makes all existing SOPS files unreadable.
# On the existing homelab account these are the keys ending 4a38.../6baa...,
# adopted once (2026-09-24) via the import blocks below. deletion_window_in_days
# and bypass_policy_lockout_safety_check are write-only arguments (not
# API-readable on an enabled key) - declaring them makes every imported
# state show a permanent spurious diff, so they stay at provider defaults.

resource "aws_kms_key" "sops_01" {
  description              = "Mozilla SOPS key-01"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled               = true
  enable_key_rotation      = true
  rotation_period_in_days  = 90
  multi_region             = false
}

resource "aws_kms_alias" "sops_01" {
  name          = "alias/sops-01"
  target_key_id = aws_kms_key.sops_01.key_id
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = aws_kms_key.sops_01
  id = "4a38975b-065e-4cbc-b0d7-b6067418b38f"
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = aws_kms_alias.sops_01
  id = "alias/sops-01"
}

resource "aws_kms_key" "sops_02" {
  description              = "Mozilla SOPS key-02"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  is_enabled               = true
  enable_key_rotation      = true
  rotation_period_in_days  = 90
  multi_region             = false
}

resource "aws_kms_alias" "sops_02" {
  name          = "alias/sops-02"
  target_key_id = aws_kms_key.sops_02.key_id
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = aws_kms_key.sops_02
  id = "6baaa7c8-967a-4fc5-9923-c0a938edfcf4"
}

import {
  for_each = var.import_existing ? toset(["enabled"]) : toset([])

  to = aws_kms_alias.sops_02
  id = "alias/sops-02"
}
