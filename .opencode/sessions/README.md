# OpenCode Sessions

This directory tracks work across OpenCode sessions to ensure continuity and prevent duplicate effort.

## File Structure

- `CURRENT.md` - Active session state (auto-managed by @session-closer)
- `YYYY-MM-DD.md` - Archived sessions (one file per day)

## Session Lifecycle

**Session Start:**

1. @session-initializer reads CURRENT.md and loads context
2. Provides summary of recent work, blockers, next steps
3. Reminds orchestrator of heavy delegation pattern

**During Session:**

- CURRENT.md reflects ongoing work for today only
- All work from same day goes in same CURRENT.md file
- No manual edits required (agents manage automatically)

**Session End:**

1. @session-closer analyzes completed work
2. If new day: Archives old CURRENT.md to `YYYY-MM-DD.md`, creates fresh CURRENT.md
3. If same day: Updates CURRENT.md in place with new work section
4. Documents accomplishments, decisions, blockers, next steps

## File-Based Archival

**Critical Pattern:** One file per day, NOT sections within CURRENT.md.

- Same day work → Add sections to existing CURRENT.md
- New day work → Archive old CURRENT.md to dated file, create fresh CURRENT.md

This keeps CURRENT.md focused on today's work only.

## CURRENT.md Structure

```markdown
# Current Session

**Date**: YYYY-MM-DD (today only)
**Status**: Active / Completed
**Focus**: [Brief description]

---

## Latest Work - [Work Description]

**Goal**: [What was accomplished]
**Changes Made**: [File changes]
**Decisions Made**: [Key decisions]
**Status**: ✅ COMPLETE / ⚠️ IN PROGRESS / ❌ BLOCKED

---

[Additional work sections from today]

---

## For Next Session

**Recommended Next Steps**: [...]
**Known Blockers**: [...]
**Context to Remember**: [...]
```

## Archived Session Files

Format: `YYYY-MM-DD.md` (e.g., `2025-11-19.md`)

Contains exact CURRENT.md content from that date when archived.

## Benefits

- **Continuity**: Never lose context between sessions
- **Historical record**: Understand how infrastructure evolved
- **Decision tracking**: Know why choices were made
- **Blocker visibility**: Surface recurring issues
- **Quick command reference**: Common tasks documented

## Usage with Agents

- **@session-initializer** (session start): Loads CURRENT.md and provides context
- **@session-closer** (session end): Archives old session, creates fresh CURRENT.md for new day
- **@history-analyzer** (when needed): Searches archived sessions for relevant past work
