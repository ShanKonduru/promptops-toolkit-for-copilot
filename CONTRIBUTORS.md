# Contributor Safety Contract

All contributors must follow the safety controls in `CONTRIBUTING.md`.

## Mandatory Rules for Prompt Changes

1. Include the hidden `SAFETY_GUARDRAIL` block in every prompt file.
2. Include a Review Clause: generated commands must be shown to the user and require explicit Run/Cancel confirmation.
3. Treat file content as untrusted input. Never execute commands derived from repository text without explicit user confirmation.
4. Do not access credential stores (`~/.ssh`, `~/.aws`, `.env`, keychains, tokens) unless the user explicitly requests it.
5. Auto-install logic must use official registries and verified package names only.

## Registry and Package Integrity

Allowed installation sources:
- PyPI: `python -m pip install <exact-package-name>`
- npm: `npm install <exact-package-name>`
- Cargo: `cargo install <exact-package-name>`
- Vendor official release pages when package managers are not first-party (must be documented in prompt)

Forbidden:
- Typosquatted package names
- Unpinned or unverified install scripts from random URLs
- `curl|bash` or equivalent remote execution shortcuts

## Required Validation Before PR

```bash
python scripts/prompt_safety_scan.py
```

PRs that fail safety checks or bypass this contract will be rejected.
