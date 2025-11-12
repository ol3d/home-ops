# Output Style: Terraform Plan Analysis

## Purpose

Use when analyzing `terraform plan` output to summarize changes, assess risk, and provide actionable recommendations.

## Template

````markdown
# Terraform Plan Analysis

## Summary

[High-level overview of what's changing]

**Module**: [Module name/path]
**Resources Changed**: [X to add, Y to change, Z to destroy]
**Risk Level**: [Low | Medium | High | Critical]
**Approval**: [✅ Safe to Apply | ⚠️ Review Required | ❌ Do Not Apply]

## Resource Changes

### Resources to Add (+)

- `[resource_type.resource_name]` - [Description]
  - Key attributes: [Important config]

### Resources to Change (~)

- `[resource_type.resource_name]` - [What's changing]
  - Before: [Old value]
  - After: [New value]
  - Impact: [Will this cause recreation? Downtime?]

### Resources to Destroy (-)

- `[resource_type.resource_name]` - [Description]
  - ⚠️ **Warning**: [What data/service will be lost]

## Breaking Changes

[List any changes that will cause resource recreation or service interruption]

- [ ] Resource X will be **recreated** (forces new resource)
- [ ] Service Y will experience downtime during update

## Security Review

### Access Control Changes

- [IAM/security group/firewall changes]

### Secret Management

- [How secrets are handled]

### Compliance

- [Any compliance considerations]

## Cost Impact

[Estimated cost change: +$X/month or -$Y/month or No change]

## Dependencies

[What other resources/services depend on these changes]

## Recommendations

### Before Applying

1. [Action to take]
2. [Verification step]

### After Applying

1. [Verification command]
2. [Monitoring to check]

## Warnings

[Any critical warnings or gotchas]

## Plan Snippet

```hcl
[Relevant portion of terraform plan output]
```
````

````

## Guidelines

**Risk Assessment**:
- **Low**: Tag/label changes, non-destructive updates
- **Medium**: Configuration changes, resource modifications
- **High**: Resource recreation, network changes
- **Critical**: Data destruction, security changes

**Always Highlight**:
- Resource recreation (forces new resource)
- Data loss potential
- Service interruption
- Security implications
- Cost changes

**Focus On**:
- What matters, not every detail
- Actionable information
- Risk mitigation
- Verification steps

## Example

```markdown
# Terraform Plan Analysis

## Summary
Adding production RDS instance with read replica and automated backups

**Module**: terraform/modules/aws
**Resources Changed**: 5 to add, 0 to change, 0 to destroy
**Risk Level**: Medium
**Approval**: ⚠️ Review Required - Ensure backup window doesn't conflict

## Resource Changes

### Resources to Add (+)
- `aws_db_instance.postgres_main` - Primary PostgreSQL 15.4 instance
  - Size: db.t3.medium (2 vCPU, 4GB RAM)
  - Storage: 100GB gp3
  - Multi-AZ: Enabled

- `aws_db_instance.postgres_replica` - Read replica
  - Size: db.t3.medium
  - Region: us-east-1

- `aws_db_subnet_group.postgres` - Subnet group for RDS
  - Subnets: subnet-abc123, subnet-def456

- `aws_security_group.postgres` - Database security group
  - Ingress: Port 5432 from app security group only

- `aws_db_parameter_group.postgres15` - Custom parameter group
  - max_connections: 200
  - shared_buffers: 1GB

### Resources to Change (~)
None

### Resources to Destroy (-)
None

## Breaking Changes
None - This is a new resource with no existing dependencies

## Security Review

### Access Control Changes
- ✅ Security group restricts access to app tier only
- ✅ No public accessibility enabled
- ✅ Encryption at rest enabled (KMS)
- ✅ Encryption in transit required (ssl=required)

### Secret Management
- ⚠️ Master password will be stored in AWS Secrets Manager
- ✅ Secrets rotation enabled (30 days)

### Compliance
- ✅ Meets backup retention requirements (7 days)
- ✅ Automated backups enabled
- ✅ CloudWatch logs enabled

## Cost Impact
Estimated: **+$185/month**
- Primary instance: $73/month
- Read replica: $73/month
- Storage (200GB total): $24/month
- Backup storage (~50GB): $15/month

## Dependencies
None currently - new standalone database

## Recommendations

### Before Applying
1. Verify KMS key exists: `aws kms describe-key --key-id alias/rds-postgres`
2. Confirm subnet group networking: `aws ec2 describe-subnets --subnet-ids subnet-abc123 subnet-def456`
3. Check security group rules won't conflict
4. Ensure backup window (03:00-04:00 UTC) doesn't overlap with other maintenance

### After Applying
1. Verify instance is available: `aws rds describe-db-instances --db-instance-identifier postgres-main`
2. Test connectivity from app tier: `psql -h <endpoint> -U postgres`
3. Verify read replica lag: Check CloudWatch metric `ReplicaLag`
4. Confirm automated backups running: Check RDS console

## Warnings
- Backup window set to 03:00-04:00 UTC - this may cause brief performance impact
- Initial backup after creation will take ~1 hour for 100GB
- First replica lag may be higher until initial sync completes (~30 minutes)

## Plan Snippet
```hcl
Terraform will perform the following actions:

  # aws_db_instance.postgres_main will be created
  + resource "aws_db_instance" "postgres_main" {
      + engine                  = "postgres"
      + engine_version          = "15.4"
      + instance_class          = "db.t3.medium"
      + allocated_storage       = 100
      + storage_encrypted       = true
      + kms_key_id              = "arn:aws:kms:us-east-1:123456789012:key/abc-123"
      + multi_az                = true
      + publicly_accessible     = false
      + backup_retention_period = 7
      + backup_window           = "03:00-04:00"
    }

Plan: 5 to add, 0 to change, 0 to destroy.
````

```

```
