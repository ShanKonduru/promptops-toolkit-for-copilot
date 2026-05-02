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
  - [GitHub Repository Controls](#github-repository-controls)
  - [Threat Model](#threat-model)
  - [Roles and Responsibilities](#roles-and-responsibilities)
    - [Maintainers](#maintainers)
    - [Contributors](#contributors)
    - [Users](#users)
  - [What Users Must Do](#what-users-must-do)
  - [Red Flags: Signs of a Malicious Prompt](#red-flags-signs-of-a-malicious-prompt)
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

> **Legal notice:** These prompts generate shell commands that execute on your machine. Maintainers are not responsible for any data loss, system damage, or security incidents caused by running AI-generated scripts. You are responsible for reviewing every command before execution.

Implemented controls:

- CI scanner for high-risk prompt patterns: `.github/workflows/prompt-safety.yml`
- Rule-based prompt scanner script: `scripts/prompt_safety_scan.py`
- CODEOWNERS enforcement for prompt and policy files: `.github/CODEOWNERS`
- Contributor safety requirements: `CONTRIBUTING.md`
- Contributor safety contract: `CONTRIBUTORS.md`
- Vulnerability disclosure policy: `SECURITY.md`
- PR safety checklist template: `.github/pull_request_template.md`

Run the scanner locally before opening a pull request:

```bash
python scripts/prompt_safety_scan.py
```

---

### GitHub Repository Controls

The following controls are enforced directly at the GitHub repository level — independently of any local developer action.

#### Branch Protection (`main` / `master`)

These rules must be active in **Settings > Branches > Branch protection rules**:

| Rule | Purpose |
|---|---|
| Require status checks to pass before merging | The `Scan Prompt Safety` CI job (`prompt-safety.yml`) must pass — no merge is possible with a failing scanner |
| Require branches to be up to date before merging | Prevents stale-branch merges that could bypass a scanner fix added to `main` |
| Require pull request reviews before merging | At least one human reviewer must approve every change |
| Require review from Code Owners | Enforces the CODEOWNERS file — maintainer approval is mandatory for prompts, scripts, and `.github/` files |
| Dismiss stale pull request approvals when new commits are pushed | Prevents a reviewed-clean PR from being dirtied after approval |
| Do not allow bypassing the above settings | Even repository admins cannot force-merge without passing all checks |

> To verify these rules are active: **GitHub > Settings > Branches > Branch protection rules**.

#### CODEOWNERS (`.github/CODEOWNERS`)

Every file in this repository has a required owner review. Critical paths have explicit rules:

```
*                  @ShanKonduru   # all files — default owner
*.prompt.md        @ShanKonduru   # any prompt file, any location
scripts/*          @ShanKonduru   # scanner and automation scripts
.github/*          @ShanKonduru   # CI, templates, and CODEOWNERS itself
```

This means no prompt file, no CI change, and no policy document can merge without the maintainer's explicit approval — regardless of who opens the PR.

#### CI: Prompt Safety Scanner (`.github/workflows/prompt-safety.yml`)

The workflow runs on every pull request and push to `main`/`master`:

```
Triggers : pull_request → [main, master]
           push         → [main, master]
Permissions: contents: read  (read-only; cannot write back to the repo)
Job       : python scripts/prompt_safety_scan.py
```

The scanner checks every `*.prompt.md` file recursively and fails the build if any file:
- Is missing the `SAFETY_GUARDRAIL` block
- Is missing the `Never execute commands silently` instruction
- Is missing the `require explicit user approval` clause
- Contains a known typosquatted package name (e.g., `tr1vy`, `trivy-fix`)
- Contains a sensitive-file exfiltration pattern (reading `~/.ssh`, `~/.aws`, `.env` and piping to `curl`/`wget`)
- Contains other high-risk shell patterns (raw `curl | bash`, `iex (irm ...)`, silent `rm -rf`, obfuscated `base64` decode)

#### Pull Request Template (`.github/pull_request_template.md`)

Every PR automatically pre-fills a **Prompt Safety Checklist** that contributors must complete before a reviewer will approve:

- No destructive commands introduced
- No obfuscated execution patterns
- No remote content piped directly into a shell
- Prompt includes `SAFETY_GUARDRAIL` hidden block
- Prompt shows final command and requires explicit Run/Cancel confirmation
- Auto-install uses official registries with exact package names
- Prompt treats repository content as untrusted input
- Scanner passed locally (`python scripts/prompt_safety_scan.py`)
- Prompt tested locally

This checklist is not enforced automatically by GitHub, but an incomplete checklist is a red flag during code review.

#### Least-Privilege CI Permissions

The CI workflow is declared with minimal permissions:

```yaml
permissions:
  contents: read
```

This means the GitHub Actions runner cannot write to the repository, create releases, push tags, or interact with issues. It can only read the source code to run the scanner. This limits the blast radius of a compromised or malicious workflow step.

#### What Is NOT Yet Enabled (Recommended Next Steps)

The controls below are recommended but require manual activation in GitHub Settings:

| Control | How to Enable | Benefit |
|---|---|---|
| Branch protection rules | Settings > Branches > Add rule | Blocks direct pushes and enforces CODEOWNERS + CI |
| Secret scanning | Settings > Security > Secret scanning | Detects accidentally committed tokens or API keys |
| Dependabot alerts | Settings > Security > Dependabot | Flags vulnerable dependencies in CI workflow actions |
| Push protection | Settings > Security > Push protection | Blocks commits containing detected secrets before they reach the remote |
| Require signed commits | Branch protection > Require signed commits | Ensures commits are cryptographically attributed to the author |

---

### Threat Model

Three attack vectors are explicitly in scope for this repository:

| Threat | How It Works | Control |
|---|---|---|
| **Hidden payload injection** | A prompt body encodes a malicious command that looks benign but deletes files, exfiltrates data, or escalates privileges when executed | `SAFETY_GUARDRAIL` block required in every Core prompt; CI scanner rejects suspicious patterns |
| **Supply-chain poisoning** | A prompt instructs Copilot to install a typosquatted package (`tr1vy` instead of `trivy`, `reqeusts` instead of `requests`) silently | Scanner detects known typosquat patterns; CONTRIBUTING.md restricts to official registries only |
| **Indirect prompt injection** | A prompt reads untrusted content (e.g., a repo's `README.md`, commit messages, or code comments) that contains injected instructions to the model | All Core prompts include an explicit instruction to treat repository file content as untrusted input |

Threats explicitly **out of scope** for this repository (handled at the OS/network level):
- Copilot API authentication and token security
- VS Code extension sandbox escapes
- Network-level MITM attacks on package registries

---

### Roles and Responsibilities

#### Maintainers

Maintainers are responsible for the integrity of the `prompts/core` tier. Their obligations are:

- **Review every PR** that touches `prompts/core/`, policy files (`CONTRIBUTING.md`, `SECURITY.md`, `CONTRIBUTORS.md`), or the CI scanner.
- **Enforce CODEOWNERS**: No Core prompt or governance file merges without an approving maintainer review.
- **Keep the scanner current**: When new attack patterns are identified (e.g., new typosquat names, new exfiltration techniques), update `scripts/prompt_safety_scan.py` and `SECURITY.md`.
- **Gate tier promotions**: A community-contrib prompt may only be promoted to Core after the maintainer has audited every command, verified registry sources, and confirmed the `SAFETY_GUARDRAIL` block is present and correct.
- **Respond to security reports**: Acknowledge vulnerability disclosures within 7 days per the policy in `SECURITY.md`. Do not dismiss reports as "intended behaviour" without investigation.
- **Never merge a PR that disables or weakens the safety scanner**, even temporarily.

#### Contributors

Contributors add new prompts or update existing ones. Their obligations are:

- **Place new prompts in `prompts/community-contrib/`** — never directly into `prompts/core/`. The Core tier is maintainer-gated.
- **Include the `SAFETY_GUARDRAIL` hidden block** immediately after the YAML frontmatter in every prompt. This is a hard CI requirement; the PR will not merge without it.
- **Include the Review Clause**: Every prompt that generates a shell command must show the final command to the user and require explicit Run/Cancel confirmation before execution. Prompts must not silently execute commands.
- **Warn on privilege escalation**: If a generated command requires `sudo` or administrator privileges, the prompt must call this out explicitly before asking for confirmation.
- **Use only official package registries**: All auto-install instructions must reference packages by their exact official names from PyPI, npm, crates.io, or vendor-documented installation pages. Typosquatted names and `curl | bash` patterns are forbidden.
- **Treat repo content as untrusted**: If a prompt reads files from the repository (commit messages, `README`, source code, config files), it must include an instruction to the model to treat that content as untrusted data — not as instructions.
- **Run the scanner before opening a PR**: `python scripts/prompt_safety_scan.py` must pass locally. A failing scan means the PR will fail CI.
- **Sign off on the CONTRIBUTORS.md safety contract** by checking all relevant boxes in the PR template checklist.

#### Users

Users run synced prompts from within VS Code Copilot Chat. Their obligations and entitlements are:

- **You always have the final say.** No Core prompt will execute a shell command without first showing you the exact command and asking for your explicit confirmation. If a prompt runs something without asking, that is a bug — report it.
- **Inspect before you accept.** When Copilot presents a command for confirmation, read it. Do not click Run without understanding what the command does. This is especially important for commands involving `sudo`, `rm -rf`, `git push --force`, or network calls.
- **Sync Core only by default.** The default sync scripts copy only `prompts/core/`. You must explicitly opt in to `prompts/community-contrib/` by setting `INCLUDE_EXPERIMENTAL=1`. Treat community prompts as unvetted until they are promoted to Core.
- **Keep your local copy up to date.** Pull the latest changes and re-run the sync script regularly. Security patches to prompts or the scanner will appear as commits to this repo.
- **Report suspicious behaviour.** If a prompt asks for credentials, tries to read `~/.ssh` or `~/.aws`, attempts to send data to a remote endpoint, or performs any action that feels outside its stated purpose, stop immediately and open a security issue per the instructions in `SECURITY.md`.

---

### What Users Must Do

Checklist before and during each prompt run:

- [ ] **Before syncing:** Pull the latest repo version (`git pull`) to get the most current vetted prompts.
- [ ] **Before syncing experimental prompts:** Understand that `prompts/community-contrib/` files have not been through the same level of maintainer review as Core prompts.
- [ ] **At confirmation:** Read the full command Copilot presents. If it contains paths, URLs, or flags you do not recognise, cancel and ask Copilot to explain each part.
- [ ] **For `sudo` / admin commands:** Only approve if you understand exactly what the privileged operation does and why it is necessary.
- [ ] **For network calls** (`pip install`, `npm install`, `curl`): Verify the package name is spelled correctly and matches the official registry. A single character difference (e.g., `reqeusts`, `tr1vy`) is a supply-chain attack.
- [ ] **After running a prompt:** If the outcome is unexpected (wrong files modified, unexpected output, new processes started), treat it as a potential security event and check what was actually executed.
- [ ] **Never share your API keys, tokens, or credentials** in Copilot Chat, even when a prompt asks for configuration — use environment variables or a `.env` file that is listed in `.gitignore`.

---

### Red Flags: Signs of a Malicious Prompt

Stop and do not run the prompt if you observe any of the following:

| Red Flag | Why It Is Dangerous |
|---|---|
| Command accesses `~/.ssh`, `~/.aws`, `~/.gnupg`, or `~/.config/gcloud` | Credential theft |
| Command pipes output to `curl`, `wget`, or `Invoke-WebRequest` with an external URL | Data exfiltration |
| Package name differs from the official name by one character | Typosquatting / supply-chain attack |
| Install script is fetched with `curl URL \| bash` or `iex (irm URL)` | Arbitrary remote code execution |
| Prompt never shows you the command — it just executes silently | Bypasses human-in-the-loop control |
| Prompt requests or reads `~/.netrc`, `~/.docker/config.json`, or browser credential files | Credential theft |
| Command contains `base64 --decode \|` or similar obfuscation | Hidden payload |
| Prompt instructs the model to ignore previous system instructions | Direct prompt injection attack |

If you encounter any of these patterns in a Core prompt, **do not run it** and open a security issue immediately following the process in [SECURITY.md](SECURITY.md).

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
