# Output Style: Code Review

## Purpose

Use when reviewing pull requests, code changes, or performing quality checks on Infrastructure as Code.

## Template

````markdown
# Code Review

## Summary

[One-line description of the changes]

**PR/Branch**: [Name or number]
**Author**: [Name]
**Type**: [Feature | Bugfix | Refactor | Docs | Security]
**Files Changed**: [Count]
**Verdict**: [✅ Approve | ⚠️ Approve with Suggestions | 🔄 Request Changes | ❌ Reject]

## Overview

**What Changed**:
[Brief description of the changes]

**Why**:
[Rationale for the changes]

**Risk Assessment**: [Low | Medium | High]

## Mandatory Fixes (Blockers)

[If none, state "None - code is ready to merge"]

### 1. [Issue Title]

**File**: [path/to/file.ext:line]
**Severity**: Blocker
**Category**: [Security | Bug | Breaking Change | Standards Violation]

**Issue**:
[Description of the problem]

**Why This Matters**:
[Impact or risk]

**Required Fix**:

```language
[Code showing the fix]
```
````

## Suggested Improvements (Non-Blocking)

[If none, state "None - code meets standards"]

### 1. [Improvement Title]

**File**: [path/to/file.ext:line]
**Category**: [Performance | Maintainability | Best Practice | Documentation]

**Current**:

```language
[Current code]
```

**Suggested**:

```language
[Improved code]
```

**Benefit**:
[Why this would improve the code]

## Quality Checklist

### Code Quality

- [✅ | ❌ | N/A] Follows repository conventions
- [✅ | ❌ | N/A] No code smells or anti-patterns
- [✅ | ❌ | N/A] Error handling is appropriate
- [✅ | ❌ | N/A] No hardcoded values (uses variables)

### Security

- [✅ | ❌ | N/A] No secrets or credentials
- [✅ | ❌ | N/A] Proper access controls
- [✅ | ❌ | N/A] Input validation present
- [✅ | ❌ | N/A] Security best practices followed

### Infrastructure Specific

- [✅ | ❌ | N/A] Resources properly tagged
- [✅ | ❌ | N/A] Terraform/Ansible best practices
- [✅ | ❌ | N/A] Idempotent operations
- [✅ | ❌ | N/A] Rollback plan exists

### Documentation

- [✅ | ❌ | N/A] Code is self-documenting
- [✅ | ❌ | N/A] Comments explain "why" not "what"
- [✅ | ❌ | N/A] README updated if needed
- [✅ | ❌ | N/A] Variables documented

### Testing

- [✅ | ❌ | N/A] Changes are testable
- [✅ | ❌ | N/A] Test plan provided
- [✅ | ❌ | N/A] Validation steps included

## Positive Highlights

[Things done particularly well - reinforce good practices]

- [Good practice observed]
- [Well-designed solution]

## Testing Recommendations

**Before Merge**:

1. [Test to run]
2. [Validation step]

**After Deployment**:

1. [Verification command]
2. [Monitoring to check]

## Questions for Author

1. [Clarifying question about design choice]
2. [Question about edge case handling]

## Next Steps

- [ ] [Action item for author]
- [ ] [Action item for reviewer]
- [ ] [Action item for deployment]

## Additional Context

[Any relevant background information, architectural decisions, or related PRs]

````

## Guidelines

**Verdict Criteria**:
- **✅ Approve**: No blockers, high quality, ready to merge
- **⚠️ Approve with Suggestions**: No blockers, minor improvements suggested
- **🔄 Request Changes**: Blockers present, must fix before merge
- **❌ Reject**: Fundamentally flawed, needs redesign

**Be Constructive**:
- Explain the "why" behind feedback
- Provide specific examples
- Suggest solutions, don't just point out problems
- Balance criticism with positive reinforcement

**Focus On**:
- Security implications
- Breaking changes
- Performance impacts
- Maintainability
- Standards compliance

**Always Check**:
- Secret leakage
- Breaking changes
- Error handling
- Resource naming
- Documentation updates

## Example

