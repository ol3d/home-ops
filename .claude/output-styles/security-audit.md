# Output Style: Security Audit

## Purpose

Use when performing security reviews, vulnerability assessments, or security compliance checks on infrastructure code or configurations.

## Template

````markdown
# Security Audit Report

## Executive Summary

[High-level overview of security posture]

**Audit Date**: [YYYY-MM-DD]
**Scope**: [What was audited]
**Overall Risk**: [Low | Medium | High | Critical]
**Critical Issues**: [Number]
**High Priority Issues**: [Number]
**Status**: [✅ Pass | ⚠️ Pass with Warnings | ❌ Fail]

## Findings Summary

| Severity    | Count | Status                       |
| ----------- | ----- | ---------------------------- |
| 🔴 Critical | X     | [All resolved / X remaining] |
| 🟠 High     | X     | [All resolved / X remaining] |
| 🟡 Medium   | X     | [All resolved / X remaining] |
| 🟢 Low      | X     | [All resolved / X remaining] |
| ℹ️ Info     | X     | [Recommendations]            |

## Critical Issues (🔴)

### 1. [Issue Title]

**Severity**: Critical
**Category**: [Secrets | Access Control | Encryption | Network | Configuration]
**Location**: [File/Resource:Line]

**Finding**:
[Detailed description of the security issue]

**Risk**:
[What could happen if exploited]

**Recommendation**:
[Specific, actionable fix]

**Remediation**:

```bash
[Exact commands or code changes to fix]
```
````

**Verification**:

```bash
[Commands to verify the fix]
```

## High Priority Issues (🟠)

[Same format as Critical]

## Medium Priority Issues (🟡)

[Same format but less detail needed]

## Low Priority Issues (🟢)

[Brief list with recommendations]

## Security Best Practices Review

### Secrets Management

- [✅ | ❌] Secrets encrypted with SOPS
- [✅ | ❌] No hardcoded credentials
- [✅ | ❌] Environment variables used appropriately
- [✅ | ❌] Secret rotation configured

### Access Control

- [✅ | ❌] Principle of least privilege applied
- [✅ | ❌] IAM policies scoped appropriately
- [✅ | ❌] SSH key management proper
- [✅ | ❌] Service accounts use minimal permissions

### Encryption

- [✅ | ❌] Data at rest encrypted
- [✅ | ❌] Data in transit encrypted
- [✅ | ❌] KMS keys properly managed
- [✅ | ❌] TLS versions up to date

### Network Security

- [✅ | ❌] Firewall rules follow least privilege
- [✅ | ❌] No unnecessary public exposure
- [✅ | ❌] Network segmentation implemented
- [✅ | ❌] VPN/bastion access only

### Compliance & Hardening

- [✅ | ❌] Security updates applied
- [✅ | ❌] Unused services disabled
- [✅ | ❌] Audit logging enabled
- [✅ | ❌] Backup and disaster recovery configured

## Positive Findings

[Things that are done well - reinforce good practices]

## Recommendations

### Immediate Actions (Do Now)

1. [Critical fix required]
2. [High priority security issue]

### Short Term (This Week)

1. [Medium priority improvement]
2. [Configuration hardening]

### Long Term (This Month)

1. [Strategic security improvement]
2. [Process enhancement]

## Compliance Status

[If applicable - SOC2, HIPAA, PCI-DSS, etc.]

## References

- [Link to security standard]
- [Link to documentation]
- [Related CVE or advisory]

## Audit Trail

**Audited By**: [Name/System]
**Files Reviewed**: [Count]
**Tools Used**: [List of scanning tools]
**Methodology**: [How the audit was performed]

````

## Guidelines

**Severity Levels**:
- **Critical** (🔴): Immediate exploitation risk, data loss, credential exposure
- **High** (🟠): Significant risk, privilege escalation, weak encryption
- **Medium** (🟡): Moderate risk, configuration issues, missing hardening
- **Low** (🟢): Minor issues, best practice violations, informational
- **Info** (ℹ️): Recommendations, optimization, future considerations

**Always Include**:
- Exact location (file:line)
- Specific remediation steps
- Verification commands
- Risk explanation

**Be Actionable**:
- Provide copy-paste commands
- Reference specific lines
- Give concrete examples
- Prioritize fixes clearly

## Example

