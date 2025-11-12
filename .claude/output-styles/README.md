# Claude Output Styles

Output styles are standardized formats for Claude and agents to communicate about specific tasks. They ensure consistent, structured responses that are easy to scan and act upon.

## Available Output Styles

### Infrastructure Management

- **`infrastructure-change.md`** - Use when planning or reviewing IaC changes
- **`terraform-plan.md`** - Use when analyzing Terraform plan output
- **`ansible-playbook.md`** - Use when reviewing or running Ansible playbooks
- **`deployment-checklist.md`** - Use when planning deployments

### Security & Quality

- **`security-audit.md`** - Use when performing security reviews
- **`code-review.md`** - Use when reviewing code changes
- **`incident-response.md`** - Use when troubleshooting issues

### Documentation

- **`documentation-update.md`** - Use when creating or updating docs
- **`configuration-audit.md`** - Use when auditing system configurations

## How to Use

### For Users

Request a specific output style:

```
"Review this Terraform change using the terraform-plan output style"
"Audit the Ansible playbooks using the security-audit style"
```

Or reference by shorthand:

```
"Review this PR - use code-review format"
```

### For Claude/Agents

When appropriate, automatically apply output styles:

1. Read the style file from `.claude/output-styles/`
2. Structure your response using that format
3. Include all required sections
4. Be consistent with formatting

### Creating Custom Styles

Copy an existing style and modify it:

```bash
cp .claude/output-styles/code-review.md .claude/output-styles/my-custom-style.md
```

Edit to match your needs, then use it in prompts.

## Style Format

Each output style contains:

- **Purpose** - When to use this style
- **Template** - The exact structure to follow
- **Guidelines** - How to fill in each section
- **Example** - Sample output

## Tips

- Styles ensure consistency across sessions
- Easy to scan for key information
- Structured for decision-making
- Can be parsed by automation tools
- Safe to commit (no secrets)
