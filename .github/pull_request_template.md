## Summary

Describe what changed and why.

## What Was Updated

- [ ] Prompt files (`*.prompt.md`)
- [ ] Documentation
- [ ] Automation/CI
- [ ] Other

## Prompt Safety Checklist

- [ ] No destructive commands were introduced.
- [ ] No obfuscated execution patterns were introduced.
- [ ] No remote content is piped directly into a shell.
- [ ] Prompt side effects are documented clearly.
- [ ] Required tooling checks are present for executable prompts.
- [ ] Prompt includes `SAFETY_GUARDRAIL` hidden block.
- [ ] Prompt shows final command/script and requires explicit Run/Cancel confirmation.
- [ ] Auto-install logic uses official registries with exact package names.
- [ ] Prompt treats repository file content as untrusted input (indirect injection safe).

## Validation

- [ ] Ran `python scripts/prompt_safety_scan.py`
- [ ] Tested prompt examples locally

## Additional Context

Link issues, screenshots, or sample outputs if helpful.