```markdown
# Code Review

## Summary
Add tflint configuration and integrate into CI/CD pipeline

**PR/Branch**: feature/tflint-integration
**Author**: ol3d
**Type**: Feature
**Files Changed**: 4
**Verdict**: ⚠️ Approve with Suggestions

## Overview

**What Changed**:
- Added `.github/linters/.tflint.hcl` with terraform-linters config
- Updated `.taskfiles/lint/Taskfile.yaml` to run tflint on modules
- Modified `.github/workflows/lint.yaml` to install and run tflint
- Added `tflint@0.59.1` to devbox.json

**Why**:
Improve Terraform code quality by catching common errors, deprecated syntax, and enforcing best practices before deployment.

**Risk Assessment**: Low

## Mandatory Fixes (Blockers)

None - code is ready to merge

## Suggested Improvements (Non-Blocking)

### 1. Simplify tflint Execution in Taskfile
**File**: .taskfiles/lint/Taskfile.yaml:33-38
**Category**: Maintainability

**Current**:
```yaml
- |
  echo "Running tflint on Terraform modules..."
  cd lab/provision/terraform/modules/aws && tflint --config {{.LINTER_CONFIG_DIR}}/.tflint.hcl
  cd lab/provision/terraform/modules/backblaze && tflint --config {{.LINTER_CONFIG_DIR}}/.tflint.hcl
  # ... repeated for each module
````

**Suggested**:

```yaml
- |
  echo "Running tflint on Terraform modules..."
  for module in lab/provision/terraform/modules/*; do
    if [ -d "$module" ]; then
      echo "Linting $module..."
      (cd "$module" && tflint --config {{.LINTER_CONFIG_DIR}}/.tflint.hcl) || exit 1
    fi
  done
```

**Benefit**:
Automatically handles new modules without manual Taskfile updates, reduces duplication, and makes maintenance easier.

### 2. Cache tflint Plugin Downloads in CI

**File**: .github/workflows/lint.yaml:40
**Category**: Performance

**Suggested**:

```yaml
- name: Cache tflint plugins
  uses: actions/cache@v4
  with:
    path: ~/.tflint.d/plugins
    key: ${{ runner.os }}-tflint-${{ hashFiles('.github/linters/.tflint.hcl') }}

- name: Initialize tflint
  run: tflint --init --config .github/linters/.tflint.hcl
```

**Benefit**:
Reduces CI execution time by caching AWS ruleset plugin (~30 second download), improves workflow reliability.

### 3. Add tflint Version Comment to Config

**File**: .github/linters/.tflint.hcl:1
**Category**: Documentation

**Suggested**:

```hcl
# tflint configuration for Terraform v1.13+
# Ruleset versions: terraform (built-in), aws (0.32.0)
# See: https://github.com/terraform-linters/tflint

config {
  module = true
  force = false
}
```

**Benefit**:
Documents compatible versions and provides reference link for future maintainers.

## Quality Checklist

### Code Quality

- [✅] Follows repository conventions
- [✅] No code smells or anti-patterns
- [✅] Error handling is appropriate
- [✅] No hardcoded values (uses variables)

### Security

- [✅] No secrets or credentials
- [N/A] Proper access controls
- [N/A] Input validation present
- [✅] Security best practices followed

### Infrastructure Specific

- [N/A] Resources properly tagged
- [✅] Terraform/Ansible best practices
- [N/A] Idempotent operations
- [N/A] Rollback plan exists

### Documentation

- [⚠️] Code is self-documenting (consider adding version comment)
- [N/A] Comments explain "why" not "what"
- [✅] README updated if needed
- [✅] Variables documented

### Testing

- [✅] Changes are testable
- [✅] Test plan provided
- [✅] Validation steps included

## Positive Highlights

- Excellent choice of tflint ruleset (terraform + aws plugins)
- Proper version pinning for tflint in devbox.json
- Clean integration with existing Taskfile structure
- Good use of variables for config directory path
- Consistent with other linting tools in the repo

## Testing Recommendations

**Before Merge**:

1. Run `devbox update` to install tflint locally
2. Execute `task lint:check:terraform` on all modules
3. Verify no false positives from aws ruleset
4. Test CI workflow with a test branch

**After Deployment**:

1. Monitor CI job execution time
2. Review tflint findings in next PR
3. Adjust rules if too strict/lenient

## Questions for Author

None - implementation is clear and well-designed

## Next Steps

- [x] Code review completed
- [ ] Author considers suggestions (optional)
- [ ] Merge when ready
- [ ] Update session docs with tflint addition

## Additional Context

This is part of a larger effort to establish consistent linting across the repository. Related PRs include prettier integration and pre-commit hook setup. The tflint aws plugin (v0.32.0) is compatible with current AWS provider version (5.x).

```

```
