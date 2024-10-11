resource "aws_kms_key" "sops-aws_kms_key-01" {
    description = "Mozilla SOPS key-01"
    key_usage = "ENCRYPT_DECRYPT"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days = 30
    is_enabled = true
    enable_key_rotation = true
    rotation_period_in_days = 90
    multi_region = false
    bypass_policy_lockout_safety_check = false
}

resource "aws_kms_alias" "sops_aws_kms_alias-01" {
    name = "alias/sops-01"
    target_key_id = aws_kms_key.sops-aws_kms_key-01.key_id
}

resource "aws_kms_key" "sops-aws_kms_key-02" {
    description = "Mozilla SOPS key-02"
    key_usage = "ENCRYPT_DECRYPT"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days = 30
    is_enabled = true
    enable_key_rotation = true
    rotation_period_in_days = 90
    multi_region = false
    bypass_policy_lockout_safety_check = false
}

resource "aws_kms_alias" "sops_aws_kms_alias-02" {
    name = "alias/sops-02"
    target_key_id = aws_kms_key.sops-aws_kms_key-02.key_id
}
