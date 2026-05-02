---
name: View Git Log
description: Search and visualize recent commits with filtering
parameters:
  - id: filter
    type: string
    description: 'Filter by author, grep text, or file pattern (optional)'
    required: false
  - id: limit
    type: number
    description: 'Number of commits to show (default: 20)'
    required: false
---

# View Git Log

Search and visualize commit history with various filters.

## Recent Commits

**Last 20 commits (default):**
```bash
git log --oneline -20
```

**Pretty graph:**
```bash
git log --graph --oneline --all --decorate -20
```

**With timestamps:**
```bash
git log --oneline --date=short --pretty=format:"%h %ad %s" -20
```

## Filter by Author

```bash
git log --oneline --author="{{ filter }}" -20
```

## Search Commit Messages

```bash
git log --oneline --grep="{{ filter }}" -20
```

## Changes to Specific File

```bash
git log --oneline {{ filter }} -20
```

## Show Details

**Full commit info:**
```bash
git log -p -1  # last commit with full diff
```

**Commit stats:**
```bash
git log --stat -5
```

## One-Liner for Team Standup

```bash
echo "=== My commits today ===" && \
git log --oneline --since="1 day ago" --author="$(git config user.name)" && \
echo -e "\n=== Team commits ===" && \
git log --oneline --since="1 day ago" --all --not --author="$(git config user.name)" | head -10
```

---

**Tip**: Combine with `--after="2 weeks ago"`, `--before="2026-05-01"` for date ranges. Use `-S "text"` to find code changes.
