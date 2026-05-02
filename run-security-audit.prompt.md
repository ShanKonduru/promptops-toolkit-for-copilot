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
mkdir -p security_reports
pip-audit -f json > security_reports/pip-audit.json
python -c "
import json, html
data = json.load(open('security_reports/pip-audit.json', 'r', encoding='utf-8'))
body = '<html><body><h1>pip-audit report</h1><pre>' + html.escape(json.dumps(data, indent=2)) + '</pre></body></html>'
open('security_reports/pip-audit.html', 'w', encoding='utf-8').write(body)
"
```

**Code security issues (SAST):**
```bash
mkdir -p security_reports
bandit -r src/ -f json -o security_reports/bandit.json
bandit -r src/ -f html -o security_reports/bandit.html
```

**Filesystem/container threats:**
```bash
mkdir -p security_reports
trivy fs . --format json -o security_reports/trivy.json
python -c "
import json, html
data = json.load(open('security_reports/trivy.json', 'r', encoding='utf-8'))
body = '<html><body><h1>trivy report</h1><pre>' + html.escape(json.dumps(data, indent=2)) + '</pre></body></html>'
open('security_reports/trivy.html', 'w', encoding='utf-8').write(body)
"
```

## All Security Scans

```bash
mkdir -p security_reports

echo "=== Dependency Audit ==="
pip-audit -f json > security_reports/pip-audit.json || true

echo "=== Code Security ==="
bandit -r src/ -f json -o security_reports/bandit.json || true
bandit -r src/ -f html -o security_reports/bandit.html || true

echo "=== Filesystem Scan ==="
trivy fs . --format json -o security_reports/trivy.json || true

python -c "
import json, html
for src, title, dst in [
  ('security_reports/pip-audit.json', 'pip-audit report', 'security_reports/pip-audit.html'),
  ('security_reports/trivy.json', 'trivy report', 'security_reports/trivy.html'),
]:
    try:
        data = json.load(open(src, 'r', encoding='utf-8'))
        body = '<html><body><h1>' + html.escape(title) + '</h1><pre>' + html.escape(json.dumps(data, indent=2)) + '</pre></body></html>'
        open(dst, 'w', encoding='utf-8').write(body)
    except FileNotFoundError:
        pass
"

echo "Reports generated in security_reports/"
```

---

**Auto-fix dependencies:**
```bash
pip-audit --fix
```

**Reports**: Check `security_reports/` for JSON outputs and generated HTML summaries.

**Tip**: Run this before pushing to catch issues early. CI will re-run these checks on your PR.
