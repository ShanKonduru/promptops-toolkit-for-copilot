---
name: Create Feature Branch
description: Create and switch to a feature branch following conventions
parameters:
  - id: branch_name
    type: string
    description: 'Branch name (will be prefixed with feature/, fix/, or hotfix/)'
    required: true
  - id: branch_type
    type: string
    description: 'Branch type: "feature" (default), "fix", "hotfix", "docs", "chore"'
    required: false
---

# Create Feature Branch

Quickly create and checkout a new branch following Git Flow conventions.

## Common Patterns

**Feature branch:**
```bash
git checkout -b feature/{{ branch_name }}
```

**Bug fix:**
```bash
git checkout -b fix/{{ branch_name }}
```

**Hotfix (urgent production fix):**
```bash
git checkout -b hotfix/{{ branch_name }}
```

**Documentation:**
```bash
git checkout -b docs/{{ branch_name }}
```

**Chore (maintenance, refactoring):**
```bash
git checkout -b chore/{{ branch_name }}
```

## Naming Conventions

Good names:
- `feature/add-litellm-support`
- `fix/routing-engine-timeout`
- `docs/update-readme`
- `chore/upgrade-dependencies`

Avoid:
- `feature/wip` (too vague)
- `feature/JIRA-123-large-description-here` (too long)

## Full Workflow

```bash
# Create and switch
git checkout -b {{ branch_type || "feature" }}/{{ branch_name }}

# Verify
git branch -vv

# Make your changes...
git add .
git commit -m "feat: your change description"

# Push upstream
git push -u origin {{ branch_type || "feature" }}/{{ branch_name }}
```

---

**Tip**: Branch names become part of PR history. Keep them short, descriptive, and lowercase with hyphens.
