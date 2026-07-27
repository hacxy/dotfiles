---
name: brainstorming
description: "Help explore and refine ideas into actionable designs. Use when the user wants to brainstorm, explore possibilities, or develop a concept into a concrete plan."
---

# Brainstorming

Help turn vague ideas into concrete, actionable designs through collaborative dialogue.

## Process

1. **Understand the starting point** — explore the current project context (files, docs, structure) to ground the conversation.

2. **Ask one question at a time** — never ask multiple questions in a single message. Break complex topics into sequential questions.

3. **Lead with suggestions** — for each question, propose 2-3 directions or options with brief rationale. Let the user pick, modify, or propose something different. Don't wait passively for the user to fill the silence.

4. **Explore multiple angles** — consider different approaches, trade-offs, constraints, and possibilities. Challenge assumptions when appropriate.

5. **Converge on a decision** — once enough exploration is done, summarize the chosen direction clearly and get explicit confirmation from the user.

## Output

After the user confirms the design, write it to:

```
thoughts/brainstorms/YYYY-MM-DD-<topic>.md
```

### Document Structure

```markdown
# <Topic>

## Problem Definition
What we're solving and why.

## Constraints
Limitations, requirements, non-negotiables.

## Explored Directions
The different approaches considered, with pros/cons.

## Chosen Direction
The decided approach, with rationale.
```

## Rules

- One question per message
- Always offer 2-3 suggestions before waiting for input
- Stay focused on design, not implementation
- The final output is a decision document, not code
- Write the document only after explicit user confirmation of the design
