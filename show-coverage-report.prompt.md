---
name: Show Coverage Report
description: Open and summarize test coverage analysis
parameters:
  - id: browser
    type: boolean
    description: Open HTML report in browser
    required: false
---

# Show Coverage Report

View test coverage statistics and identify gaps.

## Pre-Execution: Verify Coverage Tools Are Installed

Before viewing coverage reports, ensure the coverage tool is available. If not, install it:

```bash
# Check if coverage is installed, install if missing
echo "Checking for coverage tool..."

if ! python -m pip show coverage &> /dev/null; then
  echo "⚠️  coverage not found. Installing..."
  pip install coverage pytest-cov --upgrade
else
  echo "✅ coverage found: $(python -m pip show coverage | grep Version)"
fi
```

**Windows (PowerShell):**
```powershell
if (-not (python -m pip show coverage 2>$null)) {
  Write-Host "⚠️  coverage not found. Installing..."
  pip install coverage pytest-cov --upgrade
} else {
  Write-Host "✅ coverage found"
}
```

## View Terminal Summary

**Show coverage report:**
```bash
coverage report
```

**Show missing lines:**
```bash
coverage report -m
```

## Open HTML Report

**Browser (interactive):**
```bash
# Windows
start coverage_reports/html/index.html

# macOS
open coverage_reports/html/index.html

# Linux
xdg-open coverage_reports/html/index.html
```

## Generate Fresh Coverage Report

**Run tests with coverage:**
```bash
pytest --cov=src --cov-report=html --cov-report=term-missing
```

**View coverage for specific module:**
```bash
coverage report -m | grep "src/your_module.py"
```

## Coverage Delta (Since Last Commit)

```bash
# Run tests
pytest --cov=src --cov-report=json

# Compare with previous
git show HEAD:coverage_reports/coverage.json > /tmp/old-coverage.json && \
python -c "
import json
with open('coverage_reports/coverage.json') as f1, open('/tmp/old-coverage.json') as f2:
    new = json.load(f1)
    old = json.load(f2)
    new_pct = new['totals']['percent_covered']
    old_pct = old['totals']['percent_covered']
    delta = new_pct - old_pct
    print(f'Coverage: {old_pct:.1f}% → {new_pct:.1f}% ({delta:+.1f}%)')
"
```

---

**Threshold warning**: If coverage drops below 80%, consider adding more tests before merging.
