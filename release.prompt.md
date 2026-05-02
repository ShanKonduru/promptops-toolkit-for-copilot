---
mode: auto
description: One-command full release — bump, commit, tag, push automatically
parameters:
  - id: version
    type: string
    description: 'Version number (e.g., 0.11.0) or semver keyword (patch, minor, major)'
    required: true
  - id: message
    type: string
    description: Release message/changelog (default: Release {version})'
    required: false
---

# Release

Complete automated release workflow: I'll detect your project, bump version, commit, create tag, and push — all in one go.

**{{ version }}** with message: _"{{ message }}"_

---

Let me handle everything:

```bash
# 1. Verify working tree is clean
git status --porcelain | grep -q . && echo "❌ Working tree not clean" && exit 1 || echo "✓ Clean tree"

# 2. Detect project type and bump version
if [ -f "pyproject.toml" ]; then
  echo "→ Python project detected"
  sed -i 's/version = "[^"]*"/version = "{{ version }}"/g' pyproject.toml
  git add pyproject.toml
elif [ -f "package.json" ]; then
  echo "→ Node.js project detected"
  npm version {{ version }} --no-git-tag-version
  git add package.json package-lock.json
elif [ -f "Cargo.toml" ]; then
  echo "→ Rust project detected"
  sed -i 's/version = "[^"]*"/version = "{{ version }}"/g' Cargo.toml
  git add Cargo.toml
else
  echo "→ Manual version bump required"
  echo "Please update your version file and run: git add ."
  exit 1
fi

# 3. Commit
git commit -m "chore(release): bump version to {{ version }} — {{ message }}"

# 4. Create annotated tag
git tag -a {{ version }} -m "{{ version }}: {{ message }}"

# 5. Push commits and tag
git push origin $(git rev-parse --abbrev-ref HEAD)
git push origin refs/tags/{{ version }}

echo "✓ Release {{ version }} complete!"
```

Done! Your release is live. 🚀
