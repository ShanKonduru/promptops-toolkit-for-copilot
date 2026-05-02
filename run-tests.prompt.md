---
name: Run Tests
description: Execute tests with coverage reporting
parameters:
  - id: filter
    type: string
    description: 'Optional test filter (e.g., "test_models.py", "test_router", or leave blank for all)'
    required: false
  - id: coverage
    type: boolean
    description: Generate HTML coverage report
    required: false
---

# Run Tests

Execute your test suite with optional coverage analysis and open the HTML report.

## Pre-Execution: Verify pytest and pytest-cov Are Installed

Before running tests, ensure required testing tools are available. If not, generate and execute install commands:

```bash
# Check if pytest is installed, install if missing
echo "Checking for pytest and pytest-cov..."

if ! python -m pip show pytest &> /dev/null; then
  echo "⚠️  pytest not found. Installing..."
  pip install pytest pytest-cov --upgrade
else
  echo "✅ pytest found: $(python -m pip show pytest | grep Version)"
fi

# Verify pytest-cov
if ! python -m pip show pytest-cov &> /dev/null; then
  echo "⚠️  pytest-cov not found. Installing..."
  pip install pytest-cov --upgrade
else
  echo "✅ pytest-cov found: $(python -m pip show pytest-cov | grep Version)"
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

## Commands

**All tests with coverage:**
```bash
pytest --cov=src --cov-report=html --cov-report=term-missing
```

**Specific test file/pattern:**
```bash
pytest {{ filter }} --cov=src --cov-report=html --cov-report=term-missing
```

**Quick run (no coverage):**
```bash
pytest {{ filter }}
```

---

**Coverage Report**: Open `coverage_reports/html/index.html` in your browser to see detailed line-by-line coverage.

**Tip**: Add `-v` for verbose output, `-x` to stop on first failure, `-k "test_name"` to filter by function names.