```markdown
# Security Audit Report

## Executive Summary
Security audit of Terraform AWS infrastructure modules identified 1 critical issue related to S3 bucket encryption and several medium-priority hardening opportunities.

**Audit Date**: 2025-11-05
**Scope**: lab/provision/terraform/modules/aws/
**Overall Risk**: High
**Critical Issues**: 1
**High Priority Issues**: 0
**Status**: ❌ Fail - Critical issue must be resolved

## Findings Summary

| Severity | Count | Status |
|----------|-------|--------|
| 🔴 Critical | 1 | 0 resolved / 1 remaining |
| 🟠 High | 0 | - |
| 🟡 Medium | 3 | 0 resolved / 3 remaining |
| 🟢 Low | 2 | Recommendations |
| ℹ️ Info | 1 | Optimization |

## Critical Issues (🔴)

### 1. S3 Bucket Missing Server-Side Encryption
**Severity**: Critical
**Category**: Encryption
**Location**: lab/provision/terraform/modules/aws/s3.tf:15

**Finding**:
S3 bucket `terraform-state-prod` does not have server-side encryption enabled. This bucket stores Terraform state files containing sensitive infrastructure configuration.

**Risk**:
- Sensitive data exposed at rest (resource IDs, configurations)
- Potential credential exposure if outputs contain secrets
- Compliance violation (encryption at rest required)
- Data breach if AWS account compromised

**Recommendation**:
Enable AES-256 server-side encryption using aws:kms with customer-managed key.

**Remediation**:
```hcl
# Add to s3.tf
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.terraform_state.arn
    }
    bucket_key_enabled = true
  }
}
````

**Verification**:

```bash
# Check encryption status
aws s3api get-bucket-encryption --bucket terraform-state-prod

# Verify KMS key is being used
aws s3api head-object --bucket terraform-state-prod --key terraform.tfstate | grep ServerSideEncryption
```

## Medium Priority Issues (🟡)

### 1. S3 Bucket Versioning Not Enabled

**Location**: s3.tf:15
**Risk**: State file corruption without recovery option
**Fix**: Enable versioning with lifecycle policy for old versions

### 2. S3 Bucket Public Access Not Explicitly Blocked

**Location**: s3.tf:15
**Risk**: Accidental public exposure
**Fix**: Add aws_s3_bucket_public_access_block resource

### 3. DynamoDB Table Missing Point-in-Time Recovery

**Location**: dynamodb.tf:8
**Risk**: State lock table data loss without recovery
**Fix**: Enable point_in_time_recovery

## Low Priority Issues (🟢)

- S3 access logging not configured (consider for compliance)
- KMS key rotation not enabled (best practice for long-term keys)

## Security Best Practices Review

### Secrets Management

- [✅] No hardcoded credentials found
- [✅] SOPS encryption used for sensitive vars
- [⚠️] Consider using AWS Secrets Manager for IAM credentials

### Access Control

- [✅] IAM policies follow least privilege
- [✅] S3 bucket policy restricts access
- [❌] Bucket ACLs still used (migrate to bucket policies)

### Encryption

- [❌] S3 encryption missing (CRITICAL)
- [✅] KMS keys defined
- [⚠️] KMS key rotation not enabled

### Network Security

- [✅] No public S3 access required
- [✅] VPC endpoints available
- [N/A] Network-level controls (backend only)

### Compliance & Hardening

- [✅] MFA delete can be enabled
- [⚠️] CloudTrail logging recommended
- [✅] Resource tagging consistent

## Positive Findings

- Excellent use of SOPS for secret encryption
- Proper IAM role separation
- KMS keys properly scoped per environment
- State locking configured correctly with DynamoDB
- Consistent resource tagging strategy

## Recommendations

### Immediate Actions (Do Now)

1. Enable S3 bucket encryption with KMS (CRITICAL)
2. Block public access on S3 bucket

### Short Term (This Week)

1. Enable S3 versioning with lifecycle management
2. Enable DynamoDB point-in-time recovery
3. Configure S3 access logging

### Long Term (This Month)

1. Implement KMS key rotation policy
2. Add CloudTrail logging for state access
3. Consider AWS Backup for automated backups

## References

- AWS S3 Security Best Practices: https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html
- Terraform State Security: https://developer.hashicorp.com/terraform/language/state/remote-state-data
- CIS AWS Foundations Benchmark

## Audit Trail

**Audited By**: Claude Code
**Files Reviewed**: 5 (s3.tf, dynamodb.tf, kms-key.tf, main.tf, secret.sops.yaml)
**Tools Used**: Manual review, tfsec patterns, AWS security best practices
**Methodology**: Line-by-line code review with focus on AWS security controls

```

```
