---
name: Quick Code Review
description: Self-review uncommitted changes for common issues
parameters:
  - id: staged
    type: boolean
    description: Review only staged changes (default: all unstaged)
    required: false
---

# Quick Code Review

Scan uncommitted changes for:
- Type hints and docstrings
- Security issues (bandit)
- Code style (PEP8)
- Test coverage gaps
- Potential bugs

## Pre-Execution: Verify Required Tools Are Installed

Before scanning code, ensure all linting and type-checking tools are available. If any are missing, install them:

```bash
# Check for required code review tools
echo "Checking for required code analysis tools..."

required_tools=("pylint" "mypy" "black" "bandit")

for tool in "${required_tools[@]}"; do
  if ! python -m pip show $tool &> /dev/null; then
    echo "⚠️  $tool not found. Installing..."
    pip install $tool --upgrade
  else
    echo "✅ $tool found"
  fi
done

echo "All tools ready. Proceeding with code review..."
```

**Windows (PowerShell):**
```powershell
$tools = @('pylint', 'mypy', 'black', 'bandit')
foreach ($tool in $tools) {
  if (-not (python -m pip show $tool 2>$null)) {
    Write-Host "⚠️  $tool not found. Installing..."
    pip install $tool --upgrade
  } else {
    Write-Host "✅ $tool found"
  }
}
Write-Host "All tools ready. Proceeding with code review..."
```

## Review Uncommitted Changes

**Show diff:**
```bash
git diff
```

**Run linters on changed files:**
```bash
git diff --name-only | grep '\.py$' | xargs pylint
```

**Security check (bandit) on changes:**
```bash
git diff HEAD | bandit -
```

**Type checking (mypy):**
```bash
mypy $(git diff --name-only | grep '\.py$')
```

**Format check (black):**
```bash
black --check $(git diff --name-only | grep '\.py$')
```

## One-Command Pre-Commit Review

```bash
echo "=== Changed Files ===" && \
git diff --name-only && \
echo -e "\n=== Type Check ===" && \
mypy $(git diff --name-only | grep '\.py$' | tr '\n' ' ') && \
echo -e "\n=== Style Check ===" && \
black --check $(git diff --name-only | grep '\.py$' | tr '\n' ' ') && \
echo -e "\n=== Security Check ===" && \
bandit -r $(git diff --name-only | grep '\.py$' | xargs -I {} dirname {} | sort -u | tr '\n' ' ') && \
echo -e "\n✅ All checks passed!"
```

---

**Staged changes only:**
```bash
git diff --staged
```

**Tip**: Run this before `git commit` to catch issues early. Saves time waiting for CI to fail!
