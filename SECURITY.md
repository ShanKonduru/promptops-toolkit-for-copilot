# Security Policy

## Scope

This project contains executable prompt workflows. Security issues include both repository code and prompt content.

## Supported Versions

Security fixes are applied to the latest default branch.

## Reporting a Vulnerability

If you discover unsafe or malicious prompt behavior:

1. Do not open a public issue with exploit details.
2. Contact the maintainer privately through GitHub security reporting.
3. Include a minimal reproduction and the impacted file(s).

We will acknowledge reports as quickly as possible and prioritize high-impact issues.

## Prompt-Specific Threat Model

We treat these as security vulnerabilities:

- Destructive command sequences.
- Hidden payload instructions that attempt to execute undocumented actions.
- Hidden network execution patterns.
- Supply-chain poisoning through typosquatted package/tool names.
- Exfiltration-focused instructions.
- Obfuscated command execution.
- Indirect prompt injection from untrusted repository files.
- Misleading prompt behavior that differs from documentation.

## Human-in-the-Loop Requirement

All executable prompts must enforce explicit user review before any command runs.

Required behavior:

1. Show the full command/script before execution.
2. Require explicit Run/Cancel confirmation.
3. Warn when elevated privileges are needed.

These prompts are assistive and must not perform silent execution.

## Disclaimer

These prompts generate CLI commands. Use at your own risk. Always inspect generated commands before execution. Maintainers are not responsible for data loss resulting from AI-generated scripts.

## Security Controls in This Repo

- Prompt safety CI scanning for high-risk command patterns.
- CODEOWNERS review requirements.
- Contribution policy requiring explicit behavior and validation.
