# Contributing to PromptOps Toolkit for Copilot

Thanks for helping improve this project.

This repository ships executable prompt workflows. Treat prompt changes with the same care as code changes.

## Ground Rules

1. Open a pull request for all changes.
2. Keep changes focused and small.
3. Include a clear before/after behavior summary in the PR description.
4. For prompt updates, include at least one usage example.
5. Do not include secrets, tokens, credentials, or private URLs.

## Prompt Safety Requirements

Prompt changes must not include:

- Destructive commands that can wipe or reformat systems.
- Obfuscated execution patterns.
- Piping downloaded content directly to a shell.
- Hidden side effects that are not clearly documented.

Prompt changes should include:

- Clear intent and expected output.
- Pre-flight tool checks when a command relies on external tools.
- Safer alternatives where commands might require elevated privileges.
- Windows and Unix-friendly guidance when possible.

## Local Validation

Run the safety scanner before opening a PR:

```bash
python scripts/prompt_safety_scan.py
```

## Pull Request Checklist

- [ ] I described what changed and why.
- [ ] I validated prompt behavior locally.
- [ ] I ran the prompt safety scan.
- [ ] I updated docs when behavior changed.
- [ ] I confirmed no secrets or unsafe instructions were added.

## Governance Recommendations

Repository maintainers should enable these settings in GitHub:

1. Branch protection on `main` (and `master` if used).
2. At least 2 required reviews for prompt changes.
3. Required status checks, including prompt safety workflow.
4. Restrict direct pushes to protected branches.
5. Require CODEOWNERS review.
