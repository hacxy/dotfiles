---
name: create-skill
description: Create or update an OpenCode skill. Use when the user wants to create a new skill, scaffold a skill, or says "I want to make a skill for X".
---

# Create Skill

Create or update an OpenCode skill in `~/.config/opencode/skills/<name>/SKILL.md`.

## Process

### 1. Gather Requirements

Ask one question at a time to clarify:
- What is the skill's purpose and when should it trigger?
- What specific workflow or instructions should it provide?
- Are there existing skills that overlap?

### 2. Determine Metadata

- **name**: kebab-case, 1-64 characters, matches directory name
- **description**: 1-1024 chars, specific enough for agent to choose correctly

### 3. Draft SKILL.md

Write the content following these rules:
- Maximum 80 lines for the main SKILL.md
- Keep instructions clear and unambiguous
- If logic is complex, extract to `scripts/` directory
- Use references directory for detailed docs that load on demand

### 4. Confirm with User

Show the draft and get explicit approval before writing.

### 5. Write and Review

After user confirms:
1. Write to `~/.config/opencode/skills/<name>/SKILL.md`
2. Launch a sub-agent to review:
   - Frontmatter format (name, description)
   - Instructions clarity and completeness
   - Overlap with existing skills
   - Missing scenarios or edge cases
   - Line count under 80
   - Shell scripts extracted if applicable
3. Present review findings to user
4. Fix issues if user approves, re-review until passed

## Validation Checklist

- [ ] name: lowercase alphanumeric with single hyphen separators
- [ ] name: matches directory name
- [ ] description: 1-1024 characters
- [ ] SKILL.md: under 80 lines
- [ ] No duplicate functionality with existing skills
- [ ] Complex logic extracted to scripts/
