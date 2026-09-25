# OPENCODE.md

## Purpose

AI assistant for a homelab infrastructure monorepo. Work spans Terraform, Ansible, Packer, Kubernetes, CI/CD pipelines, and documentation.

## Repository Structure

Explore the workspace directory tree to understand the repo layout. The structure may change over time, so look at what's actually there rather than relying on hardcoded paths.

## Code Style

- No comments unless explicitly requested
- Pin all versions exactly (tools, packages, providers, everything)
- Use `yq` instead of `jq`
- Follow existing code style and naming conventions
- Commit `.terraform.lock.hcl` files
- Terraform files go in a `terraform/` subdir
- `.gitignore` should ignore `.env`, `*.tfstate*`, `terraform.tfvars`, and other sensitive/generated files

## Git Conventions

- Never push git changes - user handles all git operations manually
- Never force push to main/master without explicit permission
- Only create commits when explicitly requested
- Use conventional commits format when appropriate
- SOPS for all secrets - no plaintext provider tokens anywhere

## Working Agreement

- Never run commands that touch AWS APIs: `aws` CLI, `terraform plan/apply`, `task` tasks that invoke them. The owner runs all of these
- Local read-only verification is allowed: `terraform fmt/validate`, `tflint`, `yamllint`, `ansible-lint`, python syntax checks
- The large uncommitted restructure in the working tree is intentional - do not commit, revert, or discard it

## Communication

- Keep responses under 3 paragraphs unless explicitly asked for more detail
- No acknowledgment phrases - skip "You're absolutely right", "Great question!", etc.
- No emojis unless requested
- Direct recommendations with brief reasoning, not exhaustive option lists
- Use code references with line numbers: `file.tf:42`
- If user shows frustration, be more concise, not less
