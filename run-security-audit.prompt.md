---
name: Run Security Audit
description: Execute security scanning (pip-audit, bandit, trivy)
parameters:
  - id: tool
    type: string
    description: 'Specific tool: "pip-audit", "bandit", "trivy", or "all" (default: all)'
    required: false
  - id: fix
    type: boolean
    description: Auto-fix vulnerabilities where possible
    required: false
---

# Run Security Audit

Scan for dependency vulnerabilities, code security issues, and container threats.

## Pre-Execution: Verify Tools Are Installed

Before running security scans, check if required tools are installed. If not, generate the install commands:

```bash
# Check for required tools
echo "Checking for required security tools..."

# On Windows, macOS, or Linux with pip:
for tool in pip-audit bandit trivy; do
  if ! command -v $tool &> /dev/null; then
    echo "⚠️  $tool not found. Installing..."
    if [[ "$tool" == "trivy" ]]; then
      echo "Install trivy from: https://github.com/aquasecurity/trivy/releases"
      echo "Or use: brew install trivy (macOS) / apt-get install trivy (Linux)"
    else
      pip install $tool --upgrade
    fi
  else
    echo "✅ $tool found: $(command -v $tool)"
  fi
done
```

**Windows alternative (PowerShell):**
```powershell
# Check and install if missing
$tools = @('pip-audit', 'bandit')
foreach ($tool in $tools) {
  try {
    & $tool --version | Out-Null
    Write-Host "✅ $tool found"
  } catch {
    Write-Host "⚠️  $tool not found. Installing..."
    pip install $tool --upgrade
  }
}
```

## Single Tool Scans

**Dependency vulnerabilities:**
```bash
pip-audit
```

**Code security issues (SAST):**
```bash
bandit -r src/
```

**Filesystem/container threats:**
```bash
trivy fs .
```

## All Security Scans

```bash
echo "=== Dependency Audit ===" && pip-audit && \
echo "=== Code Security ===" && bandit -r src/ && \
echo "=== Filesystem Scan ===" && trivy fs .
```

---

**Auto-fix dependencies:**
```bash
pip-audit --fix
```

**Reports**: Check `security_reports/` for HTML and JSON outputs.

**Tip**: Run this before pushing to catch issues early. CI will re-run these checks on your PR.
