# Claude Sessions

This directory tracks work sessions with Claude Code to maintain context across shell restarts and conversations.

## Files

- **`CURRENT.md`** - Always contains the active session state

  - What we're working on right now
  - Decisions made in this session
  - Next steps
  - Files modified
  - Quick command reference

- **`YYYY-MM-DD.md`** - Historical session logs
  - Summary of what was accomplished each day
  - Technical details and decisions
  - Reference for future work

## Usage

### For Claude/Agents

Read `CURRENT.md` at the start of any session to understand:

- What we were working on last
- Decisions that were made
- Context needed to continue

Update `CURRENT.md` as the session progresses with:

- New accomplishments
- Changed decisions
- Updated next steps

### For Users

When starting a new topic:

1. Archive current session: `cp CURRENT.md sessions/$(date +%Y-%m-%d).md`
2. Update `CURRENT.md` with new topic/focus
3. Claude will maintain it from there

To continue previous work:

- Just start - Claude will read `CURRENT.md` automatically

To reference old work:

- Check dated session files in this directory

## Format

Session files use this structure:

```markdown
# Current Session / Session: YYYY-MM-DD

**Date**: YYYY-MM-DD
**Status**: Active/Completed
**Focus**: Brief description

## What We Accomplished Today

[List of accomplishments]

## Next Steps

[What to do next]

## Decisions Made

[Important decisions and rationale]

## Important Context

[Background info needed to understand the work]

## Files Modified This Session

[List of changed files]

## Quick Commands Reference

[Relevant commands for this work]

## Questions/Blockers

[Anything blocking progress]
```

## Tips

- Sessions persist across shell restarts
- Safe to commit to public repo (no secrets)
- Use as knowledge base for homelab infrastructure
- Agents can read these for context without asking user
- Keep `CURRENT.md` updated as work progresses
