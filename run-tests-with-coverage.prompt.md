---
name: Run Tests With Coverage
description: Run tests for a module/package and enforce a minimum coverage threshold
parameters:
  - id: module
    type: string
    description: 'Coverage target (e.g., "src/payments" or "src")'
    required: false
  - id: threshold
    type: number
    description: 'Minimum allowed coverage percentage (default: 80)'
    required: false
---

# Run Tests With Coverage

Execute tests with coverage for a specific module and fail if coverage is below threshold.

## Pre-Execution: Verify Required Tools Are Installed

```bash
echo "Checking for pytest and pytest-cov..."

if ! python -m pip show pytest &> /dev/null; then
  echo "⚠️  pytest not found. Installing..."
  pip install pytest --upgrade
else
  echo "✅ pytest found"
fi

if ! python -m pip show pytest-cov &> /dev/null; then
  echo "⚠️  pytest-cov not found. Installing..."
  pip install pytest-cov --upgrade
else
  echo "✅ pytest-cov found"
fi
```

**Windows (PowerShell):**
```powershell
$tools = @('pytest', 'pytest-cov')
foreach ($tool in $tools) {
  if (-not (python -m pip show $tool 2>$null)) {
    Write-Host "⚠️  $tool not found. Installing..."
    pip install $tool --upgrade
  } else {
    Write-Host "✅ $tool found"
  }
}
```

## Run Tests and Enforce Threshold

```bash
# Default values if not provided:
#   module: src
#   threshold: 80

pytest --cov={{ module || "src" }} --cov-report=term-missing --cov-report=html --cov-report=json

python -c "
import json, sys
threshold = float('{{ threshold || 80 }}')
with open('coverage.json', 'r', encoding='utf-8') as f:
    data = json.load(f)
coverage = float(data['totals']['percent_covered'])
print(f'Coverage: {coverage:.2f}% (threshold: {threshold:.2f}%)')
if coverage < threshold:
    print('❌ Coverage threshold not met')
    sys.exit(1)
print('✅ Coverage threshold met')
"
```

---

**Coverage report:** `htmlcov/index.html` and `coverage.json`

**Examples:**
```bash
/run-tests-with-coverage
/run-tests-with-coverage src/payments 85
/run-tests-with-coverage src 90
```
