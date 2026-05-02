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
- Hidden network execution patterns.
- Exfiltration-focused instructions.
- Obfuscated command execution.
- Misleading prompt behavior that differs from documentation.

## Security Controls in This Repo

- Prompt safety CI scanning for high-risk command patterns.
- CODEOWNERS review requirements.
- Contribution policy requiring explicit behavior and validation.
