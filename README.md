# PromptOps Toolkit for Copilot

> A lightweight workflow layer on top of GitHub Copilot — versioned, reusable, and team-ready.

Most teams don't lack good AI prompts. They lack a way to reuse them without friction.

**PromptOps Toolkit** is a collection of structured Markdown prompt files that plug directly into VS Code Copilot's custom prompt feature and standardize day-to-day engineering tasks across the full development lifecycle.

> Important: These prompts generate shell commands. Use at your own risk. Always inspect generated commands before execution. Maintainers are not responsible for data loss from AI-generated scripts.

---

## Table of Contents

- [What It Is](#what-it-is)
- [Why It Exists](#why-it-exists)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Available Prompts](#available-prompts)
  - [init-project](#0-init-project)
  - [setup-dev-environment](#1-setup-dev-environment)
  - [create-feature-branch](#2-create-feature-branch)
  - [run-tests](#3-run-tests)
  - [run-tests-with-coverage](#4-run-tests-with-coverage)
  - [show-coverage-report](#5-show-coverage-report)
  - [run-security-audit](#6-run-security-audit)
  - [quick-code-review](#7-quick-code-review)
  - [generate-release-notes](#8-generate-release-notes)
  - [release](#9-release)
  - [view-git-log](#10-view-git-log)
- [How Prompts Work](#how-prompts-work)
- [Syncing Prompts to VS Code](#syncing-prompts-to-vs-code)
- [Recommended Workflow](#recommended-workflow)
- [Supported Languages & Runtimes](#supported-languages--runtimes)
- [Tool Reference](#tool-reference)
- [Security & Trust](#security--trust)
- [Prompt Tiers](#prompt-tiers)
- [Contributing](#contributing)
- [License](#license)

---

## What It Is

PromptOps Toolkit is a set of **`.prompt.md` files** — structured, parameterized Markdown files that VS Code Copilot recognizes as reusable custom prompts. Each prompt file defines:

- A **name** and **description**
- **Parameters** with types and descriptions
- **Executable shell commands** with usage patterns and expected outputs
- **Pre-flight checks** that verify and install required tools before running

Think of it as CI/CD for developer workflows — but triggered from your editor.

---

## Why It Exists

| Problem | Solution |
|---|---|
| Prompts scattered across chats and notes | Single versioned repo of structured prompt files |
| Different devs run tools differently | Standardized, parameterized workflows |
| Tools missing on a new machine | Execution prompts auto-detect and install required tooling |
| Onboarding is slow | Clone → sync → use, in minutes |
| Inconsistent releases | One-command version bump, commit, tag, push |

![PromptOps Toolkit Overview](From%20Prompt%20Chaos%20to%20Developer%20Flow%20Introducing%20PromptOps%20Toolkit%20for%20Copilot.png)

---

## Prerequisites

- [VS Code](https://code.visualstudio.com/) with [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) extension
- Git
- Python 3.12+ (for Python project prompts)
- Node.js or Rust (optional, for those project types)

---

## Installation

### 1. Clone this repository

```bash
git clone https://github.com/ShanKonduru/promptops-toolkit-for-copilot.git
cd promptops-toolkit-for-copilot
```

### 2. Sync prompts to VS Code

**Windows:**
```cmd
sync-prompts.bat
```

**macOS / Linux:**
```bash
chmod +x sync-prompts.sh
./sync-prompts.sh
```

The sync scripts:
- Auto-detect your VS Code user profile path
- Create the prompts directory if it does not exist
- Copy all `*.prompt.md` files to the correct location
- Report success or failure for each file

### 3. Reload VS Code

```
Ctrl+Shift+P → Developer: Reload Window
```

### 4. Use a prompt

Type `/` in Copilot Chat to see all available prompts.

---

## Available Prompts

### 0. `init-project`

**Bootstrap a blank project with structure, dependencies, and Git in one command.**

```
/init-project python "my-project"
/init-project node "my-app"
/init-project rust "my-tool"
```

Creates:
- `src/`, `tests/`, `docs/` directories
- Config file (`pyproject.toml`, `package.json`, or `Cargo.toml`)
- `.gitignore` and `README.md`
- Dev dependencies installed
- Initial Git commit

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `project_type` | string | No | `python` (default), `node`, `rust` |
| `project_name` | string | No | Name used for package/module naming |

---

### 1. `setup-dev-environment`

**Install all development tools required by the other prompts.**

```
/setup-dev-environment
```

Installs: `pytest`, `pytest-cov`, `bandit`, `pip-audit`, `pylint`, `black`, `mypy`, and optionally `trivy`.

Run this once after cloning an existing project or onboarding a new team member.

---

### 2. `create-feature-branch`

**Create and switch to a branch following Git Flow conventions.**

```
/create-feature-branch add-payment-support
/create-feature-branch fix-timeout-issue fix
/create-feature-branch urgent-patch hotfix
```

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `branch_name` | string | Yes | Descriptive name (prefixed automatically) |
| `branch_type` | string | No | `feature` (default), `fix`, `hotfix`, `docs`, `chore` |

**Naming conventions:**

| Good | Avoid |
|---|---|
| `feature/add-litellm-support` | `feature/wip` |
| `fix/routing-engine-timeout` | `feature/JIRA-123-very-long-name` |
| `docs/update-readme` | |

---

### 3. `run-tests`

**Execute your test suite with coverage analysis.**

```
/run-tests
/run-tests test_models.py
/run-tests test_router
```

- Verifies `pytest` and `pytest-cov` are installed; installs if missing
- Runs with `--cov=src --cov-report=html --cov-report=term-missing`
- HTML report saved to `coverage_reports/html/index.html`

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `filter` | string | No | Test file name or pattern |
| `coverage` | boolean | No | Generate HTML coverage report |

For strict coverage enforcement by module and threshold, use `run-tests-with-coverage`.

---

### 4. `run-tests-with-coverage`

**Run tests with module-level coverage targeting and threshold enforcement.**

```
/run-tests-with-coverage
/run-tests-with-coverage src/payments 85
/run-tests-with-coverage src 90
```

- Verifies `pytest` and `pytest-cov` are installed; installs if missing
- Generates terminal, HTML, and JSON coverage reports
- Fails the workflow if coverage is below the provided threshold

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `module` | string | No | Coverage target path (default: `src`) |
| `threshold` | number | No | Minimum required coverage percent (default: 80) |

---

### 5. `show-coverage-report`

**Open and summarize the latest test coverage report.**

```
/show-coverage-report
```

- Verifies `coverage` is installed; installs if missing
- Prints a terminal summary with line numbers of uncovered code
- Opens `coverage_reports/html/index.html` in the browser
- Calculates coverage delta vs. the previous commit

**Threshold:** Raises a warning if coverage falls below 80%.

---

### 6. `run-security-audit`

**Scan for vulnerabilities across three dimensions.**

```
/run-security-audit
/run-security-audit pip-audit
/run-security-audit bandit
/run-security-audit trivy
```

| Scan | Tool | Detects |
|---|---|---|
| Dependency audit | `pip-audit` | CVEs in installed packages |
| Static analysis (SAST) | `bandit` | Code-level security issues |
| Filesystem scan | `trivy` | Container and filesystem threats |

Reports saved to `security_reports/` in JSON format with generated HTML summaries.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `tool` | string | No | `pip-audit`, `bandit`, `trivy`, or `all` (default) |
| `fix` | boolean | No | Auto-fix dependency vulnerabilities where possible |

---

### 7. `quick-code-review`

**Self-review uncommitted changes before committing.**

```
/quick-code-review
/quick-code-review staged
```

Checks performed on changed `.py` files:
1. **Type checking** — `mypy`
2. **Code formatting** — `black --check`
3. **Security** — `bandit`
4. **Linting** — `pylint`

All required tools are verified and installed if missing.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `staged` | boolean | No | Review only staged changes (default: all unstaged) |

---

### 8. `generate-release-notes`

**Create a changelog from Git commit history since the last tag.**

```
/generate-release-notes
/generate-release-notes v1.0.0
```

Organizes commits by type using conventional commit prefixes:

```markdown
### Features
- Add LiteLLM support (abc123)

### Fixes
- Fix routing timeout issue (def456)

### Chores
- Update dependencies (ghi789)
```

Output: `RELEASE_NOTES.md` (Markdown) or `RELEASE_NOTES.json` (for automation).

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `tag` | string | No | Git tag to compare against (default: last tag) |
| `format` | string | No | `markdown` (default) or `json` |

---

### 9. `release`

**Full automated release: version bump, commit, tag, and push.**

```
/release 1.2.0 "Add payment module"
/release patch "Bug fixes"
/release minor "New features"
/release major "Breaking changes"
```

Steps executed automatically:
1. Verifies working tree is clean
2. Detects project type and bumps version in the config file
3. Commits the version bump
4. Creates an annotated Git tag
5. Pushes commits and tag to the remote

**Supported project types:** Python (`pyproject.toml`), Node.js (`package.json`), Rust (`Cargo.toml`)

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `version` | string | Yes | Version number or semver keyword (`patch`, `minor`, `major`) |
| `message` | string | No | Release message / changelog summary |

---

### 10. `view-git-log`

**Search and visualize commit history with filtering.**

```
/view-git-log
/view-git-log my-name
/view-git-log "fix: bug"
/view-git-log src/router.py
```

Useful patterns:
- Last 20 commits in graph view
- Filter by author (great for standups)
- Search commit messages
- Track changes to a specific file

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `filter` | string | No | Author name, grep text, or file path |
| `limit` | number | No | Number of commits to show (default: 20) |

---

## How Prompts Work

Each `.prompt.md` file has a YAML frontmatter block that defines its identity and parameters:

```yaml
---
name: Run Tests
description: Execute tests with coverage reporting
parameters:
  - id: filter
    type: string
    description: Optional test filter
    required: false
---
```

The prompt body contains shell commands and usage patterns. Parameters are referenced as `{{ filter }}` inside the prompt body and resolved by Copilot at runtime.

**Self-healing execution:** Execution prompts include pre-flight checks that detect missing tools and install them before running primary tasks.

**Mandatory review clause:** Prompts must present the final command/script and require explicit user confirmation before execution, with elevated privilege warnings when applicable.

---

## Syncing Prompts to VS Code

| OS | Script | Destination |
|---|---|---|
| Windows | `sync-prompts.bat` | `%APPDATA%\Code\User\prompts` |
| macOS | `sync-prompts.sh` | `~/Library/Application Support/Code/User/prompts` |
| Linux | `sync-prompts.sh` | `~/.config/Code/User/prompts` |

Both scripts auto-detect the correct path — no hardcoded values.

Default behavior syncs vetted prompts from `prompts/core` only.

To include community/experimental prompts:

- Windows: `set INCLUDE_EXPERIMENTAL=1 && sync-prompts.bat`
- macOS/Linux: `INCLUDE_EXPERIMENTAL=1 ./sync-prompts.sh`

**Team workflow:**
1. Team member clones the repo
2. Runs `sync-prompts.bat` or `./sync-prompts.sh`
3. Reloads VS Code
4. All prompts are immediately available

When prompts are updated, pull the latest changes and re-run the sync script.

---

## Recommended Workflow

### Starting a new project

```
/init-project python "my-service"
/create-feature-branch add-core-logic
# ... write code ...
/quick-code-review
/run-tests-with-coverage src 85
/run-security-audit
/release 0.1.0 "Initial release"
```

### Day-to-day development

```
/create-feature-branch add-new-feature
# ... write code ...
/quick-code-review          # catch issues before committing
/run-tests-with-coverage src 85
/show-coverage-report       # check coverage gaps
/view-git-log               # review recent history
```

### Release day

```
/run-tests-with-coverage src 85
/run-security-audit
/generate-release-notes
/release 1.2.0 "Add payment module"
```

---

## Supported Languages & Runtimes

| Language | Init | Release | Tests | Security |
|---|---|---|---|---|
| Python | ✅ | ✅ | ✅ (pytest) | ✅ (bandit, pip-audit, trivy) |
| Node.js | ✅ | ✅ (npm version) | Partial | Partial |
| Rust | ✅ | ✅ (Cargo.toml) | Partial | Partial |

Full toolchain support is currently Python-first. Node.js and Rust support covers project initialization and release automation.

---

## Tool Reference

| Tool | Version | Used By | Install |
|---|---|---|---|
| `pytest` | ≥8.2.0 | `run-tests`, `run-tests-with-coverage` | `pip install pytest` |
| `pytest-cov` | ≥5.0.0 | `run-tests`, `run-tests-with-coverage`, `show-coverage-report` | `pip install pytest-cov` |
| `coverage` | latest | `show-coverage-report` | `pip install coverage` |
| `bandit` | ≥1.7.9 | `run-security-audit`, `quick-code-review` | `pip install bandit` |
| `pip-audit` | ≥2.7.0 | `run-security-audit` | `pip install pip-audit` |
| `pylint` | ≥3.0.0 | `quick-code-review` | `pip install pylint` |
| `black` | ≥24.0.0 | `quick-code-review` | `pip install black` |
| `mypy` | ≥1.8.0 | `quick-code-review` | `pip install mypy` |
| `trivy` | latest | `run-security-audit` | See [trivy releases](https://github.com/aquasecurity/trivy/releases) |

Python tools are auto-installed by execution prompts where needed.

---

## Security & Trust

This repository is designed for safe public collaboration on executable prompts.

Implemented controls:

- CI scanner for high-risk prompt patterns: `.github/workflows/prompt-safety.yml`
- Rule-based prompt scanner script: `scripts/prompt_safety_scan.py`
- CODEOWNERS enforcement for prompt and policy files: `.github/CODEOWNERS`
- Contributor safety requirements: `CONTRIBUTING.md`
- Contributor safety contract: `CONTRIBUTORS.md`
- Vulnerability disclosure policy: `SECURITY.md`
- PR safety checklist template: `.github/pull_request_template.md`

Threats explicitly covered in policy and automation:

- Hidden payload injection in prompt bodies
- Supply-chain poisoning via typosquatted tool/package names
- Indirect prompt injection from untrusted repository content

Run the scanner locally before opening a pull request:

```bash
python scripts/prompt_safety_scan.py
```

---

## Prompt Tiers

- `prompts/core`: Vetted prompts audited by maintainers and synced by default
- `prompts/community-contrib`: New or experimental prompts that require extra scrutiny before promotion

Promotion to Core requires:

1. Maintainer review and CODEOWNERS approval
2. Safety scanner passing in CI
3. Review clause and hidden safeguard block present
4. Registry/tooling checks constrained to official sources

---

## Contributing

Contributions are welcome. To add a new prompt:

1. Add new prompts in `prompts/community-contrib`
2. Include the mandatory hidden `SAFETY_GUARDRAIL` block and Review Clause
3. Keep auto-install commands on official registries with exact package names
4. Document parameters in frontmatter and expected behavior in body
5. Run `python scripts/prompt_safety_scan.py`
6. Test with `sync-prompts.bat` or `sync-prompts.sh`
7. Open a pull request

For full policy requirements, see `CONTRIBUTING.md` and `CONTRIBUTORS.md`.

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

*Built with PromptOps Toolkit for Copilot · [GitHub](https://github.com/ShanKonduru/promptops-toolkit-for-copilot)*
