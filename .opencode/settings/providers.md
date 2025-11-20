# AI Provider Configuration for OpenCode

OpenCode supports multiple AI providers, offering flexibility beyond Anthropic's Claude models.

## Current Configuration

**Primary Model**: `anthropic/claude-sonnet-4-5-20250929`
**Small Model**: `anthropic/claude-haiku-4-5-20251001`

Configured in: `opencode.jsonc`

## Supported Providers

### Anthropic (Current Default)

**Models Available:**
- `anthropic/claude-sonnet-4-5-20250929` - Latest Sonnet (best quality)
- `anthropic/claude-haiku-4-5-20251001` - Fast, cost-effective
- `anthropic/claude-opus-4-20250514` - Most capable (if available)

**Configuration:**
```jsonc
{
  "model": "anthropic/claude-sonnet-4-5-20250929",
  "smallModel": "anthropic/claude-haiku-4-5-20251001"
}
```

**Use Cases:**
- Default for homelab infrastructure work
- Best for complex reasoning and orchestration
- Proven track record with Terraform, Ansible, K8s

### OpenAI

**Models Available:**
- `openai/gpt-4-turbo-2024-04-09` - High capability
- `openai/gpt-4` - Stable, reliable
- `openai/gpt-3.5-turbo` - Fast, economical

**Configuration:**
```jsonc
{
  "model": "openai/gpt-4-turbo-2024-04-09",
  "smallModel": "openai/gpt-3.5-turbo"
}
```

**Use Cases:**
- When Anthropic credits are exhausted
- Alternative perspective on complex problems
- Testing multi-provider workflows

### Google

**Models Available:**
- `google/gemini-1.5-pro` - Latest Gemini Pro
- `google/gemini-1.5-flash` - Fast variant

**Configuration:**
```jsonc
{
  "model": "google/gemini-1.5-pro",
  "smallModel": "google/gemini-1.5-flash"
}
```

**Use Cases:**
- Alternative when other providers unavailable
- Cost optimization
- Specific use cases where Gemini excels

### Local Models (Ollama)

**Models Available:**
- `ollama/mistral` - Good general purpose
- `ollama/codellama` - Code-focused
- `ollama/llama2` - Open alternative

**Configuration:**
```jsonc
{
  "model": "ollama/mistral",
  "smallModel": "ollama/mistral"
}
```

**Requirements:**
- Ollama installed locally
- Models pulled: `ollama pull mistral`
- Sufficient compute resources

**Use Cases:**
- Offline work
- Privacy-sensitive operations
- Cost elimination (no API fees)
- Experimentation

## Switching Providers

### Quick Switch

Edit `opencode.jsonc`:

```jsonc
{
  "model": "provider/model-name",
  "smallModel": "provider/small-model-name"
}
```

Restart OpenCode for changes to take effect.

### Per-Agent Override

Agents can specify their own model in opencode.jsonc:

```jsonc
{
  "agent": {
    "agent-name": {
      "model": "openai/gpt-4-turbo-2024-04-09",  // Override for this agent
      ...
    }
  }
}
```

**Use Case:** Use cheaper models for simple tasks, premium models for complex analysis.

## Provider Selection Guide

**For Homelab Infrastructure:**

**Terraform/Ansible/K8s Work:**
- Primary: Anthropic Claude Sonnet (best infrastructure reasoning)
- Fallback: OpenAI GPT-4 Turbo
- Budget: Anthropic Claude Haiku

**Documentation:**
- Primary: Anthropic Claude Sonnet (excellent writing)
- Fallback: OpenAI GPT-4
- Budget: OpenAI GPT-3.5-turbo

**Code Review/Security:**
- Primary: Anthropic Claude Sonnet (thorough analysis)
- Fallback: OpenAI GPT-4 Turbo
- Never: Small models (insufficient security coverage)

**Session Management:**
- Primary: Anthropic Claude Haiku (fast, context-aware)
- Fallback: OpenAI GPT-3.5-turbo
- Budget: Ollama local models

## Cost Optimization Strategies

**1. Use Small Models for Simple Tasks:**

Agents that can use small models:
- @session-initializer (context loading)
- @session-closer (session updates)
- @history-analyzer (simple search)

**2. Use Primary Models for Complex Tasks:**

Agents that need primary models:
- @pre-commit-reviewer (security critical)
- @pr-reviewer (holistic analysis)
- @docs-maintainer (quality writing)
- @ecosystem-analyzer (comprehensive audit)

**3. Hybrid Approach:**

Default to small model, override critical agents:

```jsonc
{
  "model": "anthropic/claude-haiku-4-5-20251001",  // Default
  "agent": {
    "pre-commit-reviewer": {
      "model": "anthropic/claude-sonnet-4-5-20250929"  // Override
    },
    "pr-reviewer": {
      "model": "anthropic/claude-sonnet-4-5-20250929"
    }
  }
}
```

## Temperature Settings

**By Agent Type:**

- **Reviewers** (pre-commit, PR, security): 0.1-0.2 (consistent, deterministic)
- **Analyzers** (history, renovate, ecosystem): 0.2-0.3 (balanced)
- **Builders** (docs, agents): 0.3-0.4 (creative but structured)
- **Session managers**: 0.2 (consistent)

Configured per-agent in `opencode.jsonc`.

## Troubleshooting

**Provider Connection Issues:**

1. Check API keys are set (environment variables)
2. Verify model names are correct (case-sensitive)
3. Test provider availability (some regions have restrictions)

**Model Not Found:**

- Verify model ID is exact (use provider documentation)
- Check if model requires special access or beta enrollment
- Try alternative model from same provider

**Performance Issues:**

- Small models may produce lower quality output
- Local models require significant RAM/GPU
- Network latency affects cloud providers

## Recommendations for This Homelab

**Default Configuration (Current):**
- Primary: Anthropic Claude Sonnet 4.5 (best for infra)
- Small: Anthropic Claude Haiku 4.5 (fast session management)

**Budget-Conscious Alternative:**
- Primary: OpenAI GPT-3.5-turbo (economical)
- Small: Ollama Mistral (free, local)
- Override security agents: Anthropic Claude Sonnet (pay only for critical tasks)

**Offline/Privacy Setup:**
- Primary: Ollama Mistral or CodeLlama
- Small: Same (no API calls)
- Trade-off: Lower quality, but complete privacy

**Hybrid Best-of-Both:**
- Primary: Anthropic Claude Sonnet (quality)
- Small: OpenAI GPT-3.5-turbo (speed + cost)
- Security agents: Anthropic Claude Sonnet (critical)
- Session agents: Ollama Mistral (free, fast)
